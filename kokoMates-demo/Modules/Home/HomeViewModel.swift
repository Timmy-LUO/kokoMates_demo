//
//  HomeViewModel.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/27.
//

import Combine
import Foundation

public final class HomeViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    // inputs
    public var onPageType = PassthroughSubject<PageType, Never>()
    public var onKeyword = PassthroughSubject<String, Never>()
    
    // outputs
    @Published public var userData: UserUiModel? = nil
    @Published public var friendrequestList: [FriendRequestUiModel] = []
    @Published public var subTabList: [SubTabUiModel] = []
    @Published public var friendList: [FriendUiModel] = []
    
    public var errorMessage: AnyPublisher<String, Never> { _errorMessage.eraseToAnyPublisher() }
    
    // internals
    private var _originalFriendList = CurrentValueSubject<[FriendUiModel], Never>([])
    private var _errorMessage = PassthroughSubject<String, Never>()
    
    public init() {
        onPageType
            .sink { [weak self] type in
                switch type {
                case .noFriends:
                    self?.getNoFriends()
                case .noInvites:
                    self?.getNoInvites()
                case .hasInvites:
                    self?.getHasInvites()
                }
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(
            _originalFriendList,
            onKeyword
        )
        .map { friendList, keyword in
            let newList: [FriendUiModel]
            if keyword.isEmpty {
                newList = friendList
            } else {
                newList = friendList.filter { $0.name.contains(keyword) }
            }
            return newList
        }
        .sink { [weak self] friendList in
            self?.friendList = friendList
        }
        .store(in: &cancellables)
        
        getUserData()
        subTabList = [
            SubTabUiModel(title: "好友", badgeCount: 0),
            SubTabUiModel(title: "聊天", badgeCount: 0),
        ]
    }
    
    private func getUserData() {
        UserService.getUser()
            .request { [weak self] result in
                switch result {
                case .success(let response):
                    switch response {
                    case .success(let successBody):
                        self?.userData = successBody.response.first?.toUiModel()
                    case .failure(let failureBody):
                        self?._errorMessage.send(failureBody.Message)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    private func getNoFriends() {
        subTabList = [
            SubTabUiModel(title: "好友", badgeCount: 0),
            SubTabUiModel(title: "聊天", badgeCount: 0),
        ]
    }
    
    private func getNoInvites() {
        combineFriendData()
    }
    
    private func getHasInvites() {
        combineFriendData()
        getFriendsRequest()
    }
    
    private func combineFriendData() {
        Publishers.CombineLatest(
            getFriendListOne(),
            getFriendListTwo()
        )
        .map { friendOneList, friendTowList -> [FriendUiModel] in
            let combinedList = friendOneList + friendTowList
            
            var latestFriends: [String: FriendUiModel] = [:]
            for friend in combinedList {
                if let existingFriend = latestFriends[friend.id] {
                    if friend.updateDate > existingFriend.updateDate {
                        latestFriends[friend.id] = friend
                    }
                } else {
                    latestFriends[friend.id] = friend
                }
            }
            return Array(latestFriends.values)
        }
        .sink { [weak self] combinedList in
            let badgeCount = combinedList.filter { $0.status == 2 }.count
            self?.subTabList = [
                SubTabUiModel(title: "好友", badgeCount: badgeCount),
                SubTabUiModel(title: "聊天", badgeCount: 100),
            ]
            
            let sortedList = combinedList.sorted { $0.id < $1.id }
            self?.friendList = sortedList
            self?._originalFriendList.send(sortedList)
        }
        .store(in: &cancellables)
    }
    
    private func getFriendListOne() -> AnyPublisher<[FriendUiModel], Never> {
        Future<[FriendUiModel], Never> { promise in
            FriendService.getFriendOne()
                .request { result in
                    switch result {
                    case .success(let response):
                        switch response {
                        case .success(let successBody):
                            let list = successBody.response.map { $0.toUiModel() }
                            promise(.success(list))
                        case .failure(let failureBody):
                            print("failure: \(failureBody)")
                            promise(.success([]))
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        promise(.success([]))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    private func getFriendListTwo() -> AnyPublisher<[FriendUiModel], Never> {
        Future<[FriendUiModel], Never> { promise in
            FriendService.getFriendTwo()
                .request { result in
                    switch result {
                    case .success(let response):
                        switch response {
                        case .success(let successBody):
                            let list = successBody.response.map { $0.toUiModel() }
                            promise(.success(list))
                        case .failure(let failureBody):
                            print("failure: \(failureBody)")
                            promise(.success([]))
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        promise(.success([]))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    private func getFriendsRequest() {
        FriendService.getFriendRequest()
            .request { [weak self] result in
                switch result {
                case .success(let response):
                    switch response {
                    case .success(let successBody):
                        self?.friendrequestList = successBody.response.map { $0.toFriendRequestUiModel() }
                    case .failure(let failureBody):
                        print("failure: \(failureBody)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    public enum PageType {
        case noFriends
        case noInvites
        case hasInvites
    }
}

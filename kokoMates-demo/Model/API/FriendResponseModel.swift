//
//  FriendResponseModel.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/27.
//

public struct FriendResponseModel: Decodable {
    public let response: [FriendDataModel]
}

public struct FriendDataModel: Decodable {
    public let name: String
    public let status: Int
    public let isTop: String
    public let fid: String
    public let updateDate: String
    
    public func toUiModel() -> FriendUiModel {
        FriendUiModel(id: fid, userImage: nil, name: name, status: status, isTop: isTop, updateDate: updateDate.formatConverter() ?? "")
    }
    
    public func toFriendRequestUiModel() -> FriendRequestUiModel {
        FriendRequestUiModel(id: fid, userImage: nil, name: name, message: "邀請您成為好友：）", status: status, isTop: isTop, updateDate: updateDate.formatConverter() ?? "")
    }
}

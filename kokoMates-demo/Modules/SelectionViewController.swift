//
//  SelectionViewController.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/18.
//

import UIKit
import SnapKit

public final class SelectionViewController: BaseViewController {
    
    private weak var parentCoordinator: WelcomeCoordinator!
    private var viewModel: HomeViewModel!
    
    public init(
        _ parentCoordinator: WelcomeCoordinator,
        viewModel: HomeViewModel
    ) {
        self.parentCoordinator = parentCoordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    @objc
    private func toNoFriends() {
        viewModel.onPageType.send(.noFriends)
        parentCoordinator.toHome(viewModel: viewModel, pageType: .noFriends)
    }
    
    @objc
    private func toHasFriendsNoInvites() {
        viewModel.onPageType.send(.noInvites)
        parentCoordinator.toHome(viewModel: viewModel, pageType: .noInvites)
    }
    
    @objc
    private func toHasFriendsWithInvites() {
        viewModel.onPageType.send(.hasInvites)
        parentCoordinator.toHome(viewModel: viewModel, pageType: .hasInvites)
    }
    
    private func setupUI() {
        containerView.backgroundColor = .white
        
        noFriendsButton.setTitle("無好友", for: .normal)
        noFriendsButton.setTitleColor(.blue, for: .normal)
        noFriendsButton.addTarget(self, action: #selector(toNoFriends), for: .touchUpInside)
        
        hasFriendsNoInvitesButton.setTitle("有好友且無邀請", for: .normal)
        hasFriendsNoInvitesButton.setTitleColor(.blue, for: .normal)
        hasFriendsNoInvitesButton.addTarget(self, action: #selector(toHasFriendsNoInvites), for: .touchUpInside)
        
        hasFriendsWithInvitesButton.setTitle("有好友且有邀請", for: .normal)
        hasFriendsWithInvitesButton.setTitleColor(.blue, for: .normal)
        hasFriendsWithInvitesButton.addTarget(self, action: #selector(toHasFriendsWithInvites), for: .touchUpInside)
    }

    private func setupLayout() {
        containerView.addSubview(noFriendsButton) { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        containerView.addSubview(hasFriendsNoInvitesButton) { make in
            make.centerX.equalTo(noFriendsButton.snp.centerX)
            make.top.equalTo(noFriendsButton.snp.bottom).offset(30)
        }
        containerView.addSubview(hasFriendsWithInvitesButton) { make in
            make.centerX.equalTo(noFriendsButton.snp.centerX)
            make.top.equalTo(hasFriendsNoInvitesButton.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-30)
        }
        safeEdgesView.addSubview(containerView) { make in
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.center.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let noFriendsButton = UIButton()
    private let hasFriendsNoInvitesButton = UIButton()
    private let hasFriendsWithInvitesButton = UIButton()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

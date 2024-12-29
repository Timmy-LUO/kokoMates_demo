//
//  FriendRequestTableView.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/25.
//

import UIKit
import SnapKit

public final class FriendRequestTableView: UITableView {
    
    private var diffableDataSource: UITableViewDiffableDataSource<Int, FriendRequestUiModel>!

    public convenience init() {
        self.init(frame: .zero, style: .plain)
        separatorStyle = .none
        separatorColor = .clear
        allowsSelection = false
        backgroundColor = nil
        register(FriendRequestTableViewCell.self, forCellReuseIdentifier: FriendRequestTableViewCell.identifier)
        diffableDataSource = UITableViewDiffableDataSource<Int, FriendRequestUiModel>(tableView: self) { tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestTableViewCell.identifier) as! FriendRequestTableViewCell
            cell.bind(item)
            return cell
        }
        dataSource = diffableDataSource
    }
    
    public func setData(_ list: [FriendRequestUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FriendRequestUiModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}

public final class FriendRequestTableViewCell: UITableViewCell {
    
    public static let identifier = "FriendRequestTableViewCell"
    
    public func bind(_ item: FriendRequestUiModel) {
        nameLabel.text = item.name
        messageLabel.text = item.message
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    @objc
    private func confirmFriend() {
        print("confirm Friend")
    }
    
    @objc
    private func cancelFriend() {
        print("cancel Friend")
    }
    
    private func setupUI() {
        containerView.backgroundColor = .white
        containerView.layer.shadowRadius = 7
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.cornerRadius = 6
        
        userImageView.image = "img_user_default".image
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = "greyish_brown".color
        messageLabel.font = .systemFont(ofSize: 13)
        messageLabel.textColor = "light_grey".color
        confirmButton.setImage("btn_friends_agree".image, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmFriend), for: .touchUpInside)
        cancelButton.setImage("btn_friends_delet".image, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelFriend), for: .touchUpInside)
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView) { make in
            make.leading.top.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        containerView.addSubview(cancelButton) { make in
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        containerView.addSubview(confirmButton) { make in
            make.size.equalTo(30)
            make.centerY.equalTo(cancelButton.snp.centerY)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-15)
        }
        containerView.addSubview(userImageView) { make in
            make.size.equalTo(40)
            make.leading.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        containerView.addSubview(nameLabel) { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(15)
            make.top.equalToSuperview().offset(15)
            make.trailing.equalTo(confirmButton.snp.leading).offset(-5)
        }
        containerView.addSubview(messageLabel) { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.trailing.equalTo(confirmButton.snp.leading).offset(-5)
        }
    }
    
    private let containerView = UIView()
    private let userImageView = UIImageView()
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let confirmButton = UIButton()
    private let cancelButton = UIButton()
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

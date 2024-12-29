//
//  TabFriendTableView.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/26.
//

import UIKit
import SnapKit
import Combine

public final class TabFriendTableView: UITableView {

    private var diffableDataSource: UITableViewDiffableDataSource<Int, FriendUiModel>!
    
    convenience init() {
        self.init(frame: .zero, style: .plain)
        separatorStyle = .none
        separatorColor = .clear
        allowsSelection = false
        backgroundColor = nil
        register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.identifier)
        diffableDataSource = UITableViewDiffableDataSource<Int, FriendUiModel>(tableView: self) { tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier) as! FriendTableViewCell
            cell.bind(item)
            return cell
        }
        dataSource = diffableDataSource
    }
    
    public func setData(_ list: [FriendUiModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FriendUiModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}

public final class FriendTableViewCell: UITableViewCell {
    
    public static let identifier = "FriendTableViewCell"
    
    public func bind(_ item: FriendUiModel) {
        nameLabel.text = item.name
        starImageView.isHidden = (item.isTop == "0")
        handleStatusUi(status: item.status)
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    public func handleStatusUi(status: Int) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if status == 2 {
            stackView.spacing = 10
            stackView.addArrangedSubview(transferButton)
            stackView.addArrangedSubview(invitingButton)
        } else {
            stackView.spacing = 25
            stackView.addArrangedSubview(transferButton)
            stackView.addArrangedSubview(moreButton)
        }
        
        layoutIfNeeded()
    }
    
    private func setupUI() {
        starImageView.image = "ic_friends_star".image
        userImageView.image = "img_user_default".image
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = "greyish_brown".color
        
        transferButton.setTitle("轉帳", for: .normal)
        invitingButton.setTitle("邀請中", for: .normal)
        moreButton.setImage("ic_friends_more".image, for: .normal)
        stackView.axis = .horizontal
        separatorView.backgroundColor = "transfer_money".color
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView) { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        containerView.addSubview(stackView) { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        containerView.addSubview(starImageView) { make in
            make.size.equalTo(15)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        containerView.addSubview(userImageView) { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(starImageView.snp.trailing).offset(6)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        containerView.addSubview(nameLabel) { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(userImageView.snp.trailing).offset(15)
        }
        contentView.addSubview(separatorView) { make in
            make.height.equalTo(1)
            make.leading.equalTo(nameLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private let containerView = UIView()
    private let starImageView = UIImageView()
    private let userImageView = UIImageView()
    private let nameLabel = UILabel()
    private let transferButton = HollowButton(border: .pink)
    private let invitingButton = HollowButton(border: .gray)
    private let moreButton = UIButton()
    private let stackView = UIStackView()
    private let separatorView = UIView()
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

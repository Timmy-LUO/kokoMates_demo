//
//  FriendEmptyView.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/28.
//

import UIKit
import SnapKit

public final class FriendEmptyView: UIView {
    
    public convenience init() {
        self.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        friendEmptyImageView.image = "img_friends_empty".image
        friendEmptyTitleLabel.text = "就從加好友開始吧：）"
        friendEmptyTitleLabel.textColor = "greyish_brown".color
        friendEmptyTitleLabel.font = .systemFont(ofSize: 21)
        friendEmptyTitleLabel.textAlignment = .center
        
        friendEmptySubTitleLabel.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）"
        friendEmptySubTitleLabel.textColor = "light_grey".color
        friendEmptySubTitleLabel.font = .systemFont(ofSize: 14)
        friendEmptySubTitleLabel.numberOfLines = 0
        friendEmptySubTitleLabel.textAlignment = .center
                
        supportTitleLabel.text = "幫助好友更快找到你？"
        supportTitleLabel.textColor = "light_grey".color
        supportTitleLabel.font = .systemFont(ofSize: 13)
        
        let btuTitle: String = "設定 KOKO ID"
        settingIdButton.setTitle(btuTitle, for: .normal)
        let attributedString = NSAttributedString(
            string: btuTitle,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: "hot_pink".color,
                .font: UIFont.systemFont(ofSize: 13)
            ]
        )
        settingIdButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    private func setupLayout() {
        addSubview(friendEmptyImageView) { make in
            make.height.equalTo(172)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
        addSubview(friendEmptyTitleLabel) { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(friendEmptyImageView.snp.bottom).offset(50)
        }
        addSubview(friendEmptySubTitleLabel) { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(friendEmptyTitleLabel.snp.bottom).offset(8)
        }
        addSubview(addFriendButton) { make in
            make.width.equalTo(192)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(friendEmptySubTitleLabel.snp.bottom).offset(35)
        }
        addSubview(supportBgView) { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        supportBgView.addSubview(supportTitleLabel) { make in
            make.leading.top.bottom.equalToSuperview()
        }
        supportBgView.addSubview(settingIdButton) { make in
            make.centerY.equalTo(supportTitleLabel.snp.centerY)
            make.leading.equalTo(supportTitleLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }
    
    private let friendEmptyImageView = UIImageView()
    private let friendEmptyTitleLabel = UILabel()
    private let friendEmptySubTitleLabel = UILabel()
    private let addFriendButton = GradientButton(title: "加好友")
    private let supportBgView = UIView()
    private let supportTitleLabel = UILabel()
    private let settingIdButton = UIButton(type: .system)
}

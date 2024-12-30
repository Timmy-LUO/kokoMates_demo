//
//  BadgeView.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/26.
//

import UIKit
import SnapKit

public final class BadgeView: UIView {
    
    private let label = UILabel()
    private let height: Int = 18
    public var count: Int = 0 {
        didSet {
            updateBadge()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = "soft_pink".color
        layer.masksToBounds = true

        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        addSubview(label) { make in
            make.edges.equalToSuperview()
        }
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.width.equalTo(height)
        }
    }

    private func updateBadge() {
        label.text = (count <= 99) ? "\(count)" : "99+"
        
        let isSingleDigit = ("\(count)".count == 1)
        self.snp.updateConstraints { make in
            make.height.equalTo(height)
            make.width.equalTo((isSingleDigit) ? height : label.intrinsicContentSize.width + 10)
        }
        
        layer.cornerRadius = CGFloat(height / 2)
        isHidden = (count == 0)
    }
}

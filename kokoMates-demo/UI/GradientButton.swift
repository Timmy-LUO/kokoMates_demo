//
//  GradientButton.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/28.
//

import UIKit

public final class GradientButton: UIView {
    
    private var title: String!
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.title = title
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            "frog_green".color.cgColor,
            "booger".color.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 20
        layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16)
        iconImageView.image = UIImage(systemName: "person.badge.plus")
        iconImageView.tintColor = .white
    }
    
    private func setupLayout() {
        addSubview(titleLabel) { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        addSubview(iconImageView) { make in
            make.size.equalTo(20)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }
    
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
}

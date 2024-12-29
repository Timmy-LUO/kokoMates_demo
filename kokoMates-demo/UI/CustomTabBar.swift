//
//  CustomTabBar.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/24.
//

import UIKit

public final class CustomTabBar: UITabBar {
    
    public let middleButton = UIButton()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    public func setupMiddleButton() {
        addSubview(middleButton)
    }
    
    private func setupLayout() {
        let tabBarItemCount = 5
        let buttonWidth = bounds.width / CGFloat(tabBarItemCount)
        let buttonHeight = bounds.height
        var index = 0
        
        // 調整每個 TabBarItem 的位置和寬度
        for subview in subviews {
            if subview is UIControl && subview != middleButton {
                subview.frame = CGRect(
                    x: CGFloat(index) * buttonWidth,
                    y: -10,
                    width: buttonWidth,
                    height: buttonHeight
                )
                index += (index == 1 ? 2 : 1) // 跳過中間按鈕的位置
            }
        }

        // 設定中間按鈕的位置
        middleButton.frame = CGRect(
            x: (bounds.width - 64) / 2, // 中間置中
            y: -10, // 向上浮起
            width: 64,
            height: 64
        )
        middleButton.layer.cornerRadius = 32
//        middleButton.backgroundColor = .gray
        middleButton.setImage("ic_ko".image, for: .normal)
        middleButton.tintColor = .white

        // 確保按鈕在最上層
        bringSubviewToFront(middleButton)
    }
}

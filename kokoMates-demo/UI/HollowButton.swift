//
//  HollowButton.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/27.
//

import UIKit

public final class HollowButton: UIButton {
    
    enum Border {
        case gray
        case pink
    }
    
    private var border: Border = .pink
    private var padding: CGFloat = 10

    convenience init(border: Border = .pink) {
        self.init(frame: .zero)
        self.border = border
        commonInit()
    }
    
    private func commonInit() {
        sizeToFit()
        contentEdgeInsets = UIEdgeInsets(top: 2, left: padding, bottom: 2, right: padding)
        
        layer.cornerRadius = 2
        layer.borderColor = (border == .pink) ? "hot_pink".color.cgColor : "pinkish_grey".color.cgColor
        layer.borderWidth = 2
        
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitleColor((border == .pink) ? "hot_pink".color : "light_grey".color, for: .normal)
    }
}

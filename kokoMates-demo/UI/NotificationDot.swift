//
//  NotificationDot.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/25.
//

import UIKit
import SnapKit

public final class NotificationDot: UIView {
    
    public convenience init() {
        self.init(frame: .zero)
        backgroundColor = "hot_pink".color
        layer.cornerRadius = 5
        self.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
}

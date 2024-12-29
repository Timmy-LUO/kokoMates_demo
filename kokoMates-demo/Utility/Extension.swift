//
//  Extension.swift
//  travel-interview
//
//  Created by ZHI on 2024/11/22.
//

import Foundation
import UIKit
import SnapKit

public extension String {
    var image: UIImage { UIImage(named: self)! }
    var color: UIColor { UIColor(named: self)! }
    var localised: String { NSLocalizedString(self, comment: "") }
    
    func formatConverter() -> String? {
        let inputFormatter1 = DateFormatter()
        inputFormatter1.dateFormat = "yyyyMMdd"
        
        let inputFormatter2 = DateFormatter()
        inputFormatter2.dateFormat = "yyyy/MM/dd"
        
        if let date = inputFormatter1.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy/MM/dd"
            return outputFormatter.string(from: date)
        } else if let date = inputFormatter2.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy/MM/dd"
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: self)
    }
}

public extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        
        return self.presentedViewController!.topMostViewController()
    }
}

public extension UIView {
    var safeAreaEdges: ConstraintItem {
        safeAreaLayoutGuide.snp.edges
    }
    
    func addSubview(_ view: UIView, _ closure: (_ make: ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints(closure)
    }
}

//
//  AlertBuilder.swift
//  travel-interview
//
//  Created by ZHI on 2024/11/29.
//

import UIKit

final public class AlertBuilder {
    
    private var style: UIAlertController.Style = .alert
    private var title: String!
    private var message: String!
    private var actionList = [UIAlertAction]()
    
    func setStyle(_ style: UIAlertController.Style) -> AlertBuilder{
        self.style = style
        return self
    }
    
    func setTitle(_ title: String) -> AlertBuilder {
        self.title = title
        return self
    }
    
    func setMessage(_ message: String) -> AlertBuilder {
        self.message = message
        return self
    }
    
    func setButton(title: String, style: UIAlertAction.Style = .default, action: (() -> Void)? = nil) -> AlertBuilder {
        self.actionList.append(UIAlertAction(title: title, style: style) { _ in
            action?()
        })
        return self
    }
    
    func setOkButton(title: String = "OK", action: (() -> Void)? = nil) -> AlertBuilder {
        self.actionList.append(UIAlertAction(title: title, style: .default) { _ in
            action?()
        })
        return self
    }
    
    @discardableResult
    func show(_ parent: UIViewController? = Utils.topMostViewController()) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        for action in actionList {
            alertController.addAction(action)
        }
        parent?.present(alertController, animated: true, completion: nil)
        return alertController
    }
}

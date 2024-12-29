//
//  BaseViewController.swift
//  travel-interview
//
//  Created by ZHI on 2024/11/26.
//

import UIKit
import SnapKit
import Combine

open class BaseViewController: UIViewController {
    
    internal var cancellables = Set<AnyCancellable>()

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(safeEdgesView) { make in
            make.edges.equalTo(view.safeAreaEdges)
        }
    }
    
    internal func promptAlert(message: String, action: (() -> Void)? = nil) {
        AlertBuilder()
            .setMessage(message)
            .setOkButton(action: action)
            .show(self)
    }
    
    internal let safeEdgesView = UIView()
}

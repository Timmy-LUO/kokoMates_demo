//
//  TabNoFriendViewController.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/28.
//

import UIKit
import SnapKit

public final class TabNoFriendViewController: BaseViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(friendEmptyView) { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let friendEmptyView = FriendEmptyView()
}

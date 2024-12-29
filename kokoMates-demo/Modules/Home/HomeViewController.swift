//
//  HomeViewController.swift
//  kokoMates-demo
//
//  Created by ZHI on 2024/12/19.
//

import UIKit

public final class HomeViewController: UITabBarController {
    
    private weak var viewModel: HomeViewModel!
    private let pageType: HomeViewModel.PageType!
    
    public init(
        viewModel: HomeViewModel,
        pageType: HomeViewModel.PageType
    ) {
        self.viewModel = viewModel
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBorder()
    }
    
    private func setupBorder() {
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        topBorder.backgroundColor = UIColor.lightGray
        tabBar.addSubview(topBorder)
    }
    
    private func setupTabBar() {
        view.backgroundColor = .white
        
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        customTabBar.setupMiddleButton()
        customTabBar.middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -12)
        
        moneyViewController.tabBarItem.image = "ic_tabbar_money".image
        moneyViewController.title = "錢錢"
        friendViewController.tabBarItem.image = "ic_tabbar_friends".image
        friendViewController.title = "朋友"
        accountingViewController.tabBarItem.image = "ic_tabbar_accounting".image
        accountingViewController.title = "記帳"
        settingViewController.tabBarItem.image = "ic_tabbar_setting".image
        settingViewController.title = "設定"
        
        setViewControllers([moneyViewController, friendViewController, accountingViewController, settingViewController], animated: true)
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = "hot_pink".color
        tabBar.unselectedItemTintColor = "light_grey".color
        
        selectedIndex = 1
    }
    
    @objc
    private func middleButtonTapped() {
        print("中間按鈕點擊事件")
    }
    
    private let moneyViewController = MoneyViewController()
    private lazy var friendViewController = FriendViewController(viewModel: viewModel, pageType: pageType)
    private let accountingViewController = AccountingViewController()
    private let settingViewController = SettingViewController()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

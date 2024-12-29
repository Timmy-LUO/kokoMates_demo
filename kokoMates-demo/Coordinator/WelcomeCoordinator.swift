//
//  WelcomeCoordinator.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/10.
//

import UIKit

public final class WelcomeCoordinator: Coordinator {
    
    public var childCoordinators = [Coordinator]()
    public var rootViewController: UIViewController?
    public var navigationController: UINavigationController?
    
    public init() {
        let navigationController = UINavigationController()
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = SelectionViewController(self, viewModel: HomeViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func toHome(
        viewModel: HomeViewModel,
        pageType: HomeViewModel.PageType
    ) {
        let vc = HomeViewController(viewModel: viewModel, pageType: pageType)
        navigationController?.pushViewController(vc, animated: true)
    }
}

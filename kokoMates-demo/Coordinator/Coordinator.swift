//
//  Cordinator.swift
//  DailyBellePOS
//
//  Created by Harry on 2023/2/10.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get set }

    func start()
}

//
//  LoginCoordinator.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

final class LoginCoordinator: BaseCoordinatorProtocol {
    
    var flowCompletionHandler: (() -> Void)?
    
    private(set) weak var navigation: UINavigationController?
    var childCoordinators: [BaseCoordinatorProtocol] = []
    
    private var factoryViewController: ViewControllerFactoryProtocol
    private var factoryCoordinator: CoordinatorFactoryProtocol
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        
        factoryViewController = ViewControllerFactory()
        factoryCoordinator = CoordinatorFactory()
        
//        super.init()
    }
    
    public func start() {
        
    }
    
    private func showLoginViewController() {
        let loginViewController = factoryViewController.makeLoginViewController()
        loginViewController.completionHandler = { [weak self] result in
            switch result {
            default: break
            }
        }
        
        push(controller: loginViewController)
    }
}

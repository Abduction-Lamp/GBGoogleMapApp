//
//  BaseCoordinator.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

protocol BaseCoordinatorProtocol: AnyObject, NavigationRouterProtocol {
    
    var childCoordinators: [BaseCoordinatorProtocol] { get set }
    var flowCompletionHandler: (() -> Void)? { get set }
    
    init(navigation: UINavigationController)
    
    func start()
    
    func addDependency(_ coordinator: BaseCoordinatorProtocol)
    func removeDependency(_ coordinator: BaseCoordinatorProtocol?)
}


extension BaseCoordinatorProtocol {

    func addDependency(_ coordinator: BaseCoordinatorProtocol) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: BaseCoordinatorProtocol?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
        else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

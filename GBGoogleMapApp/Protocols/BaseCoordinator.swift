//
//  BaseCoordinator.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

enum FlowCompletionCoordinator {
    case nothing
    case runAuthFlow
    case runMapFlow(by: User)
}

protocol BaseCoordinatorProtocol: AnyObject, NavigationRouterProtocol {
    
    var navigation: UINavigationController? { get set }
    
    func start()
    var flowCompletionHandler: ((FlowCompletionCoordinator) -> Void)? { get set }
    
    var childCoordinators: [BaseCoordinatorProtocol] { get set }
    func addDependency(_ coordinator: BaseCoordinatorProtocol)
    func removeDependency(_ coordinator: BaseCoordinatorProtocol?)
}


extension BaseCoordinatorProtocol {
    
    func addDependency(_ coordinator: BaseCoordinatorProtocol) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
        print("✅\tAppend Child Coordinator")
    }
    
    func removeDependency(_ coordinator: BaseCoordinatorProtocol?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
        else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                print("❎\tRemove Child Coordinator")
                break
            }
        }
    }
}

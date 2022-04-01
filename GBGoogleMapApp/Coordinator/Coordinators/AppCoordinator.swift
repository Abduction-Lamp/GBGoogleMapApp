//
//  AppCoordinator.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

final class AppCoordinator: BaseCoordinatorProtocol {
    
    var childCoordinators: [BaseCoordinatorProtocol] = []
    var flowCompletionHandler: (() -> Void)?
    
    private(set) weak var navigation: UINavigationController?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        if let router = navigation {
            let mapCoordinator = MapCoordinator(navigation: router)
            mapCoordinator.flowCompletionHandler = { [weak self] in
                self?.dismiss()
                self?.removeDependency(mapCoordinator)
            }
            addDependency(mapCoordinator)
            mapCoordinator.start()
        }
    }
}

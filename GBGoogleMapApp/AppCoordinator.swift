//
//  AppCoordinator.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

final class AppCoordinator: BaseCoordinatorProtocol {

    var childCoordinators: [BaseCoordinatorProtocol] = []
    var flowCompletionHandler: ((FlowCompletionCoordinator) -> Void)?
    
    private(set) weak var navigation: UINavigationController?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        print("🏃‍♂️\tRun AppCoordinator")
        runAuthFlow()
    }
    
    
    
    private func runAuthFlow() {
        if let router = navigation {
            let authCoordinator = AuthCoordinator(navigation: router)
            authCoordinator.flowCompletionHandler = { [weak self] action in
                self?.dismiss()
                self?.removeDependency(authCoordinator)
                self?.managerFlowCompletion(action)
            }
            addDependency(authCoordinator)
            authCoordinator.start()
        }
    }
    
    private func runMapFlow(user: User) {
        if let router = navigation {
            let mapCoordinator = MapCoordinator(navigation: router)
            mapCoordinator.flowCompletionHandler = { [weak self] action in
                self?.dismiss()
                self?.removeDependency(mapCoordinator)
                self?.managerFlowCompletion(action)
            }
            addDependency(mapCoordinator)
            mapCoordinator.start()
        }
    }
    
    private func managerFlowCompletion(_ action: FlowCompletionCoordinator) {
        switch action {
        case .nothing:
            break
        case .escaping:
            break
        case .runAuthFlow:
            runAuthFlow()
        case .runMapFlow(let user):
            runMapFlow(user: user)
        }
    }
}

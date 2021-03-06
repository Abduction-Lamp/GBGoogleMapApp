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
    
    weak var navigation: UINavigationController?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    deinit {
        print("♻️\tDeinit AppCoordinator")
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
                authCoordinator.flowCompletionHandler = nil
                
                self?.managerFlowCompletion(action)
            }
            addDependency(authCoordinator)
            authCoordinator.start()
        }
    }
    
    private func runMapFlow(by user: User) {
        if let router = navigation {
            let mapCoordinator = MapCoordinator(navigation: router, user: user)
            mapCoordinator.flowCompletionHandler = { [weak self] action in
                self?.dismiss()
                self?.removeDependency(mapCoordinator)
                mapCoordinator.flowCompletionHandler = nil
                
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
        case .runAuthFlow:
            runAuthFlow()
        case .runMapFlow(let user):
            runMapFlow(by: user)
        }
    }
}

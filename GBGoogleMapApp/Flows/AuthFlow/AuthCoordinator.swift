//
//  AuthCoordinator.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

final class AuthCoordinator: BaseCoordinatorProtocol {
    
    var childCoordinators: [BaseCoordinatorProtocol] = []
    var flowCompletionHandler: ((FlowCompletionCoordinator) -> Void)?
    
    private(set) weak var navigation: UINavigationController?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }

    public func start() {
        print("🏃‍♂️\tRun AuthCoordinator")
        showLoginViewController()
    }

    private func showLoginViewController() {
        let realm = RealmManager()
        let loginViewModel = LoginViewModel(realm: realm)
        loginViewModel.completionHandler = { [weak self] action in
            self?.managerFlowCompletion(action)
        }
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        
        push(controller: loginViewController)
    }
    
    private func showRegistationViewController() {
        let realm = RealmManager()
        let registrationViewModel = RegistrationViewModel(realm: realm)
        registrationViewModel.completionHandler = { [weak self] action in
            self?.managerFlowCompletion(action)
        }
        let registrationViewController = RegistrationViewController(viewModel: registrationViewModel)

        push(controller: registrationViewController)
    }
    
    private func managerFlowCompletion(_ action: AuthCompletionActions) {
        switch action {
        case .user(let user):
            self.flowCompletionHandler?(.runMapFlow(user))
        case .goToRegistration:
            showRegistationViewController()
        case .goToLogin:
            showLoginViewController()
        }
    }
}


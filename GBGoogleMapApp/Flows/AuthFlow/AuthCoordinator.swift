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
    
    weak var navigation: UINavigationController?
    private var realm: RealmManagerProtocol?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        self.realm = RealmManager()
    }

    public func start() {
        print("🏃‍♂️\tRun AuthCoordinator")
        showLoginViewController()
    }
    
    deinit {
        print("♻️\tDeinit AuthCoordinator")
    }

    
    
    private func showLoginViewController() {
        let loginViewModel = LoginViewModel(realm: realm)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        
        loginViewModel.completionHandler = { [weak self] action in
            self?.managerFlowCompletion(action)
            loginViewController.viewModel = nil
        }
        
        push(controller: loginViewController)
    }
    
    private func showRegistationViewController() {
        let registrationViewModel = RegistrationViewModel(realm: realm)
        let registrationViewController = RegistrationViewController(viewModel: registrationViewModel)
        
        registrationViewModel.completionHandler = { [weak self] action in
            self?.managerFlowCompletion(action)
            registrationViewController.viewModel = nil
        }

        push(controller: registrationViewController)
    }
    
    private func managerFlowCompletion(_ action: AuthCompletionActions) {
        switch action {
        case .successfully(let user):
            flowCompletionHandler?(.runMapFlow(by: user))
        case .goToRegistration:
            showRegistationViewController()
        case .goToLogin:
            showLoginViewController()
        }
    }
}

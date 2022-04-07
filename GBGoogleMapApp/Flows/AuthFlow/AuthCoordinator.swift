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
    
    private var loginViewModel: LoginViewModel
    private var registrationViewModel: RegistrationViewModel
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        self.realm = RealmManager()
        
        self.loginViewModel = LoginViewModel(realm: realm)
        self.registrationViewModel = RegistrationViewModel(realm: realm)
    }
    
    deinit {
        print("♻️\tDeinit AuthCoordinator")
    }

    public func start() {
        print("🏃‍♂️\tRun AuthCoordinator")
        showLoginViewController(isStart: true)
    }
    
    
    private func showLoginViewController(isStart: Bool = false) {
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        loginViewModel.completionHandler = { [weak self] action in
            self?.managerFlowCompletion(action)
        }
        isStart ? setRoot(controller: loginViewController) : pop()
    }
    
    private func showRegistationViewController() {
        let registrationViewController = RegistrationViewController(viewModel: registrationViewModel)
        registrationViewModel.completionHandler = { [weak self] action in
            self?.managerFlowCompletion(action)
        }
        push(controller: registrationViewController, hideBar: false)
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

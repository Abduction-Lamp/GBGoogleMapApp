//
//  MapCoordinator.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import Foundation
import UIKit

final class MapCoordinator: BaseCoordinatorProtocol {

    var childCoordinators: [BaseCoordinatorProtocol] = []
    var flowCompletionHandler: ((FlowCompletionCoordinator) -> Void)?
    
    weak var navigation: UINavigationController?
    
    private var realm: RealmManagerProtocol?

    private var user: User
    
    init(navigation: UINavigationController, user: User) {
        self.navigation = navigation
        self.user = user
        self.realm = RealmManager()
    }
    
    deinit {
        print("♻️\tDeinit MapCoordinator")
    }
    
    
    func start() {
        print("🏃‍♂️\tRun MapCoordinator")
        
        let mapViewModel = MapViewModel(realm: realm, user: user)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        
        mapViewModel.completionHandler = { [weak self] action in
            self?.flowCompletionHandler?(.runAuthFlow)
            mapViewController.viewModel = nil
        }

        push(controller: mapViewController)
    }
}

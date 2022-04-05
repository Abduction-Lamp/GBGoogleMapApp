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
    
    private var user: User
    
    init(navigation: UINavigationController, user: User) {
        self.navigation = navigation
        self.user = user
    }
    
    
    func start() {
        print("🏃‍♂️\tRun MapCoordinator")
        
        let realm = RealmManager()
        let mapViewModel = MapViewModel(realm: realm, user: user)
        mapViewModel.completionHandler = { [weak self] action in
            self?.flowCompletionHandler?(.runAuthFlow)
        }
        let mapViewController = MapViewController(viewModel: mapViewModel)
        
        push(controller: mapViewController)
    }
}

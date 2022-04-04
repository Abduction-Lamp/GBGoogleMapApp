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
    
    private(set) weak var navigation: UINavigationController?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        print("🏃‍♂️\tRun MapCoordinator")
        
        let realm = RealmManager()
        let mapViewModel = MapViewModel(realm: realm)
        mapViewModel.completionHandler = { [weak self] action in
            self?.flowCompletionHandler?(.runAuthFlow)
        }
        let mapViewController = MapViewController(viewModel: mapViewModel)
        
        push(controller: mapViewController)
    }
}

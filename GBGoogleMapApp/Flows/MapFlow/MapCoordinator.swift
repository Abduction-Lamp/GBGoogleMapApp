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
    private var mapViewModel: MapViewModel
    
    init(navigation: UINavigationController, user: User) {
        self.navigation = navigation
        self.user = user
        self.realm = RealmManager()
        self.mapViewModel = MapViewModel(realm: realm, user: user)
    }
    
    deinit {
        print("♻️\tDeinit MapCoordinator")
    }
    
    
    func start() {
        print("🏃‍♂️\tRun MapCoordinator")

        let mapViewController = MapViewController(viewModel: mapViewModel)
        mapViewModel.completionHandler = { [weak self] action in
            self?.flowCompletionHandler?(.runAuthFlow)
        }
        setRoot(controller: mapViewController)
    }
}

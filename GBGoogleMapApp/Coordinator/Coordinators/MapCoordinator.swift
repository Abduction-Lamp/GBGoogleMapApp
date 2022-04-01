//
//  MapCoordinator.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import Foundation
import UIKit

final class MapCoordinator: BaseCoordinatorProtocol {
    
    var childCoordinators: [BaseCoordinatorProtocol]
    var flowCompletionHandler: (() -> Void)?
    
    private(set) weak var navigation: UINavigationController?
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func start() {
        let realm = RealmManager()
        let mapViewModel = MapViewModel(realm: realm)
        mapViewModel.completionHandler = {
            
        }
        let mapViewController = MapViewController(viewModel: mapViewModel)
        
        push(controller: mapViewController)
    }
}


protocol BaseViewController {
    
}

protocol Presentable {
    
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
}

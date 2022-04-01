//
//  ViewControllerFactory.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

protocol ViewControllerFactoryProtocol {
    func makeLoginViewController() -> UIViewController
    func makeRegistrationViewController() -> UIViewController
    func makeMapViewController() -> MapViewController
}

final class ViewControllerFactory: ViewControllerFactoryProtocol {
    
    func makeLoginViewController() -> UIViewController {
        return UIViewController()
    }
    
    func makeRegistrationViewController() -> UIViewController {
        return UIViewController()
    }
    
    func makeMapViewController() -> MapViewController {
        let realm = RealmManager()
        let viewModel = MapViewModel(realm: realm)
        return MapViewController(viewModel: viewModel)
    }
}

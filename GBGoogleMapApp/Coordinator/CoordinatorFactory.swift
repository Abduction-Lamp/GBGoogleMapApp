//
//  CoordinatorFactory.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    func makeLoginCoordinator() -> (coordinator: LoginCoordinator, navigation: UINavigationController)
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func makeLoginCoordinator() -> (coordinator: LoginCoordinator, navigation: UINavigationController) {
        return (coordinator: LoginCoordinator(, navigation: UINavigationController)
    }
}

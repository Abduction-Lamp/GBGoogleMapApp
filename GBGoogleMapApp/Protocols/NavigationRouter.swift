//
//  NavigationRouter.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 31.03.2022.
//

import UIKit

protocol NavigationRouterProtocol {
    var navigation: UINavigationController? { get }
    
    func present(controller: UIViewController, animated: Bool)
    func push(controller: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
}

extension NavigationRouterProtocol {
    
    func present(controller: UIViewController, animated: Bool = true) {
        navigation?.present(controller, animated: animated, completion: nil)
    }
    
    func push(controller: UIViewController, animated: Bool = true) {
        navigation?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigation?.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool = true) {
        navigation?.dismiss(animated: animated, completion: nil)
    }
}

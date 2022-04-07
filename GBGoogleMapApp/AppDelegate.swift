//
//  AppDelegate.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 12.03.2022.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let navigation = UINavigationController()
    var coordinator: AppCoordinator?
    
    var canvasBlurEffect = UIVisualEffectView()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyD05zpZsg6DH45dHPPQMBheAL5LXUDh8A8")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        navigation.isNavigationBarHidden = true
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        coordinator = AppCoordinator(navigation: navigation)
        coordinator?.start()
        
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        canvasBlurEffect.frame = UIScreen.main.bounds
        canvasBlurEffect.effect = UIBlurEffect(style: .regular)
        canvasBlurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        window?.addSubview(canvasBlurEffect)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        canvasBlurEffect.removeFromSuperview()
    }
}

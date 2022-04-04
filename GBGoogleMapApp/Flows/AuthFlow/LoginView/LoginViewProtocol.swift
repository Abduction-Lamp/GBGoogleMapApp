//
//  LoginViewData.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 03.04.2022.
//

import Foundation

enum AuthRefreshActions {
    case initiation
    case loading
    case success
    case failure(message: String)
}

enum AuthCompletionActions {
    case goToRegistration
    case goToLogin
    case user(User)
}


protocol LoginViewModelProtocol: AnyObject,
                                 RefreshActionsProtocol,
                                 CompletionActionsProtocol where RefreshActions == AuthRefreshActions,
                                                                 CompletionActions == AuthCompletionActions {
    init(realm: RealmManagerProtocol?)
    
    func login(login: String, password: String)
    func registretion()
}

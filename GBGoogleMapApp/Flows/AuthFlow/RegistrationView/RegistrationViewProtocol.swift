//
//  RegistrationViewProtocol.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import Foundation

protocol RegistrationViewModelProtocol: AnyObject,
                                        RefreshActionsProtocol,
                                        CompletionActionsProtocol where RefreshActions == AuthRefreshActions,
                                                                        CompletionActions == AuthCompletionActions {
    init(realm: RealmManagerProtocol?)
    
    func registretion(firstName: String, lastName: String, email: String, login: String, password: String)
}

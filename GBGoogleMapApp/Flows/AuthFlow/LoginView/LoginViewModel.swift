//
//  LoginViewModel.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 03.04.2022.
//

import Foundation
import RealmSwift


final class LoginViewModel: LoginViewModelProtocol {
    
    var refresh: ((AuthRefreshActions) -> Void)?
    var completionHandler: ((AuthCompletionActions) -> Void)?

    private var realm: RealmManagerProtocol?
    
    init(realm: RealmManagerProtocol?) {
        self.realm = realm
    }
    
    func login(login: String, password: String) {
        refresh?(.loading)
        
        if login == "Username" && password == "UserPassword" {
//            completionHandler?(.user(login))
        }
        else {
            refresh?(.failure(message: "Wrong login or password"))
        }
    }
    
    func registretion() {
        completionHandler?(.goToRegistration)
    }
}

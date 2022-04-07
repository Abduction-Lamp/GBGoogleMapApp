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

    private weak var realm: RealmManagerProtocol?
    
    init(realm: RealmManagerProtocol?) {
        self.realm = realm
    }

    deinit {
        print("♻️\tDeinit LoginViewModel")
    }
    
    
    
    func login(login: String, password: String) {
        refresh?(.loading)
        guard
            let result = realm?.getUser(by: login, password: password),
            let user = Array(result).first else {
                refresh?(.failure(message: "Wrong login or password"))
                return
            }
        completionHandler?(.successfully(user: user))
    }
    
    func registretion() {
        completionHandler?(.goToRegistration)
    }
}

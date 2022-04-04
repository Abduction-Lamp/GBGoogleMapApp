//
//  RegistrationViewModel.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import Foundation
import RealmSwift


final class RegistrationViewModel: RegistrationViewModelProtocol {
    
    var refresh: ((AuthRefreshActions) -> Void)?
    var completionHandler: ((AuthCompletionActions) -> Void)?

    private var realm: RealmManagerProtocol?
    
    init(realm: RealmManagerProtocol?) {
        self.realm = realm
    }
    
    func login(login: String, password: String) {
        refresh?(.loading)
        refresh?(.failure(message: "Wrong login or password"))
    }
    
    func registretion() {
        refresh?(.failure(message: "Wrong login or password"))
    }
}

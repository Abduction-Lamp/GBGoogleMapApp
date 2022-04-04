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

    func registretion(firstName: String, lastName: String, email: String, login: String, password: String) {
        refresh?(.loading)
        сheckRegistretionForm(firstName: firstName, lastName: lastName, email: email, login: login, password: password)
    }
    
    
    
    private func сheckRegistretionForm(firstName: String, lastName: String, email: String, login: String, password: String) {
        guard !firstName.isEmpty else {
            refresh?(.failure(message: "Empty First Name field"))
            return
        }
        guard !lastName.isEmpty else {
            refresh?(.failure(message: "Empty Last Name field"))
            return
        }
        guard !email.isEmpty else {
            refresh?(.failure(message: "Empty E-mail field"))
            return
        }
        guard email.isValidEmail() else {
            refresh?(.failure(message: "Wrong email format"))
            return
        }
        guard !login.isEmpty else {
            refresh?(.failure(message: "Empty Login field"))
            return
        }
        guard !password.isEmpty else {
            refresh?(.failure(message: "Empty Password field"))
            return
        }
        guard password.count > 6 else {
            refresh?(.failure(message: "Short password"))
            return
        }
        
        let user = User(firstName: firstName, lastName: lastName, email: email, login: login, password: password)
        do {
            try realm?.write(object: user)
        } catch {
            print("⚠️\t\(error.localizedDescription)")
            refresh?(.failure(message: "Error when writing to the database"))
            return
        }
        completionHandler?(.user(user))
    }
}

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

    
    private weak var realm: RealmManagerProtocol?
    
    init(realm: RealmManagerProtocol?) {
        self.realm = realm
    }
    
    deinit {
        print("♻️\tDeinit RegistrationViewModel")
    }

    
    func registretion(firstName: String, lastName: String, email: String, login: String, password: String) {
        refresh?(.loading)
        
        if let message = сheckRegistretionForm(firstName: firstName,
                                               lastName: lastName,
                                               email: email,
                                               login: login,
                                               password: password) {
            refresh?(.failure(message: message))
            return
        }
        
        if let _ = checkingUserInDatabase(by: login) {
            refresh?(.failure(message: "Users with a \(login) already exist"))
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
        completionHandler?(.successfully(user: user))
    }
    
    
    private func сheckRegistretionForm(firstName: String, lastName: String, email: String, login: String, password: String) -> String? {
        guard !firstName.isEmpty else {
            return "Empty First Name field"
        }
        guard !lastName.isEmpty else {
            return "Empty Last Name field"
        }
        guard !email.isEmpty else {
            return "Empty E-mail field"
        }
        guard email.isValidEmail() else {
            return "Wrong email format"
        }
        guard !login.isEmpty else {
            return "Empty Login field"
        }
        guard !password.isEmpty else {
            return "Empty Password field"
        }
        guard password.count > 6 else {
            return "Short password"
        }
        return nil
    }
    
    private func checkingUserInDatabase(by login: String) -> User? {
        guard let results = realm?.getUser(by: login) else { return nil }
        guard let user = Array(results).first else { return nil }
        return user
    }
}

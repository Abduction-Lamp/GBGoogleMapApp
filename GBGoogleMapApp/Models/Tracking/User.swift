//
//  User.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import Foundation
import RealmSwift


class User: Object {
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var email: String?
    @objc dynamic var login: String?
    @objc dynamic var password: String?
    @objc dynamic var lastTracking: Tracking?
    
    convenience init(firstName: String, lastName: String, email: String, login: String, password: String) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.login = login
        self.password = password
    }

    override static func primaryKey() -> String? {
        return "login"
    }
}

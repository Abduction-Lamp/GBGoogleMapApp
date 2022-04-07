//
//  User.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import Foundation
import RealmSwift


class User: Object {
    @Persisted var firstName: String?
    @Persisted var lastName: String?
    @Persisted var email: String?
    @Persisted(primaryKey: true) var login: String?
    @Persisted var password: String?
    @Persisted var lastTracking: String?
    @Persisted var start: Date?
    @Persisted var finish: Date?
    
    convenience init(firstName: String, lastName: String, email: String, login: String, password: String) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.login = login
        self.password = password
    }
    
    func addTracking(encoded: String, start: Date, finish: Date) {
        self.lastTracking = encoded
        self.start = start
        self.finish = finish
    }
    
    func addTracking(_ tracking: Tracking) {
        lastTracking = tracking.encodedPath
        start = tracking.start
        finish = tracking.finish
    }
}

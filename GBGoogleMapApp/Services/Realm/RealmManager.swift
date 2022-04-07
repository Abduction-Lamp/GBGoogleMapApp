//
//  RealmManager.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 22.03.2022.
//

import Foundation
import RealmSwift


protocol RealmManagerProtocol: AnyObject {
    func write<T: Object>(object: T) throws
    func read<T: Object>() -> Results<T>
    func delete<T: Object>(object: T) throws
    func remove() throws
    
    func getUser(by login: String) -> Results<User>
    func getUser(by login: String, password: String) -> Results<User>
    func wirteLastTracking(by user: User, tracking: Tracking) throws 
}


final class RealmManager: RealmManagerProtocol {
    
    private let db: Realm
    
    init?() {
        let configurator = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configurator) else {
            print("⚠️\tRealm error: failed to configure the database")
            return nil
        }
        
        self.db = realm
        print("🐙\tRealm DB location:\n\t\(realm.configuration.fileURL?.description ?? "nil")\n")
    }
    
    deinit {
        print("♻️\tDeinit RealmManager")
    }
    
    
    
    public func write<T: Object>(object: T) throws {
        try db.write {
            db.add(object, update: .all)
        }
    }
    
    public func read<T: Object>() -> Results<T> {
        return db.objects(T.self)
    }
    
    public func delete<T: Object>(object: T) throws {
        try db.write {
            db.delete(object)
        }
    }
    
    public func remove() throws {
        try db.write {
            db.deleteAll()
        }
    }
    
    
    public func getUser(by login: String) -> Results<User> {
        let object = db.objects(User.self)
        let results = object.where { $0.login == login }
        return results
    }
    
    func getUser(by login: String, password: String) -> Results<User> {
        let object = db.objects(User.self)
        let results = object.where { ($0.login == login) && ($0.password == password) }
        return results
    }
    
    func wirteLastTracking(by user: User, tracking: Tracking) throws {
        try db.write {
            user.lastTracking = tracking
        }
    }
}

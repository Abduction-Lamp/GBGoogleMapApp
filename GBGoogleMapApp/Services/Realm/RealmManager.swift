//
//  RealmManager.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 22.03.2022.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private let db: Realm
    
    init?() {
        let configurator = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configurator) else {
            print("Realm error: failed to configure the database")
            return nil
        }
        
        self.db = realm
        print("\nRealm DB location:\n\(realm.configuration.fileURL?.description ?? "nil")\n\n\n")
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
}

//
//  RealmManager.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 22.03.2022.
//

import Foundation
import RealmSwift


protocol RealmManagerProtocol {
    func write<T: Object>(object: T) throws
    func read<T: Object>() -> Results<T>
    func delete<T: Object>(object: T) throws
    func remove() throws
}


final class RealmManager: RealmManagerProtocol {
    
    private let db: Realm
    
    init?() {
        let configurator = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        guard let realm = try? Realm(configuration: configurator) else {
            print("Realm error: failed to configure the database")
            return nil
        }
        
        self.db = realm
        print("✅\tRealm DB location:\n\t\(realm.configuration.fileURL?.description ?? "nil")\n\n\n")
    }
    
    deinit {
        print("❎\tRemove RealmManager")
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

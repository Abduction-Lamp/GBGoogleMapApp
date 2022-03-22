//
//  Tracking.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 21.03.2022.
//

import Foundation
import RealmSwift

class Tracking: Object {
    @objc dynamic var encodedPath: String?
    @objc dynamic var start: Date?
    @objc dynamic var finish: Date?
    
    convenience init(encoded: String, start: Date, finish: Date) {
        self.init()
        self.encodedPath = encoded
        self.start = start
        self.finish = finish
    }
    
    override static func primaryKey() -> String? {
        return "encodedPath"
    }
}

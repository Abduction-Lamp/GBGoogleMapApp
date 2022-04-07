//
//  Tracking.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 21.03.2022.
//

import Foundation
import RealmSwift

class Tracking: Object {
    @Persisted var encodedPath: String?
    @Persisted var start: Date?
    @Persisted var finish: Date?
    
    convenience init(encoded: String, start: Date, finish: Date) {
        self.init()
        self.encodedPath = encoded
        self.start = start
        self.finish = finish
    }
}

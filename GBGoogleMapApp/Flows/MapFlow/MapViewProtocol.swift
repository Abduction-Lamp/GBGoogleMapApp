//
//  MapViewData.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 27.03.2022.
//

import Foundation
import CoreLocation

//enum MapViewData {
//    case initiation
//    case location(isLocation: Bool)
//    case updateLocation(location: CLLocation)
//    case tracking(isTracking: Bool)
//    case updateTracking(location: CLLocation)
//    case saveLastTracking(isSave: Bool)
//    case drawLastTracking(tracking: Tracking)
//    case alert(title: String, message: String)
//}


enum MapRefreshActions {
    case initiation
    case location(isLocation: Bool)
    case updateLocation(location: CLLocation)
    case tracking(isTracking: Bool)
    case updateTracking(location: CLLocation)
    case saveLastTracking(isSave: Bool)
    case drawLastTracking(tracking: Tracking)
    case alert(title: String, message: String)
}

enum MapCompletionActions {
    case aaa
}


protocol MapViewModelProtocol: AnyObject,
                               RefreshActionsProtocol,
                               CompletionActionsProtocol where RefreshActions == MapRefreshActions,
                                                               CompletionActions == MapCompletionActions {
    init(realm: RealmManagerProtocol?, user: User)
    
    func location()
    func tracking()
    
    var isLastTracking: Bool { get }
    func saveLastTracking(encoded: String?, start: Date?, finish: Date?)
    func fetchLastTracking()
}

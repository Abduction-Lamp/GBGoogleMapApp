//
//  MapViewData.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 27.03.2022.
//

import Foundation
import CoreLocation

enum MapViewData {
    case initiation
    case location(isLocation: Bool)
    case updateLocation(location: CLLocation)
    case tracking(isTracking: Bool)
    case updateTracking(location: CLLocation)
}

//
//  MapViewModel.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 27.03.2022.
//

import Foundation
import CoreLocation
import RealmSwift

final class MapViewModel: NSObject, MapViewModelProtocol {
    
    var refresh: ((MapRefreshActions) -> Void)?
    var completionHandler: ((MapCompletionActions) -> Void)?
    

    private var locationManager: CLLocationManager
    
    weak var user: User?
    private weak var realm: RealmManagerProtocol?
    
    init(realm: RealmManagerProtocol?, user: User) {
        self.realm = realm
        
        self.user = user
        
        self.locationManager = CLLocationManager()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        super.init()

        self.locationManager.delegate = self
    }

    
    private var isLocation: Bool = false {
        didSet {
            isLocation ? locationManager.startUpdatingLocation() : locationManager.stopUpdatingLocation()
            refresh?(.location(isLocation: isLocation))
        }
    }
    
    public func location() {
        guard !isTracking else { return }
        isLocation = !isLocation
    }
    
    
    private var isTracking: Bool = false {
        didSet {
            isLocation = isTracking
            refresh?(.tracking(isTracking: isTracking))
        }
    }
    
    public func tracking() {
        isTracking = !isTracking
    }
    
    
    public var isLastTracking: Bool {
        guard let _ = user?.lastTracking else { return false }
        return true
    }
    
    public func saveLastTracking(encoded: String?, start: Date?, finish: Date?) {
        guard
            let user = user,
            let encoded = encoded, let start = start, let finish = finish
        else {
            refresh?(.saveLastTracking(isSave: false))
            refresh?(.alert(title: "", message: "Failed saved"))
            return
        }
        
        let tracking = Tracking(encodedPath: encoded, start: start, finish: finish)
        do {
            try realm?.wirteLastTracking(by: user, tracking: tracking)
            refresh?(.saveLastTracking(isSave: true))
            refresh?(.alert(title: "", message: "Successfully saved"))
        } catch {
            print("⚠️\t" + error.localizedDescription)
            refresh?(.saveLastTracking(isSave: false))
            refresh?(.alert(title: "", message: "Failed saved"))
        }
    }
    
    public func fetchLastTracking() {
        if let encodedPath = user?.lastTracking, let start = user?.start, let finish = user?.finish {
            let tracking = Tracking(encodedPath: encodedPath, start: start, finish: finish)
            isLocation = false
            refresh?(.drawLastTracking(tracking: tracking))
        }
//        completionHandler?(.exit)
    }
}


// MARK: - Extension CLLocationManagerDelegate
//
extension MapViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        refresh?(.updateLocation(location: location))
        if isTracking {
            refresh?(.updateTracking(location: location))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️\t" + error.localizedDescription)
    }
}

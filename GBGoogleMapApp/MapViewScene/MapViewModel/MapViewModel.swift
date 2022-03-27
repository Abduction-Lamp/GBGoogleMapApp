//
//  MapViewModel.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 27.03.2022.
//

import Foundation
import CoreLocation
import RealmSwift


protocol MapViewModelProtocol {
    var updateMapViewData: ((MapViewData) -> Void)? { get set }
    
    init(realm: RealmManager?)
    
    func location()
    func tracking()
    
    func fetchLastTracking() -> Tracking?
}

protocol MapViewControllerProtocol {
    var viewModel: MapViewModelProtocol { get set }
    
    init(viewModel: MapViewModelProtocol)
}


final class MapViewModel: NSObject, MapViewModelProtocol {
    
    public var updateMapViewData: ((MapViewData) -> Void)?
    
    private var realm: RealmManager?
    private var locationManager: CLLocationManager
    
    init(realm: RealmManager?) {

        self.realm = realm
        
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
            updateMapViewData?(.location(isLocation: isLocation))
        }
    }
    
    public func location() {
        guard !isTracking else { return }
        isLocation = !isLocation
    }
    
    
    private var isTracking: Bool = false {
        didSet {
            isLocation = isTracking
            updateMapViewData?(.tracking(isTracking: isTracking))
        }
    }
    
    public func tracking() {
        isTracking = !isTracking
    }
    
    
    func fetchLastTracking() -> Tracking? {
        if let tracking: Results<Tracking> = realm?.read() {
            return Array(tracking).first
        }
        return nil
    }
}



// MARK: - Extension CLLocationManagerDelegate
//
extension MapViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        updateMapViewData?(.updateLocation(location: location))
        if isTracking {
            updateMapViewData?(.updateTracking(location: location))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

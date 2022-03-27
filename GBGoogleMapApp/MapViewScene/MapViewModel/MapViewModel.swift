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
        
        locationManager = CLLocationManager()
        super.init()
        initLocationManager()
    }
    
    
    private func initLocationManager() {
//        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    
    
    private var isLocation: Bool = false {
        didSet {
            isLocation ? locationManager.stopUpdatingLocation() : locationManager.stopUpdatingLocation()
            updateMapViewData?(.location(isLocation: isLocation))
        }
    }
    
    public func location() {
        isLocation = !isLocation
    }
    
    public func tracking() {
        
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
//        if isTracking {
//            drawRouteLine(coordinate: location.coordinate)
//        }
//        mapView.map.animate(toLocation: location.coordinate)
        updateMapViewData?(.updateLocation(location: location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

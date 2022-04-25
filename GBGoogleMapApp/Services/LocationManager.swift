//
//  LocationManager.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 10.04.2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay


final class LocationManager: NSObject {
    
    static let instance = LocationManager()
    
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
    }
    
    let locationManager = CLLocationManager()
    let location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location.accept(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️\t" + error.localizedDescription)
    }
}

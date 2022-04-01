//
//  MapViewModel.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 27.03.2022.
//

import Foundation
import CoreLocation
import RealmSwift

protocol MapFlowCompletionProtocol {
    
    var completionHandler: (() -> Void)? { get set }
}

protocol MapViewModelProtocol {
    var updateMapViewData: ((MapViewData) -> Void)? { get set }
    
    init(realm: RealmManagerProtocol?)
    
    func location()
    func tracking()
    
    var isLastTracking: Bool { get }
    func saveLastTracking(encoded: String?, start: Date?, finish: Date?)
    func fetchLastTracking()
}

protocol MapViewControllerProtocol {
    var viewModel: MapViewModelProtocol { get set }
    
    init(viewModel: MapViewModelProtocol)
}


final class MapViewModel: NSObject, MapViewModelProtocol, MapFlowCompletionProtocol {
    
    public var updateMapViewData: ((MapViewData) -> Void)?
    var completionHandler: (() -> Void)?
    
    private var realm: RealmManagerProtocol?
    private var locationManager: CLLocationManager
    
    init(realm: RealmManagerProtocol?) {

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
    
    
    public var isLastTracking: Bool {
        guard let result: Results<Tracking> = realm?.read(),
              let tracking = Array(result).first,
              let _ = tracking.encodedPath else { return false }
        return true
    }
    
    public func saveLastTracking(encoded: String?, start: Date?, finish: Date?) {
        if let encoded = encoded, let start = start, let finish = finish {
            let tracking = Tracking(encoded: encoded, start: start, finish: finish)
            do {
                try realm?.remove()
                try realm?.write(object: tracking)
                updateMapViewData?(.saveLastTracking(isSave: true))
                updateMapViewData?(.alert(title: "", message: "Successfully saved"))
            } catch {
                print(error.localizedDescription)
                updateMapViewData?(.saveLastTracking(isSave: false))
                updateMapViewData?(.alert(title: "", message: "Failed saved"))
            }
        }
    }
    
    public func fetchLastTracking() {
        if let result: Results<Tracking> = realm?.read(),
           let tracking = Array(result).first,
           let _ = tracking.encodedPath {
            isLocation = false
            updateMapViewData?(.drawLastTracking(tracking: tracking))
        }
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

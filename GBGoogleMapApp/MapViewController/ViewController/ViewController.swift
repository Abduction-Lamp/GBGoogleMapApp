//
//  ViewController.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 12.03.2022.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

class ViewController: UIViewController {
    
    private var mapView: MapView {
        guard let view = self.view as? MapView else {
            return MapView(frame: self.view.frame)
        }
        return view
    }
    
    private var locationManager: CLLocationManager?
    
    
    private var routeLine: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    private var markerStart: GMSMarker?
    private var markerFinish: GMSMarker?
    
    private var dateStart: Date?
    private var dateFinish: Date?
    
    private var isLocation: Bool = false {
        didSet {
            if isLocation {
                mapView.locationButton.tintColor = .systemBlue.withAlphaComponent(1)
                locationManager?.startUpdatingLocation()
            } else {
                mapView.locationButton.tintColor = .systemGray.withAlphaComponent(0.7)
                locationManager?.stopUpdatingLocation()
            }
        }
    }
    
    private var isTracking: Bool = false {
        didSet {
            if isTracking {
                cleanRouteLine()
                cleanRouteMarkers()
                dateStart = Date()
                mapView.startButton.setTitle("Stop", for: .normal)
                mapView.startButton.setTitleColor(.black, for: .highlighted)
                mapView.startButton.setTitleColor(.white, for: .normal)
                mapView.startButton.backgroundColor = .systemRed
                mapView.lastRouteButton.isEnabled = false
                isLocation = true
                
            } else {
                dateFinish = Date()
                mapView.startButton.setTitle("Start tracking", for: .normal)
                mapView.startButton.setTitleColor(.white, for: .highlighted)
                mapView.startButton.setTitleColor(.black, for: .normal)
                mapView.startButton.backgroundColor = .systemYellow
                mapView.lastRouteButton.isEnabled = true
                isLocation = false
                drawRouteMarkers()
                saveTracking()
            }
        }
    }
    
    private var lastTracking:Tracking? {
        if let tracking: Results<Tracking> = realm?.read() {
            return Array(tracking).first
        }
        return nil
    }
    
    private var realm: RealmManager?
    
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        
        self.view = MapView(frame: self.view.frame)
        mapView.startButton.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        mapView.locationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
        mapView.lastRouteButton.addTarget(self, action: #selector(tapLastRouteButton), for: .touchUpInside)
        
        mapView.zoomPlusButton.addTarget(self, action: #selector(tapZoomPlusButton), for: .touchUpInside)
        mapView.zoomMinusButton.addTarget(self, action: #selector(tapZoomMinusButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = RealmManager()
        configureMap()
        configureLocationManager()
    }
    
    
    //MARK: - Suppotr methods
    //
    private func configureMap() {
        let defaultСameraPositionInMoscow = GMSCameraPosition.camera(withLatitude: 55.7504461,
                                                                     longitude: 37.6174943,
                                                                     zoom: 17)
        mapView.map.camera = defaultСameraPositionInMoscow
        mapView.map.isMyLocationEnabled = true
        
        if lastTracking != nil {
            mapView.lastRouteButton.isEnabled = true
            mapView.lastRouteButton.setBackgroundImage(UIImage(systemName: "flag.circle"), for: .normal)
            mapView.lastRouteButton.tintColor = .systemIndigo
        }
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
//        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func drawRouteMarkers() {
        guard let count = routePath?.count(),
              let last = (count > 1) ? (count - 1) : nil,
              let start = routePath?.coordinate(at: 0),
              let finish = routePath?.coordinate(at: last) else { return }
    
        markerStart = GMSMarker(position: start)
        markerStart?.title = "Start"
        markerStart?.snippet = "\(dateStart?.description ?? "")"
        
        markerFinish = GMSMarker(position: finish)
        markerFinish?.title = "Finish"
        markerFinish?.snippet = "\(dateFinish?.description ?? "")"
        
        markerStart?.map = mapView.map
        markerFinish?.map = mapView.map
    }
    
    private func cleanRouteMarkers() {
        markerStart?.map = nil
        markerStart = nil
        markerFinish?.map = nil
        markerFinish = nil
    }
    
    private func drawRouteLine(coordinate: CLLocationCoordinate2D) {
        routePath?.add(coordinate)
        routeLine?.path = routePath
    }
    
    private func cleanRouteLine() {
        routeLine?.map = nil
        routeLine = GMSPolyline()
        setupRouteLine()
        routePath = GMSMutablePath()
        routeLine?.map = mapView.map
    }
    
    private func setupRouteLine() {
        routeLine?.geodesic = true
        routeLine?.strokeWidth = 5
        routeLine?.strokeColor = .systemPurple
    }
    
    private func saveTracking() {
        if let encoded = routePath?.encodedPath(),
           let start = dateStart,
           let finish = dateFinish {
            let tracking = Tracking(encoded: encoded, start: start, finish: finish)
            do {
                try realm?.remove()
                try realm?.write(object: tracking)
                mapView.lastRouteButton.isEnabled = true
                mapView.lastRouteButton.setBackgroundImage(UIImage(systemName: "flag.circle"), for: .normal)
                mapView.lastRouteButton.tintColor = .systemIndigo
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


// MARK: - Extension Buttons Actions
//
extension ViewController {
    
    @objc
    private func tapStartButton(_ sender: UIButton) {
        isTracking = !isTracking
    }
    
    @objc
    private func tapLocationButton(_ sender: UIButton) {
        guard !isTracking else { return }
        isLocation = !isLocation
    }
    
    @objc
    private func tapLastRouteButton(_ sender: UIButton) {
        isLocation = false
        cleanRouteLine()
        cleanRouteMarkers()
        if let encoded = lastTracking?.encodedPath {
            routePath = GMSMutablePath(fromEncodedPath: encoded)
            routeLine?.path = routePath
            
            dateStart = lastTracking?.start
            dateFinish = lastTracking?.finish
            drawRouteMarkers()
            
            let bounds = GMSCoordinateBounds(path: routePath!)
            mapView.map.moveCamera(GMSCameraUpdate.fit(bounds))
        }
    }
    
    @objc
    private func tapZoomPlusButton(_ sender: UIButton) {
        mapView.map.moveCamera(GMSCameraUpdate.zoomIn())
    }
    
    @objc
    private func tapZoomMinusButton(_ sender: UIButton) {
        mapView.map.moveCamera(GMSCameraUpdate.zoomOut())
    }
}


// MARK: - Extension CLLocationManagerDelegate
//
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if isTracking {
            drawRouteLine(coordinate: location.coordinate)
        }
        mapView.map.animate(toLocation: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printContent(error.localizedDescription)
    }
}

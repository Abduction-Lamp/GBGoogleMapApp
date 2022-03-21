//
//  ViewController.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 12.03.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    private var mapView: MapView {
        guard let view = self.view as? MapView else {
            return MapView(frame: self.view.frame)
        }
        return view
    }
    
    private var locationManager: CLLocationManager?
    private var geo: CLGeocoder?
    
    private var currentZoom: Float = 17
    
    private var routeLine: GMSPolyline?
    private var routePath: GMSMutablePath?
    
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
                mapView.startButton.setTitle("Stop", for: .normal)
                mapView.startButton.setTitleColor(.black, for: .highlighted)
                mapView.startButton.setTitleColor(.white, for: .normal)
                mapView.startButton.backgroundColor = .systemRed
                isLocation = true
            } else {
                mapView.startButton.setTitle("Start tracking", for: .normal)
                mapView.startButton.setTitleColor(.white, for: .highlighted)
                mapView.startButton.setTitleColor(.black, for: .normal)
                mapView.startButton.backgroundColor = .systemYellow
                isLocation = false
            }
        }
    }
    
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        
        self.view = MapView(frame: self.view.frame)
        mapView.startButton.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        mapView.locationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
        
        mapView.zoomPlusButton.addTarget(self, action: #selector(tapZoomPlusButton), for: .touchUpInside)
        mapView.zoomMinusButton.addTarget(self, action: #selector(tapZoomMinusButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
    }
    
    
    //MARK: - Suppotr methods
    //
    private func configureMap() {
        let defaultСameraPositionInMoscow = GMSCameraPosition.camera(withLatitude: 55.7504461,
                                                                     longitude: 37.6174943,
                                                                     zoom: currentZoom)
        mapView.map.camera = defaultСameraPositionInMoscow
        mapView.map.isMyLocationEnabled = true
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func addMarker(location: CLLocation) {
        if geo == nil { geo = CLGeocoder() }
        
        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude)
        let marker = GMSMarker(position: position)
        
        geo?.reverseGeocodeLocation(location) { placemarks, error in
            if let place = placemarks?.first {
                marker.title = place.locality
                marker.snippet = place.country
            }
        }
        marker.map = mapView.map
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
}


// MARK: - Extension Buttons Actions
//
extension ViewController {
    
    @objc
    private func tapStartButton(_ sender: UIButton) {
        cleanRouteLine()
        isTracking = !isTracking
    }
    
    @objc
    private func tapLocationButton(_ sender: UIButton) {
        guard !isTracking else { return }
        isLocation = !isLocation
    }
    
    @objc
    private func tapZoomPlusButton(_ sender: UIButton) {
        if currentZoom < mapView.map.maxZoom {
            currentZoom += 1
            mapView.map.animate(toZoom: currentZoom)
        }
    }
    
    @objc
    private func tapZoomMinusButton(_ sender: UIButton) {
        if currentZoom > mapView.map.minZoom {
            currentZoom -= 1
            mapView.map.animate(toZoom: currentZoom)
        }
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

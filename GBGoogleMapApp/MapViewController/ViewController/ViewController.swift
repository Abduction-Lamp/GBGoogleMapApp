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
    
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        
        self.view = MapView(frame: self.view.frame)
        mapView.startButton.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        mapView.zoomPlusButton.addTarget(self, action: #selector(tapZoomPlusButton), for: .touchUpInside)
        mapView.zoomMinusButton.addTarget(self, action: #selector(tapZoomMinusButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        configureMap()
    }
    
    
    //MARK: - Suppotr methods
    //
    private func configureMap() {
        let defaultСameraInMoscow = GMSCameraPosition.camera(withLatitude: 55.7504461,
                                                             longitude: 37.6174943,
                                                             zoom: currentZoom)
        mapView.map.camera = defaultСameraInMoscow
        mapView.map.isMyLocationEnabled = true
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
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
}


// MARK: - Extension Buttons Actions
//
extension ViewController {
    
    @objc
    private func tapStartButton(_ sender: UIButton) {
        locationManager?.startUpdatingLocation()
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
        guard let coordinate = locations.last else { return }
        addMarker(location: coordinate)
        mapView.map.animate(toLocation: CLLocationCoordinate2D(latitude: coordinate.coordinate.latitude,
                                                               longitude: coordinate.coordinate.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printContent(error.localizedDescription)
    }
}

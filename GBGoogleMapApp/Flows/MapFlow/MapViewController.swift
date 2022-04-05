//
//  ViewController.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 12.03.2022.
//

import UIKit
import GoogleMaps
//import CoreLocation

final class MapViewController: UIViewController {

    private var mapView: MapView {
        guard let view = self.view as? MapView else {
            return MapView(frame: self.view.frame)
        }
        return view
    }
    
    var refresh: MapRefreshActions = .initiation {
        didSet {
            
            switch refresh {
            case .initiation:
                break
                
            case .location(let isLocation):
                isLocation ? (mapView.locationButton.tintColor = .systemBlue) : (mapView.locationButton.tintColor = .systemGray)
                
            case .updateLocation(let location):
                mapView.map.animate(toLocation: location.coordinate)
                
            case .tracking(let isTracking):
                isTracking ? startTracking() : stopTracking()
                
            case .updateTracking(let location):
                drawRouteLine(coordinate: location.coordinate)
                
            case .saveLastTracking(let isSave):
                switchLastTrackingButton(isSave)
                
            case .drawLastTracking(let tracking):
                drawLastTracking(tracking: tracking)
                
            case .alert(let title, let message):
                showAlert(title: title, message: message, actionTitle: "Good") {
                    self.refresh = .initiation
                }
            }
        }
    }
    var viewModel: MapViewModel
    
    
    // MARK: - initiation
    //
    required init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
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
        
        if viewModel.isLastTracking {
            mapView.lastRouteButton.isEnabled = true
            mapView.lastRouteButton.setBackgroundImage(UIImage(systemName: "flag.circle"), for: .normal)
            mapView.lastRouteButton.tintColor = .systemOrange
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        configureMap()
        
        viewModel.refresh = { [weak self] action in
            guard let self = self else { return }
            self.refresh = action
        }
    }
    
    
    //MARK: - Suppotr methods
    //
    private func configureMap() {
        let defaultСameraPositionInMoscow = GMSCameraPosition.camera(withLatitude: 55.7504461,
                                                                     longitude: 37.6174943,
                                                                     zoom: 17)
        mapView.map.camera = defaultСameraPositionInMoscow
        mapView.map.isMyLocationEnabled = true
    }


    private var routeLine: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    private var markerStart: GMSMarker?
    private var markerFinish: GMSMarker?
    
    private var dateStart: Date?
    private var dateFinish: Date?
    
    
    private func startTracking() {
        cleanRouteLine()
        cleanRouteMarkers()
        dateStart = Date()
        mapView.startButton.setTitle("Stop", for: .normal)
        mapView.startButton.setTitleColor(.black, for: .highlighted)
        mapView.startButton.setTitleColor(.white, for: .normal)
        mapView.startButton.backgroundColor = .systemRed
        mapView.lastRouteButton.isEnabled = false
    }
    
    private func stopTracking() {
        dateFinish = Date()
        mapView.startButton.setTitle("Start tracking", for: .normal)
        mapView.startButton.setTitleColor(.white, for: .highlighted)
        mapView.startButton.setTitleColor(.black, for: .normal)
        mapView.startButton.backgroundColor = .systemYellow
        mapView.lastRouteButton.isEnabled = true
        drawRouteMarkers()
        
        viewModel.saveLastTracking(encoded: routePath?.encodedPath(), start: dateStart, finish: dateFinish)
    }
    
    private func switchLastTrackingButton(_ status: Bool) {
        if status {
            mapView.lastRouteButton.isEnabled = true
            mapView.lastRouteButton.setBackgroundImage(UIImage(systemName: "flag.circle"), for: .normal)
            mapView.lastRouteButton.tintColor = .systemOrange
        } else {
            mapView.lastRouteButton.isEnabled = false
            mapView.lastRouteButton.setBackgroundImage(UIImage(systemName: "flag.slash.circle"), for: .normal)
            mapView.lastRouteButton.tintColor = .systemGray
        }
    }
    
    private func drawLastTracking(tracking: Tracking) {
        cleanRouteLine()
        if let encoded = tracking.encodedPath {
            routePath = GMSMutablePath(fromEncodedPath: encoded)
            routeLine?.path = routePath
            
            dateStart = tracking.start
            dateFinish = tracking.finish
            drawRouteMarkers()
            
            if let path = routePath {
                let bounds = GMSCoordinateBounds(path: path)
                mapView.map.moveCamera(GMSCameraUpdate.fit(bounds))
            }
        }
//        mapViewData = .initiation
    }


    //MARK: - Supporting methods drawing on the map
    //
    private func drawRouteMarkers() {
        guard let count = routePath?.count(),
              let last = (count > 1) ? (count - 1) : nil,
              let start = routePath?.coordinate(at: 0),
              let finish = routePath?.coordinate(at: last) else { return }
    
        cleanRouteMarkers()
        
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
}


// MARK: - Extension Buttons Actions
//
extension MapViewController {
    
    @objc
    private func tapStartButton(_ sender: UIButton) {
        viewModel.tracking()
    }
    
    @objc
    private func tapLocationButton(_ sender: UIButton) {
        viewModel.location()
    }
    
    @objc
    private func tapLastRouteButton(_ sender: UIButton) {
        viewModel.fetchLastTracking()
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

//
//  ViewController.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 12.03.2022.
//

import UIKit
import GoogleMaps
import AVFoundation
import SwiftUI

final class MapViewController: UIViewController {

    private var spinner: LoadingScreenWithSpinner?
    
    private var mapView: MapView {
        guard let view = self.view as? MapView else {
            return MapView(frame: self.view.frame)
        }
        return view
    }
        
    private var userMarker: GMSMarker?
    
    
    var refresh: MapRefreshActions = .initiation {
        didSet {
            switch refresh {
            case .initiation:
                spinner?.hide()
                
            case .loading:
                spinner?.show()
                
            case .location(let isLocation):
                if isLocation {
                    (mapView.locationButton.tintColor = .systemBlue)
                } else {
                    userMarker?.map = nil
                    userMarker = nil
                    mapView.locationButton.tintColor = .systemGray
                }
                
            case .updateLocation(let location):
                mapView.map.animate(toLocation: location.coordinate)
                userMarker?.position = location.coordinate
                
            case .tracking(let isTracking):
                isTracking ? startTracking() : stopTracking()
                
            case .updateTracking(let location):
                drawRouteLine(coordinate: location.coordinate)
                
            case .saveLastTracking(let isSave):
                switchLastTrackingButton(isSave)
                
            case .saveUserpic(let image):
                initUserMarker(by: image)
                
            case .drawLastTracking(let tracking):
                drawLastTracking(tracking: tracking)
                
            case .alert(let title, let message):
                showAlert(title: title, message: message, actionTitle: "Good") {
                    self.refresh = .initiation
                }
            }
        }
    }
    
    private weak var viewModel: MapViewModel?

    
    // MARK: - initiation
    //
    required init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("♻️\tDeinit MapViewController")
    }

    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        configureMap()
        
        viewModel?.refresh = { [weak self] action in
            guard let self = self else { return }
            self.refresh = action
        }
    }
    
    
    //MARK: - Suppotr methods
    //
    private func configureUI() {
        self.view = MapView(frame: self.view.frame)
        mapView.startButton.addTarget(self, action: #selector(tapStartButton), for: .touchUpInside)
        mapView.locationButton.addTarget(self, action: #selector(tapLocationButton), for: .touchUpInside)
        mapView.lastRouteButton.addTarget(self, action: #selector(tapLastRouteButton), for: .touchUpInside)
        
        mapView.zoomPlusButton.addTarget(self, action: #selector(tapZoomPlusButton), for: .touchUpInside)
        mapView.zoomMinusButton.addTarget(self, action: #selector(tapZoomMinusButton), for: .touchUpInside)
        
        mapView.exitButton.addTarget(self, action: #selector(tapExitButton), for: .touchUpInside)
        
        if viewModel?.isLastTracking == true {
            mapView.lastRouteButton.isEnabled = true
            mapView.lastRouteButton.setBackgroundImage(UIImage(systemName: "flag.circle"), for: .normal)
            mapView.lastRouteButton.tintColor = .systemGreen
        }
        
        mapView.profileButton.menu = UIMenu(title: viewModel?.userFullName ?? "",
                                            options: .displayInline,
                                            children: [cameraMenuHandler, galleryMenuHandler])
        
        spinner = LoadingScreenWithSpinner(view: mapView)
        
        if let image = viewModel?.initUserpic() {
            initUserMarker(by: image)
        }
    }

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
        
        viewModel?.saveLastTracking(encoded: routePath?.encodedPath(), start: dateStart, finish: dateFinish)
    }
    
    private func switchLastTrackingButton(_ status: Bool) {
        if status {
            mapView.lastRouteButton.isEnabled = true
            mapView.lastRouteButton.setBackgroundImage(UIImage(systemName: "flag.circle"), for: .normal)
            mapView.lastRouteButton.tintColor = .systemGreen
        } else {
            mapView.lastRouteButton.isEnabled = false
            mapView.lastRouteButton.setBackgroundImage(UIImage(systemName: "flag.slash.circle"), for: .normal)
            mapView.lastRouteButton.tintColor = .systemGray
        }
    }
    
    private func drawLastTracking(tracking: Tracking) {
        cleanRouteLine()
        
        routePath = GMSMutablePath(fromEncodedPath: tracking.encodedPath)
        routeLine?.path = routePath
            
        dateStart = tracking.start
        dateFinish = tracking.finish
        drawRouteMarkers()
        
        if let path = routePath {
            let bounds = GMSCoordinateBounds(path: path)
            mapView.map.moveCamera(GMSCameraUpdate.fit(bounds))
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
        viewModel?.tracking()
    }
    
    @objc
    private func tapLocationButton(_ sender: UIButton) {
        viewModel?.location()
    }
    
    @objc
    private func tapLastRouteButton(_ sender: UIButton) {
        viewModel?.fetchLastTracking()
    }
    
    @objc
    private func tapZoomPlusButton(_ sender: UIButton) {
        mapView.map.moveCamera(GMSCameraUpdate.zoomIn())
    }
    
    @objc
    private func tapZoomMinusButton(_ sender: UIButton) {
        mapView.map.moveCamera(GMSCameraUpdate.zoomOut())
    }
    
    @objc
    private func tapExitButton(_ sender: UIButton) {
        viewModel?.exit()
    }
    
    private var cameraMenuHandler: UIMenuElement {
        
        return UIAction(title: "Take new photo", image: UIImage(systemName: "camera")) {[weak self]  _ in
            self?.refresh = .loading
            
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                self?.showAlert(title: "Device Error", message: "Camera is not available", actionTitle: "Cancel", handler: {
                    self?.refresh = .initiation
                })
                return
            }
        }
    }
    
    private var galleryMenuHandler: UIMenuElement {
        return UIAction(title: "Open Gallery", image: UIImage(systemName: "photo.on.rectangle")) { [weak self] _ in
            self?.refresh = .loading
            
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            self?.present(imagePickerController, animated: true, completion: {
                self?.refresh = .initiation
            })
        }
    }
}


extension MapViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        refresh = .initiation
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = extractImage(from: info) {
            viewModel?.gallery(image: image)
        }
        
        picker.dismiss(animated: true, completion: nil)
        refresh = .initiation
    }

    
    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            return image
        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            return image
        }
        return nil
    }
    
    
    private func initUserMarker(by image: UIImage) {
        let size = CGSize(width: 50.0, height: 50.0)
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = size.width / 2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        imageView.image = image

        userMarker = GMSMarker()
        userMarker?.iconView = imageView
        userMarker?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        userMarker?.map = mapView.map
    }
}

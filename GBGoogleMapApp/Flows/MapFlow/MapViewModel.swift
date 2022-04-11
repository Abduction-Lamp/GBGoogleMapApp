//
//  MapViewModel.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 27.03.2022.
//

import Foundation
import CoreLocation
import RealmSwift
import RxSwift

final class MapViewModel: MapViewModelProtocol {
    
    var refresh: ((MapRefreshActions) -> Void)?
    var completionHandler: ((MapCompletionActions) -> Void)?
    
    weak var user: User?
    private weak var realm: RealmManagerProtocol?
    
    
    private let disposeBag = DisposeBag()
    private var locationManager = LocationManager.instance
    
    
    init(realm: RealmManagerProtocol?, user: User) {
        self.realm = realm
        self.user = user

        self.locationManager
            .location
            .asObservable()
            .bind(onNext: { [weak self] location in
                guard let location = location else { return }
                self?.refresh?(.updateLocation(location: location))
                if self?.isTracking == true {
                    self?.refresh?(.updateTracking(location: location))
                }
            }).disposed(by: disposeBag)
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
    }
    
    public func exit() {
        completionHandler?(.exit)
    }
}

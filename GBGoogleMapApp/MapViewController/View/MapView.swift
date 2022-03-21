//
//  MapView.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 17.03.2022.
//

import UIKit
import GoogleMaps

final class MapView: UIView {
    
    public lazy var map: GMSMapView = GMSMapView.init()
    
    private(set) var lastRouteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "flag.slash.circle"), for: .normal)
        button.tintColor = .systemGray
        button.contentMode = .scaleToFill
        return button
    }()
    
    private(set) var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Start tracking", for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private(set) var locationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(systemName: "location.circle"), for: .normal)
        button.tintColor = .systemGray.withAlphaComponent(0.7)
        button.contentMode = .scaleToFill
        return button
    }()
    
    private(set) var zoomPlusButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.buttonSize = .large
        config.cornerStyle = .large
        config.image = UIImage(systemName: "plus")
        config.imagePadding = 0
        config.imagePlacement = .all

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
    
    private(set) var zoomMinusButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.buttonSize = .large
        config.cornerStyle = .large
        config.image = UIImage(systemName: "minus")
        config.imagePadding = 0
        config.imagePlacement = .all
        
        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        return button
    }()
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 7
        return stack
    }()
    
    
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure Content
    //
    private func configuration() {
        self.addSubview(map)
        self.addSubview(lastRouteButton)
        self.addSubview(startButton)
        self.addSubview(locationButton)
        self.addSubview(stack)

        stack.addArrangedSubview(zoomPlusButton)
        stack.addArrangedSubview(zoomMinusButton)

        placesConstraint()
    }
    
    private func placesConstraint() {
        map.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: self.topAnchor),
            map.leftAnchor.constraint(equalTo: self.leftAnchor),
            map.rightAnchor.constraint(equalTo: self.rightAnchor),
            map.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            lastRouteButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            lastRouteButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 5),
            lastRouteButton.widthAnchor.constraint(equalToConstant: 40),
            lastRouteButton.heightAnchor.constraint(equalToConstant: 40),
            
            startButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 40),
            
            locationButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            locationButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -5),
            locationButton.widthAnchor.constraint(equalToConstant: 40),
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            
            stack.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -5),
            stack.widthAnchor.constraint(equalToConstant: 40),
            stack.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

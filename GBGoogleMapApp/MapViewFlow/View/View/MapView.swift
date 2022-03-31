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
    
    private let size = CGSize(width: 150, height: 40)
    private let spacing = CGFloat(7)
    
    
    private(set) lazy var lastRouteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        button.setBackgroundImage(UIImage(systemName: "flag.slash.circle"), for: .normal)
        button.tintColor = .systemGray
        button.contentMode = .scaleToFill
        button.layer.cornerRadius = size.height/2
        return button
    }()
    
    private(set) lazy var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Start tracking", for: .normal)
        button.layer.cornerRadius = size.height/2
        return button
    }()
    
    private(set) lazy var locationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        button.setBackgroundImage(UIImage(systemName: "location.circle"), for: .normal)
        button.tintColor = .systemGray.withAlphaComponent(1)
        button.contentMode = .scaleToFill
        button.layer.cornerRadius = size.height/2
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
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = spacing
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
            lastRouteButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10),
            lastRouteButton.widthAnchor.constraint(equalToConstant: size.height),
            lastRouteButton.heightAnchor.constraint(equalToConstant: size.height),
            
            startButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: size.width),
            startButton.heightAnchor.constraint(equalToConstant: size.height),
            
            locationButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            locationButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10),
            locationButton.widthAnchor.constraint(equalToConstant: size.height),
            locationButton.heightAnchor.constraint(equalToConstant: size.height),
            
            stack.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -5),
            stack.widthAnchor.constraint(equalToConstant: size.height),
            stack.heightAnchor.constraint(equalToConstant: size.height + size.height + spacing)
        ])
    }
}

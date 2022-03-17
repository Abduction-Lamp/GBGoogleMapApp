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
    
    private(set) var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private(set) var zoomPlusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("+", for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private(set) var zoomMinusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.white, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("-", for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 10
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
        self.addSubview(startButton)
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
            
            startButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 40),
            
            stack.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            stack.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -5),
            stack.widthAnchor.constraint(equalToConstant: 40),
            stack.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

//
//  LoadingScreenWithSpinner.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import UIKit

final class LoadingScreenWithSpinner {

    private weak var parent: UIView?

    private var blurEffect = UIBlurEffect(style: .regular)
    private var canvas = UIVisualEffectView()
    private var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    init(view: UIView) {
        parent = view
    }
    
    deinit {
        parent = nil
    }
    
    public func show() {
        if let view = parent {
            DispatchQueue.main.async {
                self.canvas.frame = UIScreen.main.bounds
                self.canvas.effect = self.blurEffect
                self.canvas.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        
                self.spinner.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
                self.spinner.center = self.canvas.center
                self.spinner.style = .large
                self.spinner.color = .systemRed

                self.canvas.contentView.addSubview(self.spinner)
                view.addSubview(self.canvas)
                
                self.spinner.startAnimating()
            }
        }
    }
    
    public func hide() {
        if parent != nil {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.canvas.removeFromSuperview()
            }
        }
    }
}

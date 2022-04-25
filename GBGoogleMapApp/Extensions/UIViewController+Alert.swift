//
//  UIViewController+Extension.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import Foundation

import UIKit

extension UIViewController {

    public func showAlert(title: String, message: String, actionTitle: String, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            handler?()
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}

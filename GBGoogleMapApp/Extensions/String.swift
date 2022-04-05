//
//  String.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import UIKit

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-zА-Яа-я._%+-]+@[A-Za-z0-9А-Яа-я.-]+\\.[A-Za-zА-Яа-я]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

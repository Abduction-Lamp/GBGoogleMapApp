//
//  Refresh.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import Foundation

protocol RefreshActionsProtocol {
    associatedtype RefreshActions
    var refresh: ((RefreshActions) -> Void)? { get set }
}

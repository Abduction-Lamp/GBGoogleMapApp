//
//  Completion.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import Foundation

protocol CompletionActionsProtocol {
    associatedtype CompletionActions
    var completionHandler: ((CompletionActions) -> Void)? { get set }
}

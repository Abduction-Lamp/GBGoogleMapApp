//
//  StorageManager.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 20.04.2022.
//

import Foundation
import UIKit

final class StorageManager {
    
    private let manager = FileManager.default
    
    private let root: URL
    
    private let appFolder = "GBGoogleMapApp"
    private let userFolder: String
    
    init?(user: User) {
        guard let login = user.login else { return nil }
        userFolder = login
        
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        root = url.appendingPathComponent(appFolder).appendingPathComponent(userFolder)
        
        do {
            try manager.createDirectory(at: root, withIntermediateDirectories: true, attributes: [:])
        } catch {
            print("⚠️\t Storage Manager: Failed to create root directory")
            print("\t \(root.absoluteString)")
            print("⚠️\t Storage Manager: " + error.localizedDescription)
            return nil
        }
        
        print("✅\tStorage Manager: Success")
        print("🦄\tRoot directory: \(root.absoluteString)")
    }
    
    public func save(userpic: UIImage) throws -> URL {
        let filePath = root.appendingPathComponent("userpic.jpg")
        try userpic.jpegData(compressionQuality: 1.0)?.write(to: filePath)
        return filePath
    }
}

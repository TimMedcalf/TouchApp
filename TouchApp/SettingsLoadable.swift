//
//  SettingsManageable.swift
//  TouchApp
//
//  Created by Tim Medcalf on 26/01/2020.
//  Copyright © 2020 ErgoThis Ltd. All rights reserved.
//

import Foundation

protocol SettingsLoadable {
    
 
    mutating func loadUsingSettingsFile() -> Bool
    func settingsURL() -> URL
}


extension SettingsLoadable where Self: Codable {
    
    func settingsURL() -> URL {
      let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
      return cachesDirectory.appendingPathComponent("\(Self.self).plist")
    }
    
    mutating func loadUsingSettingsFile() -> Bool {
        guard let originalSettingsURL = Bundle.main.url(forResource: "\(Self.self)", withExtension: "plist")
         else { return false }
    }
}

//
//  NetworkingConfiguration.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class NetworkingConfiguration {
    private var infoDict = Bundle.main.infoDictionary
    
    private func stringValue(forKey key: String) -> String {
        guard let value = infoDict?[key] as? String else {
            fatalError("Cannot get string value from Info.plist")
        }
        return value
    }
    
    private enum InfoPlistKeys {
        static let serverProtocol = "ServerProtocol"
        static let baseServerUrl = "BaseServerUrl"
        static let apiKey = "ApiKey"
        static let sharedSecret = "SharedSecret"
    }
  
    public static let shared = NetworkingConfiguration()
    
    var baseApiPath: String {
        let prefix = stringValue(forKey: InfoPlistKeys.serverProtocol)
        let base = stringValue(forKey: InfoPlistKeys.baseServerUrl)
        
        return "\(prefix)://\(base)"
    }
    
    var apiKey: String {
        return stringValue(forKey: InfoPlistKeys.apiKey)
    }
    
    var sharedSecret: String {
        return stringValue(forKey: InfoPlistKeys.sharedSecret)
    }
    
}

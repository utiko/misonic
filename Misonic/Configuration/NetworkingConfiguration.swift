//
//  NetworkingConfiguration.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class NetworkingConfiguration {
    enum Environment {
        case staging
        case production
    }
    
    public static let shared = NetworkingConfiguration()
    
    var environment: Environment = .production
    
    var baseApiPath: String {
        switch environment {
        case .staging: fatalError("Staging not available")
        case .production: return "https://ws.audioscrobbler.com"
        }
    }
    
    var apiKey: String {
        switch environment {
        case .staging: fatalError("Staging not available")
        case .production: return "***REMOVED***"
        }
    }
    
    var sharedSecret: String {
        switch environment {
        case .staging: fatalError("Staging not available")
        case .production: return "***REMOVED***"
        }
    }
    
}

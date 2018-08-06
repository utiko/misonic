//
//  ArtistSearchRequest.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ArtistSearchRequest: BaseRequest <ArtistSearchResponse> {
    
    var searchQuery: String = ""
    
    override func apiMethod() -> String {
        return "artist.search"
    }
    
    override func parameters() -> [String: Any] {
        var parameters = super.parameters()
        parameters["artist"] = searchQuery
        return parameters
    }
}

struct ArtistSearchResponse: Decodable {
    struct Results: Decodable {
        struct Matches: Decodable {
            var artists: [Artist]
            
            enum CodingKeys: String, CodingKey {
                case artists = "artist"
            }
        }
        
        let artistmatches: Matches
    }
    
    let results: Results
}

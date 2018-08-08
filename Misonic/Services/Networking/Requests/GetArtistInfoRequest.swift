//
//  GetArtistInfoRequest.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/6/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class GetArtistInfoRequest: LastFMBaseRequest <GetArtistInfoResponse> {
    
    var artistID: String = ""
    
    override func apiMethod() -> String {
        return "artist.getInfo"
    }
    
    override func parameters() -> [String: Any] {
        var parameters = super.parameters()
        parameters["mbid"] = artistID
        return parameters
    }
}

struct GetArtistInfoResponse: Decodable {
    let artist: Artist
}

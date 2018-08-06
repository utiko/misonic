//
//  GetArtistAlbumsRequest.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/6/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class GetArtistAlbumsRequest: BaseRequest <GetArtistAlbumsResponse> {
    
    var artistID: String = ""
    
    override func apiMethod() -> String {
        return "artist.getTopAlbums"
    }
    
    override func parameters() -> [String: Any] {
        var parameters = super.parameters()
        parameters["mbid"] = artistID
        return parameters
    }
}

struct GetArtistAlbumsResponse: Decodable {
    struct TopAlbums: Decodable {
        var albums: [Album]
        
        enum CodingKeys: String, CodingKey {
            case albums = "album"
        }
        
        init(from decoder: Decoder) throws {
            let map = try decoder.container(keyedBy: CodingKeys.self)
            
            // Last.fm API returns some albums without ID for some reason, so filter it out
            albums = (try map.decode(Array.self, forKey: .albums)).filter { !$0.albumID.isEmpty }
        }
    }
    
    var topalbums: TopAlbums
}

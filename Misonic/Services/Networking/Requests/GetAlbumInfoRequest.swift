//
//  GetAlbumInfoRequest.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class GetAlbumInfoRequest: LastFMBaseRequest <GetAlbumInfoResponse> {
    
    var albumID: String = ""
    
    override func apiMethod() -> String {
        return "album.getInfo"
    }
    
    override func parameters() -> [String: Any] {
        var parameters = super.parameters()
        parameters["mbid"] = albumID
        return parameters
    }
}

struct GetAlbumInfoResponse: Decodable {
    let album: Album
}

//
//  AlbumScreenDataModel.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class AlbumScreenDataModel {
    
    var albumID: String
    var album: Album
    
    init(albumID: String) {
        self.albumID = albumID
    }
    
    func startLoadingData() {
        
    }
}

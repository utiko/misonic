//
//  AlbumScreenDataModel.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

protocol AlbumScreenDataModelDelegate: class {
    func dataUpdated()
}

class AlbumScreenDataModel {
    weak var delegate: AlbumScreenDataModelDelegate?
    
    var albumID: String
    var album: Album?
    
    init(albumID: String) {
        self.albumID = albumID
    }
    
    func startLoadingData() {
        let request = GetAlbumInfoRequest { [weak self] result in
            switch result {
            case .success(let response):
                self?.album = response.album
                self?.delegate?.dataUpdated()
                
            default:
                // TODO: - Handle errors
                break
            }
        }
        request.albumID = albumID
        request.perform()
    }
}

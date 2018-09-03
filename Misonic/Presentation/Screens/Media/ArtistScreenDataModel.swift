//
//  ArtistsScreenDataModel.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/6/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class ArtistScreenDataModel {
    weak var delegate: ScreenDataModelDelegate?
    
    public var artistID: String
    public private(set) var artist: Artist?
    public private(set) var albums = [Album]()
    
    init(artistID: String) {
        self.artistID = artistID
    }

    init(artist: Artist) {
        self.artist = artist
        self.artistID = artist.artistID
    }

    func startLoadingData() {
        getArtistInfo()
    }
    
    func getArtistInfo() {
        let request = GetArtistInfoRequest { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.artist = response.artist
                self?.getAlbums()
            default:
                // TODO: - Handle errors
                break
            }
        }
        request.artistID = artistID
        request.perform()
    }
    
    func getAlbums() {
        let request = GetArtistAlbumsRequest { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.albums = response.topalbums.albums
                self?.delegate?.dataUpdated()
            case .errorResponse(let serverError):
                // Handle server error
                print(serverError.message)
                
            case .error(let error):
                // Handle behavior error
                print(error ?? "")
            }
        }
        request.artistID = artistID
        request.perform()
    }
    
}

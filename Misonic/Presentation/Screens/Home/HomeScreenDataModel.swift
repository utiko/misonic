//
//  HomeScreenDataModel.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 9/2/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class HomeScreenDataModel: ScreenDataModeling {
    struct HomeAlbumGroup {
        var artistID: String
        var artistName: String
        var albums: [Album]
    }
    
    weak var delegate: ScreenDataModelDelegate?

    var albumGroups: [HomeAlbumGroup] = []
    
    func startLoadingData() {
        DatabaseProvider.getAlbums { [weak self] (albums) in
            // Group albums by artist ID
            // map result dict into [HomeAlbumGroup]
            // sort by artist name
            self?.albumGroups = Dictionary(grouping: albums) { $0.artist.artistID }
                .map { (_, albums) in
                    HomeAlbumGroup(artistID: albums.first!.artist.artistID,
                                   artistName: albums.first!.artist.name,
                                   albums: albums)
                }
                .sorted { $0.artistName > $1.artistName }
            
            self?.delegate?.dataUpdated()
        }
    }
}

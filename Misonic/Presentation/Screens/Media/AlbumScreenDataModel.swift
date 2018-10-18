//
//  AlbumScreenDataModel.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

class AlbumScreenDataModel {
    weak var delegate: ScreenDataModelDelegate?
    
    private (set) var albumID: String
    private (set) var album: Album?
    private (set) var isInMyLibrary: Bool?
    
    init(albumID: String) {
        self.albumID = albumID
    }
    
    init(album: Album) {
        self.albumID = album.albumID
        self.album = album
    }
    
    public func startLoadingData() {
        getAlbumFromDatabase { [weak self] in
            self?.reloadAlbumData {
                self?.delegate?.dataUpdated()
            }
        }
    }
    
    public func saveAlbumToMyLibrary() {
        guard let album = album else { return }
        
        DatabaseProvider.addAlbum(album: album, completion: { [weak self] success in
            self?.isInMyLibrary = success
            self?.delegate?.dataUpdated()
        })
    }

    public func removeAlbumFromMyLibrary() {
        DatabaseProvider.removeAlbum(withID: albumID) { [weak self] in
            self?.isInMyLibrary = false
            self?.delegate?.dataUpdated()
        }
    }
    
    private func getAlbumFromDatabase(completion: @escaping () -> Void) {
        DatabaseProvider.getAlbum(withID: albumID) { [weak self] (album) in
            guard let album = album else {
                self?.isInMyLibrary = false
                completion()
                return
            }
            
            self?.album = album
            self?.isInMyLibrary = true
            completion()
        }
    }
    
    private func reloadAlbumData(completion: @escaping () -> Void) {
        let request = GetAlbumInfoRequest { [weak self] result in
            switch result {
            case .success(let response):
                self?.album = response.album
                completion()
                
            default:
                // TODO: - Handle errors
                completion()
            }
        }
        request.albumID = albumID
        request.perform()
    }
    
}

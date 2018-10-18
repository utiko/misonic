//
//  DatabaseProvider.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseProvider {
    
    enum DatabaseError: Error {
        case objectAlreadyExist
    }
    
    static var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Realm not creted")
        }
    }
    
    private static let realmQueue = DispatchQueue(label: "net.utiko.misonic.RealmQueue")
    private static let mainQueue = DispatchQueue.main

    static func getArtists(completion:@escaping ([Artist]) -> Void) {
        realmQueue.async {
            let artistsManaged = self.realm.objects(ArtistManaged.self)
            let artists = Array(artistsManaged.map { Artist(with: $0) })
            mainQueue.async {
                completion(artists)
            }
        }
    }
    
    static func addArtist(artist: Artist, completion: @escaping (Bool) -> Void) {
        realmQueue.async {
            do {
                // Skip if exists
                guard realm.object(ofType: ArtistManaged.self, forPrimaryKey: artist.artistID) == nil else {
                    throw DatabaseError.objectAlreadyExist
                }
                
                try realm.write {
                    realm.add(artist.getManaged())
                }
                
                mainQueue.async { completion(true) }
            } catch {
                mainQueue.async { completion(false) }
            }
        }
    }
    
    static func getAlbums(completion:@escaping ([Album]) -> Void) {
        realmQueue.async {
            let albumsManaged = self.realm.objects(AlbumManaged.self)
            let albums = Array(albumsManaged.map { Album(with: $0) })
            mainQueue.async {
                completion(albums)
            }
        }
    }
    
    static func getAlbum(withID albumID: String, completion:@escaping (Album?) -> Void) {
        realmQueue.async {
            var album: Album?
            if let albumManaged = self.realm.object(ofType: AlbumManaged.self, forPrimaryKey: albumID) {
                album = Album(with: albumManaged)
            }
            mainQueue.async {
                completion(album)
            }
        }
    }
    
    static func addAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        realmQueue.async {
            do {
                // Skip if exists
                guard realm.object(ofType: AlbumManaged.self, forPrimaryKey: album.albumID) == nil else {
                    mainQueue.async { completion(true) }
                    return
                }
                
                try realm.write {
                    realm.add(album.getManaged())
                }
                
                mainQueue.async { completion(true) }
            } catch {
                mainQueue.async { completion(false) }
            }
        }
    }
    
    static func removeAlbum(withID albumID: String, completion: @escaping () -> Void) {
        realmQueue.async {
            defer {
                mainQueue.async { completion() }
            }
            
            do {
                // Skip if exists
                guard let album = realm.object(ofType: AlbumManaged.self, forPrimaryKey: albumID) else {
                    // Object not exists
                    return
                }
                
                try realm.write {
                    realm.delete(album)
                }
            } catch {}
        }
    }
}

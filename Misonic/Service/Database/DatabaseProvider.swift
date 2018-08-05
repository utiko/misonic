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
    //static let shared = DatabaseProvider()
    
    // Thread safe realm
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
                guard realm.object(ofType: ArtistManaged.self, forPrimaryKey: artist.id) == nil else {
                    throw NSError(domain: "", code: 12, userInfo: nil)
                }
                
                try realm.write {
                    realm.add(artist.getManaged())
                }
                
                DispatchQueue.main.async { completion(true) }
            } catch {
                DispatchQueue.main.async { completion(false) }
            }
            
        }
    }
}

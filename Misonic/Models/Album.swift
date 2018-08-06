//
//  Album.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import RealmSwift

struct Album: Decodable, ManagedConvertable {
    typealias ManagedType = AlbumManaged
    
    var albumID: String
    var artist: AlbumArtist
    var name: String
    var playcount: Int
    var images: ImageList
    
    private enum CodingKeys: String, CodingKey {
        case albumID = "mbid"
        case artist
        case name
        case playcount
        case images = "image"
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        // In ideal world ID always exists, but last.fm API returns some albums without ID for some reason
        // So I'm using empty value as default for ID as well and filter it out on higher level
        albumID = (try? map.decode(String.self, forKey: .albumID)) ?? ""
        
        name = (try? map.decode(String.self, forKey: .name)) ?? ""
        artist = (try? map.decode(AlbumArtist.self, forKey: .artist)) ?? AlbumArtist()
        playcount = (try? map.decode(Int.self, forKey: .playcount)) ?? 0
        images = (try? map.decode(ImageList.self, forKey: .images)) ?? []
    }
    
    init(with managed: AlbumManaged) {
        albumID = managed.albumID
        name = managed.name
        artist = AlbumArtist(artistID: managed.artistID, name: managed.artistName)
        playcount = managed.playcount
        images = managed.images.map { Image(with: $0) }
    }
    
    func getManaged() -> AlbumManaged {
        let managed = AlbumManaged()
        managed.albumID = albumID
        managed.name = name
        managed.artistID = artist.artistID
        managed.artistName = artist.name
        managed.images = images.managedList()
        return managed
    }
}

struct AlbumArtist: Decodable {
    var artistID = ""
    var name = ""
    
    private enum CodingKeys: String, CodingKey {
        case artistID = "mbid"
        case name
    }
}

class AlbumManaged: Object {
    @objc dynamic var albumID: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var artistID: String = ""
    @objc dynamic var artistName: String = ""
    @objc dynamic var playcount: Int = 0

    var images = List<ImageManaged>()
    
    override static func primaryKey() -> String? {
        return "albumID"
    }
}

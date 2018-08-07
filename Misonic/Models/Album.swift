//
//  Album.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import RealmSwift

extension KeyedDecodingContainer {
    public func decodeStringTo(_ type: Int.Type, forKey key: K) throws -> Int {
        if let strValue = try? decode(String.self, forKey: key), let value = Int(strValue) {
            return value
        }
        
        do {
            return try decode(Int.self, forKey: key)
        } catch {
            throw error
        }
    }
}

struct Album: Decodable, ManagedConvertable {
    typealias ManagedType = AlbumManaged
    
    var albumID: String
    var artist: AlbumArtist
    var name: String
    var playcount: Int
    var images: ImageList
    var tracks: [AlbumTrack]
    
    private enum CodingKeys: String, CodingKey {
        case albumID = "mbid"
        case artist
        case name
        case playcount
        case images = "image"
        case tracks
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)

        // In ideal world ID always exists, but last.fm API returns some albums without ID for some reason
        // So I'm using empty value as default for ID as well and filter it out on higher level
        albumID = (try? map.decode(String.self, forKey: .albumID)) ?? ""
        
        name = (try? map.decode(String.self, forKey: .name)) ?? ""
        playcount = (try? map.decodeStringTo(Int.self, forKey: .playcount)) ?? 0
        images = (try? map.decode(ImageList.self, forKey: .images)) ?? []
        
        var albumTracks = [AlbumTrack]()
        if let trackContainer = try? map.decode(AlbumTrackContainer.self, forKey: .tracks) {
            albumTracks = trackContainer.tracks
        }
        tracks = albumTracks
        
        // Use artist from first track if missed at album
        artist = (try? map.decode(AlbumArtist.self, forKey: .artist))
            ?? albumTracks.first?.artist
            ?? AlbumArtist()
    }
    
    init(with managed: AlbumManaged) {
        albumID = managed.albumID
        name = managed.name
        artist = AlbumArtist(artistID: managed.artistID, name: managed.artistName)
        playcount = managed.playcount
        images = managed.images.map { Image(with: $0) }
        tracks = managed.tracks.map { AlbumTrack(with: $0) }
    }
    
    func getManaged() -> AlbumManaged {
        let managed = AlbumManaged()
        managed.albumID = albumID
        managed.name = name
        managed.artistID = artist.artistID
        managed.artistName = artist.name
        managed.images = images.managedList()
        managed.tracks = tracks.managedList()
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
    @objc dynamic var playcount: Int = 0
    @objc dynamic var artistID: String = ""
    @objc dynamic var artistName: String = ""

    var images = List<ImageManaged>()
    var tracks = List<AlbumTrackManaged>()

    override static func primaryKey() -> String? {
        return "albumID"
    }
}

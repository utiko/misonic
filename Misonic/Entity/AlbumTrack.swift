//
//  AlbumTrack.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import RealmSwift

struct AlbumTrack: Decodable, ManagedConvertable {
    typealias ManagedType = AlbumTrackManaged
    
    var name: String
    var duration: StringCodableMap<Int>
    var artist: AlbumArtist?
    
    init(with managed: AlbumTrackManaged) {
        name = managed.name
        duration = StringCodableMap<Int>(managed.duration)
    }
    
    func getManaged() -> AlbumTrackManaged {
        let managed = AlbumTrackManaged()
        managed.name = name
        managed.duration = duration.decoded
        return managed
    }
}

class AlbumTrackManaged: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var duration: Int = 0
}

extension Array where Iterator.Element == AlbumTrack {
    func managedList() -> List<AlbumTrackManaged> {
        let list = List<AlbumTrackManaged>()
        list.append(objectsIn: map { $0.getManaged() })
        return list
    }
}

struct AlbumTrackContainer: Decodable {
    var tracks: [AlbumTrack]
    
    enum CodingKeys: String, CodingKey {
        case tracks = "track"
    }
}

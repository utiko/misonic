//
//  Artist.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol ArrayConvertable {
    associatedtype ManagedType: Object
    
    func getManagedList() -> List<ManagedType>
}

struct Artist: Decodable, ManagedConvertable {
    
    var artistID: String
    var name: String
    var listeners: Int
    var stats: ArtistStats?
    var images: ImageList
    
    private enum CodingKeys: String, CodingKey {
        case artistID = "mbid"
        case name
        case listeners
        case stats
        case images = "image"
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        artistID = try map.decode(String.self, forKey: .artistID)
        name = (try? map.decode(String.self, forKey: .name)) ?? ""
        
        stats = try? map.decode(ArtistStats.self, forKey: .stats)
        if let valueStr = try? map.decode(String.self, forKey: .listeners), let value = Int(valueStr) {
            listeners = value
        } else {
            listeners = stats?.listeners.decoded ?? 0
        }
        
        images = (try? map.decode(ImageList.self, forKey: .images)) ?? []
    }
    
    init(with managed: ArtistManaged) {
        artistID = managed.artistID
        name = managed.name
        listeners = managed.listeners
        images = managed.images.map { Image(with: $0) }
    }
    
    func getManaged() -> ArtistManaged {
        let managed = ArtistManaged()
        managed.artistID = artistID
        managed.name = name
        managed.listeners = listeners
        managed.images = images.managedList()
        return managed
    }
}

struct ArtistStats: Decodable {
    var listeners: StringCodableMap<Int>
    var playcount: StringCodableMap<Int>
}

class ArtistManaged: Object {
    @objc dynamic var artistID: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var listeners: Int = 0
    
    var images = List<ImageManaged>()
    
    override static func primaryKey() -> String? {
        return "artistID"
    }
}

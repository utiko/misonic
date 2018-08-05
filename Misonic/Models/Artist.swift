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

struct Artist: Decodable {
    
    var id = ""
    var name = ""
    var listeners = 0
    var images = ImageList()
    
    private enum CodingKeys: String, CodingKey {
        case id = "mbid"
        case name
        case listeners
        case images = "image"
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        id = try map.decode(String.self, forKey: .id)
        name = (try? map.decode(String.self, forKey: .name)) ?? ""
        
        if let listenersStr = try? map.decode(String.self, forKey: .listeners) {
            listeners = Int(listenersStr) ?? 0
        }
        
        images = (try? map.decode(ImageList.self, forKey: .images)) ?? []
    }
    
    init(with managed: ArtistManaged) {
        id = managed.id
        name = managed.name
        listeners = managed.listeners
        images = managed.images.map { Image(with: $0) }
    }
    
    func getManaged() -> ArtistManaged {
        let managed = ArtistManaged()
        managed.id = id
        managed.name = name
        managed.listeners = 0
        
        managed.images = List<ImageManaged>()
        managed.images.append(objectsIn: images.map { $0.getManaged() })
        return managed
    }
}

class ArtistManaged: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var listeners: Int = 0
    
    var images = List<ImageManaged>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

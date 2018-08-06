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

protocol ManagedConvertable {
    associatedtype ManagedType: Object
    
    init(with managed: ManagedType)
    func getManaged() -> ManagedType
}

protocol ArrayConvertable {
    associatedtype ManagedType: Object
    
    func getManagedList() -> List<ManagedType>
}

struct Artist: Decodable, ManagedConvertable {
    
    var artistID: String
    var name: String
    var listeners: Int
    var images: ImageList
    
    private enum CodingKeys: String, CodingKey {
        case artistID = "mbid"
        case name
        case listeners
        case images = "image"
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        artistID = try map.decode(String.self, forKey: .artistID)
        name = (try? map.decode(String.self, forKey: .name)) ?? ""
        
        if let valueStr = try? map.decode(String.self, forKey: .listeners), let value = Int(valueStr) {
            listeners = value
        } else {
            listeners = 0
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
        managed.listeners = 0
        managed.images = images.managedList()
        return managed
    }
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

//
//  ArtistSearchRequest.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct ArtistSearchResponse: Decodable {
    struct Results: Decodable {
        struct Matches: Decodable {
            var artists: [Artist]
            
            enum CodingKeys: String, CodingKey {
                case artists = "artist"
            }
        }
        
        let artistmatches: Matches
    }
    
    let results: Results
}

class Artist: Object, Decodable {
    
    @objc dynamic var name: String = ""
    var images = List<Image>()
    
    private enum ArtistCodingKeys: String, CodingKey {
        case name
        case image
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArtistCodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let imagesArray = try container.decode([Image].self, forKey: .image)
        
        let imageList = List<Image>()
        imageList.append(objectsIn: imagesArray)
        self.init(name: name, images: imageList)
    }
    
    init(name: String, images: List<Image>) {
        super.init()
        self.name = name
        self.images = images
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

enum ImageSizeType: String, Decodable {
    case small
    case medium
    case large
    case extralarge
    case mega
    case unknown
}

class Image: Object, Decodable {
    
    @objc dynamic var size = ""
    @objc dynamic var urlString = ""
    
    var sizeType: ImageSizeType {
        return ImageSizeType(rawValue: size) ?? .unknown
    }
    
    var url: URL? {
        return URL(string: urlString)
    }

    enum CodingKeys: String, CodingKey {
        case size
        case urlString = "#text"
    }
}

typealias ImageCollection = List<Image>

/*extension Array where Iterator.Element == Image {
    func imageUrl(for type: ImageSizeType) -> URL? {
        return self.first(where: { $0.sizeType == type})?.url
    }
}*/

struct ServerError: Decodable {
    var error: Int = 0
    var message = ""
}

class ArtistSearchRequest: BaseRequest <ArtistSearchResponse, ServerError> {
    
    var searchQuery: String = ""
    
    override func apiMethod() -> String {
        return "artist.search"
    }
    
    override func parameters() -> [String: Any] {
        var parameters = super.parameters()
        parameters["artist"] = searchQuery
        return parameters
    }
}

//
//  Image.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import RealmSwift

enum ImageSizeType: String, Decodable {
    case small
    case medium
    case large
    case extralarge
    case mega
    case unknown
}

struct Image: Decodable {
    
    var size: ImageSizeType = .unknown
    var url: URL?
    
    enum CodingKeys: String, CodingKey {
        case size
        case url = "#text"
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        size = (try? map.decode(ImageSizeType.self, forKey: .size)) ?? .unknown
        url = try? map.decode(URL.self, forKey: .url)
    }
    
    init(with managed: ImageManaged) {
        self.url = URL(string: managed.urlString)
        self.size = ImageSizeType(rawValue: managed.size) ?? .unknown
    }
    
    func getManaged() -> ImageManaged {
        let managed = ImageManaged()
        managed.size = size.rawValue
        managed.urlString = url?.absoluteString ?? ""
        return managed
    }
}

class ImageManaged: Object {
    @objc dynamic var size: String = ""
    @objc dynamic var urlString: String = ""
}

typealias ImageList = [Image]

extension Array where Iterator.Element == Image {
    func imageUrl(for size: ImageSizeType) -> URL? {
        return self.first { $0.size == size}?.url ?? anyImageUrl()
    }
    
    func anyImageUrl() -> URL? {
        return self.reversed().first { $0.url != nil }?.url
    }
}

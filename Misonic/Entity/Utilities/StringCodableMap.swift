//
//  StringCodableMap.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

struct StringCodableMap <Decoded: LosslessStringConvertible>: Codable {
    
    var decoded: Decoded
    
    init(_ decoded: Decoded) {
        self.decoded = decoded
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedString = try container.decode(String.self)
        
        guard let decoded = Decoded(decodedString) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "The string \(decodedString) is not representable as a \(Decoded.self)"
            )
        }
        self.decoded = decoded
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(decoded.description)
    }
}

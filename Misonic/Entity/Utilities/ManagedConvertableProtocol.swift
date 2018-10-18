//
//  ManagedConvertable.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import RealmSwift

protocol ManagedConvertable {
    associatedtype ManagedType: Object
    
    init(with managed: ManagedType)
    func getManaged() -> ManagedType
}

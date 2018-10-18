//
//  BaseScreenDataModelDelegate.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 9/2/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation

protocol ScreenDataModeling {
    func startLoadingData()
}

protocol ScreenDataModelDelegate: class {
    func dataUpdated()
}

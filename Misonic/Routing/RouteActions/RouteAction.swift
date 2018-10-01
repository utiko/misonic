//
//  RouteAction.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 10/1/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation


protocol RouteAction {
    func perform()
}


enum MainFlowActions: RouteAction {
    case searchButtonPressed
    case didSelectArtist
    case didSelectAlbum
}

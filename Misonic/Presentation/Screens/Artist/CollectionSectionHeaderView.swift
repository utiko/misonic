//
//  ArtistAlbumsHeaderView.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class CollectionSectionHeaderView: UICollectionReusableView, NibReusable {
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String = "" {
        didSet { titleLabel.text = title }
    }
    
}

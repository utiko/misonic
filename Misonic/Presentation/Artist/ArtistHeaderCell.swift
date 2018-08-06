//
//  ArtistHeaderCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/6/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class ArtistHeaderCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var listenersCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

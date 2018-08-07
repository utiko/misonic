//
//  ArtistImageView.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

class ArtistImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.size.width / 2
        layer.borderColor = UIColor.Misonic.orange.cgColor
        layer.borderWidth = 5
        layer.masksToBounds = true
    }
}

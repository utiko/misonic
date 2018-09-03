//
//  AlbumTrackCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/8/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class AlbumTrackCell: UICollectionViewCell, NibReusable, ModelConfigurableCell, CollectionCellLayouting {
    typealias ModelType = AlbumTrack

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func configure(with model: AlbumTrack) {
        titleLabel.text = model.name
        
        let duration = model.duration.decoded
        let seconds = duration % 60
        let minutes = duration / 60
        durationLabel.text = String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    static func size(for collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: 40)
    }
    
}

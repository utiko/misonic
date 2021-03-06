//
//  ArtistHeaderCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/6/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class ArtistHeaderCell: UICollectionViewCell, NibReusable, ModelConfigurableCell, CollectionCellLayouting {
    
    typealias ModelType = Artist
    
    @IBOutlet private(set) weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var listenersCountLabel: UILabel!
    
    func configure(with model: Artist) {
        artistNameLabel.text = model.name
        
        if model.listeners > 0 {
            listenersCountLabel.text = "\(model.listeners) listeners"
        } else {
            listenersCountLabel.isHidden = true
        }
        
        artistImageView.setImage(with: model.images.imageUrl(forSize: .large))
    }
    
    func updateParalax(forPosition position: CGFloat) {
        var progress = position / frame.size.height
        if progress > 1 { progress = 1 }
        
        let scale = 1 - progress / 2
        let translation = position / 2
        let alpha = progress > 0 ? 1 - progress : 1
        artistImageView.transform = CGAffineTransform.identity
            .translatedBy(x: 0, y: translation)
            .scaledBy(x: scale, y: scale)
        artistImageView.alpha = alpha
    }
    
    static func size(for collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: width)
    }

}

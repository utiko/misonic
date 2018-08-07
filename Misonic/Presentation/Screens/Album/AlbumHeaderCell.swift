//
//  AlbumHeaderCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class AlbumHeaderCell: UICollectionViewCell, NibReusable, ModelConfigurableCell, CollectionCellLayouting {
    typealias ModelType = Album
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    
    func configure(with model: Album) {
        titleLabel.text = model.name
        artistNameLabel.text = "by \(model.artist.name)"
        if model.playcount > 0 {
            playCountLabel.isHidden = false
            playCountLabel.text = "Played \(model.playcount) times"
        } else {
            playCountLabel.isHidden = true
        }
        albumImageView.setImage(with: model.images.imageUrl(forSize: .large))
    }
    
    static func size(for collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: width)
    }
    
    func updateParalax(forPosition position: CGFloat) {
        var progress = position / frame.size.height
        if progress > 1 { progress = 1 }
        
        let scale = 1 - progress / 2
        let translation = position / 2
        let alpha = progress > 0 ? 1 - progress : 1
        albumImageView.transform = CGAffineTransform.identity
            .translatedBy(x: 0, y: translation)
            .scaledBy(x: scale, y: scale)
        albumImageView.alpha = alpha
    }
}

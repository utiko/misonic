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
    
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var listenersCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: Artist) {
        artistNameLabel.text = model.name
        
        if let stats = model.stats, stats.listeners.decoded > 0 {
            listenersCountLabel.text = "\(stats.listeners.decoded) listeners"
            listenersCountLabel.isHidden = false
        } else {
            listenersCountLabel.isHidden = true
        }
        
        if let imageUrl = model.images.imageUrl(for: .extralarge) {
            artistImageView.af_setImage(withURL: imageUrl)
        } else {
            artistImageView.image = nil
        }
    }
    
    static func size(for collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: width)
    }

}

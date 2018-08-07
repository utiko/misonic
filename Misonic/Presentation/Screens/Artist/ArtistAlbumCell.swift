//
//  ArtistAlbumCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class ArtistAlbumCell: UICollectionViewCell, NibReusable, ModelConfigurableCell, CollectionCellLayouting {
    
    typealias ModelType = Album

    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var albumTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
    }
    
    func configure(with model: Album) {
        albumTitleLabel.text = model.name
        if let url = model.images.imageUrl(for: .large) {
            albumImageView.af_setImage(withURL: url)
        }
    }
    
    static func size(for collectionView: UICollectionView) -> CGSize {
        let columnCount: CGFloat = 2
        let space: CGFloat = 16
        
        let width = (collectionView.frame.size.width - space * (columnCount + 1))  / columnCount
        let height = width + 50
        return CGSize(width: width, height: height)
    }

}

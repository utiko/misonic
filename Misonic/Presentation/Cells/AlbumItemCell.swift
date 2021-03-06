//
//  AlbumItemCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import Reusable

class AlbumItemCell: UICollectionViewCell, NibReusable, ModelConfigurableCell, CollectionCellLayouting {
    
    typealias ModelType = Album

    @IBOutlet private(set) weak var albumImageView: UIImageView!
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
        albumImageView.setImage(with: model.images.imageUrl(forSize: .large))
    }
    
    static func size(for collectionView: UICollectionView) -> CGSize {
        let columnCount: CGFloat = 2
        let space: CGFloat = 16
        
        let width = (collectionView.frame.size.width - space * (columnCount + 1))  / columnCount
        let height = width + 50
        return CGSize(width: width, height: height)
    }
}

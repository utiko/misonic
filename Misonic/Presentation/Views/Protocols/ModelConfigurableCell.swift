//
//  ModelConfigurableCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

protocol ModelConfigurableCell {
    associatedtype ModelType
    func configure(with model: ModelType)
}

protocol CollectionCellLayouting where Self: UICollectionViewCell {
    static func size(for collectionView: UICollectionView) -> CGSize
}

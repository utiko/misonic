//
//  SearchResultTableViewCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/5/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchResultArtistCell: UITableViewCell, ModelConfigurableCell {
    typealias ModelType = Artist
    
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var artistListenersLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        artistImageView.image = nil
    }
    
    func configure(with model: Artist) {
        artistNameLabel.text = model.name
        artistListenersLabel.text = "\(model.listeners) listeners"
        artistImageView.setImage(with: model.images.imageUrl(forSize: .medium))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  SearchResultTableViewCell.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/5/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit
import AlamofireImage

protocol ModelConfigurableCell {
    associatedtype ModelType
    func configure(with model: ModelType)
}

class SearchResultArtistCell: UITableViewCell, ModelConfigurableCell {
    typealias ModelType = Artist
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistListenersLabel: UILabel!

    func configure(with model: Artist) {
        if let url = model.images.imageUrl(for: .medium) {
            artistImageView.af_setImage(withURL: url)
        } else {
            artistImageView.image = nil
        }
        
        artistNameLabel.text = model.name
        artistListenersLabel.text = "\(model.listeners) listeners"
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

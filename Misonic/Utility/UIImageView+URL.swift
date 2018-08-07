//
//  UIImageView+URL.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(with url: URL?, animated: Bool = true) {
        guard let url = url else {
            image = nil
            return
        }
        
        let transition: UIImageView.ImageTransition = animated ? .crossDissolve(0.2) : .noTransition
        af_setImage(withURL: url, imageTransition: transition, runImageTransitionIfCached: false, completion: { _ in
            
        })
        
    }
    
}

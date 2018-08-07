//
//  GradientView.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/7/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    @IBInspectable var topColor: UIColor = .clear
    @IBInspectable var bottomColor: UIColor = .clear
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [ 0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

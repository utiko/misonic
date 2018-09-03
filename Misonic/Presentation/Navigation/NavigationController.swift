//
//  NavigationController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/2/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }

    func configureNavigationBar() {
        navigationBar.shadowImage = UIImage()
//        navigationBar.barTintColor = .black
//        navigationBar.tintColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

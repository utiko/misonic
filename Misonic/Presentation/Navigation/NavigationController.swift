//
//  NavigationController.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/2/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    private var customInteractor: MainNavigationInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        delegate = self
    }

    func configureNavigationBar() {
        navigationBar.shadowImage = UIImage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard viewControllers.first != viewController else { return }
        customInteractor = MainNavigationInteractor(attachTo: viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let customInteractor = customInteractor else { return nil }
        return customInteractor.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presenting: Bool
        
        switch operation {
        case .push:
            presenting = true
            
        default:
            presenting = false
        }
        
        return MainNavigationTransition(presenting: presenting)
    }
}

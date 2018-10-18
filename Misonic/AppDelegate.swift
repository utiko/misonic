//
//  AppDelegate.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/2/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
       return UIWindow(frame: UIScreen.main.bounds)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let startupVC = HomeViewController.loadFromStoryboard()
        let navigationController = NavigationController(rootViewController: startupVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

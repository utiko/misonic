//
//  StoryboardLoadableProtocol.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/6/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

protocol StoryboardLoadable: class {
    static var sourceStoryboard: Storyboard { get }
}

extension StoryboardLoadable where Self: UIViewController {
    
    static var storyboardID: String {
        return String(describing: self)
    }
    
    static func loadFromStoryboard() -> Self {
        let storyboard = UIStoryboard.mainBundleStoryboard(sourceStoryboard)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Self.storyboardID) as? Self else {
            fatalError("Not found view controller with storyboard ID \(Self.storyboardID) of type\(String(describing: self)) on storyboard \(sourceStoryboard.rawValue)")
        }
        return vc
    }
}

public enum Storyboard: String {
    case home = "Home"
    case media = "Media"
}

extension UIStoryboard {
    public static func mainBundleStoryboard(_ storyboard: Storyboard) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
    }
}

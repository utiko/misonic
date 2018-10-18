//
//  RouteAction.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 10/1/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import UIKit

// Predifinitions

class MainNavigationController: UINavigationController {}
class SecondaryNavigationController: UINavigationController {}
class OnboardingNavigationController: UINavigationController {}
class EmptyLaunchViewController: UIViewController {}
class StartOnboardingViewController: UIViewController {}
class SignInViewController: UIViewController {}
class SignUpViewController: UIViewController {}
class PhoneVerificationViewController: UIViewController {}
class SetDisplayNameViewController: UIViewController {}
class SetAvatarViewController: UIViewController {}
class OnboardingCompletionViewController: UIViewController {}

// Article start

/*
We have such main problems which router should handle.
 1. Where we should go after some action.
 2. How we should get there. Type of navigation, animation etc.
 3. Providing meta data for target screen.
 
 First of all I need Router, it should have two methods for now:
 */

protocol Router {
    func navigate(route: Route, animated: Bool, context: RouteContext?)
    func performStartupRoute()
}

/*
 During implementing a router I'm taking into account a dip-linking and possibility that app could be launched in two modes:
 - Authorized: main flow
 - Not authorized: on-boarding flow
 
 So I need to declare RouteFlow with expected flows:
 */

enum RouteFlow {
    case main
    case onboarding
}

/*
 RouteTarget which should return a target view controller for my Router.
*/

protocol RouteTarget {
    var targetViewController: UIViewController { get }
}

/*
 
 And finally Route which contains all of this data and provides detailed route to specified target:
*/

enum Route {
    
    // Present root navigation stack
    // Used mostly for startup navigation and dip-linking
    // targets could contain more then one target for navigation stack if needed
    case root(flow: RouteFlow, targets: [RouteTarget])
    
    // Opens view controller in current navigation stack
    case open(target: RouteTarget)
    
    // Presents view controller with new navigation controller
    case present(target: RouteTarget)
    
    // Replace curernt view controller at it's navigation controller
    case replaceCurrent(target: RouteTarget)
    
    // Replace all view controllers in current navigation controller with new navigation stack
    case replaceStack(targets: [RouteTarget])
    
    // Pop or dismiss view controller depends on how it was opened
    case disapearCurrent
    
    // Pop to view controller which mathes with provided target
    // If exists in current navigation controller stack
    // case popTo(target: RouteTarget)
}

/*
Basically let's assume all route actions are performed from ViewControllers so RouteContext is current view controller.
*/

typealias RouteContext = UIViewController

/*
 Ok now we're ready to start implementing our router. I prefer to make it singleton as long as it responsible for deeplinking and startup route, I don't want to loose state which come from url or push notifications.
*/
/*
class DefaultRouter: Router {
    static let shared = DefaultRouter()
}
*/
 
/*
 But I want to prevent access to it from any place of my app, so I can make it fileprivate
 And create in same file a protocol with extension for classes which could use the router
 */

class DefaultRouter: Router {
    fileprivate static let shared = DefaultRouter()
}

protocol Routable {}
extension Routable {
    var router: Router {
        return DefaultRouter.shared
    }
}

/*
 Now it's easy to do something like:
 */
/*
extension RouteActionHandler: Routable {
    func handleAction() {
        router.navigate(route: .someRoute, context: nil)
    }
}
*/

/*
 Let's implement everything to conform Router protocol
*/

extension DefaultRouter {
    func navigate(route: Route, animated: Bool, context: RouteContext?) {
        switch route {
        case .root(let flow, let targets):
            performRootRoute(flow: flow, targets: targets, animated: animated)
        case .present(let target):
            present(target: target, animated: true, context: context)
        case .open(let target):
            open(target: target, animated: true, context: context)
        case .replaceCurrent(let target):
            replaceCurrent(target: target, animated: animated, context: context)
        case .replaceStack(let targets):
            replaceNavigationStack(targets: targets, animated: animated, context: context)
        case .disapearCurrent:
            disapearCurrent(animated: animated, context: context)
        }
    }
    
    func performStartupRoute() {
        // TODO: Implement startup route
    }
}

/*
 Before implementing navigations let's add accessor for main window
 */

extension DefaultRouter {
    var window: UIWindow {
        guard let window = UIApplication.shared.keyWindow else {
            fatalError("Key window has not been configured")
        }
        
        return window
    }
}
/*
     Now let's implement one by one all navigations:
 */

extension DefaultRouter {

    private func performRootRoute(flow: RouteFlow, targets: [RouteTarget], animated: Bool) {
        
        let viewControllers = targets.compactMap({ $0.targetViewController })
        
        switch flow {
        case .main:
            let navigationController = MainNavigationController()
            navigationController.viewControllers = viewControllers
            window.set(rootViewController: navigationController, animated: animated)
            
        case .onboarding:
            let navigationController = OnboardingNavigationController()
            navigationController.viewControllers = viewControllers
            window.set(rootViewController: navigationController, animated: animated)
        }
    }
}

/*
 I'm using three different navigation controller classes:
 - MainNavigationController for main flow
 - OnboardingNavigationController for onboarding flow
 - SecondaryNavigationController for everything what can be presented modally from main or onboarding flow
 
 To make animated transition between root navigation controllers, I'll implement UIWindow extension:
 
 */

extension UIWindow {
    func set(rootViewController: UIViewController, animated: Bool) {
        if animated {
            let transition = CATransition()
            transition.type = CATransitionType.fade
            layer.add(transition, forKey: nil)
        }
        
        self.rootViewController = rootViewController
    }
}

/*
 Present view controller with separate navigation
 */

private func present(target: RouteTarget, animated: Bool = true, context: RouteContext?) {
    guard let currentNavigationController = context?.navigationController else { return }
    
    let targetVC = target.targetViewController
    let navigationController = SecondaryNavigationController(rootViewController: targetVC)
    currentNavigationController.present(navigationController,
                                        animated: animated,
                                        completion: nil)
}

/*
 Open view controller navigation:
 */

private func open(target: RouteTarget, animated: Bool = true, context: RouteContext?) {
    guard let navigationController = context?.navigationController else { return }
    
    navigationController.pushViewController(target.targetViewController,
                                            animated: animated)
}

/*
 Replace current view controller in navigation stack:
 */

private func replaceCurrent(target: RouteTarget, animated: Bool = true, context: RouteContext?) {
    guard let navigationController = context?.navigationController else { return }
    
    var viewControllers = navigationController.viewControllers
    viewControllers.removeLast()
    viewControllers.append(target.targetViewController)
    navigationController.setViewControllers(viewControllers, animated: animated)
}

/*
 Replace whole navigation stack for current navigation controller:
 */

private func replaceNavigationStack(targets: [RouteTarget], animated: Bool = true, context: RouteContext?) {
    guard let navigationController = context?.navigationController else { return }
    
    let viewControllers = targets.compactMap({ $0.targetViewController })
    navigationController.setViewControllers(viewControllers, animated: animated)
}

/*
 Disappear current view controller:
 */
 
private func disapearCurrent(animated: Bool = true, context: RouteContext?) {
    guard let currentVC = context else { return }
    
    if let navigationController = currentVC.navigationController, navigationController.viewControllers.count > 1 {
        navigationController.popViewController(animated: animated)
        return
    }
    
    if let presentingVC = currentVC.presentingViewController {
        presentingVC.dismiss(animated: animated, completion: nil)
        return
    }
}

enum RouteTargets {
    enum Onboarding: RouteTarget {
        case startOnboarding
        case signIn
        case signUp
        case phoneVerification(phoneNumber: String)
        case selectProfileType
        case setDisplayName
        case setAvatar
        
        var targetViewController: UIViewController {
            switch self {
            case .signIn:
                <#code#>
            default:
                fatalError("Not implemented yet")
            }
        }
    }
}

//protocol RouteAction {
//    var route: Route?
//}
//
//extension RouteAction {
//    public func perform(animated: Bool = true) {
//        guard let route = route else { return }
//
//        router.navigate(route, animated: animated)
//    }
//}
//
//enum MainFlowRouteAction {
//    case mainMenuItemSelected(item: MenuItem)
//    case searchButtonPressed
//    case didSelectArtist(artistID: String)
//    case didSelectAlbum(albumID: String)
//}
//
//extension MainFlowRouteAction: RouteAction {
//    func perform() {
//
//    }
//}
//
//
//enum MenuItem {
//
//}

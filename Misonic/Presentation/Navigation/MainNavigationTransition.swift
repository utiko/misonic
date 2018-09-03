//
//  MainNavigationTransition.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 9/3/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import UIKit

class MainNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private static let duration = 0.25
    
    let presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    override init() {
        self.presenting = true
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return MainNavigationTransition.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
            else { return }
        
        let container = transitionContext.containerView
        
        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        // Setup frames
        let originFrame = container.bounds
        var leftSideFrame = originFrame
        leftSideFrame.origin.x = -originFrame.size.width * 2 / 3
        var rightSideFrame = originFrame
        rightSideFrame.origin.x = originFrame.size.width
        
        // Startup configuration
        toView.alpha = 0
        toView.frame = presenting ? rightSideFrame : leftSideFrame
        toView.layoutIfNeeded()
        
        let logoAnimation = TransitionImageAnimation(transitionContext: transitionContext, isPresenting: presenting)
        
        // animate from view controller away
        UIView.animate(
            withDuration: MainNavigationTransition.duration,
            delay: 0.0,
            options: UIViewAnimationOptions.curveEaseOut, animations: {
                if self.presenting {
                    fromView.frame = leftSideFrame
                } else {
                    fromView.frame = rightSideFrame
                }
                
                toView.frame = originFrame
                fromView.alpha = 0.0
                toView.alpha = 1.0
                
                logoAnimation?.doAnimation()
                
        }, completion: { _ in
            logoAnimation?.completeTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}

protocol TransitionImageAnimationing {
    func animatableImageView(for transitionType: TransitionImageAnimation.TransitionType) -> UIImageView?
}

class TransitionImageAnimation {
    enum TransitionType {
        case parent
        case child
    }

    typealias TransitionImageAnimationingVC = UIViewController & TransitionImageAnimationing

    var animatedImageView: UIImageView
    var fromVCAnimatableImageView: UIImageView
    var toVCAnimatableImageView: UIImageView
    var logoEndFrame: CGRect
    var logoEndCornerRadius: CGFloat
    var logoEndBorderWidth: CGFloat

    init?(transitionContext: UIViewControllerContextTransitioning, isPresenting: Bool) {
        let fromVCTransitionType: TransitionType = isPresenting ? .child : .parent
        let toVCTransitionType: TransitionType = isPresenting ? .parent : .child

        guard let fromVC = transitionContext.viewController(forKey: .from) as? TransitionImageAnimationingVC,
            let toVC = transitionContext.viewController(forKey: .to) as? TransitionImageAnimationingVC,
            let fromVCAnimatableImageView = fromVC.animatableImageView(for: fromVCTransitionType),
            let toVCAnimatableImageView = toVC.animatableImageView(for: toVCTransitionType) else { return nil }
        
        self.toVCAnimatableImageView = toVCAnimatableImageView
        self.fromVCAnimatableImageView = fromVCAnimatableImageView
        
        animatedImageView = UIImageView(image: fromVCAnimatableImageView.image)
        animatedImageView.frame = fromVCAnimatableImageView.frame(inView: fromVC.view) ?? fromVCAnimatableImageView.frame
        animatedImageView.layer.cornerRadius = fromVCAnimatableImageView.layer.cornerRadius
        animatedImageView.layer.masksToBounds = true
        animatedImageView.layer.borderColor = fromVCAnimatableImageView.layer.borderColor
        animatedImageView.layer.borderWidth = fromVCAnimatableImageView.layer.borderWidth
        
        logoEndFrame = toVCAnimatableImageView.frame(inView: toVC.view) ?? toVCAnimatableImageView.frame
        logoEndCornerRadius = toVCAnimatableImageView.layer.cornerRadius
        logoEndBorderWidth = toVCAnimatableImageView.layer.borderWidth
        
        toVCAnimatableImageView.isHidden = true
        fromVCAnimatableImageView.isHidden = true
        transitionContext.containerView.addSubview(animatedImageView)
    }
    
    func doAnimation() {
        animatedImageView.frame = logoEndFrame
        animatedImageView.layer.cornerRadius = logoEndCornerRadius
        animatedImageView.layer.borderWidth = logoEndBorderWidth
    }
    
    func completeTransition() {
        toVCAnimatableImageView.isHidden = false
        fromVCAnimatableImageView.isHidden = false
        animatedImageView.removeFromSuperview()
    }
}

class MainNavigationInteractor: UIPercentDrivenInteractiveTransition {
    
    weak var navigationController: UINavigationController!
    var shouldCompleteTransition = false
    var transitionInProgress = false
    
    init?(attachTo viewController: UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
            setupBackGesture(view: viewController.view)
        } else {
            return nil
        }
    }
    
    private func setupBackGesture(view: UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc private func handleBackGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let progress = viewTranslation.x / self.navigationController.view.frame.width
        let velocity = gesture.velocity(in: gesture.view)
        
        switch gesture.state {
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
        case .changed:
            shouldCompleteTransition = progress > 0.5 || velocity.x > 100
            update(progress)
        case .cancelled:
            transitionInProgress = false
            cancel()
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
        default:
            return
        }
    }
}

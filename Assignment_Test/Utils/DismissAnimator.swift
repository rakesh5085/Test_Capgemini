//
//  DismissAnimator.swift
//
//  This file contains the implementation of a custom UIViewControllerAnimatedTransitioning object.
//  The object is used to animate the dismissal of a view controller, moving it off-screen to the bottom.

import UIKit

// DismissAnimator: NSObject is a custom class that conforms to the UIViewControllerAnimatedTransitioning protocol.
class DismissAnimator : NSObject {
    
    // Implementation of the UIViewControllerAnimatedTransitioning protocol's required method.
    // Returns the duration of the animation in seconds.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6 // The animation duration is set to 0.6 seconds.
    }
    
    // Implementation of the UIViewControllerAnimatedTransitioning protocol's required method.
    // Performs the animation for the transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Guard statement to ensure both fromVC and toVC are not nil.
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        // Insert toVC's view below fromVC's view in the container view.
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        // Define the final frame for fromVC's view, positioned off-screen at the bottom.
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        // Animate the transition by moving fromVC's view to the final frame.
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations

//
//  ExpandTransition.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/3/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class ExpandTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    static var animator = ExpandTransition()
    
    enum ExpandTransitionMode: Int {
        case present, dismiss
    }
    let presentDuration = 0.4
    let dismissDuration = 0.15
    
    var openingFrame: CGRect?
    var transitionMode: ExpandTransitionMode = .present
    
    var zoomableCardView: UIView!
    var zoomableView: UIView!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if (transitionMode == .present) {
            return presentDuration
        } else {
            return dismissDuration
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let fromViewFrame = fromViewController.view.frame
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let toViewFrame = toViewController.view.frame
        
        let containerView = transitionContext.containerView
        
        if (transitionMode == .present) {
            let snapshotView = toViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: .zero)
            snapshotView?.frame = openingFrame!
            containerView.addSubview(snapshotView!)
            
            toViewController.view.alpha = 0
            containerView.addSubview(toViewController.view)
            
            UIView.animate(withDuration: presentDuration, delay: 0, options: .curveEaseOut, animations: {
                snapshotView?.frame = toViewController.view.frame
            }, completion: { (finished) in
                snapshotView?.removeFromSuperview()
                toViewController.view.alpha = 1
                transitionContext.completeTransition(finished)
            })
        } else {
            let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.bounds, afterScreenUpdates: true, withCapInsets: .zero)
            containerView.addSubview(snapshotView!)
            
            fromViewController.view.alpha = 0
            
            UIView.animate(withDuration: dismissDuration, delay: 0, options: .curveEaseOut, animations: {
                snapshotView?.frame = self.openingFrame!
            }, completion: { (finished) in
                snapshotView?.removeFromSuperview()
                fromViewController.view.alpha = 1
                transitionContext.completeTransition(finished)
            })
        }
        
    }
    
}

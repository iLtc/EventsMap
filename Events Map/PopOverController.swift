//
//  PopOverController.swift
//  Events Map
//
//  Created by uics3 on 11/11/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class PopOverController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: (containerView?.bounds.size)!)
        frame.origin.y = containerView!.frame.height*(1.0/4.0)
        return frame
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
}

//
//  InkOverlay.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/3/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class InkOverlay: UIView, MDCInkTouchControllerDelegate {
    
    fileprivate var inkTouchController: MDCInkTouchController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.inkTouchController = MDCInkTouchController(view:self)
        self.inkTouchController!.addInkView()
        self.inkTouchController!.delegate = self
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

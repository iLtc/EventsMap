//
//  PopOverController.swift
//  Events Map
//
//  Created by uics3 on 11/11/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class PopOverView: NSObject {
    
    
    
    func showView() {
        
        if let window = UIApplication.shared.keyWindow {
            let dimmingView = UIView()
            dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            dimmingView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(dismiss(_:))))
            window.addSubview(dimmingView)
            dimmingView.frame = window.frame
            dimmingView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                dimmingView.alpha = 1
            })
        }
        
    }
    
    @objc func dismiss(_ view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0
        }) { (bool) in
            view.removeFromSuperview()
        }
    }
    
    override init() {
        super.init()
    }
    
}

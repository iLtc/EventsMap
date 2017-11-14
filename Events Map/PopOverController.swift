//
//  PopOverController.swift
//  Events Map
//
//  Created by Tony Chen on 11/11/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class PopOverView: NSObject {
    
    
    let dimmingView = UIView()
    var showView: UIView = UIView()
    
    func presentView(_ presentView: UIView) {
        
        if let window = UIApplication.shared.keyWindow {
            
            dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            if presentView.tag == 1 {
                dimmingView.backgroundColor = UIColor(white: 0, alpha: 0)
            }
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            window.addSubview(dimmingView)
            showView = presentView
            window.addSubview(showView)
            showView.frame = CGRect(x: 0, y: window.frame.height, width: presentView.frame.width, height: presentView.frame.height)
            
            
            dimmingView.frame = window.frame
            dimmingView.alpha = 0
 
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.dimmingView.alpha = 1
                self.showView.frame = CGRect(x: 0, y: (window.frame.height - self.showView.frame.height), width: self.showView.frame.width, height: self.showView.frame.height)
            }, completion: nil)
            
            
        }
        
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.dimmingView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.showView.frame = CGRect(x: 0, y: window.frame.height, width: self.showView.frame.width, height: self.showView.frame.height)
            }
        }, completion: nil)
    }

    override init() {
        super.init()
    }
    
}

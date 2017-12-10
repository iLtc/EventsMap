//
//  CreationTransition.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/9/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//


import UIKit
import MaterialComponents

class CreationTransition: NSObject {
    
    
    let dimmingView = UIView()
    var showView: UIView = UIView()
    var floatBtn = MDCFloatingButton()
    let colors = [UIColor.MDColor.blue, UIColor.MDColor.green, UIColor.MDColor.red, UIColor.MDColor.orange, UIColor.MDColor.pink, UIColor.MDColor.indigo, UIColor.MDColor.yellow, UIColor.MDColor.amber, UIColor.MDColor.deepOrange, UIColor.MDColor.teal, UIColor.MDColor.lime, UIColor.MDColor.lightGreen, UIColor.MDColor.lightBlue]
//    var mode = 2 //leftUpCorner
    
    func presentView(startPoint: CGPoint, toView: UIView) {
        
        let dice1 = arc4random_uniform(UInt32(colors.count))
        
//        mode = startMode(startPoint: startPoint)
        
        if let window = UIApplication.shared.keyWindow {
            
            
            dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            if toView.tag == 1 {
                dimmingView.backgroundColor = UIColor(white: 0, alpha: 0)
            }
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            window.addSubview(dimmingView)
            let height = toView.frame.size.height
            let width = toView.frame.size.width
            showView = toView
            window.addSubview(showView)
            showView.frame = CGRect(origin: toView.frame.origin, size: .zero)
            showView.alpha = 0
            showView.backgroundColor = .white
            showView.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
            showView.layer.shadowOpacity = 0
            showView.layer.shadowOffset = CGSize.zero
            showView.layer.shadowRadius = 10
            showView.layer.shadowPath = UIBezierPath(rect: showView.bounds).cgPath
            showView.layer.shouldRasterize = true
            dimmingView.frame = window.frame
            dimmingView.alpha = 0
            
            floatBtn = MDCFloatingButton(frame: CGRect(center: toView.frame.origin, size: CGSize(width: 56, height: 56)))
            floatBtn.setImage(#imageLiteral(resourceName: "md-close"), for: .normal)
            window.addSubview(floatBtn)
            floatBtn.backgroundColor = colors[Int(dice1)]
            floatBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            
//            floatBtn.alpha = 0
            floatBtn.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            // animation
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.fromValue = showView.layer.shadowOpacity
            animation.toValue = 1
            animation.duration = 0.4
            showView.layer.add(animation, forKey: animation.keyPath)
            
            showView.layer.shadowOpacity = 1
            // Expand width
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.showView.frame.size.width = width
            }, completion: nil)
            
            // Expand height
            UIView.animate(withDuration: 0.3, delay: 0.05, options: .curveEaseOut, animations: {
                self.showView.frame.size.height = height
            }, completion: nil)
            
            // Alpha animate
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                self.dimmingView.alpha = 1
                self.showView.alpha = 1
                self.showView.layer.shadowPath = UIBezierPath(rect: self.showView.bounds).cgPath
            }, completion: { (bool) in
                
            })
            
            // FloatBtn animate
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                self.floatBtn.transform = CGAffineTransform.identity
            }, completion: nil)
            
            
        }
        
    }
    
    func startMode(startPoint: CGPoint) -> Int{
        if let window = UIApplication.shared.keyWindow {
            if startPoint.x > window.frame.midX {
                if startPoint.y > window.frame.midY {
                    return 4
                } else {
                    return 1
                }
            } else {
                if startPoint.y > window.frame.midY {
                    return 3
                } else {
                    return 2
                }
            }
        } else {
            return 1
        }
        
    }
    
    @objc func dismiss() {
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = showView.layer.shadowOpacity
        animation.toValue = 0
        animation.duration = 0.15
        showView.layer.add(animation, forKey: "shadowOpacity")
        showView.layer.shadowOpacity = 1
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.dimmingView.alpha = 0
            
//            self.showView.frame.size = .zero
            self.showView.alpha = 0
            self.floatBtn.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }, completion: { (bool) in
            self.showView.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
            self.floatBtn.removeFromSuperview()
        })
        
    }
    
    override init() {
        super.init()
    }
    
}

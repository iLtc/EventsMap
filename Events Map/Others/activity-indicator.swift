//
//  activity-indicator.swift
//  Events Map
//
//  Created by Alan Luo on 11/29/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

extension UIViewController {
    // https://stackoverflow.com/questions/28785715/how-to-display-an-activity-indicator-with-text-on-ios-8-with-swift
    func activityIndicator() -> UIView {
        
        
        let indicator = MDCActivityIndicator()
        
        let blue = UIColor.MDColor.blue
        let teal = UIColor.MDColor.teal
        let green = UIColor.MDColor.green
        let amber = UIColor.MDColor.amber
        let red = UIColor.MDColor.red
        let containerView:ShadowView = {
            let view = ShadowView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            view.backgroundColor = .white
            view.layer.cornerRadius = view.frame.width/2
            view.shadowLayer.elevation = ShadowElevation(rawValue: 6.0)
            view.isShadowPathAutoSizing = true
            view.shadowColor = .black
            return view
        }()
//        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        
//        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
//        strLabel.text = title
//        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
//        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
//        if let window = UIApplication.shared.keyWindow {
//            effectView.frame = CGRect(x: window.frame.midX - strLabel.frame.width/2, y: window.frame.midY - strLabel.frame.height/2 , width: 46, height: 46)
//
//            effectView.layer.cornerRadius = 15
//            effectView.layer.masksToBounds = true

        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        containerView.center = view.center
        containerView.addSubview(indicator)
        indicator.cycleColors = [blue, teal, green, amber, red]
        indicator.startAnimating()
        
//            effectView.contentView.addSubview(activityIndicator)
//            effectView.contentView.addSubview(strLabel)
        
        view.addSubview(containerView)
        
        
        
        
        return containerView
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
        }) { (finished) in
            self.view.removeFromSuperview()
        }
        
    }
}

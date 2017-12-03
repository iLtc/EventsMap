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
    func activityIndicator(_ title: String) -> UIView {
        
        
        let indicator = MDCActivityIndicator()
        
        let blue = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        let teal = UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0)
        let green = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        let amber = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
        let red = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
//        var strLabel = UILabel()
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

        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = view.center
        
        indicator.cycleColors = [blue, teal, green, amber, red]
        indicator.startAnimating()
        
//            effectView.contentView.addSubview(activityIndicator)
//            effectView.contentView.addSubview(strLabel)
        view.addSubview(indicator)
        
        
        
        
        return indicator
    }
    
    func dismiss() {
        self.view.removeFromSuperview()
    }
}

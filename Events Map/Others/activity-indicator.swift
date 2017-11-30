//
//  activity-indicator.swift
//  Events Map
//
//  Created by Alan Luo on 11/29/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

extension UIViewController {
    // https://stackoverflow.com/questions/28785715/how-to-display-an-activity-indicator-with-text-on-ios-8-with-swift
    func activityIndicator(_ title: String) -> UIView {
//        let window = UIApplication.shared.keyWindow
        
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: UIScreen.main.bounds.midX - strLabel.frame.width/2, y: UIScreen.main.bounds.midY - strLabel.frame.height/2 , width: 160, height: 46)
//        effectView.center = (window?.center)!
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
        
        return effectView
    }
}

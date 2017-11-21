//
//  LoginView.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/20/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        
        self.backgroundColor = .clear
        self.addSubview(blurEffectView)
        
        let titleLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 70, width: frame.width, height: 30))
            label.alpha = 0
            label.text = "Login"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 25)
            return label
        }()
        
        self.addSubview(titleLabel)
        UILabel.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            titleLabel.frame.origin.y = 20
            titleLabel.alpha = 1
        }, completion: nil)
        
        
        let facebookBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: 10, y: titleLabel.frame.height + 90, width: frame.width - 20, height: 40))
            let imageView = UIImageView(frame: CGRect(x: 50, y: 6, width: 29, height: 29))
            imageView.image = UIImage(named: "Facebook")
            button.addSubview(imageView)
            let label = UILabel()
            label.text = "Login with Facebook"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.sizeToFit()
            imageView.frame.origin.x = (button.bounds.width - imageView.bounds.width - label.bounds.width - 10) / 2
            label.frame.origin = CGPoint(x: imageView.frame.maxX + 10, y: 8)
            button.addSubview(label)
            button.alpha = 0
            button.layer.cornerRadius = 4
            button.layer.shadowRadius = 4
            button.backgroundColor = UIColor(red:0.26, green:0.40, blue:0.70, alpha:1.0)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(fbLogin(_:)), for: .touchUpInside)
            button.titleLabel?.textColor = .white
            button.setBackgroundColor(color: UIColor(red:0.31, green:0.50, blue:0.82, alpha:1.0), forState: .highlighted)
            return button
        }()
        
        self.addSubview(facebookBtn)
        UIButton.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            facebookBtn.frame.origin.y = titleLabel.frame.height + 40
            facebookBtn.alpha = 1
        }, completion: nil)
        
        
        let demoBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: 10, y: facebookBtn.frame.maxY + 70, width: frame.width - 20, height: 40))
            button.alpha = 0
            button.layer.cornerRadius = 4
            button.layer.shadowRadius = 4
            button.backgroundColor = UIColor(red:0.26, green:0.40, blue:0.70, alpha:0.5)
            button.setTitle("Demo User Login", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.isUserInteractionEnabled = true
            //            button.addTarget(self, action: nil, for: .touchUpInside)
            button.titleLabel?.textColor = .white
            
            return button
        }()
        
        self.addSubview(demoBtn)
        UIButton.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
            demoBtn.frame.origin.y = facebookBtn.frame.maxY + 20
            demoBtn.alpha = 1
        }, completion: nil)
        
        self.sizeToFit()
        blurEffectView.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func fbLogin(_ sender: UIButton) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }}


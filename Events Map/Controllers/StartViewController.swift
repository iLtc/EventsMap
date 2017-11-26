//
//  StartViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/23/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import paper_onboarding

class StartViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    var startBtn:UIButton = UIButton()
    var checkBtn: UIButton = UIButton()
    var checkLabel: UILabel = UILabel()
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            if self.startBtn.alpha == 1 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.startBtn.alpha = 0
                    self.checkBtn.alpha = 0
                    self.checkLabel.alpha = 0
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.startBtn.alpha = 1
                self.checkBtn.alpha = 1
                self.checkLabel.alpha = 1
            })
        }
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let bgColorOne = UIColor(red:0.75, green:0.32, blue:0.32, alpha:1.0)
        let bgColorTwo = UIColor(red:0.44, green:0.74, blue:0.25, alpha:1.0)
        let bgColorThree = UIColor(red:0.36, green:0.48, blue:0.73, alpha:1.0)
        let textColor = UIColor.white
        let descriptionColor = UIColor.white
        let textFont: UIFont = UIFont(name: "Noteworthy-Bold", size: 30)!
        let descriptionFont: UIFont = UIFont(name: "Noteworthy-Light", size: 25)!
        return [
            ("location", "Explore", "Discover interesting events", "", bgColorOne, textColor, descriptionColor, textFont, descriptionFont),
            ("profile", "Profile", "Login with social accounts", "", bgColorTwo, textColor, descriptionColor, textFont, descriptionFont),
            ("like", "Social", "Share events with friends", "", bgColorThree, textColor, descriptionColor, textFont, descriptionFont)
            ][index] as OnboardingItemInfo
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        
        startBtn = {
            let button = UIButton(frame: CGRect(x: view.bounds.maxX/2, y: view.bounds.maxY * 0.75, width: 0, height: 0))
            button.setTitle("Get Started", for: .normal)
            button.setTitleColor(UIColor(red:0.36, green:0.48, blue:0.73, alpha:1.0), for: .normal)
            button.backgroundColor = .white
            button.sizeToFit()
            button.alpha = 0
            button.frame.size.width = 120
            button.layer.cornerRadius = button.frame.height/2
            button.addTarget(self, action: #selector(getStarted(_:)), for: .touchUpInside)
            button.frame.origin = CGPoint(x: (self.view.bounds.width - button.bounds.width  ) / 2, y: button.frame.origin.y)
            return button
        }()
        
        onboarding.addSubview(startBtn)
        
        
        checkLabel = {
            let label = UILabel(frame: CGRect(x: view.bounds.maxX/2, y: startBtn.frame.maxY + 10, width: 0, height: 0))
            label.font = UIFont(name: "Noteworthy-Light", size: 15)
            label.alpha = 0
            label.text = "Never show this again"
            label.textColor = .white
            label.sizeToFit()
            return label
        }()
        
        checkBtn = {
            let button = UIButton(frame: CGRect(x: checkLabel.frame.maxX + 5, y: startBtn.frame.maxY + 15, width: 16, height: 16))
            button.alpha = 0
            button.isUserInteractionEnabled = true
            button.layer.cornerRadius = 4
            button.tag = 0
            button.backgroundColor = .white
            button.setImage(UIImage(), for: .normal)
            button.addTarget(self, action: #selector(checked), for: .touchUpInside)
            return button
        }()
        checkLabel.frame.origin.x = (view.bounds.maxX - checkLabel.frame.width - checkBtn.frame.width)/2
        checkBtn.frame.origin.x = checkLabel.frame.maxX + 5
        onboarding.addSubview(checkLabel)
        onboarding.addSubview(checkBtn)

        view.addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            
            view.addConstraint(constraint)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func checked() {
        
        print("Checked")
//        checkBtn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.5),
//                       initialSpringVelocity: CGFloat(3.0),
//                       options: UIViewAnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.checkBtn.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in
//        })
        if checkBtn.tag == 0 {
            checkBtn.tag = 1
            checkBtn.setImage(UIImage(named: "check"), for: .normal)
        } else {
            checkBtn.tag = 0
            checkBtn.setImage(UIImage(), for: .normal)
        }
    }
    
    @objc func getStarted(_ sender: UIButton) {
        let userDefault = UserDefaults.standard
        if checkBtn.tag == 1 {
            userDefault.set(true, forKey: "GetStarted")
        } else {
            userDefault.set(false, forKey: "GetStarted")
        }
        userDefault.synchronize()
        let vc = MasterViewController()
        self.show(vc, sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

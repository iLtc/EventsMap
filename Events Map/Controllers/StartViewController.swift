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
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            if self.startBtn.alpha == 1 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.startBtn.alpha = 0
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.3, animations: {
                self.startBtn.alpha = 1
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
            let button = UIButton(frame: CGRect(x: view.bounds.maxX/2, y: view.bounds.maxY * 0.8, width: 0, height: 0))
            button.setTitle("Get Started", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .clear
            button.sizeToFit()
            button.alpha = 0
            button.addTarget(self, action: #selector(getStarted(_:)), for: .touchUpInside)
            button.frame.origin = CGPoint(x: (self.view.bounds.width - button.bounds.width  ) / 2, y: button.frame.origin.y)
            return button
        }()
        
        onboarding.addSubview(startBtn)
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
    
    @objc func getStarted(_ sender: UIButton) {
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

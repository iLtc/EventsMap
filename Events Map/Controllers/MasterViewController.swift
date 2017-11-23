//
//  MasterViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/18/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import paper_onboarding

class MasterViewController: UIPageViewController {
    
    
    
    var mapVC: UIViewController?
    var listVC: UIViewController?
    
    // SegmentControl
    let titleView = UISegmentedControl(items: ["Map", "List"])
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        // MARK: navigation item settings
        self.navigationItem.largeTitleDisplayMode = .never
        
        let userBarBtn = UIBarButtonItem(image: UIImage(named: "User"), style: .plain, target: self, action: #selector(showUser))
        self.navigationItem.leftBarButtonItem = userBarBtn

        
        let filterBarBtn = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilter))
        self.navigationItem.rightBarButtonItem = filterBarBtn
        self.navigationItem.titleView = titleView
        
//        self.modalTransitionStyle
        
        titleView.selectedSegmentIndex = 0
        titleView.addTarget(self, action: #selector(switchVC(_:)), for: .valueChanged)
        // MapViewController
        let flowLayout = UICollectionViewFlowLayout()
        mapVC = ViewController(collectionViewLayout: flowLayout)
        // ListViewController (Wait for editting)
        listVC = UITableViewController()
        // set default index
        setVCforIndex(0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showUser() {
        // Custom transition
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        // Push UserTableViewController
        let vc = UserTableViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func showFilter() {
        // Custom transition
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        // Push UserTableViewController
        let vc = FilterViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: Swith VC function, animation can be turned off
    func setVCforIndex(_ index: Int) {
        setViewControllers([index == 0 ? mapVC! : listVC!], direction: UIPageViewControllerNavigationDirection.init(rawValue: index)!, animated: true, completion: nil)
        
    }
    
    // MARK: SegmentedControl valueChanged method
    @objc func switchVC(_ sender: UISegmentedControl) {
        setVCforIndex(sender.selectedSegmentIndex)
        
    }


}



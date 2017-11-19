//
//  MasterViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/18/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class MasterViewController: UIPageViewController {
    
    var mapVC: UIViewController?
    var listVC: UIViewController?
    
    // SegmentControl
    let titleView = UISegmentedControl(items: ["Map", "List"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: navigation item settings
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "User")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.title = "Filter"
        self.navigationItem.titleView = titleView
        
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
    
    // MARK: Swith VC function, animation can be turned off
    func setVCforIndex(_ index: Int) {
        setViewControllers([index == 0 ? mapVC! : listVC!], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    // MARK: SegmentedControl valueChanged method
    @objc func switchVC(_ sender: UISegmentedControl) {
        setVCforIndex(sender.selectedSegmentIndex)
        
    }


}



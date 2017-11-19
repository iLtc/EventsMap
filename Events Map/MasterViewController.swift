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
    
    let titleView = UISegmentedControl(items: ["Map", "List"])
    
    func setVCforIndex(_ index: Int) {
        setViewControllers([index == 0 ? mapVC! : listVC!], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "User")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.title = "Filter"
        self.navigationItem.titleView = titleView
        
        titleView.selectedSegmentIndex = 0
        mapVC = ViewController()
        listVC = UITableViewController()
        setVCforIndex(0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchVC(_ sender: UISegmentedControl) {
        
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

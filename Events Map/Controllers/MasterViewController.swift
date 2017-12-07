//
//  MasterViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/18/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import paper_onboarding
import MaterialComponents

class MasterViewController: UIPageViewController, UIViewControllerTransitioningDelegate {
    
    
    
    var mapVC: UIViewController?
    var listVC: UIViewController?
    
    var userBarBtn:UIBarButtonItem = UIBarButtonItem()
    // SegmentControl
    let titleView = UISegmentedControl(items: ["Map", "List"])
    
    let transition = CircularTransition()
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: view.frame.width - 100, y: 60)
        transition.circleColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: view.frame.width - 100, y: 60)
        transition.circleColor = UIColor.white
        
        return transition
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        // MARK: navigation item settings
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.navigationItem.titleView = titleView
        
        
        let userBar = MDCButtonBar()

        let userActionItem = UIBarButtonItem(image: UIImage(named: "userBtn"), style: .done, target: self, action: #selector(showUser))

        userBar.items = [userActionItem]

        let userSize = userBar.sizeThatFits(self.view.bounds.size)
        userBar.frame = CGRect(x: 0, y: 0, width: userSize.width, height: userSize.height)
        
        userBarBtn = UIBarButtonItem(customView: userBar)

//        let filterButton: MDCFlatButton = {
//            let button = MDCFlatButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
//            button.setTitle("Filter", for: .normal)
//            button.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
//            button.sizeToFit()
//            button.setTitleColor(UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1), for: .normal)
//            return button
//        }()
//        let filterBarBtn = UIBarButtonItem(customView: filterButton)
        
        let rightBar = MDCButtonBar()
        
        let searchActionItem = UIBarButtonItem(image: UIImage(named: "md-search")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(searchEvent))
        let filterActionItem = UIBarButtonItem(image: #imageLiteral(resourceName: "md-filter").withRenderingMode(.alwaysOriginal).tint(with: UIColor(red: 0, green: 122/255, blue: 250/255, alpha: 1)), style: .done, target: self, action: #selector(showFilter))
        searchActionItem.tintColor = UIColor(red: 0/255, green: 122/255, blue: 250/255, alpha: 1)
        rightBar.items = [searchActionItem, filterActionItem]
        
        let rightSize = rightBar.sizeThatFits(self.view.bounds.size)
        rightBar.frame = CGRect(x: 0, y: 0, width: rightSize.width, height: rightSize.height)
        
        let rightBarBtn = UIBarButtonItem(customView: rightBar)

        
        self.navigationItem.leftBarButtonItem = userBarBtn
        self.navigationItem.rightBarButtonItem = rightBarBtn
        
        
        
        
        
//        self.modalTransitionStyle
        
        titleView.selectedSegmentIndex = 0
        titleView.addTarget(self, action: #selector(switchVC(_:)), for: .valueChanged)
        // MapViewController
        let flowLayout = UICollectionViewFlowLayout()
        mapVC = ViewController(collectionViewLayout: flowLayout)
        // ListViewController (Wait for editting)
        listVC = ListViewController(style: .grouped)
        // set default index
        setVCforIndex(0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchEvent() {
        let searchController = SearchViewController()
//        let transition = MDCMaskedTransition(sourceView: UIView(frame: CGRect(origin: view.center, size: CGSize(width: 1,height: 1))))
//        transition.calculateFrameOfPresentedView = { info in
//            let size = CGSize(width: self.view.bounds.width - 32, height: self.view.bounds.height - 100)
//            return CGRect(x: (info.containerView!.bounds.width - size.width) / 2,
//                          y: (info.containerView!.bounds.height - size.height) / 2,
//                          width: size.width,
//                          height: size.height)
//        }
//        searchController.transitionController.transition = transition
        searchController.transitioningDelegate = self
        searchController.modalPresentationStyle = .custom
        present(searchController, animated: true)
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
        let vc = FilterViewController(style: .grouped)
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



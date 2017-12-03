//
//  EventsListViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/2/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

private let reuseIdentifier = "EventCell"

class EventsListViewController: MDCCollectionViewController {
    
    let appBar = MDCAppBar()
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicator = MDCActivityIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = CGPoint(x: view.frame.midX, y: 200)
        let blue = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        let teal = UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0)
        let green = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        let amber = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
        let red = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        activityIndicator.cycleColors = [blue, teal, green, amber, red]
        activityIndicator.startAnimating()
        collectionView?.addSubview(activityIndicator)
        EventService.instance.getAllUserEvents { (events) in
            self.events = events
            self.collectionView?.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(EventsListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.dataSource = self
        // Do any additional setup after loading the view.
        styler.cellStyle = .card
        styler.cellLayoutType = .grid
        styler.gridPadding = 15
        if (self.view.frame.size.width < self.view.frame.size.height) {
            self.styler.gridColumnCount = 1
        } else {
            self.styler.gridColumnCount = 2
        }
        
        // AppBar view
        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = .white
        appBar.headerViewController.headerView.trackingScrollView = self.collectionView
        appBar.navigationBar.tintColor = UIColor.black
        appBar.addSubviewsToParent()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(dismissView)
        )
        
        title = "Liked Events"
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (size.width < size.height) {
            self.styler.gridColumnCount = 1
        } else {
            self.styler.gridColumnCount = 2
        }
        self.collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidScroll()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            let headerView = appBar.headerViewController.headerView
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            let headerView = appBar.headerViewController.headerView
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        
        vc.event = events[indexPath.row]
        
        present(vc, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EventsListCell
        
        cell.index = indexPath.row
        cell.populateCell(events[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellHeightAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

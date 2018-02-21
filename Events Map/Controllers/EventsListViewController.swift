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

class EventsListViewController: MDCCollectionViewController, UIViewControllerTransitioningDelegate {
    
    var existingInteractivePopGestureRecognizerDelegate : UIGestureRecognizerDelegate?
    
    var zoomableImageView = UIImageView()
    var zoomableView = UIView()
    
    let appBar = MDCAppBar()
    var events = [Event]()
    
    var loadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zoomableImageView = UIImageView(frame: .zero)
        zoomableImageView.backgroundColor = .clear
        zoomableImageView.contentMode = .scaleAspectFill
        zoomableImageView.clipsToBounds = true
        
        zoomableView = UIView(frame: .zero)
        zoomableView.backgroundColor = .white
        self.view.addSubview(zoomableView)
        self.view.addSubview(zoomableImageView)
        
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
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = appBar.headerViewController.headerView.frame
        appBar.headerViewController.headerView.insertSubview(blurEffectView, at: 0)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        appBar.headerViewController.headerView.backgroundColor = .clear
        appBar.headerViewController.headerView.trackingScrollView = self.collectionView
        
        appBar.navigationBar.tintColor = .white
        appBar.addSubviewsToParent()
        appBar.navigationBar.hidesBackButton = false
        appBar.navigationBar.title = "Your Events"
        appBar.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: MDCTypography.titleFont(),
            NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (size.width < size.height) {
            self.styler.gridColumnCount = 1
        } else {
            self.styler.gridColumnCount = 2
        }
        self.collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.collectionViewLayout.invalidateLayout()
        UIView.animate(withDuration: 0.25, animations: {
            self.appBar.headerViewController.view.alpha = 1
        }, completion: nil)
        reload()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Hold reference to current interactivePopGestureRecognizer delegate
        if navigationController?.interactivePopGestureRecognizer?.delegate != nil {
            existingInteractivePopGestureRecognizerDelegate = navigationController?.interactivePopGestureRecognizer?.delegate!
        }
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set interactivePopGestureRecognizer delegate to nil
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.tag = 1
        // Return interactivePopGestureRecognizer delegate to previously held object
        if existingInteractivePopGestureRecognizerDelegate != nil {
            navigationController?.interactivePopGestureRecognizer?.delegate = existingInteractivePopGestureRecognizerDelegate!
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    var cellFrame: CGRect?
    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let presentationAnimator = ExpandTransition.animator
//        presentationAnimator.openingFrame = cellFrame!
//        presentationAnimator.transitionMode = .present
//        return presentationAnimator
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let presentationAnimator = ExpandTransition.animator
//        presentationAnimator.openingFrame = cellFrame!
//        presentationAnimator.transitionMode = .dismiss
//        return presentationAnimator
//    }
    
    
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
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let attributesFrame = attributes?.frame
        let frameToOpen = collectionView.convert(attributesFrame!, to: collectionView.superview)
        cellFrame = frameToOpen
        let cell = collectionView.cellForItem(at: indexPath) as! EventsListCell
        let vc = CardDetailViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
//        vc.event = events[indexPath.row]
//        vc.imageView.image = cell.thumbnailImageView.image
        
//        present(vc, animated: true, completion: nil)
        
        didSelectCell(cell: cell, indexPath: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.view.tag != 1 {
            cell.alpha = 0
            let transform = CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 1)
            cell.layer.transform = transform
            let delay = Double(indexPath.row % 3) * 0.1
            UIView.animate(withDuration: 0.33, delay: delay, options: .curveEaseOut, animations: {
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }

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
        cell.index = indexPath.item
        cell.populateCell(events[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellHeightAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func didSelectCell(cell: EventsListCell, indexPath: IndexPath) {
        zoomableImageView.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y - (collectionView?.contentOffset.y)!, width: cell.frame.size.width, height: cell.frame.size.height - 50)
        zoomableView.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y - (collectionView?.contentOffset.y)!, width: cell.frame.size.width, height: cell.frame.size.height)
        
        DispatchQueue.main.async {
            self.zoomableImageView.image = cell.thumbnailImageView.image
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.appBar.headerViewController.view.alpha = 0
                let quantumEaseInOut = CAMediaTimingFunction.mdc_function(withType: .easeInOut)
                CATransaction.setAnimationTimingFunction(quantumEaseInOut)
                let zoomImageFrame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 320)
                self.zoomableImageView.frame = zoomImageFrame
                self.zoomableView.frame = self.view.bounds
                cell.layoutIfNeeded()
            }, completion: { (finished) in
                
                let detailVC = CardDetailViewController()
                detailVC.event = self.events[indexPath.row]
                detailVC.headerContentView.image = cell.thumbnailImageView.image
                self.present(detailVC, animated: false, completion: {
                    self.zoomableImageView.frame = .zero
                    self.zoomableView.frame = .zero
                })
                
            })
        }
    }
    
    func reload() {
//        let activityIndicator = MDCActivityIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        activityIndicator.center = CGPoint(x: view.frame.midX, y: 200)
//        let blue = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
//        let teal = UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0)
//        let green = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
//        let amber = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
//        let red = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
//        activityIndicator.cycleColors = [blue, teal, green, amber, red]
//        activityIndicator.startAnimating()
//        collectionView?.addSubview(activityIndicator)
        loadingView = activityIndicator()
        EventService.instance.getAllUserEvents { (code, msg, events) in
            if code != "200" {
                let alert: MDCAlertController = MDCAlertController(title: "Error", message: msg)
                
                alert.addAction(MDCAlertAction(title: "OK", handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
                return
            }
            
            self.events = events.reversed()
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
//                activityIndicator.removeFromSuperview()
                if let loadingView = self.loadingView {
                    loadingView.removeFromSuperview()
                }
            }
        }
        
        
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

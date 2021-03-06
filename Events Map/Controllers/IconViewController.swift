//
//  IconViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/6/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

private let identifier = "IconCell"

class IconViewController: UITableViewController {

    var existingInteractivePopGestureRecognizerDelegate : UIGestureRecognizerDelegate?
    
    let appBar = MDCAppBar()
    let icons: [[Any]] = [
        [#imageLiteral(resourceName: "md-star"), "Favorite"],
        [#imageLiteral(resourceName: "md-share"), "Share"],
        [#imageLiteral(resourceName: "md-title"), "Title"],
        [#imageLiteral(resourceName: "md-time"), "Time"],
        [#imageLiteral(resourceName: "md-place"), "Location"],
        [#imageLiteral(resourceName: "md-short-text"), "Description"],
        [#imageLiteral(resourceName: "md-more"), "More options"],
        [#imageLiteral(resourceName: "md-calendar"), "Add to calendar"],
        [#imageLiteral(resourceName: "md-navigation"), "Get directions"],
        [#imageLiteral(resourceName: "md-people"), "See how many views"],
        [#imageLiteral(resourceName: "md-favorite"), "# of likes"],
        [#imageLiteral(resourceName: "md-browser"), "Open in browser"],
        [#imageLiteral(resourceName: "md-delete"), "Delete event"]
    ]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        appBar.navigationBar.tintColor = .white
        addChildViewController(appBar.headerViewController)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override var childViewControllerForStatusBarStyle: UIViewController? {
//        return appBar.headerViewController
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        appBar.headerViewController.headerView.backgroundColor = UIColor.MDColor.orange
        
        appBar.headerViewController.headerView.trackingScrollView = tableView
        
        appBar.addSubviewsToParent()
        appBar.navigationBar.hidesBackButton = false
        appBar.navigationBar.title = "Icons"
        appBar.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: MDCTypography.titleFont(),
            NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let backBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(dismissIcon))
        
        let origImage = MDCIcons.imageFor_ic_arrow_back()
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backBtn.image = tintedImage
        backBtn.tintColor = .white
        
//        navigationItem.leftBarButtonItem = backBtn
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    @objc func dismissIcon() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? IconCell {
            cell.icon = icons[indexPath.row][0] as? UIImage
            cell.desc = icons[indexPath.row][1] as? String
            cell.updateData()
            return cell
        } else {
            return IconCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.MDFloat.listItemHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Hold reference to current interactivePopGestureRecognizer delegate
        if navigationController?.interactivePopGestureRecognizer?.delegate != nil {
            existingInteractivePopGestureRecognizerDelegate = navigationController?.interactivePopGestureRecognizer?.delegate!
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set interactivePopGestureRecognizer delegate to nil
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Return interactivePopGestureRecognizer delegate to previously held object
        if existingInteractivePopGestureRecognizerDelegate != nil {
            navigationController?.interactivePopGestureRecognizer?.delegate = existingInteractivePopGestureRecognizerDelegate!
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    /*
    
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

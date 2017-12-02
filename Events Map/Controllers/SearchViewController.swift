//
//  SearchViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/2/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

private let reuseIdentifier = "Cell"

class SearchViewController: MDCCollectionViewController, UISearchBarDelegate {
    
    let appBar = MDCAppBar()
    
    var events: [Event] = [Event]()
    var filteredEvents = [Event]()
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styler.cellStyle = .card
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: "SearchTextCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.dataSource = self
//        searchBar.delegate = self
//        searchBar.showsCancelButton = true
//        searchBar.becomeFirstResponder()
        EventService.instance.getEvents { (events) in
            self.events = events
        }
        
        // AppBar view
        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = .white
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = true
        searchBar.barStyle = .default
        searchBar.placeholder = "Search event"
        searchBar.tintColor = .lightGray
        appBar.headerStackView.topBar = searchBar
        
        appBar.headerViewController.headerView.trackingScrollView = self.collectionView
        appBar.navigationBar.tintColor = UIColor.black
        appBar.addSubviewsToParent()
        
        title = "Search"

        // Do any additional setup after loading the view.
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
    
    @objc func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            collectionView?.reloadData()
        } else {
            isSearching = true
            filteredEvents = events.filter({ (event) -> Bool in
                return event.title.lowercased().contains(searchText.lowercased())
            })
            collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if isSearching {
            vc.event = filteredEvents[indexPath.row]
        } else {
            vc.event = events[indexPath.row]
        }
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
        if isSearching {
            return self.filteredEvents.count
        }
        
        return self.events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SearchTextCell{
            
            let event: Event!
            if isSearching {
                event = filteredEvents[indexPath.row]
            } else {
                event = events[indexPath.row]
            }
            cell.textLabel?.text = event.title
            
            return cell
        } else {
            return MDCCollectionViewTextCell()
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
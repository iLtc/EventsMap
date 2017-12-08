//
//  WebViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/6/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class WebViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate, UIWebViewDelegate {
    
    let appBar = MDCAppBar()
    let webView = UIWebView()
    let bottonBar = MDCButtonBar()
    let progressView = MDCProgressView()
    let searchBar = UISearchBar()
    var refreshBtn = UIBarButtonItem()
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = .white
//        activityIndicator.hidden = false
        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = UIColor(red:0.27, green:0.54, blue:1.00, alpha:1.0) //UIColor(red:0.80, green:0.86, blue:0.22, alpha:1.0) // Lime
        webView.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width, height: view.frame.height - 56))
        webView.scrollView.delegate = self
        webView.delegate = self
        view.addSubview(webView)
        
        progressView.progress = 0
        
        let progressViewHeight = CGFloat(2)
        progressView.frame = CGRect(x: 0, y: view.bounds.height/2 - progressViewHeight, width: view.bounds.width, height: progressViewHeight)
        progressView.progressTintColor = UIColor.MDColor.orange
        progressView.backwardProgressAnimationMode = .animate

        
        
        if url != nil {
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
            
        } else {
            let alertController = MDCAlertController(title: nil, message: "URL is invaild.")
            
            let confirmAction = MDCAlertAction(title: "OK") { (action) in
                self.dismissWeb()
            }
            alertController.addAction(confirmAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        appBar.headerViewController.headerView.trackingScrollView = webView.scrollView
        appBar.navigationBar.tintColor = UIColor.white
        appBar.addSubviewsToParent()
        
        let backBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(dismissWeb))
        let origImage = MDCIcons.imageFor_ic_arrow_back()
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backBtn.image = tintedImage
        backBtn.tintColor = .white
        
        refreshBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "md-refresh"), style: .done, target: self, action: #selector(reload(_:)))
        
        let browserBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(openURL))
        browserBtn.title = "Open"
        browserBtn.image = #imageLiteral(resourceName: "md-open-new")
        browserBtn.tintColor = .white
        
        let back = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(loadBack))
        back.image = #imageLiteral(resourceName: "md-back")
        back.tintColor = .white
        back.title = "Back"
        
        let forward = UIBarButtonItem(image: #imageLiteral(resourceName: "md-forward"), style: .done, target: self, action: #selector(loadForward))
        forward.tintColor = .white
        forward.title = "Forward"
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = true
        searchBar.barStyle = .default
        searchBar.text = url?.absoluteString
        searchBar.placeholder = "Search"
        searchBar.textContentType = UITextContentType.URL
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.layer.cornerRadius = 6
//        searchBar.tintColor = UIColor(red:0.31, green:0.76, blue:0.97, alpha:1.0)
//        searchBar.backgroundColor = UIColor(red:0.27, green:0.54, blue:1.00, alpha:1.0)
        appBar.navigationBar.titleView = searchBar
        appBar.headerStackView.bottomBar = progressView
        
        appBar.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = backBtn
        navigationItem.rightBarButtonItem = refreshBtn
//        navigationItem.title = "Browser"
//        let navigationbarAppearance = UINavigationBar.appearance()
//        navigationbarAppearance.tintColor = .white
//        navigationbarAppearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        // Do any additional setup after loading the view.
        bottonBar.frame.origin = CGPoint(x: 0, y: view.frame.maxY - 56)
        bottonBar.backgroundColor = UIColor(red:0.27, green:0.54, blue:1.00, alpha:1.0)
        bottonBar.items = [back, forward, browserBtn]
        bottonBar.sizeToFit()
        bottonBar.frame.size.width = view.frame.width
        view.addSubview(bottonBar)
    }
    
    @objc func reload(_ sender: UIBarButtonItem) {
        if sender.tag == 1 {
            webView.reload()
        } else {
            webView.stopLoading()
        }
        
    }
    
    @objc func loadForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func loadBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    @objc func dismissWeb() {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        if let url = URL(string: "http://\(searchBar.text!)") {
            self.url = url
            searchBar.text = url.absoluteString
            let request = URLRequest(url: url)
            webView.loadRequest(request)
            
        }
    }
    
    func startAndShowProgressView() {
        progressView.setHidden(false, animated: true)
        progressView.setProgress(0, animated: true) { (bool) in
            self.progressView.setProgress(0.3, animated: bool, completion: nil)
        }
        
    }
    
    func completeAndHideProgressView() {
        progressView.setProgress(1, animated: true) { (finished) in
            self.progressView.setHidden(true, animated: true)
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        startAndShowProgressView()
        refreshBtn.tag = 0
        refreshBtn.image = #imageLiteral(resourceName: "md-close")
//        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        completeAndHideProgressView()
        if let urlText = webView.request?.url?.absoluteString {
            searchBar.text = urlText
            refreshBtn.tag = 1
            refreshBtn.image = #imageLiteral(resourceName: "md-refresh")
            
        }
//        activityIndicator.stopAnimating()
//        activityIndicator.hidden = true
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        let alertController = MDCAlertController(title: nil, message: "URL is invaild.")
        
        let confirmAction = MDCAlertAction(title: "OK") { (action) in
            
        }
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
//        activityIndicator.hidden = true
    }
    
    
    @objc func openURL() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            let headerView = appBar.headerViewController.headerView
            headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            let headerView = appBar.headerViewController.headerView
            headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

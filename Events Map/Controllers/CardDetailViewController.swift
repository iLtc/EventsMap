//
//  CardDetailViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/4/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class CardDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var event: Event!
    var scrollView = DetailView()
    fileprivate let appBar = MDCAppBar()
    var headerContentView = UIImageView(frame: .zero)
    var cardHeaderView = UIView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = .clear
        appBar.navigationBar.tintColor = .black
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if (size.height > size.width) {
            appBar.headerViewController.headerView.frame.size.height = 320
        } else {
            appBar.headerViewController.headerView.minimumHeight = 160
            appBar.headerViewController.headerView.maximumHeight = 160
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        view.backgroundColor = .white
        scrollView = DetailView(frame: self.view.bounds)
        scrollView.alpha = 0
        scrollView.backgroundColor = .white
        scrollView.title = event.title
        scrollView.startDate = event.date
        scrollView.endDate = event.endDate
        scrollView.desc = event.description
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        
        // AppBar view
        appBar.headerViewController.headerView.trackingScrollView = scrollView
        
        if self.view.frame.size.height > self.view.frame.size.width {
            appBar.headerViewController.headerView.minimumHeight = 320
        } else {
            appBar.headerViewController.headerView.minimumHeight = 160
            appBar.headerViewController.headerView.maximumHeight = 160
        }
        
        headerContentView.contentMode = .scaleAspectFill
        headerContentView.clipsToBounds = true
        headerContentView.frame = appBar.headerViewController.headerView.frame
        headerContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        appBar.headerViewController.headerView.insertSubview(headerContentView, at: 0)
        
        appBar.addSubviewsToParent()
        let backBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(dismissDetail))
        
        backBtn.image = MDCIcons.imageFor_ic_arrow_back()
        appBar.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = backBtn
        
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.33, delay: 0.1, options: .curveEaseOut, animations: {
                let quantumEaseInOut = CAMediaTimingFunction.mdc_function(withType: .easeInOut)
                CATransaction.setAnimationTimingFunction(quantumEaseInOut)
                self.scrollView.alpha = 1
            }, completion: { (finished) in
                
            })
        })
        
        
//        let cardHeaderView: UIView = {
//            let headerFrame = appBar.headerViewController.headerView.bounds
//            let cardHeaderView = UIView(frame: headerFrame)
//            cardHeaderView.backgroundColor = .clear
//            cardHeaderView.layer.masksToBounds = true
//            cardHeaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            let imageView = self.headerContentView
//            imageView.contentMode = .scaleAspectFill
//            cardHeaderView.addSubview(imageView)
//
//            let inkOverlay = InkOverlay()
//            inkOverlay.frame = headerFrame
//            inkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//            cardHeaderView.addSubview(inkOverlay)
//            return cardHeaderView
//        }()
        
        // setHeaderView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissDetail() {
        dismiss(animated: true, completion: nil)
    }
    
    
//    open override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        scrollView.contentSize = CGSize(width: bottomView.bounds.size.width, height: 400)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var contentOffsetY = -scrollView.contentOffset.y
//        if contentOffsetY < 320 {
//            contentOffsetY = 320
//        }
        let scrollOffsetY = -scrollView.contentOffset.y
        appBar.headerViewController.scrollViewDidScroll(scrollView)
        var scaleRatio = scrollView.contentOffset.y / -320
        
        let duration = 0.33
        if scaleRatio < 0.5 {
            scaleRatio = 0.5
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                self.title = "Detail"
                self.headerContentView.alpha = 0
                self.appBar.headerViewController.headerView.minimumHeight = 76
            }, completion: {(finished) in
                self.appBar.headerViewController.headerView.shadowColor = .black
            
            })
        } else if scaleRatio <= 1{
            self.appBar.headerViewController.headerView.minimumHeight = self.headerContentView.frame.maxY
            self.headerContentView.alpha = scaleRatio
            self.appBar.headerViewController.headerView.shadowColor = .clear
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                self.title = ""
//                self.headerContentView.alpha = 1
                self.appBar.headerViewController.headerView.backgroundColor = .white
                
                
            }, completion: nil)
        }
        
        self.headerContentView.transform = CGAffineTransform(translationX: 0, y: scrollOffsetY * 0.1 )
        
        
        
        
    }
    
    
    
//    func setHeaderVC(_ headerVC: MDCFlexibleHeaderContainerViewController) {
//        let headerView = headerVC.headerViewController.headerView
//        headerView.trackingScrollView = scrollView
//        headerView.minimumHeight = 76
//        headerView.maximumHeight = 320
//        headerView.addSubview(cardHeaderView)
//        
//        let shadowLayer = MDCShadowLayer.init(layer: headerView.layer)
//        headerView.setShadowLayer(shadowLayer) { (layer, intensity) in
//            let elevation = intensity * ShadowElevation.appBar.rawValue
//            MDCShadowLayer(layer: layer).elevation = ShadowElevation(rawValue: elevation)
//        }
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.centerHeaderWithSize(size: self.view.frame.size)
//    }
//    
//    func centerHeaderWithSize(size: CGSize) {
//        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
//        let width = size.width
//        let headerFrame = appBar.headerViewController.headerView.bounds
//        self.headerContentView.center = CGPoint(x: width/2, y: headerFrame.size.height/2)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

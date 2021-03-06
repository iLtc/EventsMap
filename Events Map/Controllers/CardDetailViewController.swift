//
//  CardDetailViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/4/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import EventKit
import MaterialComponents

class CardDetailViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {
    
    var existingInteractivePopGestureRecognizerDelegate : UIGestureRecognizerDelegate?
    
    var event: Event!
    var scrollView = DetailView()
    fileprivate let appBar = MDCAppBar()
    var headerContentView = customImageView(frame: .zero)
    var cardHeaderView = UIView()
    let titleLabel = UILabel()
    var shareBtn = UIBarButtonItem()
    // Side buttons
    let moreBtn = MDCFloatingButton()
    let webBtn = MDCFloatingButton()
    let calendarBtn = MDCFloatingButton()
    let viewsBtn = MDCFloatingButton()
    let navigationBtn = MDCFloatingButton()
    
    var bottomPadding: CGFloat = 0
    let transition = CircularTransition()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = .clear
        appBar.navigationBar.tintColor = .white
        
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = webBtn.center
        transition.circleColor = webBtn.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = webBtn.center
        transition.circleColor = UIColor.white
        
        return transition
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        // Return interactivePopGestureRecognizer delegate to previously held object
        if existingInteractivePopGestureRecognizerDelegate != nil {
            navigationController?.interactivePopGestureRecognizer?.delegate = existingInteractivePopGestureRecognizerDelegate!
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        scrollView = DetailView(frame: self.view.bounds)
        scrollView.alpha = 0
        scrollView.backgroundColor = .white
        scrollView.event = event
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        // MARK: - Side function buttons
        // More button
        moreBtn.frame = CGRect(x: 30, y: view.frame.maxY - 106, width: 0, height: 0)
        moreBtn.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        moreBtn.setImage(#imageLiteral(resourceName: "md-more"), for: .normal)
        moreBtn.alpha = 0
        moreBtn.tag = 0
        moreBtn.addTarget(self, action: #selector(moreBtnPressed), for: .touchUpInside)
        moreBtn.sizeToFit()
        view.addSubview(moreBtn)
        // Likes button
        webBtn.frame = CGRect(x: 30, y: view.frame.maxY - 111, width: 0, height: 0)
        webBtn.setImage(#imageLiteral(resourceName: "md-browser").withRenderingMode(.alwaysTemplate).tint(with: .white), for: .normal)
        webBtn.backgroundColor = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
        webBtn.alpha = 0
        webBtn.sizeToFit()
        webBtn.addTarget(self, action: #selector(openURL(_:)), for: .touchUpInside)
        view.addSubview(webBtn)
        // Calendar button
        calendarBtn.frame = CGRect(x: 30, y: view.frame.maxY - 182, width: 0, height: 0)
        calendarBtn.setImage(#imageLiteral(resourceName: "md-calendar").withRenderingMode(.alwaysTemplate), for: .normal)
        calendarBtn.tintColor = .white
        calendarBtn.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        calendarBtn.alpha = 0
        calendarBtn.sizeToFit()
        calendarBtn.addTarget(self, action: #selector(saveCalendarAlert(_:)), for: .touchUpInside)
        view.addSubview(calendarBtn)
        // Views button
        viewsBtn.frame = CGRect(x: 30, y: view.frame.maxY - 253, width: 0, height: 0)
        viewsBtn.setImage(#imageLiteral(resourceName: "md-people"), for: .normal)
        viewsBtn.backgroundColor = UIColor(red:0.55, green:0.76, blue:0.29, alpha:1.0)
        viewsBtn.alpha = 0
        viewsBtn.sizeToFit()
        viewsBtn.addTarget(self, action: #selector(viewsBtnPressed(_:)), for: .touchUpInside)
        view.addSubview(viewsBtn)
        
        // Likes button
        navigationBtn.frame = CGRect(x: 30, y: view.frame.maxY - 324, width: 0, height: 0)
        navigationBtn.setImage(#imageLiteral(resourceName: "md-navigation").withRenderingMode(.alwaysOriginal).tint(with: .white), for: .normal)
        navigationBtn.backgroundColor = UIColor.MDColor.lightBlue
        navigationBtn.alpha = 0
        navigationBtn.sizeToFit()
        navigationBtn.addTarget(self, action: #selector(getDirection(_:)), for: .touchUpInside)
        view.addSubview(navigationBtn)
        
        // AppBar view
        appBar.headerViewController.headerView.trackingScrollView = scrollView
        
        appBar.headerViewController.headerView.visibleShadowOpacity = 0
        if self.view.frame.size.height > self.view.frame.size.width {
            appBar.headerViewController.headerView.minimumHeight = 320
        } else {
            appBar.headerViewController.headerView.minimumHeight = 160
            appBar.headerViewController.headerView.maximumHeight = 160
        }
        
        if headerContentView.image == nil {
            headerContentView.downloadedFrom(link: event.photos[0], contentMode: .scaleAspectFill)
        }
        headerContentView.contentMode = .scaleAspectFill
        headerContentView.clipsToBounds = true
        headerContentView.frame = appBar.headerViewController.headerView.frame
        headerContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let gradient = CAGradientLayer()
        gradient.frame = headerContentView.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradient.locations = [-0.4, 0.4]
        headerContentView.layer.insertSublayer(gradient, at: 0)
        let materialCurve = MDCAnimationTimingFunction.easeOut
        let timingFunction = CAMediaTimingFunction.mdc_function(withType: materialCurve)
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.timingFunction = timingFunction
        gradientChangeAnimation.duration = 0.4
        
        gradientChangeAnimation.toValue = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
        appBar.headerViewController.headerView.insertSubview(headerContentView, at: 0)
//        appBar.headerViewController.headerView.clipsToBounds = true
        appBar.addSubviewsToParent()
        let backBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(dismissDetail))
        
        let origImage = MDCIcons.imageFor_ic_arrow_back()
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backBtn.image = tintedImage
        backBtn.tintColor = .white
        
        appBar.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = backBtn
        
        titleLabel.text = event.title
        titleLabel.textColor = .white
        titleLabel.font = MDCTypography.titleFont()
        titleLabel.numberOfLines = 3
        titleLabel.sizeToFit()
        titleLabel.alpha = 0
        appBar.navigationBar.titleView = titleLabel
        
        shareBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(share(_:)))
        shareBtn.image = UIImage(named: "md-share")
        
        let likeBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(likeBtnPressed(_:)))
        if event.liked {
            likeBtn.image = UIImage(named: "md-star")
            likeBtn.tag = 0 // 0 == liked
        } else {
            likeBtn.image = UIImage(named: "md-star-border")
            likeBtn.tag = 1 // 1 == unliked
        }
        
        let deleteBtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(deleteBtnPressed(_:)))
        deleteBtn.image = UIImage(named: "md-delete")
        
        if event.owned {
            navigationItem.rightBarButtonItems = [shareBtn, likeBtn, deleteBtn]
        } else {
            navigationItem.rightBarButtonItems = [shareBtn, likeBtn]
        }
        
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.33, delay: 0.1, options: .curveEaseOut, animations: {
                self.moreBtn.alpha = 1
                let quantumEaseInOut = CAMediaTimingFunction.mdc_function(withType: .easeInOut)
                CATransaction.setAnimationTimingFunction(quantumEaseInOut)
                self.scrollView.alpha = 1
            }, completion: { (finished) in
                print("count", self.event.views)
                self.event.countViews()
                
            })
        })
        scrollView.layoutSubviews()
        
        
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
    
    @objc func openURL(_ sender: MDCFloatingButton) {
        guard let url = URL(string: event.url) else {
            return //be safe
        }
        let webViewController = WebViewController()
        webViewController.url = url
        webViewController.bottomPadding = self.bottomPadding
        webViewController.webTitle = event.title
        webViewController.transitioningDelegate = self
        webViewController.modalPresentationStyle = .custom
        present(webViewController, animated: true)
    }
    
    // Mark: add to calendar alert
    @objc func saveCalendarAlert(_ sender: Any) {
        let alertController = MDCAlertController(title: nil, message: "Add this event to calendar.")
        let cancelAction = MDCAlertAction(title: "Cancel", handler: nil)
        alertController.addAction(cancelAction)
        let confirmAction = MDCAlertAction(title: "Add") { (action) in
            self.addCalendarEvent(action)
        }
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Mark: add calendar event method
    func addCalendarEvent (_ sender: Any) {
        let eventStore = EKEventStore()
        
        //let calendars = eventStore.calendars(for: .event)
        
        eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
            if (granted) && (error == nil) {
                
                let newEvent = EKEvent(eventStore: eventStore)
                newEvent.calendar = eventStore.defaultCalendarForNewEvents
                newEvent.title = self.event.title
                newEvent.location = self.event.location
                newEvent.notes = self.event.description
                newEvent.startDate = self.event.date as Date!
                newEvent.endDate = self.event.endDate as Date!
                newEvent.isAllDay = self.event.isAllDay
                
                do {
                    try eventStore.save(newEvent, span: .thisEvent, commit: true)
                    
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    let alert = MDCAlertController(title: nil, message: (error as NSError).localizedDescription)
                    let OKAction = MDCAlertAction(title: "OK", handler: nil)
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    // Views button pressed
    @objc func viewsBtnPressed(_ sender: MDCFloatingButton) {
        // Highlight Controller
        let completion = {(accepted: Bool) in
            
        }
        let displayedButton = MDCFloatingButton(frame: sender.frame, shape: .default)
        displayedButton.setImage(#imageLiteral(resourceName: "md-close").withRenderingMode(.alwaysTemplate), for: .normal)
        displayedButton.backgroundColor = sender.titleColor(for: .normal)
        displayedButton.tintColor = sender.backgroundColor
        let highlightController = MDCFeatureHighlightViewController(highlightedView: sender, andShow: displayedButton, completion: completion)
        
        highlightController.titleColor = .white
        highlightController.titleText = ""
        highlightController.bodyText =
            String(event.views + 1) + " views\n"
            + String(event.likes) + " likes"
        highlightController.bodyColor = .white
        highlightController.outerHighlightColor =
            sender.backgroundColor!.withAlphaComponent(kMDCFeatureHighlightOuterHighlightAlpha)
        present(highlightController, animated: true, completion:nil)
        
    }
    
    // More button pressed
    @objc func moreBtnPressed(_ sender: MDCFloatingButton) {
        
        if sender.tag == 0 { // Expand
            sender.tag = 1 // More open
            
            UIButton.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                sender.setImage(#imageLiteral(resourceName: "md-close").withRenderingMode(.alwaysTemplate), for: .normal)
                sender.tintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
                sender.backgroundColor = .white
                self.webBtn.frame.origin.y = self.view.frame.maxY - 177
                self.webBtn.alpha = 1
            }, completion: nil)
            UIButton.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.calendarBtn.frame.origin.y = self.view.frame.maxY - 248
                self.calendarBtn.alpha = 1
            }, completion: nil)
            UIButton.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.viewsBtn.frame.origin.y = self.view.frame.maxY - 319
                self.viewsBtn.alpha = 1
            }, completion: nil)
            UIButton.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.navigationBtn.frame.origin.y = self.view.frame.maxY - 390
                self.navigationBtn.alpha = 1
            }, completion: nil)
        } else if sender.tag == 1 { // Collapse
            sender.tag = 0 // More close
            UIButton.animate(withDuration: 0.15, delay: 0.15, options: .curveEaseOut, animations: {
                sender.setImage(#imageLiteral(resourceName: "md-more").withRenderingMode(.alwaysTemplate), for: .normal)
                sender.tintColor = .white
                sender.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
                self.webBtn.frame.origin.y = self.view.frame.maxY - 111
                self.webBtn.alpha = 0
            }, completion: nil)
            UIButton.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseOut, animations: {
                
                self.calendarBtn.frame.origin.y = self.view.frame.maxY - 182
                self.calendarBtn.alpha = 0
            }, completion: nil)
            UIButton.animate(withDuration: 0.15, delay: 0.05, options: .curveEaseOut, animations: {
                
                self.viewsBtn.frame.origin.y = self.view.frame.maxY - 253
                self.viewsBtn.alpha = 0
            }, completion: nil)
            UIButton.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                
                self.navigationBtn.frame.origin.y = self.view.frame.maxY - 324
                self.navigationBtn.alpha = 0
            }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissDetail() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            bottomPadding = view.safeAreaInsets.bottom
            print("safe:", bottomPadding)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var contentOffsetY = -scrollView.contentOffset.y
//        if contentOffsetY < 320 {
//            contentOffsetY = 320
//        }
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let scrollOffsetY = -scrollView.contentOffset.y
        appBar.headerViewController.scrollViewDidScroll(scrollView)
        var scaleRatio = scrollView.contentOffset.y / -320
        
        let duration = 0.33
        if scaleRatio < 0.5 {
            scaleRatio = 0.5
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                
                self.titleLabel.alpha = 1
                self.headerContentView.alpha = 0
                self.appBar.headerViewController.headerView.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
                self.appBar.headerViewController.headerView.minimumHeight = statusBarHeight + 56
            }, completion: {(finished) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.appBar.headerViewController.headerView.shadowColor = .black
                }, completion: nil)
            
            })
        } else if scaleRatio <= 1{
            self.appBar.headerViewController.headerView.minimumHeight = self.headerContentView.frame.maxY * scaleRatio
            self.headerContentView.alpha = scaleRatio
            self.appBar.headerViewController.headerView.shadowColor = .clear
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                self.titleLabel.alpha = 0
//                self.headerContentView.alpha = 1
                self.appBar.headerViewController.headerView.backgroundColor = .white
                
                
            }, completion: nil)
        } else {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                self.headerContentView.alpha = 1
                
            }, completion: nil)
        }
        
//        self.headerContentView.transform = CGAffineTransform(translationX: 0, y: scrollOffsetY * 0.1 )
        self.headerContentView.frame.size.height = appBar.headerViewController.headerView.frame.height
        
    }
    
    let creation = CreationTransition()
    
    // Get direction
    @objc func getDirection(_ sender: UIButton) {
        let mapView = MapView(frame: CGRect(origin: sender.center, size: CGSize(width: 250, height: 100)))
        mapView.tag = 1
        mapView.event = self.event
        mapView.layer.cornerRadius = 8
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.layoutIfNeeded()
        
        creation.presentView(startPoint: sender.center, toView: mapView)
    }
    
    // Mark: share method
    @objc func share(_ sender: Any) {
        
        let text = "Check out this event."
        let url = URL(string: ConfigService.instance.get("EventsServerHost") + "/events/" + event.id)
        let dataToShare: [Any] = [ text, url! ]
        let activityViewController = UIActivityViewController(
            activityItems: dataToShare,
            applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = (sender as! UIBarButtonItem)
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Mark: like method
    @objc func likeBtnPressed(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            event.unlike() { code, msg in
                if code != "200" {
                    
                    let alert: MDCAlertController = MDCAlertController(title: "Error", message: msg)
                    alert.addAction(MDCAlertAction(title: "OK", handler: nil))
                    
                    self.present(alert, animated: true)
                    return
                } else {
                
                    sender.tag = 1
                    sender.image = UIImage(named: "md-star-border")
                    self.event.liked = false
                    self.removeNotification(self.event)
                }
            }
        } else if sender.tag == 1 {
            event.like() { code, msg in
                switch code {
                case "200":
                    sender.tag = 0
                    sender.image = UIImage(named: "md-star")
                    self.event.liked = true
                    self.scheduleNotification(self.event)
                    // Notification Tip Alert
                    let userDefault = UserDefaults.standard
                    if !userDefault.bool(forKey: "NotificationTip") {
                        let alert: MDCAlertController = MDCAlertController(title: "Tip", message: "Hawk Events will push a notification 15 minutes before the event start.")
                        alert.addAction(MDCAlertAction(title: "Got it!", handler: { (action) in
                            userDefault.set(true, forKey: "NotificationTip")
                            userDefault.synchronize()
                        }))
                        self.present(alert, animated: true)
                    }
                case "401":
                    let alertController = MDCAlertController(title: nil, message: "You need to login.")
                    let cancelAction = MDCAlertAction(title: "Cancel", handler: nil)
                    alertController.addAction(cancelAction)
                    let confirmAction = MDCAlertAction(title: "Login") { (action) in
                        let loginView = LoginView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 220))
                        loginView.parentVC = self
                    }
                    alertController.addAction(confirmAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                default:
                    let alert: MDCAlertController = MDCAlertController(title: "Error", message: msg)
                    alert.addAction(MDCAlertAction(title: "OK", handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    // Mark: delete method
    @objc func deleteBtnPressed(_ sender: Any?) {
        let alertController = MDCAlertController(title: nil, message: "Are you sure you want to delete this event?")
        let cancelAction = MDCAlertAction(title: "Cancel", handler: nil)
        alertController.addAction(cancelAction)
        let confirmAction = MDCAlertAction(title: "Delete") { (action) in
            let loadingView = self.activityIndicator()
            self.event.delete() { code, msg in
                loadingView.removeFromSuperview()
                
                if code == "200" {
                    let alertController = MDCAlertController(title: nil, message: "Delete Success!")
                    let confirmAction = MDCAlertAction(title: "Done") { (action) in
                        self.dismissDetail()
                    }
                    alertController.addAction(confirmAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = MDCAlertController(title: "Error", message: msg)
                    let confirmAction = MDCAlertAction(title: "Cancel", handler: nil)
                    alertController.addAction(confirmAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
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

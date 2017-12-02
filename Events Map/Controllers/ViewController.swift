//
//  ViewController.swift
//  Events Map
//
//  Created by Alan Luo on 10/26/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import MaterialComponents

class ViewController: UICollectionViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    let manger = CLLocationManager()
    var mapView: GMSMapView!
    var carema = GMSCameraPosition()
    var buffer: [UIView] = []
    var markerBuffer: [GMSMarker] = []
    var newEventMarker: GMSMarker?
    var event: Event = Event()
    var address = ""
    var coordinate: CLLocationCoordinate2D?
    var loadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "Map"
        collectionView?.backgroundColor = UIColor(red: 237/255.0, green: 234/255.0, blue: 227/255.0, alpha: 1)
        manger.delegate = self
        manger.desiredAccuracy = kCLLocationAccuracyBest
        manger.requestWhenInUseAuthorization()
        manger.startUpdatingLocation()
        
        loadingView = activityIndicator("Loading......")
        EventService.instance.getEvents(addEvents)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingView = activityIndicator("Loading......")
        EventService.instance.getEvents(addEvents)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.manger.stopUpdatingLocation()
    }
    
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: (self.manger.location?.coordinate.latitude)!,longitude: (self.manger.location?.coordinate.longitude)!,zoom: 15)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        mapView.restorationIdentifier = "MapView"
        self.view.addSubview(mapView)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        removeView()
        addInfoView(marker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        removeView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("hehe")
    }
    
    @objc func removeView() {
        // Mark: Animated remove infoView
        if buffer.count != 0 {
            for infoView in buffer {
                UIView.animate(withDuration: 0.3, animations: {
                    infoView.frame.origin.y = self.view.bounds.height
                }, completion: {(finished: Bool) in
                    infoView.removeFromSuperview()
                })
                buffer.removeAll()
            }
        }
        
        // Mark: Remove New Event Marker
        if let marker = newEventMarker {
            marker.map = nil
        }
    }
    
    func addInfoView(_ marker: GMSMarker) {
        if(marker.snippet == "New Event") {
            return
        }
        
        let event = marker.userData as! Event
        self.event = event
        
        //Mark: move camera
        for view in self.view.subviews {
            if view.restorationIdentifier == "MapView" {
                let mapView = view as! GMSMapView
                mapView.animate(toLocation: marker.position)
            }
        }
        
        
        let size = CGSize(width: self.view.bounds.width, height: 180) // first: 180
        let origin = CGPoint(x: 0, y: self.view.bounds.height)
        let rect = CGRect(origin: origin, size: size)
        let infoView = UIView(frame: rect)
        
//        let blurEffect = UIBlurEffect(style: .prominent)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = infoView.bounds
//        blurEffectView.layer.cornerRadius = 8
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        infoView.addSubview(blurEffectView)
        
        
        // Mark: infoView UI style
        infoView.backgroundColor = UIColor(white: 247/255, alpha: 240.0/255)
        infoView.tintColor = self.navigationController?.navigationBar.tintColor
        infoView.layer.cornerRadius = 8
        infoView.layer.shadowRadius = 2
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.5
        infoView.layer.shadowOffset = CGSize(width: -1, height: 1)
        infoView.layer.shadowPath = UIBezierPath(rect: infoView.bounds).cgPath
        infoView.tag = 1
        
        // Mark: Indicator
        let indicatorView = UIImageView(frame: CGRect(x: view.frame.width/2 - 30, y: 3, width: 0, height: 0))
        indicatorView.image = UIImage(named: "Indicator")
        infoView.addSubview(indicatorView)
        indicatorView.sizeToFit()
        // Mark: imageView UI
        let imageView = UIImageView(frame: CGRect(x: 15, y: 15, width: 120, height: 80))
        
        let image = UIImage.gif(url: event.photos[0])
        imageView.image = image?.resizeImage(targetSize: imageView.frame.size)
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        infoView.addSubview(imageView)
        
        // Mark: DateLabel UI
        let dateLabel = UILabel(frame: CGRect(origin: CGPoint(x: imageView.bounds.width + 25, y: 10), size: CGSize(width: infoView.bounds.width/2 - 10, height: 0)))
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .red
        let startDate = self.event.date as Date
        let endDate = self.event.endDate as Date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd HH:mm"
        let endFormatter = DateFormatter()
        endFormatter.dateFormat = "HH:mm"
        var eventStartDate = String()
        var eventEndDate = String()
        if (Calendar.current.isDate(startDate, inSameDayAs: endDate)) {
            eventStartDate = formatter.string(from: startDate)
            eventEndDate = endFormatter.string(from: endDate)
        } else {
            eventStartDate = formatter.string(from: startDate)
            eventEndDate = formatter.string(from: endDate)
            
        }
        dateLabel.text = eventStartDate + " - " + eventEndDate
        dateLabel.sizeToFit()
        infoView.addSubview(dateLabel)
        
        // Mark: ContentLabel UI
        let contentLabel = UILabel(frame: CGRect(origin: CGPoint(x: imageView.bounds.width + 25, y: 20 + dateLabel.bounds.height), size: CGSize(width: infoView.bounds.width - imageView.frame.width - 45, height: 0)))
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.numberOfLines = 3
        contentLabel.text = marker.title
        contentLabel.sizeToFit()
        infoView.addSubview(contentLabel)
        
        // Mark: -- Detail button
        let detailBtn = UIButton(frame: CGRect(x: 15, y: imageView.frame.maxY + 15, width: infoView.bounds.maxX - 30, height: 40))
        detailBtn.layer.cornerRadius = 8
        detailBtn.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        detailBtn.setTitleColor(UIColor.white, for: .normal)
        detailBtn.setTitle("Detail", for: .normal)
        detailBtn.isUserInteractionEnabled = true
        detailBtn.addTarget(self, action: #selector(btnPressedDown(_:)), for: UIControlEvents.touchDown)
        detailBtn.addTarget(self, action: #selector(infoViewTapped(_:)), for: UIControlEvents.touchUpInside)
        
        infoView.addSubview(detailBtn)
        
        let likeBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: 15, y: detailBtn.frame.maxY + 10, width: (infoView.bounds.maxX - 30)/2 - 5, height: 40))
            button.setImage(UIImage(named: "star-default"), for: .normal)
            
            button.backgroundColor = UIColor(red:0.26, green:0.40, blue:0.70, alpha:1.0)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(likeBtnPressed(_:)), for: .touchUpInside)
            button.tag = 0
            return button
        }()
        
        infoView.addSubview(likeBtn)
        
        let shareBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: likeBtn.frame.maxX + 10, y: detailBtn.frame.maxY + 10, width: (infoView.bounds.maxX - 30)/2 - 5, height: 40))
            let image = UIImage(named: "share")
            button.addTarget(self, action: #selector(shareBtnPressed(_:)), for: .touchUpInside)
            button.setImage(image?.resizeImage(targetSize: CGSize(width: 30, height: 30)), for: .normal)
            button.backgroundColor = .lightGray
            
            button.layer.cornerRadius = 8
//            button.addTarget(self, action: #selector(likeBtnPressed(_:)), for: .touchUpInside)
            return button
        }()
        
        infoView.addSubview(shareBtn)
        
        let cancelBtn: UIButton = {
            let button = UIButton(frame: CGRect(origin: CGPoint(x: 15, y: likeBtn.frame.maxY + 10), size: detailBtn.frame.size))
            button.setTitleColor(UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1), for: .normal)
            button.setTitle("Cancel", for: .normal)
            button.setTitleColor(UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1), for: .highlighted)
            button.layer.cornerRadius = 8
            button.backgroundColor = .white
            button.addTarget(self, action: #selector(removeView), for: .touchUpInside)
            return button
        }()
        
        infoView.addSubview(cancelBtn)
        
        infoView.frame.size = CGSize(width: self.view.bounds.width, height: imageView.frame.height + detailBtn.frame.height + likeBtn.frame.height + cancelBtn.frame.height + 65)
        
        self.view.addSubview(infoView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            infoView.frame.origin.y = self.view.bounds.height - likeBtn.frame.minY
        }, completion: nil)
        
        buffer.append(infoView)
        
        
        
        // Tap InfoView trigger
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoViewTapped(sender:)))
        
        infoView.isUserInteractionEnabled = true
    }
    
    @objc func likeBtnPressed(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.5),
                       initialSpringVelocity: CGFloat(3.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in
                        })
        if sender.tag == 0 {
            self.like(sender)
        } else if sender.tag == 1 {
            self.unlike(sender)
        }
        
    }
    
    func like(_ sender: UIButton) {
        if event.like() {
            print("Liked")
            sender.setImage(UIImage(named: "star-filled"), for: .normal)
            sender.tag = 1
            
        } else {
            let alertController = MDCAlertController(title: nil, message: "You need to login.")
            alertController.mdc_adjustsFontForContentSizeCategory = true
            let cancelAction = MDCAlertAction(title: "Cancel",  handler: nil)
            alertController.addAction(cancelAction)
            let confirmAction = MDCAlertAction(title: "Login") { (action) in
                let _ = LoginView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 220))
            }
            alertController.addAction(confirmAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func unlike(_ sender: UIButton) {
        print("unlike")
        event.unlike()
        sender.setImage(UIImage(named: "star-default"), for: .normal)
        sender.tag = 0
    }
    
    @objc func shareBtnPressed(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.5),
                       initialSpringVelocity: CGFloat(3.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in
        })
        share(sender)
    }
    
    func share(_ sender: Any) {
        
        let text = "Check out this event."
        let url = URL(string: "https://events.iltcapp.net/events/" + event.id)
        let dataToShare: [Any] = [ text, url! ]
        let activityViewController = UIActivityViewController(
            activityItems: dataToShare,
            applicationActivities: nil)
        if let _ = activityViewController.popoverPresentationController {
//            popoverController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        //Mark: remove buffer
        removeView()
        
        //Mark: Add Marker
        let marker = GMSMarker()
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.position = coordinate
//        marker.icon = UIImage(named: "Oval")
        marker.icon = GMSMarker.markerImage(with: UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1))
        marker.title = event.title
        marker.snippet = "New Event"
        marker.map = mapView
        
        self.newEventMarker = marker
        
        //Mark: move camera
        for view in self.view.subviews {
            if view.restorationIdentifier == "MapView" {
                let mapView = view as! GMSMapView
                mapView.animate(toLocation: coordinate)
            }
        }
        
        GMSGeocoder().reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines!
                
                let addressText = lines.joined(separator: ", ")
                self.address = addressText
                self.coordinate = coordinate
                
                let size = CGSize(width: self.view.bounds.width, height: 130)
                let origin = CGPoint(x: 0, y: self.view.bounds.height)
                let rect = CGRect(origin: origin, size: size)
                let infoView = UIView(frame: rect)
                
                // Mark: infoView UI style
                infoView.backgroundColor = UIColor(white: 247/255, alpha: 240.0/255)
                infoView.tintColor = self.navigationController?.navigationBar.tintColor
                infoView.layer.cornerRadius = 4
                infoView.layer.shadowRadius = 2
                infoView.layer.shadowColor = UIColor.black.cgColor
                infoView.layer.shadowOpacity = 0.5
                infoView.layer.shadowOffset = CGSize(width: -1, height: 1)
                infoView.layer.shadowPath = UIBezierPath(rect: infoView.bounds).cgPath
                infoView.tag = 0
                
                // Mark: ContentLabel UI
                let contentLabel = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: infoView.bounds.width - 20, height: 100)))
                contentLabel.font = UIFont.systemFont(ofSize: 15)
                contentLabel.numberOfLines = 4
                contentLabel.text = addressText
                contentLabel.sizeToFit()
                infoView.addSubview(contentLabel)
                
                // Mark: -- Detail button
                let detailBtn = UIButton(frame: CGRect(x: 10, y: contentLabel.frame.height + 20, width: infoView.bounds.maxX - 20, height: 40))
                detailBtn.layer.cornerRadius = 4
                detailBtn.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
                detailBtn.setTitleColor(UIColor.white, for: .normal)
                detailBtn.setTitle("New Event", for: .normal)
                detailBtn.isUserInteractionEnabled = true
                detailBtn.addTarget(self, action: #selector(self.btnPressedDown(_:)), for: UIControlEvents.touchDown)
                detailBtn.addTarget(self, action: #selector(self.addViewTapped(_:)), for: UIControlEvents.touchUpInside)
                infoView.addSubview(detailBtn)
                
                self.view.addSubview(infoView)
                infoView.frame.size = CGSize(width: self.view.bounds.width, height: contentLabel.frame.height + detailBtn.frame.height + 40)
                UIView.animate(withDuration: 0.3, animations: {
                    infoView.frame.origin.y = self.view.bounds.height - infoView.frame.height
                }, completion: nil)
                
                self.buffer.append(infoView)
            }
            
        }
    }
    
    // Mark: ButtonPressed down action
    @objc func btnPressedDown(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1) {
            sender.backgroundColor = UIColor(red: 128/255.0, green: 212/255.0, blue: 255/255.0, alpha: 1)
        }
        
    }
    
    // Mark: InfoView tap action
    @objc func infoViewTapped(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1) {
            sender.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        }
        let vc = DetailViewController()
        vc.event = self.event
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Mark: AddView tap action
    @objc func addViewTapped(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1) {
            sender.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        }
        let vc = AddEventTableViewController()
        vc.address = self.address
        vc.coordinate = ["la": (self.coordinate!.latitude) , "lo": (self.coordinate!.longitude)]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addEvents(events: [Event]) {
        if let loadingView = loadingView {
            loadingView.removeFromSuperview()
        }
        
        if events.count == 0 {
            let alert: MDCAlertController = MDCAlertController(title: "No Event", message: "There is no event now or base on your filter.")
            alert.addAction(MDCAlertAction(title: "OK", handler: nil))
            
            present(alert, animated: true)
        }
        
        // Mark: Remove old markers
        if(markerBuffer.count > 0){
            for marker in markerBuffer {
                marker.map = nil
            }
            
            markerBuffer = []
        }
        
        for event in events {
            if event.geo["latitude"] == "" {
                continue
            }
            let latitude = event.geo["latitude"]! as NSString
            let longitude = event.geo["longitude"]! as NSString
            let marker = GMSMarker()
            let la = latitude.floatValue
            let lo = longitude.floatValue
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(la), longitude: CLLocationDegrees(lo))
            marker.icon = GMSMarker.markerImage(with: .red)
            marker.title = event.title
            marker.snippet = "\(event.date)"
            marker.map = mapView
            
            marker.userData = event
            
            markerBuffer.append(marker)
        }
    }
    
    var locationBegan: CGFloat = 0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first as UITouch!

        if (touch.view?.tag == 1) {
            
            locationBegan = touch.location(in: touch.view).y
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch:UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {
            let infoView = touch.view
//            if ((infoView?.frame.origin.y)! > view.frame.maxY - (infoView?.frame.height)! - 30) {
//                let displacement = (infoView?.frame.midY)! - touch.location(in: view).y
//                infoView?.frame.origin.y -= displacement * 0.005
//            }
            if ((infoView?.frame.origin.y)! >= view.frame.maxY - (infoView?.frame.height)!) {
                
                infoView?.frame.origin.y = touch.location(in: self.view).y - locationBegan
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {
            
            let infoView = touch.view
            var location: CGFloat = (infoView?.frame.origin.y)!
            if (infoView?.frame.origin.y)! < (view.frame.height - (infoView?.frame.height)!) + 40 {
                location = self.view.bounds.height - (infoView?.frame.height)!
            } else if (infoView?.frame.origin.y)! > view.frame.height - 95 {
                location = self.view.bounds.height
            } else {
                location = self.view.bounds.height - 160
            }

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                infoView?.frame.origin.y = location
            }, completion: {(finished: Bool) in
                if location == self.view.bounds.height {
                    self.removeView()
                }
            })
            //infoViewTapped(infoView!)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {
            
            
            let infoView = touch.view
            var location: CGFloat = (infoView?.frame.origin.y)!
            if (infoView?.frame.origin.y)! < (view.frame.height - (infoView?.frame.height)!) + 40 {
                location = self.view.bounds.height - (infoView?.frame.height)!
            } else if (infoView?.frame.origin.y)! > view.frame.height - 95 {
                location = self.view.bounds.height
            } else {
                location = self.view.bounds.height - 160
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
                infoView?.frame.origin.y = location
            }, completion: {(finished: Bool) in
                if location == self.view.bounds.height {
                    self.removeView()
                }
            })
        }
    }
}


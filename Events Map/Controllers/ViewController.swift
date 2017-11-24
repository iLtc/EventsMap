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

class ViewController: UICollectionViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    let manger = CLLocationManager()
    var mapView: GMSMapView!
    var carema = GMSCameraPosition()
    var buffer: [UIView] = []
    var event: Event = Event()
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(red: 237/255.0, green: 234/255.0, blue: 227/255.0, alpha: 1)
        manger.delegate = self
        manger.desiredAccuracy = kCLLocationAccuracyBest
        manger.requestWhenInUseAuthorization()
        manger.startUpdatingLocation()
        
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
        EventService.instance.getEvents(addEvents)
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
    
    // Mark: Animated remove infoView
    func removeView() {
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
    }
    
    func addInfoView(_ marker: GMSMarker) {
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
        infoView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        infoView.layer.cornerRadius = 8
        infoView.layer.shadowRadius = 2
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.5
        infoView.layer.shadowOffset = CGSize(width: -1, height: 1)
        infoView.layer.shadowPath = UIBezierPath(rect: infoView.bounds).cgPath
        infoView.tag = 1
        
        
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
        detailBtn.layer.cornerRadius = 4
        detailBtn.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        detailBtn.setTitleColor(UIColor.white, for: .normal)
        detailBtn.setTitle("Detail", for: .normal)
        detailBtn.isUserInteractionEnabled = true
        detailBtn.addTarget(self, action: #selector(btnPressedDown(_:)), for: UIControlEvents.touchDown)
        detailBtn.addTarget(self, action: #selector(infoViewTapped(_:)), for: UIControlEvents.touchUpInside)
        infoView.addSubview(detailBtn)
        
        let likeBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: 15, y: detailBtn.frame.maxY + 10, width: (infoView.bounds.maxX - 30)/2 - 10, height: 40))
            let imageDefault = UIImage(named: "star-default")
            let imageFilled = UIImage(named: "star-filled")
            button.setImage(imageDefault?.resizeImage(targetSize: CGSize(width: 30, height: 30)), for: .normal)
            button.setImage(imageFilled?.resizeImage(targetSize: CGSize(width: 30, height: 30)), for: UIControlState.highlighted)
            button.backgroundColor = UIColor(red:0.26, green:0.40, blue:0.70, alpha:1.0)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(likeBtnPressed(_:)), for: .touchUpInside)
            return button
        }()
        
        infoView.addSubview(likeBtn)
        
        let shareBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: likeBtn.frame.maxX + 20, y: detailBtn.frame.maxY + 10, width: (infoView.bounds.maxX - 30)/2 - 10, height: 40))
            let image = UIImage(named: "share")
            
            button.setImage(image?.resizeImage(targetSize: CGSize(width: 30, height: 30)), for: .normal)
            button.backgroundColor = .lightGray
            
            button.layer.shadowRadius = 2
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.5
            button.layer.shadowOffset = CGSize(width: 1, height: 1)
            button.layer.shadowPath = UIBezierPath(rect: button.bounds).cgPath
            button.layer.cornerRadius = 8
//            button.addTarget(self, action: #selector(likeBtnPressed(_:)), for: .touchUpInside)
            return button
        }()
        
        infoView.addSubview(shareBtn)
        
        infoView.frame.size = CGSize(width: self.view.bounds.width, height: imageView.frame.height + detailBtn.frame.height + likeBtn.frame.height + 55)
        
        self.view.addSubview(infoView)
        
        UIView.animate(withDuration: 0.3, animations: {
            infoView.frame.origin.y = self.view.bounds.height - infoView.frame.height
        }, completion: nil)
        
        buffer.append(infoView)
        
        
        
        // Tap InfoView trigger
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoViewTapped(sender:)))
        
        infoView.isUserInteractionEnabled = true
    }
    
    @objc func likeBtnPressed(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        //Mark: remove buffer
        removeView()
        
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
                
                let size = CGSize(width: self.view.bounds.width, height: 130)
                let origin = CGPoint(x: 0, y: self.view.bounds.height)
                let rect = CGRect(origin: origin, size: size)
                let infoView = UIView(frame: rect)
                
                // Mark: infoView UI style
                infoView.backgroundColor = UIColor(white: 1, alpha: 0.95)
                infoView.layer.cornerRadius = 4
                infoView.layer.shadowRadius = 2
                infoView.layer.shadowColor = UIColor.black.cgColor
                infoView.layer.shadowOpacity = 0.5
                infoView.layer.shadowOffset = CGSize(width: -1, height: 1)
                infoView.layer.shadowPath = UIBezierPath(rect: infoView.bounds).cgPath
                infoView.tag = 1
                
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
        let vc = AddEventViewController()
        vc.address = self.address
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addEvents(events: [Event]) {
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
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {
            
            //let infoView = touch.view
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch:UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {
            let infoView = touch.view
            if ((infoView?.frame.origin.y)! > view.frame.maxY - (infoView?.frame.height)! - 30) {
                let displacement = (infoView?.frame.midY)! - touch.location(in: view).y
                infoView?.frame.origin.y -= displacement * 0.005
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {

            let infoView = touch.view
            UIView.animate(withDuration: 0.3, animations: {
                infoView?.frame.origin.y = self.view.bounds.height - (infoView?.frame.height)!
            }, completion: nil)
            //infoViewTapped(infoView!)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {
            
            let infoView = touch.view
            UIView.animate(withDuration: 0.3, animations: {
                infoView?.frame.origin.y = self.view.bounds.height - (infoView?.frame.height)!
            }, completion: nil)
        }
    }
    
    
}


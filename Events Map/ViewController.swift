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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
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
        EventService.instance.sync(addEvents)
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
        let la = Double(marker.position.latitude)
        let lo = Double(marker.position.longitude)
        
        for view in self.view.subviews {
            if view.restorationIdentifier == "MapView" {
                let mapView = view as! GMSMapView
                let newCamera = GMSCameraPosition.camera(withLatitude: la,
                                                         longitude: lo,
                                                         zoom: mapView.camera.zoom)
                mapView.animate(toLocation: marker.position)
            }
        }
        
        
        let edge = CGFloat(10)
        let size = CGSize(width: self.view.bounds.width-2*edge, height: 170)
        let origin = CGPoint(x: edge, y: self.view.bounds.height)
        let rect = CGRect(origin: origin, size: size)
        let infoView = UIView(frame: rect)
        
        // Mark: infoView UI style
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 4
        infoView.layer.shadowRadius = 4
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.5
        infoView.layer.shadowOffset = CGSize(width: -1, height: 1)
        infoView.layer.shadowPath = UIBezierPath(rect: infoView.bounds).cgPath
        infoView.layer.shouldRasterize = true
        infoView.sizeToFit()
        infoView.tag = 1
        
        // Mark: imageView UI
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 150, height: 100))
        imageView.downloadedFrom(url: URL(string: event.photos[0])!)
        imageView.contentMode = .scaleAspectFit
        infoView.addSubview(imageView)
        
        // Mark: ContentLabel UI
        let contentLabel = UILabel(frame: CGRect(origin: CGPoint(x: imageView.bounds.width + 5, y: 5), size: CGSize(width: infoView.bounds.width/2 - 10, height: 100)))
        contentLabel.numberOfLines = 4
        contentLabel.text = marker.title
        contentLabel.sizeToFit()
        infoView.addSubview(contentLabel)
        
        // Mark: -- Detail button
        let detailBtn = UIButton(frame: CGRect(x: 10, y: imageView.frame.maxY + 10, width: infoView.bounds.maxX - 20, height: 40))
        detailBtn.layer.cornerRadius = 4
        detailBtn.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        detailBtn.setTitleColor(UIColor.white, for: .normal)
        detailBtn.setTitle("Detail", for: .normal)
        detailBtn.isUserInteractionEnabled = true
        detailBtn.addTarget(self, action: #selector(btnPressedDown(_:)), for: UIControlEvents.touchDown)
        detailBtn.addTarget(self, action: #selector(infoViewTapped(_:)), for: UIControlEvents.touchUpInside)
        infoView.addSubview(detailBtn)
        
        // Mark: DateLabel UI
        let dateLabel = UILabel()
        
        self.view.addSubview(infoView)
        
        UIView.animate(withDuration: 0.3, animations: {
            infoView.frame.origin.y = self.view.bounds.height - 180
        }, completion: nil)
        
        buffer.append(infoView)
        
        
        
        // Tap InfoView trigger
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoViewTapped(sender:)))
        infoView.isUserInteractionEnabled = true
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("You long pressed at \(coordinate.latitude), \(coordinate.longitude)")
        

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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addEvents() {
        let events = EventService.instance.getEvents()
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
            if ((infoView?.frame.origin.y)! > view.frame.maxY * 0.7) {
                let displacement = (infoView?.frame.maxY)!*0.5 - touch.location(in: view).y
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
                infoView?.frame.origin.y = self.view.bounds.height - 180
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
                infoView?.frame.origin.y = self.view.bounds.height - 180
            }, completion: nil)
        }
    }
}

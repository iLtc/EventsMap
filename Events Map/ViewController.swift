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
        EventService.instance.sync(addEvents)
        self.view.addSubview(mapView)

    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        addInfoView(marker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if buffer.count != 0 {
            for infoView in buffer {
                UIView.animate(withDuration: 0.5, animations: {
                    infoView.frame.origin.y = self.view.bounds.height
                }, completion: nil)
                infoView.removeFromSuperview()
                buffer.removeAll()
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("hehe")
    }
    
    func addInfoView(_ marker: GMSMarker) {
        let event = marker.userData as! Event
        self.event = event
        let edge = CGFloat(10)
        let size = CGSize(width: self.view.bounds.width-2*edge, height: (self.view.bounds.height)/2-100)
        let origin = CGPoint(x: edge, y: self.view.bounds.height)
        let rect = CGRect(origin: origin, size: size)
        let infoView = UIView(frame: rect)
        infoView.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.downloadedFrom(url: URL(string: event.photos[0])!)
        imageView.contentMode = .scaleAspectFit
        infoView.addSubview(imageView)
        let contentLabel = UILabel(frame: CGRect(origin: CGPoint(x: infoView.bounds.midX, y: edge), size: CGSize(width: infoView.bounds.width/2, height: infoView.bounds.height)))
        contentLabel.numberOfLines = 10
        contentLabel.text = marker.title
        contentLabel.sizeToFit()
        infoView.tag = 1
        infoView.addSubview(contentLabel)
        self.view.addSubview(infoView)
        
        UIView.animate(withDuration: 0.5, animations: {
            infoView.frame.origin.y = self.view.bounds.height * 0.5 + 100
        }, completion: nil)
        
        buffer.append(infoView)
        
        
        
        // Tap InfoView trigger
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoViewTapped(sender:)))
        infoView.isUserInteractionEnabled = true
        
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("You long pressed at \(coordinate.latitude), \(coordinate.longitude)")
        

    }
    
    
    
    // Mark: InfoView tap action
    func infoViewTapped(_ view: UIView) {
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
            marker.snippet = event.date
            marker.map = mapView
            
            marker.userData = event
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {
            
            let infoView = touch.view
            infoView?.backgroundColor = UIColor.lightGray
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first as UITouch!
        
        if (touch.view?.tag == 1) {

            let infoView = touch.view
            infoView?.backgroundColor = UIColor.white
            infoViewTapped(infoView!)
        }
    }
}

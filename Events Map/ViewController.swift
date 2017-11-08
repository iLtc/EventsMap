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

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    
    let manger = CLLocationManager()
    var mapView: GMSMapView!
    var carema = GMSCameraPosition()
    var buffer: [UIView] = []
    
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
            for i in buffer {
                i.removeFromSuperview()
                buffer.removeAll()
            }
        }
    }
    
    func addInfoView(_ marker: GMSMarker) {
        let event = marker.userData as! Event
        let edge = CGFloat(5)
        let size = CGSize(width: self.view.bounds.width-2*edge, height: (self.view.bounds.height)/2-100)
        let origin = CGPoint(x: edge, y: (self.view.bounds.height)/2+100)
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
        infoView.addSubview(contentLabel)
        self.view.addSubview(infoView)
        buffer.append(infoView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoViewTapped(tapGestureRecognizer:)))
        infoView.isUserInteractionEnabled = true
        infoView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("You long pressed at \(coordinate.latitude), \(coordinate.longitude)")
        

    }
    
    @objc func infoViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = DetailViewController()
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
}

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

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    let manger = CLLocationManager()
    var mapView: GMSMapView!
    var carema = GMSCameraPosition()
    
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
        EventService.instance.sync(addEvents)
        self.view.addSubview(mapView)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addEvents() {
        let events = EventService.instance.getEvents()
        for event in events {
            print(event.id, event.title)
            if event.geo["latitude"] == "" {
                continue
            }
            let latitude = event.geo["latitude"]! as NSString
            let longitude = event.geo["longitude"]! as NSString
            let marker = GMSMarker()
            let la = latitude.floatValue
            let lo = longitude.floatValue
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(la), longitude: CLLocationDegrees(lo))
            marker.title = event.title
            marker.snippet = event.date
            marker.map = mapView
            print(la, lo)
        }
    }
}

//
//  MapView.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/9/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents
import MapKit

class MapView: UIView {
    
    var event: Event = Event()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 16, width: 0, height: 0))
        titleLabel.text = "Get Directions"
        titleLabel.font = MDCTypography.titleFont()
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        let appleMapsBtn = MDCFlatButton(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: 60, height: 60))
        appleMapsBtn.setImage(#imageLiteral(resourceName: "AppleMaps"), for: .normal)
        appleMapsBtn.sizeToFit()
        appleMapsBtn.addTarget(self, action: #selector(getDirectionMapKit), for: .touchUpInside)
       
        let appleMapsLabel = UILabel(frame: CGRect(x: appleMapsBtn.frame.center.x - 30, y: appleMapsBtn.frame.maxY, width: 60, height: 20))
        appleMapsLabel.text = "Maps"
        appleMapsLabel.textAlignment = .center
        addSubview(appleMapsBtn)
        addSubview(appleMapsLabel)
        
        let googleMapsBtn = MDCFlatButton(frame: CGRect(x: appleMapsBtn.frame.maxX, y: titleLabel.frame.maxY, width: 60, height: 60))
        googleMapsBtn.setImage(#imageLiteral(resourceName: "GoogleMaps"), for: .normal)
        googleMapsBtn.sizeToFit()
        let googleMapsLabel = UILabel(frame: CGRect(x: googleMapsBtn.frame.center.x - 60, y: googleMapsBtn.frame.maxY, width: 120, height: 20))
        googleMapsBtn.addTarget(self, action: #selector(getDirectionGoogle), for: .touchUpInside)
        googleMapsLabel.text = "Google Maps"
        googleMapsLabel.textAlignment = .center
        addSubview(googleMapsLabel)
        addSubview(googleMapsBtn)
        frame.size.width = appleMapsBtn.frame.width + googleMapsBtn.frame.width
        frame.size.height = 32 + titleLabel.frame.height + appleMapsBtn.frame.height + appleMapsLabel.frame.height
    }

    // Mark: get direction method using MapKit
    @objc func getDirectionMapKit () {
        
        let latitude: CLLocationDegrees = (event.geo["latitude"]! as NSString).doubleValue
        let longitude: CLLocationDegrees = (event.geo["longitude"]! as NSString).doubleValue
        
        let regionDistance: CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault] as [String : Any]
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = event.location
        mapItem.openInMaps(launchOptions: options)
        
        
    }
    
    // MARK: -- get direction method using Google Maps
    @objc func getDirectionGoogle () {
        let geoLocation = event.geo["latitude"]! + "," + event.geo["longitude"]!
        let location = event.location.replacingOccurrences(of: " ", with: "+")
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?daddr="+location+"&center="+geoLocation+"&zoom=14&view=traffic")!)
        } else {
            let appID = "585027354"
            UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id" + appID)!)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

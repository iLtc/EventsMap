//
//  MapsCell.swift
//  Events Map
//
//  Created by Tony Chen on 11/13/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MapKit

class MapsCell: UICollectionViewCell {
    
    var event: Event = Event()
    
    override var isHighlighted: Bool {
        didSet {
            if let selectMap: String = titleLabel.text {
                switch selectMap {
                case "Google Maps":
                    getDirectionGoogle()
                case "Maps":
                    getDirectionMapKit()
                default:
                    break
                }
            }
            
        }
    }
    var setting: Setting? {
        didSet {
            titleLabel.text = setting?.name
            if let imageName = setting?.imageName {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder;) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image  = UIImage(named: "GoogleMaps")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Google Maps"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        titleLabel.frame = CGRect(x: 0, y: 80 + 2, width: 80, height: 20)
    }
    
    // Mark: get direction method using MapKit
    @objc func getDirectionMapKit () {
        
        let latitude: CLLocationDegrees = (event.geo["latitude"]! as NSString).doubleValue
        let longitude: CLLocationDegrees = (event.geo["longitude"]! as NSString).doubleValue
        
        let regionDistance: CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = event.title
        mapItem.openInMaps(launchOptions: options)
        
        
        
    }
    
    // MARK: -- get direction method using Google Maps
    func getDirectionGoogle () {
        let geoLocation = event.geo["latitude"]! + "," + event.geo["longitude"]!
        let location = event.location.replacingOccurrences(of: " ", with: "+")
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?daddr="+location+"&center="+geoLocation+"&zoom=14&view=traffic")!)
        } else {
            let appID = "585027354"
            UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id" + appID)!)
        }
    }
    
}

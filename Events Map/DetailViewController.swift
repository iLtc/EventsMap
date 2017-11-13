//
//  DetailViewController.swift
//  Events Map
//
//  Created by uics3 on 11/7/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import EventKit
import MapKit
import SwiftGifOrigin

class DetailViewController: UITableViewController, UIToolbarDelegate {
    
    
    var event: Event = Event()
    //var scroll: UIScrollView = UIScrollView()
    
    var imageCell: UITableViewCell = UITableViewCell()
    //var titleCell: UITableViewCell = UITableViewCell()
    var titleView: UIView = UIView()
    var dateCell: UITableViewCell = UITableViewCell()
    var addressCell: UITableViewCell = UITableViewCell()
    var descriptionCell: UITableViewCell = UITableViewCell()
    
    var imageHeight: CGFloat = 0
    var titleHeight: CGFloat = 0
    var dateHeight: CGFloat = 0
    var addressHeight: CGFloat = 0
    var descriptionHeight: CGFloat = 0
    
    
    private var toolBar: UIToolbar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
        
        // ToolBar UI
        //toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40.0))
        //toolBar.layer.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height-20.0)
        //self.navigationController?.toolbar.barStyle = .default
        //self.navigationController?.toolbar.tintColor = UIColor.blue
        //self.navigationController?.toolbar.backgroundColor = UIColor.white
        
        let starBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Star"), style: .done, target: self, action: nil)
        let calendarBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Calendar"), style: .done, target: self, action: #selector(saveCalendarAlert(_:)))
        let navigationBtn: UIBarButtonItem = UIBarButtonItem(title: "navi" , style: .plain, target: self, action: #selector(getDirectionMapKit(_:)))
        let shareBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [space, starBtn, space, calendarBtn, space, navigationBtn, space, shareBtn, space]
        
        self.toolbarItems = items
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Event Detail"
        self.navigationController?.navigationBar.topItem?.title = "Map"

        self.navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = UIColor(red: 238/255.0, green: 242/255.0, blue: 245/255.0, alpha: 1)
        setUI()
        // Do any additional setup after loading the view.
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: share method
    @objc func share(_ sender: Any) {
        
        let text = "Check out this event."
        let dataToShare = [ text ]
        let activityViewController = UIActivityViewController(
            activityItems: dataToShare,
            applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func popUpView() {
        
    }
    
    // Mark: get direction method using MapKit
    @objc func getDirectionMapKit (_ sender: Any) {
        
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
        
        
        """
        
        
        let directionView = UIViewController()
        
        directionView.modalPresentationStyle = UIModalPresentationStyle.popover
        directionView.preferredContentSize = CGSize(width: view.bounds.width - 5, height: view.bounds.height * 0.4)
        directionView.view.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.7)
        
        if let popoverController = directionView.popoverPresentationController {
            popoverController.barButtonItem = (sender as! UIBarButtonItem)
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = CGRect(x: 5, y: view.bounds.height * 0.6, width: view.bounds.width - 5, height: view.bounds.height * 0.4)
            popoverController.delegate = self as? UIPopoverPresentationControllerDelegate
            popoverController.sourceView?.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.7)
        }
        
        present(directionView, animated: true, completion: nil)
        """
    }
    
    // MARK: -- get direction method using Google Maps
    func getDirectionGoogle (_ sender: Any) {
        let geoLocation = event.geo["latitude"]! + "," + event.geo["longitude"]!
        let location = event.location.replacingOccurrences(of: " ", with: "+")
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?daddr="+location+"&center="+geoLocation+"&zoom=14&view=traffic")!)
        } else {
            let appID = "585027354"
            UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id" + appID)!)
        }
    }
    
    // Mark: add to calendar alert
    @objc func saveCalendarAlert(_ sender: Any) {
        let alertController = UIAlertController(title: "Calendar", message: "Add this event to calendar.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
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
                newEvent.endDate = newEvent.startDate.addingTimeInterval(30 * 60)
                
                do {
                    try eventStore.save(newEvent, span: .thisEvent, commit: true)
                    
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    // MARK: -- SET UI
    func setUI() {
        // set cells UI
        self.imageCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.titleView.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        
        // set imageView UI
        let asset = NSDataAsset(name: "Loading")
        let gifImage = UIImage.gif(data: (asset?.data)!)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width * 0.67))
        imageView.image = gifImage
        //let toImage = UIImage.gif(url: event.photos[0])
        //UIView.transition(with: imageView,
        //                          duration:5,
        //                          options: .transitionCrossDissolve,
        //                          animations: { imageView.image = toImage },
        //                          completion: nil)
        imageView.downloadedFrom(url: URL(string: event.photos[0])!)
        imageView.contentMode = .scaleAspectFit
        imageHeight = imageView.bounds.maxY
        self.imageCell.isUserInteractionEnabled = false
        self.imageCell.addSubview(imageView)
        
        // set titleLabel UI (title)
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 15, width: self.view.bounds.width - 30, height: 0))
        titleLabel.text = event.title
        titleLabel.font = UIFont(name: "Arial", size: 25.0)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        titleHeight = titleLabel.bounds.maxY + 30
        self.titleView.addSubview(titleLabel)
        
        // set dateLabel UI (date)
        let dateLabel = UILabel(frame: CGRect(x: 15, y: 15, width: self.view.bounds.width - 30, height: 0))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd,yyyy HH:mm"
        let eventDate = formatter.string(from: self.event.date as Date)
        dateLabel.text = eventDate
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont(name: "Arial", size: 15.0)
        dateLabel.textColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1)
        dateLabel.sizeToFit()
        dateHeight = dateLabel.bounds.maxY + 30
        let dateButton = makeTouchBtn(subView: dateLabel, rect: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: dateHeight), tag: 1)
        self.dateCell.selectionStyle = .none
        self.dateCell.isUserInteractionEnabled = true
        self.dateCell.addSubview(dateButton)
        
        
        // set addressLabel UI (address)
        let addressLabel = UILabel(frame: CGRect(x: 15, y: 15, width: self.view.bounds.width - 30, height: 0))
        addressLabel.text = event.location
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.font = UIFont(name: "Arial", size: 20.0)
        addressLabel.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        addressLabel.sizeToFit()
        addressHeight = addressLabel.bounds.maxY + 30
        let addressButoon = makeTouchBtn(subView: addressLabel, rect: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: addressHeight), tag: 2)
        self.addressCell.selectionStyle = .none
        self.addressCell.isUserInteractionEnabled = true
        self.addressCell.addSubview(addressButoon)
        
        // set ContentLabel UI (description)
        let contentLabel = UILabel(frame: CGRect(x: 15, y: 10, width: self.view.bounds.width - 30, height: 0))
        contentLabel.text = event.description
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.sizeToFit()
        descriptionHeight = contentLabel.bounds.maxY + 20
        self.descriptionCell.isUserInteractionEnabled = false
        self.descriptionCell.addSubview(contentLabel)
        

        
        // set scroll UI
        //scroll.contentSize = CGSize(width: imageView.bounds.width, height: imageView.bounds.height + textLabel.bounds.height + 80)
        //view.addSubview(scroll)
    }
    
    // Return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Return the number of rows for each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 1
        case 1: return 3
        default: fatalError("Unknown number of sections")
        }
    }
    
    // Return the cell for each section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.imageCell
            default: fatalError("Unknown number of sections")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return self.dateCell
            case 1: return self.addressCell
            case 2: return self.descriptionCell
            default: fatalError("Unknown number of sections")
            }
        default:
            fatalError("Error section")
        }
    }
    
    // MARK: -- Touch Event
    @objc func btnTouchDown(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1) {
            sender.backgroundColor = .lightGray
        }
    }
    
    @objc func touchUp(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1) {
            sender.backgroundColor = .white
        }
        switch (sender.tag) {
        case 0:
            break
        case 1:
            saveCalendarAlert(sender)
        case 2:
            getDirectionGoogle(sender)
        default:
            break
        }
        
    }
    
    @objc func touchCancelled(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1) {
            sender.backgroundColor = .white
        }
    }
    
    // MARK: -- Make touch button
    func makeTouchBtn(subView: UIView, rect: CGRect, tag: Int) -> UIButton {
        let button = UIButton(frame: rect)
        button.addSubview(subView)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(btnTouchDown(_:)), for: UIControlEvents.touchDown)
        button.tag = tag
        button.addTarget(self, action: #selector(touchUp(_:)), for: UIControlEvents.touchUpInside)
        button.addTarget(self, action: #selector(touchCancelled(_:)), for: UIControlEvents.touchDragExit)
        return button
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            return self.titleView
        } else {
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 1) {
            return self.titleHeight
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.imageHeight
            default: fatalError("Unknown number of sections")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return self.dateHeight
            case 1: return self.addressHeight
            case 2: return self.descriptionHeight
            default: fatalError("Unknown number of sections")
            }
        default:
            fatalError("Error section")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

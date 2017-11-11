//
//  DetailViewController.swift
//  Events Map
//
//  Created by uics3 on 11/7/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import EventKit

class DetailViewController: UITableViewController, UIToolbarDelegate {
    
    var calendar: EKCalendar!
    var event: Event = Event()
    //var scroll: UIScrollView = UIScrollView()
    
    var imageCell: UITableViewCell = UITableViewCell()
    var titleCell: UITableViewCell = UITableViewCell()
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
        let calendarBtn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Calendar"), style: .done, target: self, action: nil)
        let navigationBtn: UIBarButtonItem = UIBarButtonItem(title: "navi" , style: .plain, target: self, action: #selector(getDirection(_:)))
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
    
    // Mark: get direction method
    @objc func getDirection (_ sender: Any) {
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
    }
    
    // Mark: add calendar event method
    func addCalendarEvent (_ sender: Any) {
        let eventStore = EKEventStore()
        
        if let calendarEvent = eventStore.calendar(withIdentifier: self.calendar.calendarIdentifier) {
            let newEvent = EKEvent(eventStore: eventStore)
            newEvent.calendar = calendarEvent
            newEvent.title = self.event.title
            //newEvent.startDate = self.event.date
            //newEvent.endDate
        }
    }
    
    // MARK: -- SET UI
    func setUI() {
        // set cells UI
        self.imageCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.titleCell.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        
        // set imageView UI
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.imageCell.bounds.width, height: self.imageCell.bounds.width * 0.67))
        imageView.downloadedFrom(url: URL(string: event.photos[0])!)
        imageView.contentMode = .scaleAspectFit
        imageHeight = imageView.bounds.maxY
        self.imageCell.isUserInteractionEnabled = false
        self.imageCell.addSubview(imageView)
        
        // set titleLabel UI (title)
        let titleLabel = UILabel(frame: self.titleCell.contentView.bounds.insetBy(dx: 15, dy: 10))
        titleLabel.text = event.title
        titleLabel.font = UIFont(name: "Arial", size: 25.0)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        titleHeight = titleLabel.bounds.maxY + 20
        self.titleCell.isUserInteractionEnabled = false
        self.titleCell.addSubview(titleLabel)
        
        // set dateLabel UI (date)
        let dateLabel = UILabel(frame: self.titleCell.contentView.bounds.insetBy(dx: 20, dy: titleLabel.bounds.maxY + 5))
        dateLabel.text = event.date
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont(name: "Arial", size: 15.0)
        dateLabel.textColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.5)
        dateLabel.sizeToFit()
        
        
        
        // set addressLabel UI (address)
        let addressLabel = UILabel(frame: self.addressCell.contentView.bounds.insetBy(dx: 15, dy: 10))
        addressLabel.text = event.location
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.font = UIFont(name: "Arial", size: 15.0)
        addressLabel.textColor = UIColor(red: 127/255.0, green: 127/255.0, blue: 127/255.0, alpha: 0.5)
        addressLabel.sizeToFit()
        addressHeight = addressLabel.bounds.maxY + 20
        self.addressCell.isUserInteractionEnabled = false
        self.addressCell.addSubview(addressLabel)
        
        // set ContentLabel UI (description)
        let contentLabel = UILabel(frame: self.descriptionCell.contentView.bounds.insetBy(dx: 15, dy: 10))
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
        return 3
    }
    
    // Return the number of rows for each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 1
        case 1: return 2
        case 2: return 1
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
            case 0: return self.titleCell
            case 1: return self.addressCell
            default: fatalError("Unknown number of sections")
            }
        case 2:
            switch(indexPath.row) {
            case 0: return self.descriptionCell
            default: fatalError("Unknown number of sections")
            }
        default:
            fatalError("Error section")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 2) {
            return "Description"
        } else {
            return ""
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
            case 0: return self.titleHeight
            case 1: return self.addressHeight
            default: fatalError("Unknown number of sections")
            }
        case 2:
            switch(indexPath.row) {
            case 0: return self.descriptionHeight
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

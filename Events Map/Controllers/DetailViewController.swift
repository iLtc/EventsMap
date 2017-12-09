//
//  DetailViewController.swift
//  Events Map
//
//  Created by Tony Chen on 11/7/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import EventKit
import SwiftGifOrigin
import MaterialComponents

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class DetailViewController: UITableViewController, UIToolbarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
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
    
    var starBtn: UIBarButtonItem = UIBarButtonItem()
    var calendarBtn: UIBarButtonItem = UIBarButtonItem()
    var navigationBtn: UIBarButtonItem = UIBarButtonItem()
    var shareBtn: UIBarButtonItem = UIBarButtonItem()
    var space: UIBarButtonItem = UIBarButtonItem()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Event Detail"
        
        // ToolBar UI
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if event.liked {
            button.setImage(UIImage(named: "Favorites"), for: .normal)
            button.addTarget(self, action: #selector(unlike), for: .touchUpInside)
            
        } else {
            button.setImage(UIImage(named: "Star"), for: .normal)
            button.addTarget(self, action: #selector(like), for: .touchUpInside)
        }
        starBtn = UIBarButtonItem(customView: button)
        
        calendarBtn = UIBarButtonItem(image: UIImage(named: "Calendar"), style: .done, target: self, action: #selector(saveCalendarAlert(_:)))
        navigationBtn = UIBarButtonItem(image: UIImage(named: "Explore") , style: .done, target: self, action: #selector(popUpView))
        shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [space, starBtn, space, calendarBtn, space, navigationBtn, space, shareBtn, space]
        
        self.toolbarItems = items
//        self.navigationController?.navigationBar.topItem?.title = "Map"

        self.navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = UIColor(red: 238/255.0, green: 242/255.0, blue: 245/255.0, alpha: 1)
        setUI()
        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        if (navigationController?.navigationBar) == nil {
            setCloseBtn()
        }
        
        event.countViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCloseBtn() {
        
        let closeBtn: MDCFloatingButton = {
            let button = MDCFloatingButton(frame: CGRect(x: view.frame.width - 72, y: 16, width: 56, height: 56), shape: MDCFloatingButtonShape.default)
            button.setImage(UIImage(named: "Close"), for: .normal)
            button.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
            button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
            return button
        }()
        view.addSubview(closeBtn)
        
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func like() {
        if event.like() {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            button.setImage(UIImage(named: "Favorites"), for: .normal)
            button.addTarget(self, action: #selector(unlike), for: .touchUpInside)
            starBtn = UIBarButtonItem(customView: button)
            self.setToolbarItems([space, starBtn, space, calendarBtn, space, navigationBtn, space, shareBtn, space], animated: true)
            
        } else {
            let alertController = MDCAlertController(title: nil, message: "You need to login.")
            let cancelAction = MDCAlertAction(title: "Cancel", handler: nil)
            alertController.addAction(cancelAction)
            let confirmAction = MDCAlertAction(title: "Login") { (action) in
                let loginView = LoginView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 220))
                loginView.parentVC = self
            }
            alertController.addAction(confirmAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func unlike() {
        print("unlike")
        event.unlike()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: "Star"), for: .normal)
        button.addTarget(self, action: #selector(like), for: .touchUpInside)
        starBtn = UIBarButtonItem(customView: button)
        self.setToolbarItems([space, starBtn, space, calendarBtn, space, navigationBtn, space, shareBtn, space], animated: true)
    }
    
    // Mark: share method
    @objc func share(_ sender: Any) {
        
        let text = "Check out this event."
        let url = URL(string: "https://events.iltcapp.net/events/" + event.id)
        let dataToShare: [Any] = [ text, url! ]
        let activityViewController = UIActivityViewController(
            activityItems: dataToShare,
            applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    let cellIdentifier = "mapCell"
    
    let settings: [Setting] = {
        return [Setting(name: "Google Maps", imageName: "GoogleMaps"), Setting(name: "Maps", imageName: "AppleMaps")]
    } ()
    // MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MapsCell
        cell.setting = settings[indexPath.item]
        cell.event = self.event
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / CGFloat(settings.count) - 30, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(30, 50, 20, 50)
    }
    
    let popoverMenu = PopOverView()
    
    @objc func popUpView() {
        
        let popUpView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 170))
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = popUpView.frame
        
        popUpView.backgroundColor = .clear
        popUpView.addSubview(blurEffectView)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Get Directions"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            return label
        }()
        
        popUpView.addSubview(titleLabel)
        
        let selectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 130), collectionViewLayout: layout)
            cv.backgroundColor = UIColor.clear
            return cv
        }()
        selectionView.dataSource = self
        selectionView.delegate = self
        selectionView.register(MapsCell.self, forCellWithReuseIdentifier: cellIdentifier)
        popUpView.addSubview(selectionView)
        
        titleLabel.frame = CGRect(x: 20, y: 10, width: view.frame.width, height: 30)
        selectionView.frame.origin = CGPoint(x: 0, y: 30)
        popUpView.sizeToFit()
        blurEffectView.sizeToFit()
        
        popoverMenu.presentView(popUpView)
    }
    

    // Mark: add to calendar alert
    @objc func saveCalendarAlert(_ sender: Any) {
        let alertController = MDCAlertController(title: nil, message: "Add this event to calendar.")
        let cancelAction = MDCAlertAction(title: "Cancel", handler: nil)
        alertController.addAction(cancelAction)
        let confirmAction = MDCAlertAction(title: "Add") { (action) in
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
                newEvent.endDate = self.event.endDate as Date!
                newEvent.isAllDay = self.event.isAllDay
                
                do {
                    try eventStore.save(newEvent, span: .thisEvent, commit: true)
                    
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    let alert = MDCAlertController(title: nil, message: (error as NSError).localizedDescription)
                    let OKAction = MDCAlertAction(title: "OK", handler: nil)
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
        let imageView = customImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width * 0.67))
        let imageInkController = MDCInkTouchController(view: imageView)
        imageInkController.addInkView()
        imageView.isUserInteractionEnabled = true
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
        let titleLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 20, y: 15, width: self.view.bounds.width - 30, height: 0))
            label.text = event.title
            label.font = UIFont(name: "Arial", size: 25.0)
            label.textColor = UIColor.white
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.sizeToFit()
            return label
        }()
        titleHeight = titleLabel.bounds.maxY + 30
        self.titleView.addSubview(titleLabel)
        titleView.isUserInteractionEnabled = true
        let titleInkController = MDCInkTouchController(view: titleView)
        titleInkController.addInkView()
        
        // set dateCell UI (date)
        let calendarIconView = UIImageView(image: UIImage(named: "Calendar"))
        
        calendarIconView.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        
        let dateLabel = UILabel(frame: CGRect(x: 15, y: 15, width: self.view.bounds.width - calendarIconView.frame.width - 30, height: 0))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd,yyyy HH:mm"
        let eventDate = formatter.string(from: self.event.date as Date)
        dateLabel.text = eventDate
        dateLabel.numberOfLines = 0
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
            popUpView()
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

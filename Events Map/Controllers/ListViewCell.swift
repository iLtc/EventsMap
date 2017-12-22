//
//  ListViewCell.swift
//  Events Map
//
//  Created by Alan Luo on 11/24/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class ListViewCell: UITableViewCell, MDCInkTouchControllerDelegate {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: customImageView!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    fileprivate var inkOverlay = InkOverlay()
    var event: Event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        self.isUserInteractionEnabled = true
        self.selectionStyle = .none
        
        inkOverlay.frame = self.bounds
        inkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(inkOverlay)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("haha")
            let inkTouchController = MDCInkTouchController(view: self)
            inkTouchController.addInkView()
            let location = sender.location(in: self)
            inkTouchController.inkView(atTouchLocation: location)
            inkTouchController.gestureRecognizerShouldBegin(sender)
            inkTouchController.delegate = self
            
        }
        sender.cancelsTouchesInView = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
    
    func updateViews(_ event: Event) {
        self.event = event
        
        eventTitleLabel.text = event.title
        eventImageView.downloadedFrom(link: event.photos[0])
//        eventImageView.image = UIImage.gif(url: event.photos[0])?.resizeImage(targetSize: eventImageView.frame.size)
        eventImageView.layer.cornerRadius = 10
        eventImageView.clipsToBounds = true
        
        let startDate = event.date as Date
        let endDate = event.endDate as Date
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
        eventTimeLabel.text = eventStartDate + " - " + eventEndDate
        
        eventLocationLabel.text = event.location
    }
}

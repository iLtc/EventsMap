//
//  EventCell.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/21/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class EventCell: UITableViewCell {

    var event: Event?
    public var parentVC: UIViewController?
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        // Mark: event imageView
        eventImage.layer.cornerRadius = 10
        
        // Mark: event title label
        eventTitle.font = MDCTypography.titleFont()
        
        // Mark: event date label
        eventDate.font = MDCTypography.captionFont()
        
        // Mark: detail button style
        likeBtn.backgroundColor = UIColor.MDColor.blue
        likeBtn.tintColor = .white
        likeBtn.setImage(#imageLiteral(resourceName: "md-star-border"), for: .normal)
        likeBtn.layer.cornerRadius = likeBtn.bounds.width/2
    }
    
    func updateViews(_ event: Event) {
        self.event = event
        
        eventImage.downloadedFrom(link: event.photos[0], contentMode: .scaleAspectFill)
        
        eventTitle.text = event.title
        
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
        eventDate.text = eventStartDate + " - " + eventEndDate
        
    }
    
    @IBAction func likeBtnPressedDown(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    @IBAction func likeBtnPressedUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @IBAction func likeBtnPressed(_ sender: UIButton) {
        
        print("like")
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

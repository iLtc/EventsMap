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
    @IBOutlet weak var detailBtn: MDCRaisedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Mark: event imageView
        eventImage.layer.cornerRadius = 10
        
        // Mark: event title label
        eventTitle.font = MDCTypography.titleFont()
        
        // Mark: event date label
        eventDate.font = MDCTypography.captionFont()
        
        // Mark: detail button style
        detailBtn.backgroundColor = UIColor.MDColor.blue
        detailBtn.tintColor = .white
        detailBtn.setTitle("Detail", for: .normal)
        
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
    
    @IBAction func detailBtnPressed(_ sender: MDCRaisedButton) {
        let vc = CardDetailViewController()
        vc.event = self.event
//        vc.headerContentView.image = UIImage.gif(url: (event?.photos[0])!)
        
        parentVC?.show(vc, sender: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

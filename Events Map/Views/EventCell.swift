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
    @IBOutlet weak var eventImage: customImageView!
    @IBOutlet weak var likeBtn: ShadowButton!
    
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
        let btnLayer = likeBtn.layer as! MDCShadowLayer
        btnLayer.elevation = ShadowElevation(rawValue: 2)
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
        
        if event.liked {
            likeBtn.setImage(#imageLiteral(resourceName: "md-star"), for: .normal)
            likeBtn.tag = 0 // 0 == liked
        } else {
            likeBtn.setImage(#imageLiteral(resourceName: "md-star-border"), for: .normal)
            likeBtn.tag = 1 // 1 == unliked
        }
    }
    
    @IBAction func likeBtnPressedDown(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @IBAction func likeBtnPressedUp(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @IBAction func likeBtnPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        print("like")
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
        
        if sender.tag == 0 {
            event?.unlike() { code, msg in
                if code != "200" {
                    let alert: MDCAlertController = MDCAlertController(title: "Error", message: msg)
                    alert.addAction(MDCAlertAction(title: "OK", handler: nil))
                    
                    self.parentVC?.present(alert, animated: true)
                    return
                } else {
                    sender.tag = 1
                    self.event?.liked = false
                    self.likeBtn.setImage(#imageLiteral(resourceName: "md-star-border"), for: .normal)
                }
            }
        } else if sender.tag == 1 {
            event?.like() { code, msg in
                switch code {
                case "200":
                    sender.tag = 0
                    self.likeBtn.setImage(#imageLiteral(resourceName: "md-star"), for: .normal)
                    self.event?.liked = true
                case "400":
                    let alertController = MDCAlertController(title: nil, message: "You need to login.")
                    let cancelAction = MDCAlertAction(title: "Cancel", handler: nil)
                    alertController.addAction(cancelAction)
                    let confirmAction = MDCAlertAction(title: "Login") { (action) in
                        let loginView = LoginView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 220))
                        loginView.parentVC = self.parentVC
                    }
                    alertController.addAction(confirmAction)
                    
                    self.parentVC?.present(alertController, animated: true, completion: nil)
                    
                default:
                    let alert: MDCAlertController = MDCAlertController(title: "Error", message: msg)
                    alert.addAction(MDCAlertAction(title: "OK", handler: nil))
                    
                    self.parentVC?.present(alert, animated: true)
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class ShadowButton: UIButton {
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
}

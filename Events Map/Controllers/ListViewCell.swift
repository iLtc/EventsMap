//
//  ListViewCell.swift
//  Events Map
//
//  Created by Alan Luo on 11/24/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    var event: Event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
    
    func updateViews(_ event: Event) {
        self.event = event
        
        eventTitleLabel.text = event.title
        eventImageView.image = UIImage.gif(url: event.photos[0])?.resizeImage(targetSize: eventImageView.frame.size)
        
        eventImageView.layer.cornerRadius = 10
        eventImageView.clipsToBounds = true
    }
}

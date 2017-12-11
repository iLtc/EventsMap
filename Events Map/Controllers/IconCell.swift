//
//  IconCell.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/6/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class IconCell: UITableViewCell {
    
    var desc: String?
    var icon: UIImage?
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData() {
        iconView.image = icon?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = .lightGray
        descLabel.text = desc
        descLabel.textColor = .black
        descLabel.font = MDCTypography.subheadFont()
        let inkOverlay = InkOverlay()
        inkOverlay.frame = self.frame
        inkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectionStyle = .none
        addSubview(inkOverlay)
    }
    
}

//
//  SearchCell.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/2/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class SearchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let inkTouchController = MDCInkTouchController(view: titleLabel)
        inkTouchController.addInkView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews(_ event: Event) {
        titleLabel.text = event.title
    }
    
}

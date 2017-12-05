//
//  DetailView.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/4/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents
class DetailView: UIScrollView {
    
    var title = ""
    var desc = ""
    var startDate = NSDate()
    var endDate = NSDate()
    
    fileprivate var titleLabel = UILabel()
    fileprivate var dateLabel = UILabel()
    fileprivate var labelDesc = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        let minContentHeight: CGFloat = 640
        self.contentSize = CGSize(width: self.frame.width, height: minContentHeight)
        
        let labelPadding: CGFloat = 50
        
        titleLabel.font = UIFont(name: "AbrilFatface-Regular", size: 46)
        titleLabel.textColor = UIColor(red: 0.039, green: 0.192, blue: 0.259, alpha: 1)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                value:paragraphStyle,
                                range: NSRange(location: 0, length:attrString.length))
        titleLabel.attributedText = attrString
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: labelPadding,
                             y: labelPadding, width: self.frame.width - 2*labelPadding, height: titleLabel.frame.size.height)
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(titleLabel)
        
        dateLabel.font = UIFont(name: "AbrilFatface-Regular", size: 24)
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.numberOfLines = 2
        let dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.lineHeightMultiple = 1.5
        let dateAttrString = NSMutableAttributedString(string: desc)
        dateAttrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                    value:dateParagraphStyle,
                                    range:NSRange(location: 0, length: dateAttrString.length))
        let startDate = self.startDate as Date
        let endDate = self.endDate as Date
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
        dateLabel.text = eventStartDate + " - " + eventEndDate
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(x: labelPadding,
                                 y: titleLabel.frame.maxY + labelPadding, width: self.frame.size.width - 2 * labelPadding, height: dateLabel.frame.height)
        self.addSubview(dateLabel)
        
        labelDesc.lineBreakMode = .byWordWrapping
        labelDesc.numberOfLines = 0
        labelDesc.font = UIFont(name: "Helvetica", size: 14)
        labelDesc.textColor = UIColor(white: 0.54, alpha: 1)
        let descParagraphStyle = NSMutableParagraphStyle()
        descParagraphStyle.lineHeightMultiple = 1.5
        let descAttrString = NSMutableAttributedString(string: desc)
        descAttrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                    value:descParagraphStyle,
                                    range:NSRange(location: 0, length: descAttrString.length))
        labelDesc.attributedText = descAttrString
        labelDesc.frame = CGRect(x: labelPadding,
                                 y: dateLabel.frame.maxY + labelPadding, width: self.frame.size.width - 2 * labelPadding, height: 160)
        labelDesc.sizeToFit()
        labelDesc.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(labelDesc)
        self.backgroundColor = .white
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

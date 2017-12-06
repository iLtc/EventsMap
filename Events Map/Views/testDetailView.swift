//
//  DetailView.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/4/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents
class testDetailView: UIScrollView {
    
    var event: Event = Event()
    
    fileprivate var titleLabel = UILabel()
    fileprivate var dateLabel = UILabel()
    fileprivate var addressLabel = UILabel()
    fileprivate var labelDesc = UILabel()
    
    fileprivate var titleIcon = UIImageView()
    fileprivate var dateIcon = UIImageView()
    fileprivate var addressIcon = UIImageView()
    fileprivate var descIcon = UIImageView()
    
    let inkOverlay = InkOverlay()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleIcon = UIImageView(image: #imageLiteral(resourceName: "md-title"))
        dateIcon = UIImageView(image: #imageLiteral(resourceName: "md-time"))
        addressIcon = UIImageView(image: #imageLiteral(resourceName: "md-place"))
        descIcon = UIImageView(image: #imageLiteral(resourceName: "md-short-text"))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        
        let title = event.title
        let desc = event.description
        let address = event.location
        let likes = event.likes
        let website = event.url
        let views = event.views
        let labelPadding: CGFloat = 50
        
        titleIcon.frame.origin = CGPoint(x: labelPadding, y: labelPadding)
        titleLabel.font = MDCTypography.headlineFont()
        titleLabel.textColor = .black
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
        titleLabel.frame = CGRect(x: titleIcon.frame.maxX + 30,
                             y: labelPadding, width: self.frame.width - titleIcon.frame.width - 2*labelPadding, height: titleLabel.frame.size.height)
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(titleLabel)
        self.addSubview(titleIcon)
        
        
        
        dateIcon.frame.origin = CGPoint(x: labelPadding, y: titleLabel.frame.maxY + labelPadding)
        dateIcon.alpha = 0.75
        dateLabel.font = MDCTypography.subheadFont()
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.numberOfLines = 2
        let dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.lineHeightMultiple = 1.5
        let dateAttrString = NSMutableAttributedString(string: desc)
        dateAttrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                    value:dateParagraphStyle,
                                    range:NSRange(location: 0, length: dateAttrString.length))
        let startDate = self.event.date as Date
        let endDate = self.event.endDate as Date
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
        dateLabel.frame = CGRect(x: dateIcon.frame.maxX + 30,
                                 y: titleLabel.frame.maxY + labelPadding, width: self.frame.size.width - dateIcon.frame.size.width - 2 * labelPadding, height: dateLabel.frame.height)
        self.addSubview(dateLabel)
        self.addSubview(dateIcon)
        
        
        addressIcon.alpha = 0.5
        addressIcon.frame.origin = CGPoint(x: labelPadding, y: dateLabel.frame.maxY + labelPadding)
        addressLabel.font = MDCTypography.subheadFont()
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.numberOfLines = 2
        let addressParagraphStyle = NSMutableParagraphStyle()
        addressParagraphStyle.lineHeightMultiple = 1.5
        let addressAttrString = NSMutableAttributedString(string: address)
        addressAttrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                       value:addressParagraphStyle,
                                       range:NSRange(location: 0, length: addressAttrString.length))
        addressLabel.text = address
        addressLabel.sizeToFit()
        addressLabel.frame = CGRect(x: addressIcon.frame.maxX + 30,
                                    y: dateLabel.frame.maxY + labelPadding, width: self.frame.width - addressIcon.frame.width - 2*labelPadding, height: addressLabel.frame.height)
        self.addSubview(addressIcon)
        self.addSubview(addressLabel)
        
        descIcon.frame.origin = CGPoint(x: labelPadding, y: addressLabel.frame.maxY + labelPadding)
        descIcon.alpha = 0.25
        self.addSubview(descIcon)
        labelDesc.lineBreakMode = .byWordWrapping
        labelDesc.numberOfLines = 0
        labelDesc.font = MDCTypography.body2Font()
        labelDesc.textColor = UIColor(white: 0.35, alpha: 1)
        let descParagraphStyle = NSMutableParagraphStyle()
        descParagraphStyle.lineHeightMultiple = 1.5
        let descAttrString = NSMutableAttributedString(string: desc)
        descAttrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                    value:descParagraphStyle,
                                    range:NSRange(location: 0, length: descAttrString.length))
        labelDesc.attributedText = descAttrString
        labelDesc.frame = CGRect(x: descIcon.frame.maxX + 30,
                                 y: addressLabel.frame.maxY + labelPadding, width: self.frame.size.width - descIcon.frame.width -  2 * labelPadding, height: 160)
        labelDesc.sizeToFit()
        labelDesc.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(labelDesc)
        
        self.backgroundColor = .white
        
        self.contentSize = CGSize(width: self.frame.width, height: titleLabel.frame.size.height + dateLabel.frame.size.height + addressLabel.frame.size.height +  labelDesc.frame.size.height + 5*labelPadding)
        inkOverlay.frame = CGRect(origin: .zero, size: contentSize)
        inkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(inkOverlay)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

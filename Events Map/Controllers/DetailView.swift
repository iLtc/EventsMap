//
//  DetailView.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/4/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents
class DetailView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var event: Event!
    
    fileprivate var titleLabel = UILabel()
    fileprivate var dateLabel = UILabel()
    fileprivate var addressLabel = UILabel()
    fileprivate var labelDesc = UILabel()
    
    fileprivate var titleCell = UITableViewCell()
    fileprivate var dateCell = UITableViewCell()
    fileprivate var addressCell = UITableViewCell()
    fileprivate var toolCell = UITableViewCell()
    fileprivate var descCell = UITableViewCell()
    fileprivate var cells = [UITableViewCell]()
    fileprivate var buttonBar = MDCButtonBar()
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        cells = [titleCell, dateCell, toolCell, descCell]
//        self.tableFooterView = UIView(frame: .zero)
        dataSource = self
        delegate = self
        let title = event.title
        let desc = event.description
        let startDate = event.date as Date
        let endDate = event.endDate as Date
        let address = event.location
        
        self.backgroundColor = .white
        let minContentHeight: CGFloat = self.frame.height
        self.contentSize = CGSize(width: self.frame.width, height: minContentHeight)
        
        let labelPadding: CGFloat = 15
        let iconPadding: CGFloat = 25
        
        // Title Cell
        let titleIcon = UIImageView(image: UIImage(named: "md-title"))
        titleIcon.frame.origin = CGPoint(x: iconPadding, y: iconPadding)
        
        titleLabel.font = MDCTypography.headlineFont()
        titleLabel.textColor = UIColor(red: 0.039, green: 0.192, blue: 0.259, alpha: 1)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 3
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                value:paragraphStyle,
                                range: NSRange(location: 0, length:attrString.length))
        titleLabel.attributedText = attrString
        titleLabel.frame = CGRect(x: titleIcon.frame.maxX + iconPadding,
                             y: iconPadding, width: self.frame.width - titleIcon.frame.width - 2*iconPadding, height: titleLabel.frame.size.height)
        titleLabel.sizeToFit()
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleCell.addSubview(titleIcon)
        titleCell.addSubview(titleLabel)
        titleCell.selectionStyle = .none
        let titleInkOverlay = InkOverlay()
        titleInkOverlay.frame = titleCell.bounds
        titleInkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleCell.addSubview(titleInkOverlay)
        
        // Date Cell
        let dateIcon = UIImageView(image: UIImage(named: "md-time"))
        dateIcon.frame.origin = CGPoint(x: iconPadding, y: 7)
        
        dateLabel.font = MDCTypography.subheadFont()
        dateLabel.lineBreakMode = .byWordWrapping
        dateLabel.numberOfLines = 2
        let dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.lineHeightMultiple = 1.5
        let dateAttrString = NSMutableAttributedString(string: desc)
        dateAttrString.addAttribute(NSAttributedStringKey.paragraphStyle,
                                    value:dateParagraphStyle,
                                    range:NSRange(location: 0, length: dateAttrString.length))
        
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
        dateLabel.frame = CGRect(x: dateIcon.frame.maxX + iconPadding,
                                 y: labelPadding, width: self.frame.size.width - 2 * labelPadding, height: dateLabel.frame.height)
        dateCell.addSubview(dateIcon)
        dateCell.addSubview(dateLabel)
        dateCell.selectionStyle = .none
        let dateInkOverlay = InkOverlay()
        dateInkOverlay.frame = dateCell.bounds
        dateInkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dateCell.addSubview(dateInkOverlay)
        
        // Desc Cell
        let descIcon = UIImageView(image: UIImage(named: "md-short-text"))
        descIcon.frame.origin = CGPoint(x: iconPadding, y: iconPadding)
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
        labelDesc.frame = CGRect(x: descIcon.frame.maxX + iconPadding,
                                 y: labelPadding, width: self.frame.width - descIcon.frame.width - 2*iconPadding, height: 160)
        labelDesc.sizeToFit()
        labelDesc.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        descCell.addSubview(descIcon)
        descCell.addSubview(labelDesc)
        descCell.selectionStyle = .none
//        let descInkOverlay = InkOverlay()
//        descInkOverlay.frame = descCell.bounds
//        descInkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        descCell.addSubview(descInkOverlay)
        
        // Address Cell
        let addressIcon = UIImageView(image: UIImage(named: "md-place"))
        addressIcon.frame.origin = CGPoint(x: iconPadding, y: 7)
        
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
        addressLabel.frame = CGRect(x: addressIcon.frame.maxX + iconPadding,
                                 y: labelPadding, width: self.frame.width - addressIcon.frame.width - 2*iconPadding, height: addressLabel.frame.height)
        addressCell.addSubview(addressIcon)
        addressCell.addSubview(addressLabel)
        addressCell.selectionStyle = .none
        let addressInkOverlay = InkOverlay()
        addressInkOverlay.frame = addressCell.bounds
        addressInkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addressCell.addSubview(addressInkOverlay)
        
        // Tool Cell
        let navigationItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "md-navigation").withRenderingMode(.alwaysTemplate),
            style: .done, // ignored
            target: self,
            action: #selector(btnPressed)
        )
        let calendarItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "md-calendar").withRenderingMode(.alwaysTemplate),
            style: .done, // ignored
            target: self,
            action: #selector(btnPressed)
        )
        let webItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "md-browser").withRenderingMode(.alwaysTemplate),
            style: .done, // ignored
            target: self,
            action: #selector(btnPressed)
        )
        let deleteItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "md-delete").withRenderingMode(.alwaysTemplate),
            style: .done, // ignored
            target: self,
            action: #selector(btnPressed)
        )
        navigationItem.tintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        navigationItem.width = frame.width/4
        calendarItem.tintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        calendarItem.width = frame.width/4
        webItem.tintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        webItem.width = frame.width/4
        deleteItem.tintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        deleteItem.width = frame.width/4
        buttonBar.tintColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        buttonBar.items = [navigationItem,calendarItem,webItem,deleteItem]
        buttonBar.buttonTitleBaseline = 10
        let size = buttonBar.sizeThatFits(bounds.size)
        buttonBar.frame = CGRect(x: 0, y: 15, width: size.width, height: size.height)
        toolCell.addSubview(buttonBar)
        toolCell.selectionStyle = .none

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            return titleCell
        case 1:
            return dateCell
        case 2:
            return addressCell
        case 3:
            return toolCell
        case 4:
            return descCell
        default:
            fatalError("Error section")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            return titleLabel.frame.size.height + 50
        case 1:
            return dateLabel.frame.size.height + 30
        case 2:
            return addressLabel.frame.size.height + 30
        case 3:
            return buttonBar.frame.size.height + 30
        case 4:
            return labelDesc.frame.size.height + 30
        default:
            fatalError("Error section")
        }
    }

    @objc func btnPressed() {
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

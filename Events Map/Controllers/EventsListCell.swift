//
//  EventsListCell.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/2/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class EventsListCell: MDCCollectionViewCell {
    
    private let labelHeight: CGFloat = 72
    var index = 0
    
    var titleLabel: UILabel = UILabel()
    var dateLabel: UILabel = UILabel()
    var thumbnailImageView: UIImageView = UIImageView()
    
    fileprivate var cellView = UIView()
    fileprivate var inkOverlay = InkOverlay()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.alpha = 0
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        UIView.animate(withDuration: 0.4, delay: TimeInterval(Double(index) * 0.2), options: .curveEaseOut, animations: {
            self.alpha = 1
        }, completion: nil)
        cellView.frame = bounds
        cellView.backgroundColor = .white
        cellView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellView.clipsToBounds = true
        
        
        let shadowLayer = self.layer as! MDCShadowLayer
        shadowLayer.elevation = .cardResting
        
        thumbnailImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .lightGray
            imageView.contentMode = .scaleAspectFill
            imageView.autoresizingMask = .flexibleWidth
            imageView.clipsToBounds = true
            return imageView
        }()
        cellView.addSubview(thumbnailImageView)
        
        dateLabel = {
            let label = UILabel()
            label.font = MDCTypography.captionFont()
            label.alpha = MDCTypography.captionFontOpacity()
            label.textColor = UIColor(white: 0.5, alpha: 1)
            
            return label
        }()
        cellView.addSubview(dateLabel)
        
        titleLabel = {
            let label = UILabel()
            label.font = MDCTypography.headlineFont()
            label.alpha = MDCTypography.headlineFontOpacity()
            label.textColor = UIColor(white: 0, alpha: 0.87)
            
            return label
        }()
        cellView.addSubview(titleLabel)
        
        inkOverlay.frame = self.bounds
        inkOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellView.addSubview(inkOverlay)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    func populateCell(_ event: Event) {
        thumbnailImageView.image = UIImage.gif(url: event.photos[0])
        let startDate = event.date as Date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd HH:mm"
        dateLabel.text = formatter.string(from: startDate)
        titleLabel.text = event.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(cellView)
        thumbnailImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - labelHeight)
        
        dateLabel.frame = CGRect(x: 15, y: self.frame.size.height - dateLabel.font.pointSize - 15, width: self.frame.size.width - 30, height: dateLabel.font.pointSize + 2)
        
        titleLabel.frame = CGRect(x: 15, y: dateLabel.frame.origin.y - titleLabel.font.pointSize - 8, width: self.frame.size.width - 30, height: titleLabel.font.pointSize + 2)
        
    }
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
}

//
//  InfoView.swift
//  Events Map
//
//  Created by Yizhen Chen on 12/21/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

private let cellIdentifier = "EventCell"

class InfoView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var events:[Event]!
    public var parentVC: UIViewController?
    let infoHeaderView = UIView()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        
        infoHeaderView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        infoHeaderView.backgroundColor = .white
        let separator = UIView(frame: CGRect(center: CGPoint(x: infoHeaderView.center.x, y: 30), size: CGSize(width: frame.width - 30, height: 0.5)))
        separator.backgroundColor = UIColor(white: 224/255, alpha: 1)
        infoHeaderView.addSubview(separator)
        
        self.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.dataSource = self
        self.delegate = self
        self.alwaysBounceVertical = false
        
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//        blurEffectView.layer.cornerRadius = 8
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.addSubview(blurEffectView)
        
        // Mark: Indicator
        let indicatorView = UIImageView(frame: CGRect(x: frame.width/2 - 30, y: 5, width: 0, height: 0))
        indicatorView.image = UIImage(named: "Indicator")
        infoHeaderView.addSubview(indicatorView)
        indicatorView.sizeToFit()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = dequeueReusableCell(withIdentifier: cellIdentifier) as? EventCell {
            cell.parentVC = self.parentVC
            cell.updateViews(events[indexPath.row])
            
            return cell
        } else {
            return EventCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return infoHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class ShadowView: UIView {
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    var shadowLayer: MDCShadowLayer {
        return self.layer as! MDCShadowLayer
    }
    
    func setElevation(points: CGFloat) {
        self.shadowLayer.elevation = ShadowElevation(rawValue: points)
    }
}

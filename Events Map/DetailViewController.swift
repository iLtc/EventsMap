//
//  DetailViewController.swift
//  Events Map
//
//  Created by uics3 on 11/7/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIToolbarDelegate {
    
    var event: Event = Event()
    var scroll: UIScrollView = UIScrollView()
    private var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = event.title
        self.navigationItem.backBarButtonItem?.title = "Map"
        // iOS 11.0 largeTitle layout
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = UIColor(red: 238/255.0, green: 242/255.0, blue: 245/255.0, alpha: 1)
        setUI()
        // Do any additional setup after loading the view.
        toolBar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.size.height - 44, width: self.view.bounds.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: view.bounds.width/2, y: view.bounds.height-20.0)
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.blue
        toolBar.backgroundColor = UIColor.white
        
        let starBtn: UIBarButtonItem = UIBarButtonItem(title: "✩", style: .done, target: self, action: nil)
        let calendarBtn: UIBarButtonItem = UIBarButtonItem(title: "📅", style: .plain, target: self, action: nil)
        let navigationBtn: UIBarButtonItem = UIBarButtonItem(title: "navi" , style: .plain, target: self, action: nil)
        let shareBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.items = [space, starBtn, space, calendarBtn, space, navigationBtn, space, shareBtn, space]
        view.addSubview(toolBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func share(_ sender: Any) {
        let text = "Check out this event."
        let dataToShare = [ text ]
        let activityViewController = UIActivityViewController(
            activityItems: dataToShare,
            applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func setUI() {
        scroll = UIScrollView(frame: view.bounds)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.4))
        
        imageView.downloadedFrom(url: URL(string: event.photos[0])!)
        
        let textLabel = UILabel(frame: CGRect(x: view.frame.width * 0.1, y: view.frame.height * 0.5, width: view.frame.width * 0.8, height: view.frame.height))
        textLabel.text = event.description
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        scroll.addSubview(imageView)
        scroll.addSubview(textLabel)
        scroll.contentSize = CGSize(width: imageView.bounds.width, height: imageView.bounds.height + textLabel.bounds.height + 100)
        view.addSubview(scroll)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

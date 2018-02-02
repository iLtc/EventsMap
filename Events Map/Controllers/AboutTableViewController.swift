//
//  AboutTableViewController.swift
//  Events Map
//
//  Created by Alan Luo on 12/4/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    let cellTitle = ["Icons", "Licenses"]
    var bottomPadding: CGFloat = 0
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            bottomPadding = view.safeAreaInsets.bottom
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.alpha = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "About and Help"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "About"
        } else {
            return "Help"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
                cell.textLabel?.text = "Our Website"
                return cell
            case 1:
                let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
                cell.textLabel?.text = "Developers"
                return cell
            case 2:
                let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
                cell.textLabel?.text = "Privacy Policy"
                return cell
            default:
                fatalError("Error row")
            }
        } else {
            let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
            cell.textLabel?.text = cellTitle[indexPath.row]
            
            return cell
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                openURL(url: URL(string: "https://events.iltcapp.net/")!, title: "Hawk Events")
            case 1:
                openURL(url: URL(string: "https://events.iltcapp.net/#contributors")!, title: "Developers")
            case 2:
                openURL(url: URL(string: "https://events.iltcapp.net/privacy/")!, title: "Privacy Policy")
            default:
                fatalError("Error row")
            }
        } else {
            if indexPath.row == 0 {
                let vc = IconViewController(nibName: nil, bundle: nil)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = LicencesViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func openURL(url: URL, title: String) {
        let webViewController = WebViewController()
        webViewController.url = url
        webViewController.bottomPadding = self.bottomPadding
        webViewController.webTitle = title
//        navigationController?.pushViewController(webViewController, animated: true)
        self.show(webViewController, sender: nil)
    }
    
}

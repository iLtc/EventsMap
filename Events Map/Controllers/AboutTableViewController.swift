//
//  AboutTableViewController.swift
//  Events Map
//
//  Created by Alan Luo on 12/4/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Developer"
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
                cell.textLabel?.text = "Tiancheng Luo"
                return cell
            case 1:
                let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
                cell.textLabel?.text = "Yizhen Chen"
                return cell
            case 2:
                let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
                cell.textLabel?.text = "Zhenming Wang"
                return cell
            default:
                fatalError("Error row")
            }
        } else {
            let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
            cell.textLabel?.text = "Icons"
            return cell
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                openURL(url: URL(string: "https://iLtc.io")!, title: "Yizhen Chen")
            case 1:
                openURL(url: URL(string: "https://homepage.divms.uiowa.edu/~ychen261/")!, title: "Yizhen Chen")
            case 2:
                openURL(url: URL(string: "https://homepage.divms.uiowa.edu/~zwang191/")!, title: "Zhenming Wang")
            default:
                fatalError("Error row")
            }
        } else {
            let vc = IconViewController(nibName: nil, bundle: nil)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func openURL(url: URL, title: String) {
        let webViewController = WebViewController()
        webViewController.url = url
        webViewController.webTitle = title
        present(webViewController, animated: true)
    }
    
}

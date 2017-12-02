//
//  FilterViewController.swift
//  Events Map
//
//  Created by ricardo on 11/22/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import GoogleMaps

class FilterViewController: UITableViewController {
    
    let manger = CLLocationManager()
    let sort: [String] = ["Sort"]
    let filter: [String] = ["Category", "Source"]
    let cellReuseIdentifier = "cell"
    var category:[String] = []
    var distance:[Int] = []
    var events:[Event] = []
    var currentLocation: CLLocation = CLLocation()
    
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manger.stopUpdatingLocation()
        currentLocation = locations.last!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.sort.count
        }
        else {
            return self.filter.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
            cell.textLabel?.text = self.sort[indexPath.row]
            return cell
        }
        else {
            let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
            cell.textLabel?.text = self.filter[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if indexPath.section == 0 {
            let destination = SortViewController(style: .grouped)
            self.navigationController?.pushViewController(destination, animated: true)
        }
        if indexPath.section == 1 {
            switch row {
            case 0:
                let destination = CategoryViewController(style: .grouped)
                self.navigationController?.pushViewController(destination, animated: true)
            case 1:
                let destination = SourceViewController(style: .grouped)
                self.navigationController?.pushViewController(destination, animated: true)
            default:
                print("error")
            }
        }
    }
}

//
//  SettingsViewController.swift
//  Events Map
//
//  Created by ricardo on 11/23/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    var category:[String] = []
    var events:[Event] = []
    var selectedCategory:[String] = []
    var temp:[String] = []
    
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        EventService.instance.getAllCategories() { category in
            self.category = category
            self.tableView.reloadData()
        }
        if EventService.instance.defaults.array(forKey: "CurrentCategories") != nil {
            selectedCategory = EventService.instance.defaults.array(forKey: "CurrentCategories") as! [String]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Category"
        self.tableView.allowsMultipleSelection = true
        let rightButtonItem = UIBarButtonItem.init(
            title: "Select All",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        if sender.title == "Select All" {
            EventService.instance.setCategories(categories: category)
            for cell in tableView.visibleCells {
                cell.accessoryType = .checkmark
            }
            sender.title = "Empty"
        }
        else {
            sender.title = "Select All"
            let empty:[String] = []
            EventService.instance.setCategories(categories: empty)
            for cell in tableView.visibleCells {
                cell.accessoryType = .none
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = category[indexPath.row]
        if selectedCategory.contains((cell.textLabel?.text)!) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        cell.selectionStyle = .default // to prevent cells from being "highlighted"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            for c in selectedCategory {
                if c != tableView.cellForRow(at: indexPath)?.textLabel?.text {
                    temp.append(c)
                }
            }
            selectedCategory = temp
            temp = []
            EventService.instance.setCategories(categories: selectedCategory)
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedCategory.append((tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
            EventService.instance.setCategories(categories: selectedCategory)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        for c in selectedCategory {
            if c != tableView.cellForRow(at: indexPath)?.textLabel?.text {
                temp.append(c)
            }
        }
        selectedCategory = temp
        temp = []
        EventService.instance.setCategories(categories: selectedCategory)
    }
}

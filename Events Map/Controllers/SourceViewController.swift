//
//  SettingsViewController.swift
//  Events Map
//
//  Created by ricardo on 11/23/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class SourceViewController: UITableViewController {
    
    var source:[String] = []
    var selectedSource:[String] = []
    var temp:[String] = []
    
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        EventService.instance.getAllSources() { source in
            self.source = source
            self.tableView.reloadData()
        }
        if EventService.instance.defaults.array(forKey: "CurrentSources") != nil {
            selectedSource = EventService.instance.defaults.array(forKey: "CurrentSources") as! [String]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sources"
        self.tableView.allowsMultipleSelection = true
        let rightButtonItem = UIBarButtonItem.init(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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
        return source.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = source[indexPath.row]
        if selectedSource.contains((cell.textLabel?.text)!) {
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
            for c in selectedSource {
                if c != tableView.cellForRow(at: indexPath)?.textLabel?.text {
                    temp.append(c)
                }
            }
            selectedSource = temp
            temp = []
            EventService.instance.setSources(sources: selectedSource)
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedSource.append((tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
            EventService.instance.setSources(sources: selectedSource)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        for c in selectedSource {
            if c != tableView.cellForRow(at: indexPath)?.textLabel?.text {
                temp.append(c)
            }
        }
        selectedSource = temp
        temp = []
        EventService.instance.setSources(sources: selectedSource)
    }
}

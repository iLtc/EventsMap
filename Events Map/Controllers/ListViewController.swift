//
//  ListViewController.swift
//  Events Map
//
//  Created by Alan Luo on 11/24/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MaterialComponents

class ListViewController: UITableViewController {
    
    private var events: [Event] = []
    
    private let identifier = "ListView"
    
    var loadingView: UIView?
    
    var headerView: UIView = UIView()
    var addBtn = UIButton()
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        self.tableView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        self.tableView.dataSource = self
        // self.tableView.separatorStyle = .none
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 75)
        headerView.backgroundColor = .clear
        
        addBtn = {
            let button = UIButton(frame: CGRect(x: view.frame.maxX/2 + 5, y: 15, width: 44, height: 44))
            button.setImage(UIImage(named: "add-white"), for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
            button.clipsToBounds = true
            button.layer.cornerRadius = button.frame.height/2
            button.addTarget(self, action: #selector(addEvent(_:)), for: .touchUpInside)
            return button
        }()
        
        let reloadBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: view.frame.maxX/2 - 49, y: 15, width: 44, height: 44))
            button.setImage(UIImage(named: "refresh"), for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .white
            button.clipsToBounds = true
            button.layer.cornerRadius = button.frame.height/2
            button.addTarget(self, action: #selector(reload), for: .touchUpInside)
            return button
        }()
        
        headerView.addSubview(addBtn)
        headerView.addSubview(reloadBtn)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    @objc func reload() {
        loadingView = activityIndicator("Loading......")
        
        EventService.instance.getEvents() { events in
            if let loadingView = self.loadingView {
                loadingView.removeFromSuperview()
            }
            
            if events.count == 0 {
                let alert: MDCAlertController = MDCAlertController(title: "No Event", message: "There is no event now or base on your filter.")
                alert.addAction(MDCAlertAction(title: "OK", handler: nil))
                
                self.present(alert, animated: true)
            }
            
            self.events = events
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: view)
            if !addBtn.frame.contains(location) {
                resetAddBtn(addBtn)
            }
        }
        sender.cancelsTouchesInView = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != addBtn {
            resetAddBtn(addBtn)
            print("Outside")
        }
        print("Haha")
    }
    
    func resetAddBtn(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            sender.frame.size = CGSize(width: 44, height: 44)
            sender.setImage(UIImage(named: "add-white"), for: .normal)
            sender.setTitle("", for: .normal)
            sender.tag = 0
        }, completion: nil)
    }
    
    @objc func addEvent(_ sender: UIButton) {
        if sender.tag == 0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                sender.frame.size = CGSize(width: 150, height: 44)
                sender.setImage(UIImage(), for: .normal)
                sender.setTitle("Add New Event", for: .normal)
                sender.tag = 1
            }, completion: nil)
        } else if sender.tag == 1 {
            let vc = AddEventTableViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.frame.height
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ListViewCell {
            
            cell.updateViews(events[indexPath.row])
            
            return cell
        } else {
            return ListViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let vc = CardDetailViewController()
        vc.event = event
        vc.headerContentView.downloadedFrom(link: event.photos[0])
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

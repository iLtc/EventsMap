//
//  SettingsViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/20/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    let notiSwitch: UISwitch = UISwitch()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notiSwitch.setOn((appDelegate?.isNotify)!, animated: true)
        
        notiSwitch.addTarget(self, action: #selector(switchIsChanged(_:)), for: .valueChanged)
        self.navigationItem.title = "Settings"
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.accessoryView = notiSwitch
                cell.selectionStyle = .none
                cell.textLabel?.text = "Notifications"
                return cell
            case 1:
                let cell = UITableViewCell()
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "Linked Accounts"
                return cell
            default:
                fatalError("Error row")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "About"
                return cell
            case 1:
                let cell = UITableViewCell()
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "Feedback"
                return cell
            default:
                fatalError("Error row")
            }
        default:
            fatalError("Error section")
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    @objc func switchIsChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            // Add notifications to all liked events
//            appDelegate?.scheduleNotification(Event())
            
        } else {
            appDelegate?.disableNotification()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            default:
                fatalError("Error row")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = AboutTableViewController(style: .grouped)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                sendEmail()
            default:
                fatalError("Error row")
            }
        default:
            fatalError("Error section")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func sendEmail() {
        let emailTitle = "Events Map Feedback"
        let messageBody = "Feature request or bug report?"
        let toRecipents = ["tiancheng-luo@uiowa.edu", "yizhen-chen-1@uiowa.edu", "zhenming-wang@uiowa.edu"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        }
        self.dismiss(animated: true, completion: nil)
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

//
//  UserTableViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/19/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import FacebookLogin
import GoogleSignIn
import GGLCore

class UserTableViewController: UITableViewController,GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error ?? "some error")
            return
        }
    }
    
    
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserImage.layer.cornerRadius = UserImage.bounds.height/2
        UserImage.contentMode = .scaleAspectFit
        UserImage.layer.masksToBounds = true
                
        self.navigationItem.title = "User"
        self.navigationController?.navigationBar.topItem?.title = "Map"
        
        self.navigationItem.largeTitleDisplayMode = .always
        
//        var error: NSError?
//        GGLContext.sharedInstance().configureWithError(&error)
//        if error != nil {
//            print(error ?? "some error")
//            return
//        }
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
//        let googleSignInButton = GIDSignInButton()
//        googleSignInButton.center = view.center
//        view.addSubview(googleSignInButton)

        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @objc func buttonAction(sender: UIButton!) {
        print("haha")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            if let _ = UserService.instance.getCurrentUser() {
                cell.textLabel?.text = "Logout"
            }else{
                cell.textLabel?.text = "Login / Sign Up"
            }
            return cell
        case 1:
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Your Events"
            return cell
        case 2:
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Settings"
            return cell
        default:
            fatalError("Error section")
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let _ = UserService.instance.getCurrentUser() {
                UserService.instance.logout()
                LoginManager().logOut()
                GIDSignIn.sharedInstance().signOut()
                UserImage.image = UIImage(named: "Contacts")
                UserName.text = "No User"
                self.tableView.reloadData()
            }else {
                popLoginView()
            }
            
        case 1:
            let vc = EventsListViewController()
            show(vc, sender: nil)
            
        case 2:
            // Push SettingsVC
            let vc = SettingsViewController(style: .grouped)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            fatalError("Error section")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func popLoginView() {
        let loginView = LoginView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 280))
        loginView.parentImg = UserImage
        loginView.parentName = UserName
        loginView.parentTableView = self.tableView
        loginView.parentVC = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            if let user = UserService.instance.getCurrentUser() {
                let image = UIImage.gif(url: user.picURL)
                self.UserImage.image = image?.resizeImage(targetSize: self.UserImage.frame.size)
                self.UserName.text = user.name
            }
        }
        
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

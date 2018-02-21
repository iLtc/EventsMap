//
//  LoginView.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/20/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import GoogleSignIn
import GGLCore
import MaterialComponents

class LoginView: UIView, GIDSignInUIDelegate {
    
    let popoverMenu = PopOverView()
    public var parentImg: UIImageView?
    public var parentName: UILabel?
    public var parentTableView: UITableView?
    public var parentVC: UIViewController?
    
    var loadingView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        
        self.backgroundColor = .clear
        self.addSubview(blurEffectView)
        
        let titleLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 70, width: frame.width, height: 30))
            label.alpha = 0
            label.text = "Login"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 25)
            return label
        }()
        
        self.addSubview(titleLabel)
        UILabel.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            titleLabel.frame.origin.y = 20
            titleLabel.alpha = 1
        }, completion: nil)
        
        // Facebook button
        let facebookBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: 10, y: titleLabel.frame.height + 90, width: frame.width - 20, height: 40))
            let imageView = UIImageView(frame: CGRect(x: 50, y: 6, width: 29, height: 29))
            imageView.image = UIImage(named: "Facebook")
            button.addSubview(imageView)
            let label = UILabel()
            label.text = "Login with Facebook"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.sizeToFit()
            imageView.frame.origin.x = (button.bounds.width - imageView.bounds.width - label.bounds.width - 10) / 2
            label.frame.origin = CGPoint(x: imageView.frame.maxX + 10, y: 8)
            button.addSubview(label)
            button.alpha = 0
            button.layer.cornerRadius = 4
            button.layer.shadowRadius = 4
            button.backgroundColor = UIColor(red:0.26, green:0.40, blue:0.70, alpha:1.0)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(fbLogin(_:)), for: .touchUpInside)
            button.titleLabel?.textColor = .white
            button.clipsToBounds = true
            button.setBackgroundColor(color: UIColor(red:0.43, green:0.52, blue:0.71, alpha:1.0), forState: .highlighted)
            return button
        }()
        
        addSubview(facebookBtn)
        
        UIButton.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            facebookBtn.frame.origin.y = titleLabel.frame.height + 40
            facebookBtn.alpha = 1
        }, completion: nil)
        
        // Google button
        let googleBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: 10, y: facebookBtn.frame.maxY + 90, width: frame.width - 20, height: 40))
            let imageView = UIImageView(frame: CGRect(x: 50, y: 6, width: 29, height: 29))
            imageView.image = UIImage(named: "Google")
            button.addSubview(imageView)
            let label = UILabel()
            label.text = "Login with Google"
            label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.sizeToFit()
            imageView.frame.origin.x = (button.bounds.width - imageView.bounds.width - label.bounds.width - 10) / 2
            label.frame.origin = CGPoint(x: imageView.frame.maxX + 10, y: 8)
            button.addSubview(label)
            button.alpha = 0
            button.layer.cornerRadius = 4
            button.layer.shadowRadius = 4
            button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(gLogin(_:)), for: .touchUpInside)
            button.titleLabel?.textColor = .white
            button.clipsToBounds = true
            button.setBackgroundColor(color: UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1), forState: .highlighted)
            return button
        }()
        
        addSubview(googleBtn)
        
        UIButton.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut, animations: {
            googleBtn.frame.origin.y = facebookBtn.frame.maxY + 20
            googleBtn.alpha = 1
        }, completion: nil)
        
        // Demo user button
        /*let demoBtn: UIButton = {
            let button = UIButton(frame: CGRect(x: 10, y: googleBtn.frame.maxY + 70, width: frame.width - 20, height: 40))
            button.alpha = 0
            button.layer.cornerRadius = 4
            button.layer.shadowRadius = 4
            button.backgroundColor = UIColor(red:0.26, green:0.40, blue:0.70, alpha:0.5)
            button.setTitle("Demo User Login", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.isUserInteractionEnabled = true
            button.titleLabel?.textColor = .white
            button.addTarget(self, action: #selector(demoLogin), for: .touchUpInside)
            
            return button
        }()
        
        self.addSubview(demoBtn)
        
        UIButton.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseOut, animations: {
            demoBtn.frame.origin.y = googleBtn.frame.maxY + 20
            demoBtn.alpha = 1
        }, completion: nil)*/
        
        self.sizeToFit()
        blurEffectView.sizeToFit()
        popoverMenu.presentView(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.parentVC?.present(viewController, animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.parentVC?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Facebook Login
    @objc func fbLogin(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile], viewController: nil, completion: { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, _):
                print("Logged in!")
                self.getFBUserData()
            }
        })
        popoverMenu.dismiss()
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    let pid = dict["id"] as! String
                    let name = dict["name"] as! String
                    let data = dict["picture"]!["data"] as! [String: AnyObject]
                    let picURL = data["url"] as! String
                    
                    self.loadingView = self.parentVC?.activityIndicator()
                    
                    UserService.instance.addUser(pid: pid, name: name, picURL: picURL, platform:.facebook) { code, msg, user in
                        if let loadingView = self.loadingView {
                            loadingView.removeFromSuperview()
                        }
                        
                        if code != "200" {
                            let alert: MDCAlertController = MDCAlertController(title: "Error", message: msg)
                            alert.addAction(MDCAlertAction(title: "OK", handler: nil))
                            
                            self.parentVC?.present(alert, animated: true)
                            return
                        }
                        
                        let user = user!
                        
                        let image = UIImage.gif(url: user.picURL)!
                        self.parentImg?.image = image.resizeImage(targetSize: (self.parentImg?.frame.size)!)
                        self.parentName?.text = user.name
                        self.parentTableView?.reloadData()
                    }
                }
            })
        }
    }
    
    // Mark: - Google Login
    
    @objc func gLogin(_ sender: UIButton) {
        // Google button
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil {
            print(error ?? "some error")
            return
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if let parentVC = parentVC as? UserTableViewController {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.userTableViewController = parentVC
        }
        
        GIDSignIn.sharedInstance().signIn()
        
        popoverMenu.dismiss()
    }
    
    // MARK: - Demo Login
    @objc func demoLogin() {
        loadingView = parentVC?.activityIndicator()
        
        UserService.instance.getDemoUser() {code, msg, user in
            if let loadingView = self.loadingView {
                loadingView.removeFromSuperview()
            }
            
            if code != "200" {
                let alert: MDCAlertController = MDCAlertController(title: "Error", message: msg)
                alert.addAction(MDCAlertAction(title: "OK", handler: nil))
                
                self.parentVC?.present(alert, animated: true)
                return
            }
            
            let user = user!
            
            let image = UIImage.gif(url: user.picURL)!
            self.parentImg?.image = image.resizeImage(targetSize: (self.parentImg?.frame.size)!)
            self.parentName?.text = user.name
            self.parentTableView?.reloadData()
            
            self.popoverMenu.dismiss()
        }
    }
    
    // MARK: - Google Login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print(user)
        if error != nil {
            print(error ?? "some error")
            return
        }
        print(123)
    }
}

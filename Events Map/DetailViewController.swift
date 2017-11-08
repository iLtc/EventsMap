//
//  DetailViewController.swift
//  Events Map
//
//  Created by uics3 on 11/7/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 238/255.0, green: 242/255.0, blue: 245/255.0, alpha: 1)
        setUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.4))
        imageView.image = nil
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
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

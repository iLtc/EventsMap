//
//  AddEventTableViewController.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/30/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import Material
import MaterialComponents

class AddEventTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Parameters
    var address: String?
    var coordinate: [String: Double]?
    
    var imageHasPicked = false
    
    // Input Views
    var imageView = UIImageView(frame: CGRect(x: 16, y: 16, width: 120, height: 80))
    var eventTitle = TextField()
    var addressField = TextField()
    var descripInput = MDCMultilineTextField()
    var startDateInput: DatePick = DatePick()
    var endDateInput: DatePick = DatePick()
    
    // Custom Cells
    var titleCell = UITableViewCell()
    var addressCell = UITableViewCell()
    var startDateCell = UITableViewCell()
    var endDateCell = UITableViewCell()
    var descripCell = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Event"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveBtnPressed))
        
        self.navigationItem.largeTitleDisplayMode = .always
        
        setCellUI()
        
        // MARK: - Set delegate
        eventTitle.delegate = self
        addressField.delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // MARK: Override the return on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventTitle.resignFirstResponder()
        addressField.resignFirstResponder()
        return true
    }
    
    func setCellUI() {
        // Mark: - titleCell
        imageView.image = UIImage(named: "Add")
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 237/255, alpha: 1)
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto(_:))))
        imageView.isUserInteractionEnabled = true
        eventTitle.placeholder = "Title"
        eventTitle.font = UIFont.systemFont(ofSize: 30)
        eventTitle.sizeToFit()
        eventTitle.frame = CGRect(x: imageView.frame.maxX + 16, y: imageView.frame.maxY - eventTitle.bounds.height, width: view.bounds.width - imageView.frame.width - 16, height: eventTitle.bounds.height)
        eventTitle.clearButtonMode = .whileEditing
        titleCell.addSubview(imageView)
        titleCell.addSubview(eventTitle)
        titleCell.selectionStyle = .none
        
        
        // Mark: - addressCell
        addressField.placeholder = "Address"
        addressField.font = UIFont.systemFont(ofSize: 20)
        if let address = self.address {
            addressField.text = address
        }
        addressField.sizeToFit()
        addressField.frame = CGRect(x: 16, y: 24, width: view.frame.width, height: addressField.bounds.height)
        addressField.clearButtonMode = .whileEditing
        
        addressCell.addSubview(addressField)
        addressCell.selectionStyle = .none
        
        
        // Mark: - startDateCell
        startDateInput.placeholder = "Start Date"
        startDateInput.font = UIFont.systemFont(ofSize: 20)
        startDateInput.sizeToFit()
        startDateInput.frame = CGRect(x: 16, y: 24, width: view.frame.width, height: startDateInput.bounds.height)
        startDateCell.addSubview(startDateInput)
        startDateCell.selectionStyle = .none
        
        
        // Mark: - endDateCell
        endDateInput.placeholder = "End Date"
        endDateInput.font = UIFont.systemFont(ofSize: 20)
        endDateInput.sizeToFit()
        endDateInput.frame = CGRect(x: 16, y: 24, width: view.frame.width, height: endDateInput.bounds.height)
        endDateCell.addSubview(endDateInput)
        endDateCell.selectionStyle = .none
        
        
        // Mark: - descripCell
        descripInput.frame = CGRect(x: 16, y: 16, width: view.frame.width, height: 30)
        descripInput.font = UIFont.systemFont(ofSize: 20)
        descripInput.placeholder = "Description (Optional)"
        descripInput.underline?.color = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
//        descripInput.delegate = self
//        let textFieldControllerFloating = MDCTextInputControllerDefault(textInput: descripInput) // Hold on as a property
//        textFieldControllerFloating.isFloatingEnabled = false
//        textFieldControllerFloating.normalColor = UIColor(red: 147/255, green: 147/255, blue: 147/255, alpha: 1)
        descripCell.addSubview(descripInput)
        descripCell.selectionStyle = .none
        
    }
    
    
    @objc func pickPhoto(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default, handler: { [unowned self] _ in
                self.showImagePicker(withSourceType: .camera)
            })
            alertController.addAction(takePhotoAction)
        }
        
        let chooseFromLibraryAction = UIAlertAction(title: NSLocalizedString("Choose From Library", comment: ""), style: .default, handler: { [unowned self] _ in
            self.showImagePicker(withSourceType: .photoLibrary)
        })
        alertController.addAction(chooseFromLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showImagePicker(withSourceType source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        imageHasPicked = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnPressed() {
        // TODO: Check if form has been filled completed
        
        EventService.instance.uploadImage(imageView.image!) { imageURL in
            let event = Event(id: "default", title: self.eventTitle.text!, url: "default", date: self.startDateInput.date, endDate: self.endDateInput.date, isAllDay: false, location: self.addressField.text!, description: self.descripInput.text!)
            
            event.photos.append(imageURL)
            
            if let coordinate = self.coordinate {
                event.geo["latitude"] = String(describing: coordinate["la"]!)
                event.geo["longitude"] = String(describing: coordinate["lo"]!)
            }
            
            event.categories.append("Events Map")
            
            event.save() { event in
                let vc = DetailViewController()
                vc.event = event
                self.navigationController?.pushViewController(vc, animated: true)
            }
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return titleCell
        case 1:
            return addressCell
        case 2:
            return startDateCell
        case 3:
            return endDateCell
        case 4:
            return descripCell
        default:
            fatalError("Unknown number of rows")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return imageView.frame.height + 32
        case 1:
            return addressField.bounds.height + 40
        case 2:
            return startDateInput.bounds.height + 40
        case 3:
            return endDateInput.bounds.height + 40
        case 4:
            return descripInput.bounds.height + 32
        default:
            fatalError("Unknown number of rows")
        }
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

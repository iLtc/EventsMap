//
//  AddEventViewController.swift
//  Events Map
//
//  Created by Alan Luo on 11/14/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    var address: String?
    var coordinate: [String: Double]?
    
    var imageHasPicked = false
    
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var descripInput: UITextView!
    @IBOutlet weak var startDateInput: DatePick!
    @IBOutlet weak var endDateInput: DatePick!
    
    let addEndDate = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Event"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveBtnPressed))
        
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.edgesForExtendedLayout = []

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        addEndDate.frame = endDateInput.frame
        addEndDate.backgroundColor = UIColor.lightGray
        addEndDate.titleLabel?.textColor = UIColor.black
        addEndDate.alpha = 1
        addEndDate.titleLabel?.text = "Add End Date"
        addEndDate.addTarget(self, action: #selector(showEndDate(_:)), for: .touchUpInside)
        view.bringSubview(toFront: addEndDate)
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = 7
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto(_:))))
        imageView.isUserInteractionEnabled = true

        if let address = self.address {
            addressField.text = address
        }
        
        // MARK: - Set delegate
        eventTitle.delegate = self
        addressField.delegate = self
        descripInput.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Override the return on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventTitle.resignFirstResponder()
        addressField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descripInput.resignFirstResponder()
            return false
        }
        return true
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("BeginEditing")
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame =  (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.topContraint?.constant = 0.0
            } else {
                self.topContraint?.constant = (endFrame?.size.height)!*(-1) 
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @objc func showEndDate(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            sender.alpha = 0
            self.endDateInput.alpha = 1
        }
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
            let event = Event(id: "default", title: self.eventTitle.text!, url: "default", date: self.startDateInput.date, endDate: self.endDateInput.date, isAllDay: false, location: self.addressField.text!, description: self.descripInput.text)
            
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
}

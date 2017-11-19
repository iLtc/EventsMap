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
    var pickedImage: UIImage?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var descripInput: UITextView!
    @IBOutlet weak var endDateInput: DatePick!
    let addEndDate = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Event"
        self.navigationController?.navigationBar.topItem?.title = "Map"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()

        self.navigationItem.rightBarButtonItem?.title = "Save"
        
        self.navigationItem.largeTitleDisplayMode = .always
        
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

        addressField.text = address
        
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        var pointInSuperView:CGPoint = (textView.superview?.convert(textView.frame.origin, to: view))!
//        var contentOffset:CGPoint =

        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("BeginEditing")
        let range = NSMakeRange(textView.text.count - 1, 0)
        textView.scrollRangeToVisible(range)
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
        
        pickedImage = image
        
        imageView.image = pickedImage
        imageView.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

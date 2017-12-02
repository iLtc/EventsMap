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
import GooglePlaces

class AddEventTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Declare variables to hold address form values.
    var street_number: String = ""
    var route: String = ""
    var neighborhood: String = ""
    var locality: String = ""
    var administrative_area_level_1: String = ""
    var country: String = ""
    var postal_code: String = ""
    var postal_code_suffix: String = ""
    
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
    var searchBtn = MDCFloatingButton()
    
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
        if let window = UIApplication.shared.keyWindow {
            searchBtn = {
                let button = MDCFloatingButton(shape: MDCFloatingButtonShape.default)
                button.alpha = 0
                button.frame = CGRect(x: window.frame.maxX - 72, y: window.frame.maxY - 72, width: 56, height: 56)
                button.setImage(UIImage(named: "Search"), for: .normal)
                button.addTarget(self, action: #selector(searchAddress), for: .touchUpInside)
                button.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
                
                return button
            }()
            let searchInkController = MDCInkTouchController(view: searchBtn)
            searchInkController.addInkView()
            window.addSubview(searchBtn)
        
        }
        
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
    }
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func getGeocoder(_ address: String) -> CLLocationCoordinate2D {
        let geoCoder = CLGeocoder()
        var coordinate = CLLocationCoordinate2D()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            coordinate = location.coordinate
            // Use your location
        }
        return coordinate
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if let window = UIApplication.shared.keyWindow {
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                    self.searchBtn.frame.origin = CGPoint(x: window.frame.maxX - 72, y: window.frame.maxY - 72 - keyboardHeight)
                }, completion: nil)
            }
            
            
        }
    }
    
    
    @objc func searchAddress() {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        let transition = MDCMaskedTransition(sourceView: searchBtn)
        transition.calculateFrameOfPresentedView = { info in
            let size = CGSize(width: self.view.bounds.width - 32, height: self.view.bounds.height - 100)
            return CGRect(x: (info.containerView!.bounds.width - size.width) / 2,
                          y: (info.containerView!.bounds.height - size.height) / 2,
                          width: size.width,
                          height: size.height)
        }
        autocompleteController.transitionController.transition = transition
        present(autocompleteController, animated: true)
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.searchBtn.alpha = 1
                
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.searchBtn.alpha = 0
            }, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.searchBtn.alpha = 0
        }, completion: nil)
        
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
        eventTitle.frame = CGRect(x: imageView.frame.maxX + 16, y: imageView.frame.maxY - eventTitle.bounds.height, width: view.bounds.width - imageView.frame.width - 48, height: eventTitle.bounds.height)
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
        addressField.frame = CGRect(x: 16, y: 24, width: view.frame.width - 32, height: addressField.bounds.height)
        addressField.clearButtonMode = .whileEditing
        addressField.tag = 1
        addressCell.addSubview(addressField)
        addressCell.selectionStyle = .none
        
        
        // Mark: - startDateCell
        startDateInput.placeholder = "Start Date"
        startDateInput.font = UIFont.systemFont(ofSize: 20)
        startDateInput.sizeToFit()
        startDateInput.frame = CGRect(x: 16, y: 24, width: view.frame.width - 32, height: startDateInput.bounds.height)
        startDateCell.addSubview(startDateInput)
        startDateCell.selectionStyle = .none
        
        
        // Mark: - endDateCell
        endDateInput.placeholder = "End Date"
        endDateInput.font = UIFont.systemFont(ofSize: 20)
        endDateInput.sizeToFit()
        endDateInput.frame = CGRect(x: 16, y: 24, width: view.frame.width - 32, height: endDateInput.bounds.height)
        endDateCell.addSubview(endDateInput)
        endDateCell.selectionStyle = .none
        
        
        // Mark: - descripCell
        descripInput.frame = CGRect(x: 16, y: 16, width: view.frame.width - 32, height: 30)
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
            
            
            if let location = self.address {
                self.getCoordinate(addressString: location, completionHandler: { (coordinate, error) in
                    event.geo["latitude"] = String(coordinate.latitude)
                    event.geo["longitude"] = String(coordinate.longitude)
                    print(event.geo)
                })
            }
            
            
            event.categories.append("Events Map")
            
//            event.save() { event in
//                let vc = DetailViewController()
//                vc.event = event
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
        
    }
    
    // Populate the address form fields.
    func fillAddressForm() {
        addressField.text = street_number + " " + route + ", " + locality + ", " + administrative_area_level_1 + ", " + country
        address = street_number + " " + route + ", " + locality + ", " + administrative_area_level_1 + " " + postal_code
//        if postal_code_suffix != "" {
//            addressField.text += postal_code + "-" + postal_code_suffix
//        } else {
//            postal_code_field.text = postal_code
//        }
        
        // Clear values for next time.
        street_number = ""
        route = ""
        neighborhood = ""
        locality = ""
        administrative_area_level_1  = ""
        country = ""
        postal_code = ""
        postal_code_suffix = ""
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

extension AddEventTableViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    street_number = field.name
                case kGMSPlaceTypeRoute:
                    route = field.name
                case kGMSPlaceTypeNeighborhood:
                    neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry:
                    country = field.name
                case kGMSPlaceTypePostalCode:
                    postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        
        // Call custom function to populate the address form.
        fillAddressForm()
        
        // Close the autocomplete widget.
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

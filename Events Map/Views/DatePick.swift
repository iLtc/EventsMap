//
//  DatePick.swift
//  Events Map
//
//  Created by Yizhen Chen on 11/18/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import Material
class DatePick: TextField, UITextFieldDelegate {
    
    let datePicker = UIDatePicker()
    let toolbar = UIToolbar()
    var date = NSDate()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let fixed = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let clear = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearPressed))
        toolbar.setItems([done, fixed, clear], animated: true)
        
        
        self.inputAccessoryView = toolbar
        self.inputView = datePicker
            
        datePicker.datePickerMode = .dateAndTime

    }
    
    @objc func clearPressed() {
        date = NSDate()
        text = ""
        self.superview?.endEditing(true)
    }
    
    @objc func donePressed() {
        date = datePicker.date as NSDate
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd HH:mm"
        text = formatter.string(from: datePicker.date)
        self.superview?.endEditing(true)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

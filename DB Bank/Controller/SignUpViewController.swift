//
//  SignUpViewController.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/26/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController : SuperViewController {
    
    let customView = CustomView()
    let customButton = CustomButton()
    let customImage = ImageView()
    
    override func viewDidLoad() {
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar()
    }
  
    
    
    /*
     IB Outlets
*/
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var pinTextFeild: UITextField!
    @IBOutlet weak var verifyPinTextField: UITextField!
    
    var datePicker : UIDatePicker?
    var dateTextField = UITextField()
    var textFieldArray : [UITextField] = []
    var pinTextFieldArray : [UITextField] = []
    
    /*
     IB Button Action
     */
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let result = verifyTextFields(textFields: textFieldArray)
        if result {
            let validatePin = confirmPinInput(textField: pinTextFieldArray)
            if validatePin {
                SVProgressHUD.show()
                print("Fields Sucessfully Validated")
                
                //Set Up New User on firebase App
                Auth.auth().createUser(withEmail: emailTextField.text!, password: pinTextFeild.text!) { (user, error) in
                    
                    if error != nil {
                        print("Login unsuccessfull")
                        self.informationSent()
                        SVProgressHUD.dismiss()
                    } else {
                        print("\(String(describing: user)) Successfully logged in")
                        self.instantiateDashVC(identifier: self.goToDashboard)
                        
                    }
                }
                
                
            } else {
                pinMismatchAlert()
            }
        } else {
            missingFieldAlert()
        }
    }
    
    func setUpView () {
        dateTextField = dateOfBirthTextField
        datePicker(textField: dateOfBirthTextField)
        pinTextFeild.keyboardType = .numberPad
        verifyPinTextField.keyboardType = .numberPad
        SVProgressHUD.dismiss()
        textFieldArray = [usernameTextField, emailTextField, dateOfBirthTextField, pinTextFeild, verifyPinTextField]
        pinTextFieldArray = [pinTextFeild, verifyPinTextField]
        customButton.customizeButton(button: submitButton)
        customImage.roundedImage(imageView: photoImageView)
    }
    
    func datePicker (textField : UITextField) {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        textField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(super.dateChanged(datePicker: textField: dateTextField:)), for: .valueChanged)
        datePicker?.backgroundColor = .clear
    }
}



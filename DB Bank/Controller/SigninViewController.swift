//
//  SigninViewController.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/27/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import GoogleSignIn

class SigninViewController : SuperViewController {
    
    let customButtom = CustomButton()
    
    override func viewDidLoad() {
        setUp()
    }
    
    /*
     IB Outlets
*/
    @IBOutlet weak var usernametextField: UITextField!
    @IBOutlet weak var pintTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var recoverPinButton: UIView!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var textFieldArray : [UITextField] = []
    
    /*
     IB Actions
     */
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let result = verifyTextFields(textFields: textFieldArray)
        if result {
            SVProgressHUD.show()
            print("Fields Sucessfully Validated")
            Auth.auth().signIn(withEmail: usernametextField.text!, password: pintTextField.text!) { (user, error) in
                
                if error != nil {
                    print("Failed Sign In Attempt: \(error?.localizedDescription ?? "Could not validate user details")")
                    self.failedSignInAlert()
                    SVProgressHUD.dismiss()
                } else {
                    print("\(String(describing: user)) Successfully logged in")
                    self.instantiateDashVC(identifier: self.goToDashboard)
                    
                }
            }
            
        } else {
            missingFieldAlert()
        }
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: goToCreateAccount, sender: self)
    }
    
    @IBAction func recoverPinButtonPressed(_ sender: UIButton) {
       
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar()
    
    }
    
    func setUp () {
        pintTextField.keyboardType = .numberPad
        SVProgressHUD.dismiss()
        customButtom.customizeButton(button: submitButton)
        textFieldArray = [usernametextField, pintTextField]
    }
    
}

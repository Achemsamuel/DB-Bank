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
     var count = 0
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if (pintTextField.text!.isEmpty || pintTextField.text!.count < 6) {
            failedSignInAlert()
        } else {
            
            let result = verifyTextFields(textFields: textFieldArray)
            if result {
                SVProgressHUD.show()
                print("Fields Sucessfully Validated")
                Auth.auth().signIn(withEmail: usernametextField.text!, password: pintTextField.text!) { (user, error) in
                    
                    if error != nil {
                        print("Failed Sign In Attempt: \(error?.localizedDescription ?? "Could not validate user details")")
                        let wrongPinError = "The password is invalid or the user does not have a password."
                        
                        if (error?.localizedDescription == wrongPinError) {
                            self.count += 1
                            print(self.count)
                            
                            switch self.count {
                            case 1:
                                self.wrongPasswordAlert(t: 2, tr: "tries")
                            case 2:
                                self.wrongPasswordAlert(t: 1, tr: "try")
                            case 3:
                                self.blockedPasswordAlert()
                            //self.blockUser(email: self.usernametextField.text!)
                            default :
                                print("default")
                            }
                        }
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
        
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: goToCreateAccount, sender: self)
    }
    
    @IBAction func recoverPinButtonPressed(_ sender: UIButton) {
       cannotChangePinAlert()
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

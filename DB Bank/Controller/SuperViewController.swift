//
//  ViewController.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/26/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import SVProgressHUD

class SuperViewController: UIViewController, GIDSignInDelegate {
    
  //Segue Identifiers
    let goToCreateAccount = "createAccount"
    let goToSignin = "goToSignin"
    let goToRecoverPin = "recoverPin"
    let goToDashboard = "dashboard"
    

    override func viewDidLoad() {
        super.viewDidLoad()
            doSetUp()
        }
    
    func doSetUp () {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    /*
     Mark:Navigation Bar Set up
*/
    func hideNavigationBar () {
        guard let navigationBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller Does not exist")}
        navigationBar.isHidden = true
    }
    
    func showNavigationBar () {
        guard let navigationBar = navigationController?.navigationBar else {
            fatalError("Navigation Contrller Does not exist")}
        navigationBar.isHidden = false
    }
    
    func removeNavigationBarBorder () {
        guard let navigationBar = navigationController?.navigationBar else {
            fatalError("Navigation Contrller Does not exist")}
        let img = UIImage()
        navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }
    
    //Instantiate Dashboard VC
    public func instantiateDashVC (identifier: String) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? DashboardViewController
            else {
                fatalError()
        }
        present(vc, animated: true)
        
    }
    
    /*
     Mark: UI Alert Set up
*/
    
    func failedSignInAlert () {
        let alert = UIAlertController(title: "Oops! 😢", message: "There was an error signing you in. Did You fill the fields correctly? If yes, then check your internet connection", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func verifyTextFields (textFields : [UITextField]) -> Bool {
        view.endEditing(true)
        for i in 0 ..< textFields.count {
            if textFields[i].text?.isEmpty == true  {
                return false
            }
        }
        return true
    }
    
    func confirmPinInput (textField : [UITextField])-> Bool {
        view.endEditing(true)
        for i in 0 ..< textField.count {
            if textField[0].text != textField[1].text {
                print("First pin \(textField[i])")
                print("second pin \(textField[i+1])")
                return false
            }
        }
        return true
    }
    
    func missingFieldAlert () {
        
        let alert = UIAlertController(title: "Oops!", message: "Some required fields are missing", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Continue Editing", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    func pinMismatchAlert () {
        let alert = UIAlertController(title: "Incorrect Pin", message: "Please check that both pin entries are exactly the same", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .destructive, handler: nil))
        
        present(alert, animated: true)
    }
    
    func loginErrorAlert () {
        let alert = UIAlertController(title: "Oops!", message: "Something went wrong while trying to sign you in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .destructive, handler: nil))
        
        present(alert, animated: true)
    }
    
    //MARK: Date Picker Setup
    
    @objc func dateChanged (datePicker : UIDatePicker, textField: UITextField, dateTextField : UITextField) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    

}

extension SuperViewController : GIDSignInUIDelegate {
    
    func signInDelegate () {
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func signOut () {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing you out: \(signOutError)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
}


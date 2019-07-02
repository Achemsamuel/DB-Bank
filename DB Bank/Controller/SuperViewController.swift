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
    
    //Amount Withdrawn
    var amountWithdrawn = 0

    
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
    
    func inquiryAlert (balance : String) {
        let alert = UIAlertController(title: "Balance: \(balance)", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func pinChangeAlert () {
        let alert = UIAlertController(title: "Change Pin", message: "Are you sure you want to change your pin?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            print("Pin Changed")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    //Retrieve Balance
   @objc dynamic func retrieveBalance () -> Int {
        //Should retrieve balance from the firDatabase instead
        //let dashboardVC = DashboardViewController()
        let balance = "180000"
        if let convertInt = Int(balance) {
            return convertInt
        } else {
            return 0
        }
        //Balance label should read 0 at start
    }
    
    //Choose Withdrawal Amount Alert View
    func withdrawalAmountAlert  ()  {
        
            let alert = UIAlertController(title: "Withdraw", message: "", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "N500", style:.default , handler: { (action) in
                //print("500 naira withdrawn")
                self.amountWithdrawn = 500
                //call a function that takes in the amount and then subtracts it and returns the value remaining to the balance
                var balance = self.retrieveBalance()
                print("Balance from func is :\(balance)")
                
                if balance >= 500 {
                    print("Can withdraw")
                    balance -= 500
                    print("Balance from func is :\(balance)")
                }
                else {
                    print("Sadly, you do not have sufficient funds")
                }
                
            }))
            alert.addAction(UIAlertAction(title: "N1000", style:.default , handler: { (action) in
                print("1000 naira withdrawn")
                self.amountWithdrawn = 1000
               // cashWithdrawn  = 1000
                
            }))
            alert.addAction(UIAlertAction(title: "N2000", style:.default , handler: { (action) in
                print("2000 naira withdrawn")
                self.amountWithdrawn = 2000
               // cashWithdrawn = 2000
            }))
            alert.addAction(UIAlertAction(title: "N5000", style:.default , handler: { (action) in
                print("5000 naira withdrawn")
                //self.amountWithdrawn = 5000
            }))
            alert.addAction(UIAlertAction(title: "N10000", style:.default , handler: { (action) in
                print("10000 naira withdrawn")
                //self.amountWithdrawn = 10000
            }))
            alert.addAction(UIAlertAction(title: "N20000", style:.default , handler: { (action) in
                print("20000 naira withdrawn")
                self.amountWithdrawn = 20000
            }))
            
            alert.addAction(UIAlertAction(title: "Enter Amount", style: .default, handler: { (action) in
                self.enterAmountAlert()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            //print("Amount withdrawn \(cashWithdrawn)")
        
        
    }
    
    //Enter Amount to withdraw
    
    func enterAmountAlert ()  {
        
        var amountEntered = 0
        
        let alert = UIAlertController(title: "Enter Amount", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter amount"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Withdraw", style: .default, handler: { (action) in
            print(textField.text!)
            if let intText = Int(textField.text!) {
                amountEntered = intText
                 print("new amount entered \(amountEntered)")
                self.amountWithdrawn = amountEntered
            }
          
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

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


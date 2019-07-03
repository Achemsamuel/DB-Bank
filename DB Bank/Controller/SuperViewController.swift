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
import FirebaseDatabase
import SVProgressHUD


//Firebase Database
let firebaseDB = Database.database()
var accountArray : [Account] = [Account]()

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
            _ = getbalance()
        print("DDDD bal : \(DBalance)")
            doSetUp()
            
        }
    
    func doSetUp () {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    //Convert Int To String
    func intToString (value : Int)  -> String {
        if let newValue : String = String(value) {
            return newValue
            
        }
    }
    
    //Convert String to Int
    func stringToInt (value : String) -> Int {
        
        if let newValue : Int = Int(value) {
            return newValue
        } else {
            return 0
        }
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
    
    
    //MARK: Send Balance To DB
    @objc dynamic func sendBalanceToDB (balance : Int) {
        
        let accountDB = firebaseDB.reference().child("Account Balance")
        let accountDetailsDict = ["Owner" : Auth.auth().currentUser?.email as Any, "Balance" : balance] as [String : Any]
        
        accountDB.childByAutoId().setValue(accountDetailsDict) {(error, reference) in
            if error != nil {
                print("Could not save account balance to database: \(error?.localizedDescription ?? "")")
            } else {
                print("Balance saved successfully")
            }
            
        }
        
    }
    
    @objc dynamic func sendTransactionToDB (amount : Int) {
        
         let transactionDB = firebaseDB.reference().child("Transaction History")
        let transactionDBDetails = ["Owner" : Auth.auth().currentUser?.email as Any, "Transaction" :  amount] as [String : Any]
        
        transactionDB.childByAutoId().setValue(transactionDBDetails) {(error, reference) in
            if error != nil {
                print("Could not save transaction to Database: \(error?.localizedDescription ?? "")")
            } else {
                print("Transaction saved successfully")
            }
            
        }
        
    }
    
    //Retrieve Balance
    var DBalance = 0
    
    @objc dynamic func getbalance () -> Int {
       // FirebaseApp.configure()
        
        
        let accountBalanceDB = firebaseDB.reference().child("Account Balance")
        accountBalanceDB.observe(.childAdded) { (snapshot) in

            let snapshotValue = snapshot.value as! Dictionary<String, Any>

            let balance = snapshotValue["Balance"] as! Int
            let owner = snapshotValue["Owner"] as! String

            let account = Account()
            account.owner = owner
            account.balance = balance

            self.DBalance = balance
            
        }
            return DBalance
        }
        //Balance label should read 0 at start
    
    //Withdraw Amount
    func calculateBalance (balance :  Int, amount: Int) -> Int {
        var newBalance : Int
        if (amount < balance) {
            newBalance = balance - amount
            return newBalance
        } else {
            print("Insufficient funds")
            return 0
        }
      
    }
    
    //Choose Withdrawal Amount Alert View
    func withdrawalAmountAlert  ()  {
        
            let alert = UIAlertController(title: "Withdraw", message: "", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "N500", style:.default , handler: { (action) in
                
                self.amountWithdrawn = 500
                //call a function that takes in the amount and then subtracts it and returns the value remaining to the balance
                let balance = self.getbalance()
                print("Gotten Balance : \(balance)")
               let newBalance = self.calculateBalance(balance: balance, amount: 500)
                self.sendBalanceToDB(balance: newBalance)
                self.sendTransactionToDB(amount: 500)
            }))
        
            alert.addAction(UIAlertAction(title: "N1000", style:.default , handler: { (action) in
                print("1000 naira withdrawn")
                self.amountWithdrawn = 1000
                let balance = self.getbalance()
                print("Gotten Balance : \(balance)")
                let newBalance = self.calculateBalance(balance: balance, amount: 1000)
                self.sendBalanceToDB(balance: newBalance)
                self.sendTransactionToDB(amount: 1000)
            }))
        
            alert.addAction(UIAlertAction(title: "N2000", style:.default , handler: { (action) in
                print("2000 naira withdrawn")
                self.amountWithdrawn = 2000
                let balance = self.getbalance()
                print("Gotten Balance : \(balance)")
                let newBalance = self.calculateBalance(balance: balance, amount: 2000)
                self.sendBalanceToDB(balance: newBalance)
                self.sendTransactionToDB(amount: 2000)
            }))
        
            alert.addAction(UIAlertAction(title: "N5000", style:.default , handler: { (action) in
                print("5000 naira withdrawn")
                let balance = self.getbalance()
                print("Gotten Balance : \(balance)")
                let newBalance = self.calculateBalance(balance: balance, amount: 5000)
                self.sendBalanceToDB(balance: newBalance)
                self.sendTransactionToDB(amount: 5000)
            }))
        
            alert.addAction(UIAlertAction(title: "N10000", style:.default , handler: { (action) in
                print("10000 naira withdrawn")
                self.amountWithdrawn = 10000
                let balance = self.getbalance()
                print("Gotten Balance : \(balance)")
                let newBalance = self.calculateBalance(balance: balance, amount: 10000)
                self.sendBalanceToDB(balance: newBalance)
                self.sendTransactionToDB(amount: 10000)
            }))
        
            alert.addAction(UIAlertAction(title: "N20000", style:.default , handler: { (action) in
                print("20000 naira withdrawn")
                self.amountWithdrawn = 20000
                let balance = self.getbalance()
                print("Gotten Balance : \(balance)")
                let newBalance = self.calculateBalance(balance: balance, amount: 20000)
                self.sendBalanceToDB(balance: newBalance)
                self.sendTransactionToDB(amount: 20000)
            }))
            
            alert.addAction(UIAlertAction(title: "Enter Amount", style: .default, handler: { (action) in
                self.enterAmountAlert()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true)
        
        
        
    }
    
    //Enter Amount to withdraw
    
    func enterAmountAlert ()  {
        
        let alert = UIAlertController(title: "Enter Amount", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter amount"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Withdraw", style: .default, handler: { (action) in
            print(textField.text!)
            
            if textField.text!.isEmpty {
                print("Please enter valid text")
            } else {
                let intBalance = self.stringToInt(value: textField.text!)
                print("new amount entered \(intBalance)")
                self.amountWithdrawn = intBalance
                let balance = self.getbalance()
                print("Gotten Balance : \(balance)")
                let newBalance = self.calculateBalance(balance: balance, amount: intBalance)
                self.sendBalanceToDB(balance: newBalance)
                self.sendTransactionToDB(amount: intBalance)
            }
            
          
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true)
        
        
    }
    
    func formatBalance (balance : Int)  -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedBalance = numberFormatter.string(from: NSNumber(value: balance)) else { return "" }
        
        return formattedBalance
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


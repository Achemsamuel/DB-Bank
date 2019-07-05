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
import MapKit
import CoreLocation


//Firebase Database
let firebaseDB = Database.database()
var accountArray : [Account] = [Account]()

class SuperViewController: UIViewController, GIDSignInDelegate {
    
  //Segue Identifiers
    let goToCreateAccount = "createAccount"
    let goToSignin = "goToSignin"
    let goToRecoverPin = "recoverPin"
    let goToDashboard = "dashboard"
    let goToNavigationVC = "goToOnboardingVC"
    let goToQuicktellerVC = "quicktellerVC"
    
    //Location Manager
    let locationManager = CLLocationManager()
    
    //Amount Withdrawn
    var amountWithdrawn = 0
    
    //
    lazy var blockedUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
            _ = getbalance()
        _ = retrieveBlockedUsers(username: "")
            doSetUp()
            
        }
    
    func doSetUp () {
        locationManager.requestWhenInUseAuthorization()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //MARK: Set Balance only once
        //sendBalanceToDB(balance: 600000)
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
            fatalError("Navigation Controller Does not exist")}
        navigationBar.isHidden = false
    }
    
    func removeNavigationBarBorder () {
        guard let navigationBar = navigationController?.navigationBar else {
            fatalError("Navigation Contrller Does not exist")}
        let img = UIImage()
        navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }
    
    //MARK: Instantiate Dashboard VC
    public func instantiateDashVC (identifier: String) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? DashboardViewController
            else {
                fatalError()
        }
        present(vc, animated: true)
        
    }
    
    public func instantiateOnboardingVC (identifier : String) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? OnboardingViewController
            else {
                fatalError()
        }
        present(vc, animated: true)
        
    }
    
 /*   public func instantiateQuicktellerVC (identifier : String) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as? QuicktellerTableViewController
            else {
                fatalError()
        }
        present(vc, animated: true)
    } */
    
    
    /*
     MARK: UI Alert Set up
*/
    
    func quicktellerAlertView (array : [String]) {
        
        let alert = UIAlertController(title: "Quickteller", message: "", preferredStyle: .alert)
        
        for i in 0 ..< array.count {
            let item = array[i]
        
            alert.addAction(UIAlertAction(title: item, style: .default, handler: { (action) in
                print("Can't do anything at this time")
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
         present(alert, animated: true)
    }
    
    func failedSignInAlert () {
        let alert = UIAlertController(title: "Password must not be less than six numbers", message: "\n There was an error signing you in. \n Did You fill the fields correctly? \n If yes, then check your internet connection", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func failedSignInAlert2 () {
        let alert = UIAlertController(title: "Oops! 😢. \n ", message: "\n There was an error signing you in. \n Did You fill the fields correctly? \n If yes, then check your internet connection", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func wrongPasswordAlert (t : Int, tr : String) {
        let alert = UIAlertController(title: "Oops! 😢", message: "You entered the wrong password, you have \(t) more \(tr) before you are blocked", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Retry", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    func blockedPasswordAlert () {
        let alert = UIAlertController(title: "You entered the wrong password three times and you have been blocked.", message: "Your ATM has been siezed, contact your bank to retrive your card", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .destructive, handler: nil))
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
                //print("First pin \(textField[i])")
                //print("second pin \(textField[i+1])")
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
            self.cannotChangePinAlert()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func cannotChangePinAlert () {
        
        let alert = UIAlertController(title: "Sorry, you cannot change your pin at this time. Please contact your bank", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func informationSent () {
        let alert = UIAlertController(title: "Request Sent", message: "Your request to open a new account has been logged, please contact your bank for your login details", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
          
        }))
        
        present(alert, animated: true)
    }
    
    func transactionSuccessful (balance: Int, type: String, amount: Int) {
        let alert = UIAlertController(title: "Transaction Successful", message: "Please take your cash.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            self.reciept(balance: balance, type: type, amount: amount)
        }))
        
        present(alert, animated: true)
    }
    
    func reciept (balance : Int, type : String, amount : Int) {
        
        let dateTime = dateGetter()
        
        let alert = UIAlertController(title: "Receipt", message: "Balance : \(balance) \n Date: \(dateTime) \n Transaction: \(type) \n Amount: \(amount)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Print", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    func dateGetter () -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    //MARK: Send Balance To DB
    @objc dynamic func sendBalanceToDB (balance : Int) {
        
        let accountDB = firebaseDB.reference().child("Account Balance")
        let accountDetailsDict = ["Owner" : Auth.auth().currentUser?.email as Any, "Owner ID" : Auth.auth().currentUser?.uid as Any, "Balance" : balance] as [String : Any]
        
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
        let transactionDBDetails = ["Owner" : Auth.auth().currentUser?.email as Any, "Owner ID" : Auth.auth().currentUser?.uid as Any, "Transaction" :  amount] as [String : Any]
        
        transactionDB.childByAutoId().setValue(transactionDBDetails) {(error, reference) in
            if error != nil {
                print("Could not save transaction to Database: \(error?.localizedDescription ?? "")")
            } else {
                print("Transaction saved successfully")
            }
            
        }
        
    }

    
    //MARK: Retrieve Balance
    lazy var DBalance = 0
    
    @objc dynamic func getbalance () -> Int {
        
        let accountBalanceDB = firebaseDB.reference().child("Account Balance")
        accountBalanceDB.observe(.childAdded) { (snapshot) in

            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            //print("snapshot Value balance and stuff \(snapshotValue)")
            
            let balance = snapshotValue["Balance"] as! Int
            let owner = snapshotValue["Owner"] as! String
            let ownerID = snapshotValue["Owner ID"] as! String
            
            let currentUserID = Auth.auth().currentUser?.uid
            
            if ownerID == currentUserID {
                let account = Account()
                account.owner = owner
                account.balance = balance
                
                self.DBalance = balance
                //print("Sef  :\(self.DBalance)")
            }
            else {
                print("Invalid user")
            }
            
        }
            return DBalance
        }
    
        //Balance label should read 0 at start
    
    //Withdraw Amount
    func calculateBalance (balance :  Int, amount: Int, type: String) {
        var newBalance : Int
        if (balance > amount) {
            newBalance = balance - amount
            self.sendBalanceToDB(balance: newBalance)
            self.sendTransactionToDB(amount: amount)
            transactionSuccessful(balance: newBalance, type: type, amount: amount)
        } else {
            insufficientFundsAlert()
            print("Insufficient funds")
        }
      
    }
    
    func insufficientFundsAlert () {
        let alert = UIAlertController(title: "Insufficient Funds 😢", message: "You do not have enough funds to complete this transaction", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //Choose Withdrawal Amount Alert View
    func withdrawalAmountAlert  (type : String)  {
        
            let alert = UIAlertController(title: "Withdraw", message: "", preferredStyle: .alert)
        
            let amountArray = [500, 1000, 2000, 5000, 10000, 20000]
        
        for i in 0 ..< amountArray.count {
            let amount = amountArray[i]
            
            alert.addAction(UIAlertAction(title: "\(amount)", style:.default , handler: { (action) in
                
                self.amountWithdrawn = amount
                let balance = self.getbalance()
               // print("Gotten Balance : \(balance)")
                self.calculateBalance(balance: balance, amount: amount, type: type)
                
            }))
            
        }
            alert.addAction(UIAlertAction(title: "Enter Amount", style: .default, handler: { (action) in
                self.enterAmountAlert(type: type)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true)
    }
    
    //Enter Amount to withdraw
    
    func enterAmountAlert (type : String)  {
        
        let alert = UIAlertController(title: "Enter Amount", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter amount"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Withdraw", style: .default, handler: { (action) in
            //print(textField.text!)
            
            if textField.text!.isEmpty {
                self.enterValidAccount(title: "Please enter valid amount")
            } else {
                
                let intBalance = self.stringToInt(value: textField.text!)
                
                if (intBalance % 500 != 0) {
                    self.enterValidAccount(title: "Please enter a multiple of N500 or N1000")
                    
                } else {
                    self.amountWithdrawn = intBalance
                    let balance = self.getbalance()
                    self.calculateBalance(balance: balance, amount: intBalance, type: type)
                }
                
                
            }
            
          
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true)
        
        
    }
    
    //MARK: Transfer
    func transferToAccount (type : String) {
        
        let alert = UIAlertController(title: "Enter Recipent Bank Name", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter bank name"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            //Do something with the bank name and account number here
            if textField.text?.isEmpty == true {
                self.enterValidAccount(title: "You have to enter a valid account name to proceed")
            } else {
                self.enterAccountNumber(type: type)
            }
        }))
        
        present(alert, animated: true)
    }
    
    func enterAccountNumber (type : String) {
        
        let alert = UIAlertController(title: "Enter Recipent Account Number", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter account number"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if textField.text?.isEmpty == true {
                self.enterValidAccount(title: "You have to enter a valid account number to proceed")
                
            } else {
                if textField.text!.count < 10 || textField.text!.count > 10 {
                    self.enterValidAccount(title: "You did not enter a valid account number.")
                } else {
                    self.withdrawalAmountAlert(type: type)
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
    func enterValidAccount (title : String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            
        }))
        
        present(alert, animated: true)
    }
    
    //Format Balance
    
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
    
    func blockUser (email : String) {
        let blockedUsers = firebaseDB.reference().child("Blocked Users")
        let blockedDict = ["user" : email, "isBlcoked" : true] as [String : Any]
        blockedUsers.childByAutoId().setValue(blockedDict) {(error, reference) in
            if error != nil {
                print("Error blocing user \(error?.localizedDescription)")
            } else {
                print("User added to blocked list successfully")
            }
        }
    }
    
   
    func retrieveBlockedUsers (username : String) -> String {
        
        let blockedUsersDB = firebaseDB.reference().child("Blocked Users")
        blockedUsersDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            //print("snapshot Value balance and stuff \(snapshotValue)")
            
            let user = snapshotValue["user"] as! String
            let isBlocked = snapshotValue["isBlcoked"] as! Bool
            
            if username == user {
                print("User already blocked")
            } else {
                if isBlocked == true {
                    let blockedUsers = BlockedUser()
                    blockedUsers.email = user
                    blockedUsers.isBlocked = isBlocked
                     self.blockedUser = user
                }
            }
            
           
    }
    
        return blockedUser
    }
    
    
}

extension SuperViewController : CLLocationManagerDelegate {
    
    func doLocationSetup () {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
}

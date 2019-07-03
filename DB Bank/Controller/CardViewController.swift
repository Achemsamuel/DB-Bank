//
//  CardViewController.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/29/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CardViewController: SuperViewController {

    let customView = CustomView()
    let custombutton = CustomButton()

    //Firebase Database
    let firebaseDB = Database.database()
    
    
    //TableView Cell
    let cellId = "transactionsCell"
    
    let quicktellerActionsArray = ["Send/Receieve Money", "Buy Airtime", "Pay Bills", "Book Flight", "Request Lone", "Shop"]
    
    //T:
    var balance = ""
    var accountArray : [Account] = [Account]()
    //var dBBalance = 0
    //Transaction
    var transactionHistoryArray : [TransactionHistory] = [TransactionHistory]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //_ = retrieveBalance()
        _ = getbalance()
        setup()
        tableViewSetup()
        print(balance)
    }
    
   

  /*
     IB Outlets
 */
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var quicktellerButton: UIButton!
    @IBOutlet weak var inquiryButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    /*
     IB Actions
*/
    @IBAction func withdrawButtonPressed(_ sender: UIButton) {
        withdrawalAmountAlert(type: "Withdrawal")
    }
    
    @IBAction func transferButtonPressed(_ sender: UIButton) {
        transferToAccount(type : "Transfer")
    }
    
    @IBAction func quicktellerButtonPressed(_ sender: UIButton) {
        quicktellerAlertView(array: quicktellerActionsArray)
    }
    
    @IBAction func inquiryButtonPressed(_ sender: UIButton) {
        self.balance = formatBalance(balance: self.DBalance)
        inquiryAlert(balance: balance)
        
    }
    
    @IBAction func changePinButtonPressed(_ sender: UIButton) {
        pinChangeAlert()
    }
    
    
    var servicesButtonArray : [UIButton] = []
    var servicesText : UILabel = UILabel()
    var transactionArray = [10000000, 244000, 34100, 60000, 41000, 32600]

    func setup () {
        retrieveTransactions()
        servicesButtonArray = [withdrawButton, transferButton, quicktellerButton, inquiryButton, pinButton]
        custombutton.customizeServicesButtons(buttons: servicesButtonArray)
        
    }
    
    func tableViewSetup () {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionsTableViewCell.self, forCellReuseIdentifier: cellId)
    }

}

extension CardViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Should return number of elements in transaction Array
        
        return transactionHistoryArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TransactionsTableViewCell
        cell.isUserInteractionEnabled = false
        cell.valueLabel.text = ("-\(transactionHistoryArray.reversed()[indexPath.row].transaction)")
        
        return cell
       
    }
    
    
}

/*
    Firebase Datatbase Setup
 */

extension CardViewController {
    
    override func sendBalanceToDB (balance : Int) {
     
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
    
    func retrieveTransactions () {
        
        let transactionDB = firebaseDB.reference().child("Transaction History")
        transactionDB.observe(.childAdded) {(snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            
            let transaction = snapshotValue["Transaction"] as! Int
            let owner = snapshotValue["Owner"] as! String
            let ownerID = snapshotValue["Owner ID"] as! String
            
            let currentUserID = Auth.auth().currentUser?.uid
            
            if ownerID == currentUserID {
                let transactionHistory = TransactionHistory()
                transactionHistory.owner = owner
                transactionHistory.transaction = transaction
                transactionHistory.ownerID = ownerID
                self.transactionHistoryArray.append(transactionHistory)
                self.tableView.reloadData()
            }
            
           
        }
        
    }
    
}




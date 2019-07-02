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
    
    //
     var balance = ""
    var dBbalance = 0
    var accountArray : [Account] = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _ = retrieveBalance()
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
//         if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
       withdrawalAmountAlert()
        //print("New withdrawal amount: \(call)")
        
        //Call the send balance method here after balance from transaction
        sendBalanceToDB(balance: 180000)
    }
    
    @IBAction func transferButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func quicktellerButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func inquiryButtonPressed(_ sender: UIButton) {
        inquiryAlert(balance: balance)
    }
    
    @IBAction func changePinButtonPressed(_ sender: UIButton) {
        pinChangeAlert()
    }
    
    
    var servicesButtonArray : [UIButton] = []
    var servicesText : UILabel = UILabel()
    var transactionArray = [10000000, 244000, 34100, 60000, 41000, 32600]

    func setup () {
        
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
        
        return transactionArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TransactionsTableViewCell
        cell.isUserInteractionEnabled = false
        cell.valueLabel.text = ("-\(transactionArray[indexPath.row])")
    
        return cell
       
    }
    
    
}

/*
    Firebase Datatbase Setup
 */

extension CardViewController {
    
    func sendBalanceToDB (balance : Int) {
        
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
    
  override  func retrieveBalance () -> Int {
    
    
    let accountBalanceDB = firebaseDB.reference().child("Account Balance")
    accountBalanceDB.observe(.childAdded) { (snapshot) in
        
        let snapshotValue = snapshot.value as! Dictionary<String, Any>
        
        let balance = snapshotValue["Balance"] as! Int
        let owner = snapshotValue["Owner"] as! String
        
        let account = Account()
        account.owner = owner
        account.balance = balance
        
        self.accountArray.append(account)
        print("Account array : \(self.accountArray[0].balance)")
        let endIndex = self.accountArray.count
        self.dBbalance = balance
        //Now it is picking the exact balance, next is to use the balance to populate the balance label and then use it for other transaction
        print("DB balance : \(self.dBbalance)")
    }
    return dBbalance

    }
    
}




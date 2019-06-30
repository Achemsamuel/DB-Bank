//
//  CardViewController.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/29/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    let customView = CustomView()
    let custombutton = CustomButton()
    
    //TableView Cell
    let cellId = "transactionsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        tableViewSetup()
    }

  
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var quicktellerButton: UIButton!
    @IBOutlet weak var inquiryButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        cell.valueLabel.text = ("-\(transactionArray[indexPath.row])")
    
        return cell
       
    }
    
    
}



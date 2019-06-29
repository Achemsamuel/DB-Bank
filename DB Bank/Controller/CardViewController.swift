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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

  
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var quicktellerButton: UIButton!
    @IBOutlet weak var inquiryButton: UIButton!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var servicesButtonArray : [UIButton] = []

    func setup () {
        tableView.delegate = self
        tableView.dataSource = self
        servicesButtonArray = [withdrawButton, transferButton, quicktellerButton, inquiryButton, pinButton]
        custombutton.customizeServicesButtons(buttons: servicesButtonArray)
    }

}

extension CardViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Should return number of elements in transaction Array
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        return cell
        return UITableViewCell()
    }
    
    
}



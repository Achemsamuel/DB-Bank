//
//  CustomButton.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/26/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit

class CustomButton {
    
    func customizeButton  (button : UIButton) {
        
        let cornerRadius : CGFloat = 15.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1).cgColor
        button.layer.cornerRadius = cornerRadius
    }
    
    func customizeServicesButtons (buttons : [UIButton]) {
        
        let cornerRadius : CGFloat = 30.0
        for button in buttons {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1).cgColor
            button.layer.cornerRadius = cornerRadius
        }
    }
}


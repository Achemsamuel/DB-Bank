//
//  TextFields.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/26/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit

class TextFields {
    
    func addDynamicTextlayout (offset: CGFloat, label : UILabel, view : UIView, height : CGFloat) {
        let newOffset : CGFloat = 40.0
        label.frame = CGRect(x: 30, y: offset + newOffset , width: view.frame.width, height: height)
    }
}

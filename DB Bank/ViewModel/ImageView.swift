//
//  File.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/26/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit

class ImageView {
    
    func addCornerRadius (imageView : UIImageView, view : UIView) {
        let cornerRadius : CGFloat = 40.0
        imageView.layer.cornerRadius = cornerRadius
        let offset : CGFloat = 40
        imageView.frame = CGRect(x: 0, y: offset, width: view.frame.width, height: view.frame.height - offset)
    }
    
    func roundedImage (imageView : UIImageView) {
        
        let cornerRadius : CGFloat = 50.0
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(red: 0.007, green: 0.54, blue: 1, alpha: 1).cgColor
    }
    
    func perfectRoundedImage (imageView : UIImageView) {
        
        let cornerRadius : CGFloat = 25.0
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(red: 0.007, green: 0.54, blue: 1, alpha: 1).cgColor
    }
    
    func creditCardImageEdgesFix (imageView : UIImageView) {
        
        let cornerRadius : CGFloat = 15.0
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(red: 0.007, green: 0.54, blue: 1, alpha: 1).cgColor
    }
    
}




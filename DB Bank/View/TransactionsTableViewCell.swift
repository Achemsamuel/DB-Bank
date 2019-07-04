//
//  TransactionsTableViewCell.swift
//  DB Bank
//
//  Created by Achem Samuel on 6/30/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var cellLabel : UILabel!
    var valueLabel : UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 100.0, height: 40))
        cellLabel.text = "Debit"
        cellLabel.textColor = .red
        
        let labelW : CGFloat = 200
        valueLabel = UILabel(frame:  CGRect(x: frame.width - 15, y: 0, width: labelW, height: 40))
        valueLabel.frame.origin.y = 0
        valueLabel.frame.origin.x = self.frame.width - 160
        valueLabel.textAlignment = .right
        valueLabel.textColor = .red
        
        
        addSubview(valueLabel)
        addSubview(cellLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

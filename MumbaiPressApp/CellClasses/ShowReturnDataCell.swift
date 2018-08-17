//
//  ShowReturnDataCell.swift
//  MumbaiPressApp
//
//  Created by user on 16/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ShowReturnDataCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHeadLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

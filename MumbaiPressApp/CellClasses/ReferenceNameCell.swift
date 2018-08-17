//
//  ReferenceNameCell.swift
//  MumbaiPressApp
//
//  Created by user on 07/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ReferenceNameCell: UITableViewCell {

    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblRefType: UILabel!
    @IBOutlet weak var lblNameRef: UILabel!
    
    @IBOutlet weak var lblContactRef: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}

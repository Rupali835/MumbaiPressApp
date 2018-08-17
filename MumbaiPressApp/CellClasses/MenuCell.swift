//
//  MenuCell.swift
//  MumbaiPressApp
//
//  Created by user on 14/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var lblMenuList: UILabel!
    
    @IBOutlet weak var btnExpand: UIButton!
    
     @IBOutlet weak var btnExpandCollapse: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

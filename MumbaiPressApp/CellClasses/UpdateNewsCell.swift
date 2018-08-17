//
//  UpdateNewsCell.swift
//  MumbaiPressApp
//
//  Created by user on 19/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class UpdateNewsCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblNews: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

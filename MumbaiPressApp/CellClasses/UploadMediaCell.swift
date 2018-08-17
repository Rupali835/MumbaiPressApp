//
//  UploadMediaCell.swift
//  MumbaiPressApp
//
//  Created by user on 15/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class UploadMediaCell: UITableViewCell {

    @IBOutlet weak var lblMedia: UILabel!
    @IBOutlet weak var imgMedia: UIImageView!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  ImpLinkCell.swift
//  MumbaiPressApp
//
//  Created by user on 27/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ImpLinkCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var ImgLink: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

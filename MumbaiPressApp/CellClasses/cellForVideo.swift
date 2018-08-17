//
//  cellForVideo.swift
//  MumbaiPressApp
//
//  Created by user on 18/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class cellForVideo: UITableViewCell {

    
    @IBOutlet weak var btnDeletaDocmnt: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblAudioVideo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

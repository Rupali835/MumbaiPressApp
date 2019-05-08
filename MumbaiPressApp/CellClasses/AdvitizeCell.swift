//
//  AdvitizeCell.swift
//  MumbaiPressApp
//
//  Created by Nishikant Ashok UMBARKAR on 2/5/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdvitizeCell: UITableViewCell {

    @IBOutlet weak var bannerView: GADBannerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

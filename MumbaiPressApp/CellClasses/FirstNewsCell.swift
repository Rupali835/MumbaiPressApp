//
//  FirstNewsCell.swift
//  MumbaiPressApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol FirstNewCellDelegate : class {
    func didSelectedFirstCell(_ sender: FirstNewsCell)
}

class FirstNewsCell: UITableViewCell {

    @IBOutlet weak var btnYoutube: UIButton!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    weak var delegate : FirstNewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.backView.addGestureRecognizer(tapGesture)
        
    }

    @objc func tapOnView(onView gesture: UITapGestureRecognizer)
    {
        delegate?.didSelectedFirstCell(self)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

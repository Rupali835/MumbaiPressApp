//
//  SecondNewsCell.swift
//  MumbaiPressApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol SecondNewsCellDelegate : class {
    func didSelected(_ sender: SecondNewsCell)
   }

class SecondNewsCell: UITableViewCell
{

    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var btnyoutb: UIButton!
    @IBOutlet weak var lblDATE: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var imgNewS: UIImageView!
    
    weak var delegate: SecondNewsCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.selectionStyle = .none

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.backview.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapOnView(onView gesture: UITapGestureRecognizer)
    {
        delegate?.didSelected(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

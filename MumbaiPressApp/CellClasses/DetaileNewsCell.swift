//
//  DetaileNewsCell.swift
//  MumbaiPressApp
//
//  Created by user on 01/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class DetaileNewsCell: UICollectionViewCell
{
    
    //@IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var lblView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnView: UIView!
    
   
    
    override func awakeFromNib()
    {
   
        // designView(cView: viewImg)

        
    }
    
  
    
    func designView(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
        
    }
}

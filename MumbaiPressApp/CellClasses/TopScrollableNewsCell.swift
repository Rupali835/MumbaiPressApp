//
//  TopScrollableNewsCell.swift
//  MumbaiPressApp
//
//  Created by user on 01/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol TopNewCellDelegate : class {
    func didSelectedFirstCell(_ sender: TopScrollableNewsCell)
}

class TopScrollableNewsCell: UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    weak var delegate : TopNewCellDelegate?

}

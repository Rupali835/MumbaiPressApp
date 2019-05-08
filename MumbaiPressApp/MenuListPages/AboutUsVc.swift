//
//  AboutUsVc.swift
//  MumbaiPressApp
//
//  Created by user on 14/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class AboutUsVc: UIViewController {

    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var viewLbl: UIView!
    @IBOutlet weak var lblAboutUs: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.sideMenus()
        let newlayer = CAGradientLayer()
        newlayer.colors = [ UIColor.cyan.cgColor, UIColor.blue.cgColor ]
        newlayer.frame = view.frame
        designCell(cView: ViewBar)
        
    }

    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
        
    }

    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 310
            revealViewController().rightViewRevealWidth = 130
        
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
   
    @IBAction func menuBarbtn_Click(_ sender: Any)
    {
        if revealViewController() != nil
        {
            revealViewController().rearViewRevealWidth = 310
            revealViewController().rightViewRevealWidth = 130
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
   
}

//
//  FullScreenTodayNewsVc.swift
//  MumbaiPressApp
//
//  Created by user on 05/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Kingfisher

class FullScreenTodayNewsVc: UIViewController {

    @IBOutlet weak var imgFullScreen: UIImageView!
   
    var url : URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgFullScreen.kf.setImage(with: url)

    }

    func setImage(imgUrl: String)
    {
         url = URL(string: imgUrl as! String)
       // imgFullScreen.kf.setImage(with: url)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        customizeNavBar()
        
    }
    
    func customizeNavBar() {
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        let logo = UIImage(named: "mumbaipress")
        let imageView = UIImageView(image:logo)
        imageView.frame.size.height = 25
        imageView.frame.size.width = 160
        self.navigationItem.titleView = imageView
        
    }

   
}

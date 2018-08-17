//
//  ReporterDataVC.swift
//  MumbaiPressApp
//
//  Created by user on 30/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Kingfisher

class ReporterDataVC: UIViewController {

    private var toast: JYToast!
    var ImgNm : String = ""
    
    var ImgPath = "https://www.mumbaipress.com/wp-content/uploads/repoter_news/image/"
    
    @IBOutlet weak var imgOfReporter: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
        
    }

    private func initUi() {
        toast = JYToast()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
////////////*******      EXTRA - FUNCTIONS      ***********//////////
    
    
    func setData(img : String)
    {
        self.ImgNm = img
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customizeNavBar()
        
        let url = URL(string: ImgPath + "\(self.ImgNm)")
        imgOfReporter.kf.setImage(with: url)
        self.toast.isShow("Swipe left for go back..")
        
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
        self.navigationItem.titleView = imageView
        
    }

}

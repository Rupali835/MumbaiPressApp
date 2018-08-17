//
//  UpdatesNewsVC.swift
//  MumbaiPressApp
//
//  Created by user on 19/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SHSnackBarView

class UpdatesNewsVC: UIViewController, TableViewDelegateDataSource
{

    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tblNews: UITableView!
    
    var newsData = [AnyObject]()
    let snackbarView = snackBar()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblNews.separatorStyle = .none
        tblNews.delegate = self
        tblNews.dataSource = self
        
        self.tblNews.separatorStyle = .none
        self.tblNews.estimatedRowHeight = 80
        self.tblNews.rowHeight = UITableViewAutomaticDimension
        getNews()
        
        designCell(cView: ViewBar)
    }
    
    func getNews()
    {
        let url = "https://www.mumbaipress.com/wp-content/themes/mumbai_press/API/announcemnet.php"
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            let JSON = resp.result.value as! NSDictionary
            let Msg = JSON["msg"] as! String
            if Msg == "SUCCESS"
            {
                self.newsData = JSON["data"] as! [AnyObject]
            }
            if Msg == "FAIL"
            {
                let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "No any updates", textColor: UIColor.white, interval: 2)
            }
            self.tblNews.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblNews.dequeueReusableCell(withIdentifier: "UpdateNewsCell", for: indexPath) as! UpdateNewsCell
        let lcDict = self.newsData[indexPath.row]
        cell.lblNews.text = (lcDict["u_headline"] as! String)
        
        let date = lcDict["u_date_time"] as! String
        cell.lblDateTime.text = date.datesetting()
        cell.backView.backgroundColor = UIColor(red:0.31, green:0.76, blue:0.97, alpha:1.0)
        cell.lblNews.textColor = UIColor.white
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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
   
    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
    }
    
}

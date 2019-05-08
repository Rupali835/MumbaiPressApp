//
//  TodaysNewsVc.swift
//  MumbaiPressApp
//
//  Created by user on 05/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SHSnackBarView
import GoogleMobileAds

class TodaysNewsVc: UIViewController,CollectionViewDelegateDataSourceFlowLayout
{
   
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var collView: UICollectionView!
    
    let snackbarView = snackBar()
    var newsArr = [AnyObject]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        designCell(cView: ViewBar)
        
        bannerView.adUnitID = "ca-app-pub-5349935640076581/1498791760"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
        
    }
    func getTodaysNews()
    {
        let url = "https://www.mumbaipress.com/wp-content/themes/mumbai_press/API/today_news.php"
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
        self.newsArr = resp.result.value as! [AnyObject]
            
            if self.newsArr.isEmpty == true
            {
                let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "No Any Newspaper", textColor: UIColor.white, interval: 2)
            }
            
         self.collView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.newsArr.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        getTodaysNews()
        sideMenus()
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "TodaysNewsCell", for: indexPath) as! TodaysNewsCell
        
        let lcStr = self.newsArr[indexPath.row]
        print(lcStr)
        
        let url = URL(string: lcStr as! String)
        cell.imgTodayNews.kf.setImage(with: url)
        cell.imgTodayNews.dropShadow()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let fullVc = storyboard?.instantiateViewController(withIdentifier: "FullScreenTodayNewsVc") as! FullScreenTodayNewsVc
        
         let lcStr = self.newsArr[indexPath.row]
        fullVc.setImage(imgUrl: lcStr as! String)
        
        self.navigationController?.pushViewController(fullVc, animated: true)
    }
    
   
    func sideMenus()
    {
        if revealViewController() != nil {
            
            menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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

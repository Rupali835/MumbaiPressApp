//
//  DetailNewsScrollVC.swift
//  MumbaiPressApp
//
//  Created by user on 01/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class DetailNewsScrollVC: UIViewController,CollectionViewDelegateDataSourceFlowLayout
{
  
    @IBOutlet weak var lblPageCount: UILabel!
    
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var CollectionView: UICollectionView!
    
    var newsArr = [DetaileNews]()
    var m_nTotalNews: Int!
    var Title : String = ""
    var LinkUrl : String = ""
    var DetailText : String = ""
    var SelectedIndex = Int(0)
    var indexPath = Int(0)

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        CollectionView.dataSource = self
        CollectionView.delegate    = self
        
       self.SetLabelData(nSelectedIndex: SelectedIndex)
       
    }
    
   override func viewDidAppear(_ animated: Bool)
    {
         let indexPathofItem = IndexPath(item: self.indexPath , section: 0)
         self.CollectionView.scrollToItem(at: indexPathofItem, at: .left, animated: false)
        
    }
    
    func SetLabelData(nSelectedIndex: Int)
    {
       lblPageCount.text = "\(nSelectedIndex) / \(self.m_nTotalNews!) "
    }
    
    func setImageToView(newsarr: [DetaileNews], nSelectedIndex: Int,nTotalNews: Int)
    {
        self.m_nTotalNews = nTotalNews
        self.newsArr = newsarr
        print("NewsArr :\(self.newsArr.count)")
        SelectedIndex = nSelectedIndex + 1
        self.indexPath = nSelectedIndex
       
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = CollectionView.dequeueReusableCell(withReuseIdentifier: "DetaileNewsCell", for: indexPath) as! DetaileNewsCell
        
        let lcDataArr = self.newsArr[indexPath.row]
        
        print("lcDataArr =\(lcDataArr)")
       
        let render = lcDataArr.DetailsDesc
        let title = lcDataArr.title
        
        let textHead = changestr(stringTochange: title!)
        let textNews = changestr(stringTochange: render)
        
        let sourceImg = lcDataArr.url
        self.LinkUrl = lcDataArr.Link
     
        
        cell.TextView.text = textNews
     
        print(self.Title)
        cell.lblView.text = textHead
        cell.lblDate.text = lcDataArr.date
        
        let url = URL(string: sourceImg)
        cell.imgView.kf.setImage(with: url)
        
        cell.imgView.dropShadow()
        
    
        cell.TextView.sizeToFit()
        
        
        let calHeight = cell.TextView.frame.size.height
        cell.TextView.frame = CGRect(x: 16, y: 40, width: self.view.frame.size.width - 32, height: calHeight)

        let lnHeight = cell.imgView.frame.size.height  + cell.lblDate.frame.size.height + cell.lblView.frame.size.height + calHeight + 40
        
                cell.ContentViewHeightConstraint?.constant = lnHeight//1400
                cell.layoutIfNeeded()
                cell.layoutSubviews()
                cell.setNeedsLayout()

        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.width   , height: self.view.frame.height)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == CollectionView
        {
           let lnContentOffset = scrollView.contentOffset.x
            var lnCurrentIndex = Int((lnContentOffset / self.CollectionView.frame.width))
            lnCurrentIndex += 1
            self.SetLabelData(nSelectedIndex: lnCurrentIndex)
            
            
            let lnIndexPath = IndexPath(item: lnCurrentIndex - 1, section: 0)
            
            let cell = CollectionView.cellForItem(at: lnIndexPath) as! DetaileNewsCell
            
            // designView(cView: viewImg)
           
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
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
        
        let logo = UIImage(named: "mp_new")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        let button1 = UIBarButtonItem(image: UIImage(named: "upload"), style: .plain, target: self, action: #selector(TapToShare_Click))
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @objc func TapToShare_Click()
    {
        let someText:String = self.LinkUrl
        let objectsToShare:URL = URL(string: someText)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @objc func htmlDecode(text : String)
    {
        
    }
    
    func changestr(stringTochange:String)-> String {
        
        let str = stringTochange.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let str1 = str.replacingOccurrences(of: "[&#1234567890;]", with: "", options: .regularExpression, range: nil)
        print(str1)
        return str1
        
    }

    
    
    
}


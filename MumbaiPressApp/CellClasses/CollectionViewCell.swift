//
//  CollectionViewCell.swift
//  MumbaiPressApp
//
//  Created by user on 01/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CollectionViewCell: UITableViewCell,CollectionViewDelegateDataSourceFlowLayout
{

    @IBOutlet weak var collView: UICollectionView!
    var DetaileNewsArr = [DetaileNews]()
  var Top6LatesNews = [AnyObject]()
    
    var BreakingNewsArr = [AnyObject]()
    var TitleArr = NSMutableArray()
    
    let storyBrd = UIStoryboard(name: "Main", bundle: nil)
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func SetData(TopNewsData: [AnyObject])
    {
        self.Top6LatesNews = TopNewsData
        self.collView.reloadData()
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.selectionStyle = .none
        let nibName = UINib(nibName: "TopScrollableNewsCell", bundle:nil)
        collView.register(nibName, forCellWithReuseIdentifier: "cell")
        self.collView.delegate = self
        self.collView.dataSource = self
        startTimer()
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.Top6LatesNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopScrollableNewsCell
        
        let lcDict = self.Top6LatesNews[indexPath.item]
        
        let Title = lcDict["title"] as! NSDictionary
        let render = Title["rendered"] as! String
        
       
        if let imgDict = lcDict["better_featured_image"] as? NSDictionary
       {
           let sourceImg = imgDict["source_url"] as! String
            let url = URL(string: sourceImg)
            cell.imgView.kf.setImage(with: url)
        }else{
          cell.imgView.image =  UIImage(named: "backimg")
           
        }
        
      
        let txt = changestr(stringTochange: render)
        cell.lblTitle.text = "   " + txt
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let newsVc = storyBrd.instantiateViewController(withIdentifier: "DetailNewsScrollVC") as! DetailNewsScrollVC
        
        
        self.DetaileNewsArr.removeAll(keepingCapacity: false)
        
        for (index,lcDict) in self.Top6LatesNews.enumerated()
        {
                let Link = lcDict["link"] as! String
                let titleNews = lcDict["title"] as! NSDictionary
                let renNews = titleNews["rendered"] as! String
                let cDate = lcDict["date"] as! String
                let contentNew = lcDict["content"] as! NSDictionary
                let renDetailDesc = contentNew["rendered"] as! String
            
            var sourceImg = ""
            if let imgDict = lcDict["better_featured_image"] as? NSDictionary
            {
                 sourceImg = imgDict["source_url"] as! String
                
            }else{
                sourceImg = ""
            }
                
            self.DetaileNewsArr.append(DetaileNews(date: cDate.datesetting(), title: renNews, url: sourceImg, DetailsDesc: renDetailDesc, nIndex: index, link: Link ))
            
            
        }
        
        newsVc.setImageToView(newsarr: self.DetaileNewsArr, nSelectedIndex: indexPath.row, nTotalNews: self.DetaileNewsArr.count)
    
        let appdel = UIApplication.shared.delegate as! AppDelegate
        
        
        let childVc =  appdel.window?.rootViewController?.childViewControllers[0] as! SWRevealViewController
        childVc.navigationController?.pushViewController(newsVc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collView.frame.width, height: 320)
        
    }
    
    @objc func scrollToNextCell()
    {
        
        let cellSize = self.collView.frame.size
        
        //get current content Offset of the Collection view
        let contentOffset = collView.contentOffset
        
        if collView.contentSize.width <= collView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            collView.scrollRectToVisible(r, animated: true)
            
        } else {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width + 10, height: cellSize.height)
            collView.scrollRectToVisible(r, animated: true);
        }
        
    }
    
    func startTimer()
    {
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(NewsTopCell.scrollToNextCell), userInfo: nil, repeats: true);
    }
    
    func changestr(stringTochange:String)-> String {
        
        let str = stringTochange.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let str1 = str.replacingOccurrences(of: "[&#1234567890;]", with: "", options: .regularExpression, range: nil)
        print(str1)
        return str1
        
    }
    

}

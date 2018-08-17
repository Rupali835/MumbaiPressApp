//
//  NewsTopCell.swift
//  MumbaiPressApp
//
//  Created by user on 27/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NewsTopCell: UITableViewCell, CollectionViewDelegateDataSourceFlowLayout
{

    @IBOutlet weak var collView: UICollectionView!
    var BreakingNewsArr = [AnyObject]()
    var TitleArr = NSMutableArray()
    
    let storyBrd = UIStoryboard(name: "Main", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()

        getNews()
        startTimer()

    }

    func setUp()
    {
        self.collView.delegate = self
        self.collView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func getNews()
    {
        let newUrl = "http://mumbaipress.com/wp-json/wp/v2/posts/?per_page=6&fields=title,id,better_featured_image"
        
        Alamofire.request(newUrl, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            self.BreakingNewsArr = resp.result.value as! [AnyObject]
            
            self.collView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.BreakingNewsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "ScrollableNewsCell", for: indexPath) as! ScrollableNewsCell
        
        let lcDict = self.BreakingNewsArr[indexPath.item]
        
        let Title = lcDict["title"] as! NSDictionary
        let render = Title["rendered"] as! String
        let imgDict = lcDict["better_featured_image"] as! NSDictionary
        let sourceImg = imgDict["source_url"] as! String
        
        cell.lblScrlollNews.text = render as! String
        
        self.img(lcURl: sourceImg, cell: cell)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let newsVc = storyBrd.instantiateViewController(withIdentifier: "DetailedNewsVC") as! DetailedNewsVC
        
        let lcDict = self.BreakingNewsArr[indexPath.row]
        
        let NewsId = lcDict["id"] as! Int
        let imgDict = lcDict["better_featured_image"] as! NSDictionary
        let sourceImg = imgDict["source_url"] as! String

        let Title = lcDict["title"] as! NSDictionary
        let render = Title["rendered"] as! String

        newsVc.setImageToView(cImgURl: sourceImg as! String, Id: NewsId)

        let appdel = UIApplication.shared.delegate as! AppDelegate
        
      
        let childVc =  appdel.window?.rootViewController?.childViewControllers[0] as! SWRevealViewController
        childVc.navigationController?.pushViewController(newsVc, animated: true)
      
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collView.frame.width, height: 172)
        
    }
    
    func img(lcURl: String, cell: ScrollableNewsCell)
    {
        Alamofire.request(lcURl, method: .get).responseImage { (resp) in
            print(resp)
            if let img = resp.result.value{
                
                DispatchQueue.main.async
                    {
                        cell.imgNews.image = img
                }
            }
            
            
        }
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


}

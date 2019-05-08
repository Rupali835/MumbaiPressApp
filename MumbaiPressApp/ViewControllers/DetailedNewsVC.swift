//
//  DetailedNewsVC.swift
//  MumbaiPressApp
//
//  Created by user on 27/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON

class DetailedNewsVC: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtDetailNews: UITextView!
    @IBOutlet weak var lblDetailNews: UILabel!
    @IBOutlet weak var imgDetailNews: UIImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        
//        var contentRect = CGRect.zero
//
//        for view in mainScrollView.subviews {
//            contentRect = contentRect.union(view.frame)
//        }
//        mainScrollView.contentSize = contentRect.size
//
    }

    func img(lcURl: String)
    {
        Alamofire.request(lcURl, method: .get).responseImage { (resp) in
            print(resp)
            if let img = resp.result.value{

                DispatchQueue.main.async
                    {
                        self.imgDetailNews.image = img
                }
            }


        }
    }
    
    func setImageToView(cImgURl : String, Id: Int)
    {
        self.img(lcURl: cImgURl)
        getDetailNews(newsId: Id)
    }

    func getDetailNews(newsId: Int)
   {
        let detailUrl = "https://www.mumbaipress.com/wp-json/wp/v2/posts/\(newsId)/?&fields=id,date,title,content"
    
    print(detailUrl)
    
    Alamofire.request(detailUrl, method: .get, parameters: nil).responseJSON { (resp) in
        print(resp)
        
        let json = JSON(resp.result.value as Any)
        
        let rendered = json["content"]["rendered"].stringValue
        
        let date = json["date"].stringValue
        let title = json["title"]["rendered"].stringValue
        self.lblDetailNews.text = title
        
       let str = rendered.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        self.changestr(stringTochange: str)
      
        self.lblDate.text = date
        
       }
    

    }
    
    func changestr(stringTochange:String)-> String {
        
        let str = stringTochange.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        let str1 = str.replacingOccurrences(of: "\n", with: "\n\n", options: .regularExpression, range: nil)
        
        self.txtDetailNews.text = str1
        
        return str1
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden = false
        customizeNavBar()
    }
    
    func customizeNavBar() {
        
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 87/255, blue: 35/255, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
  

}

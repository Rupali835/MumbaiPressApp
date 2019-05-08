//
//  CategoriesNewsDataVc.swift
//  MumbaiPressApp
//
//  Created by user on 28/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import GoogleMobileAds

class CategoriesNewsDataVc: UIViewController, TableViewDelegateDataSource {
   
    @IBOutlet weak var loaderView: DotsLoader!
    @IBOutlet weak var tblNEWS: UITableView!
    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    var NewsArr = [AnyObject]()
    var catname : String = ""
    var cat_id : Int = 0
    let storyBrd = UIStoryboard(name: "Main", bundle: nil)
    var DetaileNewsArr = [DetaileNews]()
    private var toast : JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        designCell(cView: ViewBar)
        
        self.loaderView.isHidden = false
        
       tblNEWS.register(UINib(nibName: "AdvitizeCell", bundle: nil), forCellReuseIdentifier: "AdvitizeCell")
        
        tblNEWS.register(UINib(nibName: "FirstNewsCell", bundle: nil), forCellReuseIdentifier: "FirstNewsCell")
        
        tblNEWS.register(UINib(nibName: "SecondNewsCell", bundle: nil), forCellReuseIdentifier: "SecondNewsCell")
        
        tblNEWS.delegate = self
        tblNEWS.dataSource = self
        
        self.tblNEWS.separatorStyle = .none
        self.tblNEWS.estimatedRowHeight = 140
        self.tblNEWS.rowHeight = UITableViewAutomaticDimension
    
        toast = JYToast()
    //    getCategoriedData()

    }

    
    func setId(CatId : Int, CatName : String)
    {
        //getCategoriedData(Id : CatId)
        
        self.cat_id = CatId
        self.catname = CatName
    }
    
    func setlang()
    {
         let setLanguage = UserDefaults.standard.integer(forKey: "ENG")
        
        switch setLanguage
        {
        case 1:
            
            let latestEnUrl = "https://www.mumbaipress.com/"
            self.getCategoriedData(url: latestEnUrl)
            break
        case 2:
            let latestHnUrl = "https://www.mumbaipress.com/hindi"
            self.getCategoriedData(url: latestHnUrl)
            break
        case 3 :
            let latestUrduUrl = "https://www.mumbaipress.com/urdu"
            self.getCategoriedData(url: latestUrduUrl)
            break
        default:
            let latestEnUrl = "https://www.mumbaipress.com/"
            self.getCategoriedData(url: latestEnUrl)
        }
    }
    
    func getCategoriedData(url : String)
    {
        let url = url + "/wp-json/wp/v2/posts/?categories=\(self.cat_id)&per_page=20&fields=id,date,title,content,better_featured_image,link"
       
        print(url)
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            self.loaderView.isHidden = true

            switch resp.result
            {
            case .success(let json):
                self.NewsArr = resp.result.value as! [AnyObject]
                self.tblNEWS.reloadData()
                break
                
            case .failure(let err):
                self.toast.isShow("failed")
                break
                
            }
         
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

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.NewsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       // self.NewsArr.removeAll(keepingCapacity: false)
        let lcDict = self.NewsArr[indexPath.item]
        
        let date = lcDict["date"] as! String
        let Title = lcDict["title"] as! NSDictionary
        let render = Title["rendered"] as! String
        
        if indexPath.row == 0
        {
            let cell = tblNEWS.dequeueReusableCell(withIdentifier: "FirstNewsCell", for: indexPath) as! FirstNewsCell
            
          let lcDict = self.NewsArr[indexPath.item]
            
            let imgDict = lcDict["better_featured_image"] as! NSDictionary
           
            if imgDict.count == 0
            {
                cell.imgNews.isHidden = false
                cell.imgNews.image = UIImage(named: "backimg")
                
            }
            else
            {
                let sourceImg = imgDict["source_url"] as! String
                let url = URL(string: sourceImg)
                cell.imgNews.kf.setImage(with: url)
            }
            
            let lcFormatStr = changestr(stringTochange: render)
            cell.lblTitle.text = lcFormatStr.replacingHTMLEntities!

            cell.lblDate.text = date.datesetting()
         
            cell.btnYoutube.isHidden = true
            return cell
            
        }
       else if indexPath.row % 5 == 0{
            print(indexPath.row)
            
            let cell = tblNEWS.dequeueReusableCell(withIdentifier: "AdvitizeCell", for: indexPath) as! AdvitizeCell
            
            cell.bannerView.adUnitID = "ca-app-pub-5349935640076581/1498791760"
            cell.bannerView.rootViewController = self
            cell.bannerView.load(GADRequest())
            
            return cell
            
        }
        
        else{
            
            let cell = tblNEWS.dequeueReusableCell(withIdentifier: "SecondNewsCell", for: indexPath) as! SecondNewsCell
            
            cell.lblDATE.text = date.datesetting()
        //    cell.lbltitle.text = changestr(stringTochange: render)
            
            let lcFormatStr = changestr(stringTochange: render)
            cell.lbltitle.text = lcFormatStr.replacingHTMLEntities!
            
            let lcDict = self.NewsArr[indexPath.item]
            
            let imgDict = lcDict["better_featured_image"] as! NSDictionary
            
            if imgDict.count != 0
            {
                let sourceImg = imgDict["source_url"] as! String
                let url = URL(string: sourceImg)
                cell.imgNewS.kf.setImage(with: url)

            }else{
                cell.imgNewS.image = UIImage(named: "backimg")
            }
            
            cell.btnyoutb.isHidden = true
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    {
        let newsVc = storyBrd.instantiateViewController(withIdentifier: "DetailNewsScrollVC") as! DetailNewsScrollVC
        
        
        self.DetaileNewsArr.removeAll(keepingCapacity: false)
        
        for (index,lcDict) in self.NewsArr.enumerated()
        {
            
            print("lcDictCount: \(lcDict.count)")
            print("lcDict: \(lcDict)")
            var sourceImg : String = ""
            let Link = lcDict["link"] as! String
            let titleNews = lcDict["title"] as! NSDictionary
            let renNews = titleNews["rendered"] as! String
            let cDate = lcDict["date"] as! String
            let contentNew = lcDict["content"] as! NSDictionary
            let renDetailDesc = contentNew["rendered"] as! String
            let imgDict = lcDict["better_featured_image"] as! NSDictionary
         //   let sourceImg = imgDict["source_url"] as! String
            
            if imgDict.count != 0
            {
                sourceImg = imgDict["source_url"] as! String
            }
//            else
//            {
//
//
//            }
 
            self.DetaileNewsArr.append(DetaileNews(date: cDate.datesetting(), title: renNews, url: sourceImg, DetailsDesc: renDetailDesc, nIndex: index, link: Link))
            
            
        }
        
        newsVc.setImageToView(newsarr: self.DetaileNewsArr, nSelectedIndex: indexPath.row, nTotalNews: self.DetaileNewsArr.count)
        
        let appdel = UIApplication.shared.delegate as! AppDelegate
        
        
        let childVc =  appdel.window?.rootViewController?.childViewControllers[0] as! SWRevealViewController
        childVc.navigationController?.pushViewController(newsVc, animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        sideMenus()
        customizeNavBar()
        setlang()
        
    }
    
    func customizeNavBar() {
        
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 87/255, blue: 35/255, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        if indexPath.row == 0
//        {
//            return 300
//        }
//        
//
//    }
   
 
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
    
    func changestr(stringTochange:String)-> String {
        
        let str = stringTochange.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//        let str1 = str.replacingOccurrences(of: "[&#1234567890;]", with: "", options: .regularExpression, range: nil)
//        print(str1)
        return str
        
    }
}

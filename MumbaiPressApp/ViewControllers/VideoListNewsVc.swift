//
//  VideoListNewsVc.swift
//  MumbaiPressApp
//
//  Created by user on 05/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Alamofire
import SwiftyJSON
import Kingfisher
import AVKit
import SHSnackBarView
import GoogleMobileAds


class VideoListNewsVc: UIViewController, YTPlayerViewDelegate, TableViewDelegateDataSource {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var Playerview: YTPlayerView!
    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tblVideo: UITableView!
    
    var ItemArr = [AnyObject]()
    var datearr:Array = [String]()
    var videoimagearr:Array = [String]()
    var titlearr:Array = [String]()
    var renderedurl:Array = [String]()
    var activityView = UIActivityIndicatorView()
    var firstvideo = String()
     let snackbarView = snackBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Playerview?.isHidden = true
    
     
        ViewBar.designCell()
       
        getVideo()
        tblVideo.delegate = self
        tblVideo.dataSource = self
        tblVideo.separatorStyle = .none
        tblVideo.register(UINib(nibName: "FirstNewsCell", bundle: nil), forCellReuseIdentifier: "FirstNewsCell")
        
        tblVideo.register(UINib(nibName: "SecondNewsCell", bundle: nil), forCellReuseIdentifier: "SecondNewsCell")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeplayer), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
       
        bannerView.adUnitID = "ca-app-pub-5349935640076581/1498791760"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

      
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func closeplayer(notification: NSNotification) {
        Playerview?.isHidden = true
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
    }
    

/////////***********       TABLEVIEW - METHODS     ******///////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.ItemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let lcDict = self.ItemArr[indexPath.item]
       
        let Snipet = lcDict["snippet"] as! NSDictionary
        let title = Snipet["title"] as! String
         let string = Snipet["publishedAt"] as! String
     
        let thumb = Snipet["thumbnails"] as! NSDictionary
        let imgRes = thumb["high"] as! NSDictionary
        let img = imgRes["url"] as! String
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let dateFo = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "MMM d, h:mm a"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: dateFo)
        
        
        if indexPath.row == 0
        {
            let cell = tblVideo.dequeueReusableCell(withIdentifier: "FirstNewsCell", for: indexPath) as! FirstNewsCell
            
           
            cell.lblDate.text = dateString
            cell.lblTitle.text = title as! String
            
            let url = URL(string: img)
            cell.imgNews.kf.setImage(with: url)
            cell.btnYoutube.isHidden = false
            
            cell.btnYoutube.tag = indexPath.row
             cell.btnYoutube.addTarget(self, action: #selector(playVideo(sender:)), for: .touchUpInside)
            
            
            return cell
        }else{
            
            let cell = tblVideo.dequeueReusableCell(withIdentifier: "SecondNewsCell", for: indexPath) as! SecondNewsCell
            
           cell.lblDATE.text = dateString
            cell.lbltitle.text = title
            
            let url = URL(string: img)
            cell.imgNewS.kf.setImage(with: url)
            
            cell.btnyoutb.isHidden = false
             cell.btnyoutb.tag = indexPath.row
             cell.btnyoutb.addTarget(self, action: #selector(playVideo(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func dateformat()
    {
        let string = "2017-01-27T18:36:36Z"
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let YoutubeUrl = "https://www.youtube.com/results?search_query="
        
        let lcDict = self.ItemArr[indexPath.row]
       // let VideoId = lcDict["videoId"] as! String
        let Snipet = lcDict["snippet"] as! NSDictionary
        let res = Snipet["resourceId"] as! NSDictionary
        let VideoId = res["videoId"] as! String
        
        Playerview?.isHidden = false
        tblVideo?.reloadData()
        Playerview?.load(withVideoId: VideoId)
        Playerview.playVideo()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 280
        }else{
            return 150
        }
    }
   
    @IBAction func btnPlay_onClick(_ sender: Any)
    {
        
    }
    

    @objc func orientationDidChange(notification: NSNotification) {
       // collView.collectionViewLayout.invalidateLayout()
        
    }
    
   
    
    @IBAction func playbutton(_sender:UIButton) {
        Playerview?.isHidden = false
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
     //   collView.reloadData()
        tblVideo.reloadData()
        Playerview?.load(withVideoId:firstvideo)
    }


    override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
    sideMenus()
    
}

    
    
////////////*************    EXTRA - METHODS  ***************//////////
    
    @objc func playVideo(sender: Any)
    {
        let YoutubeUrl = "https://www.youtube.com/results?search_query="
        

    }
   
    func getVideo()
    {
        let vidUrl = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=30&order=date&playlistId=UUkS_zQPVxu-Rj0JsuUusZHA&key=AIzaSyAedZVel7wh319vUgZcKeX-zPUlazeMEQw"
        
        Alamofire.request(vidUrl, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            let JSON = resp.result.value as! NSDictionary
            self.ItemArr = JSON["items"] as! [AnyObject]
            self.tblVideo.reloadData()
        }
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
    

}



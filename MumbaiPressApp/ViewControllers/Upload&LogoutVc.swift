//
//  Upload&LogoutVc.swift
//  MumbaiPressApp
//
//  Created by user on 13/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import AVFoundation
import AVKit

class Upload_LogoutVc: UIViewController, TableViewDelegateDataSource, CollectionViewDelegateDataSourceFlowLayout
{

    @IBOutlet var viewNews: UIView!
    @IBOutlet weak var lblShowDetail: UILabel!
    @IBOutlet weak var lblShowHeadline: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var viewUploadNews: UIView!
    
    
    var popUp : KLCPopup!
    var Data = [AnyObject]()
    var MediaArr = [String]()
    var imgArr = String()
    var vidArr = String()
    var audArr = String()
    var ReporterId : String = ""
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblData.delegate = self
        tblData.dataSource = self
        collView.delegate = self
        collView.dataSource = self

        self.ViewBar.designCell()
        self.viewUploadNews.designCell()
        self.viewLogout.designCell()
        
        let dict = UserDefaults.standard.array(forKey: "userdata") as! [AnyObject]
        ReporterId = dict[0]["mrp_id"] as! String
        print("ID==", ReporterId)
       print(ReporterId)
    
        self.tblData.separatorStyle = .none
        self.tblData.estimatedRowHeight = 80
        self.tblData.rowHeight = UITableViewAutomaticDimension
        
          popUp = KLCPopup()
        
    }
   
  ////////////*********    BUTTON - ACTION    **********////////////////
    
    @IBAction func btnUploadNews_Click(_ sender: Any)
    {
        let newsVc = self.storyboard?.instantiateViewController(withIdentifier: "AllUploadNewsVc") as! AllUploadNewsVc
        self.navigationController?.pushViewController(newsVc, animated: true)
    }
    
    @IBAction func btnLogout_Click(_ sender: Any)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
                self.logout()
            }
            
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    @objc func logout()
    {
       UserDefaults.standard.removeObject(forKey: "userdata")
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
        
          revealViewController().pushFrontViewController(loginVC, animated: true)
        
    }
    
  
    func getMediaData()
    {
        let dataUrl = "https://mumbaipress.com/wp-content/themes/mumbai_press/API/get_reporter_wise_news.php"
        let param : [String : Any] = ["reporter_id" : self.ReporterId]
        
        Alamofire.request(dataUrl, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            let JSON = resp.result.value as! NSDictionary
            
            let Msg = JSON["msg"] as! String
            if Msg == "SUCCESS"
            {
                self.Data = JSON["data"] as! [AnyObject]
            }else
            {
               let lbl = UILabel()
                lbl.text = "No Any Uploaded News"
               lbl.textAlignment = .center
            }
            self.tblData.reloadData()
        }
        
    }
 
    
 /////////////*********     TABLEVIEW - METHODS    ******////////////
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.Data.isEmpty == true{
            return 0
        }else{
            return self.Data.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblData.dequeueReusableCell(withIdentifier: "ShowReturnDataCell", for: indexPath) as! ShowReturnDataCell

        let lcDict = self.Data[indexPath.row]
        cell.backView.designCell()
        cell.lblHeadLine.text = lcDict["Headline"] as! String
        let Date = lcDict["Created_time"] as! String
        cell.lblDate.text = Date.datesetting()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let lcDict = self.Data[indexPath.row]
        popUp.contentView = viewNews
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        
        lblShowHeadline.text = (lcDict["Headline"] as! String)
        lblShowDetail.text = (lcDict["Report_details"] as! String)
        
        
        
          let lcImageName = self.getArrayFromJSonString(cJsonStr: lcDict["Image_name"] as! String)
        
        let lcVideoName = self.getArrayFromJSonString(cJsonStr: lcDict["Video_name"] as! String)
        
        let lcAudioName = self.getArrayFromJSonString(cJsonStr: lcDict["Audio_name"] as! String)
        
        for lcImage in lcImageName
        {
            if lcImage != "NF"
            {
                self.MediaArr.append(lcImage)
            }
        }
        
        for lcVid in lcVideoName
        {
            if lcVid != "NF"
            {
                self.MediaArr.append(lcVid)
            }
        }
        
        for lcAud in lcAudioName
        {
            if lcAud != "NF"
            {
                self.MediaArr.append(lcAud)
            }
        }

        self.collView.reloadData()
        

    }
    
   
    
 ///////////*******      COLLECTIONVIEW - METHODS   ******////////////
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 300, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.MediaArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "NewsPopUpCell", for: indexPath) as! NewsPopUpCell
        cell.lblRecords.text = self.MediaArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let lcMediyaType = self.MediaArr[indexPath.row]
        let fileExtension = lcMediyaType.fileExtension()
        print(fileExtension)
        
        if ((fileExtension == "JPG") || (fileExtension == "png") || (fileExtension == "JPEG"))
        {
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "ReporterDataVC") as! ReporterDataVC
            
            vc.setData(img: lcMediyaType)
           popUp.dismiss(true)
            
            let appdel = UIApplication.shared.delegate as! AppDelegate
            
            let childVc =  appdel.window?.rootViewController?.childViewControllers[0] as! SWRevealViewController
            childVc.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if fileExtension == "m4a"
        {
            let AudioPath = "https://www.mumbaipress.com/wp-content/uploads/repoter_news/audio/" + "\(lcMediyaType)"
           print(AudioPath)
            let url = URL(string: AudioPath)
          print(url)
            
            play(url!)
            
        }else{
            
            let VideoPath = "https://www.mumbaipress.com/wp-content/uploads/repoter_news/video/" + "\(lcMediyaType)"
            popUp.dismiss(true)
            let url = URL(string: VideoPath)
            let player = AVPlayer(url: url!)
            let vcPlayer = AVPlayerViewController()
            vcPlayer.player = player
            self.present(vcPlayer, animated: true, completion: nil)
        }
        
    }
    
    
    
//    https://www.mumbaipress.com/wp-content/uploads/repoter_news/image/
//    https://www.mumbaipress.com/wp-content/uploads/repoter_news/video/
    
    
    
    @IBAction func BtnOk_Click(_ sender: Any)
    {
        popUp.dismiss(true)
    }
  
    
    
/////////////*********      EXTRA - METHODS     ******///////////////////
    
    
    func getArrayFromJSonString(cJsonStr: String)->[String]
    {
        let jsonData = cJsonStr.data(using: .utf8)!
        
        guard let lcArrData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [String] else {
            return ["NF"]
        }
        
        return lcArrData
    }
    
    func setMedia(Iarr: String, Varr: String, Aarr: String)
    {
        self.imgArr = Iarr
        self.vidArr = Varr
        self.audArr = Aarr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        sideMenus()
        getMediaData()
        
    }
    
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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

    func play(_ url: URL)
    {
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            self.player = nil
            print(error.localizedDescription)
            print("AVAudioPlayer init failed")
        }

    }
}

extension String {
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}

//
//  HomePageVC.swift
//  MumbaiPressApp
//
//  Created by user on 01/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SHSnackBarView
import Kingfisher
import GoogleMobileAds

enum eLanguageType : Int
{
    case LT_INVALID = 0
    case LT_ENGLISH = 1
    case LT_HINDI   = 2
    case LT_URDU    = 3

}
class DetaileNews: NSObject
{
    var date: String!
    var title: String!
    var url: String
    var DetailsDesc: String
    var Index: Int!
    var Link : String!
    
    init(date: String, title: String, url: String,DetailsDesc: String,nIndex: Int, link: String)
    {
        self.date   = date
        self.title  = title
        self.url    = url
        self.DetailsDesc = DetailsDesc
        self.Index = nIndex
        self.Link = link
    }
}

class HomePageVC: UIViewController,TableViewDelegateDataSource, SecondNewsCellDelegate, FirstNewCellDelegate,UIGestureRecognizerDelegate
{
    @IBOutlet var viewLanguage: UIView!
    @IBOutlet weak var btn_Urdu: UIButton!
    @IBOutlet weak var btn_hindi: UIButton!
    @IBOutlet weak var btnEnglish: UIButton!
    @IBOutlet weak var tblNews: UITableView!
    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var menuButton: MKButton!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var loaderView: DotsLoader!
    
    var popUp = KLCPopup()
    let snackbarView = snackBar()
    var SectionTitleArr = [String]()
    
    let storyBrd = UIStoryboard(name: "Main", bundle: nil)
    
    var NewsArr = [AnyObject]()
    var ShowSearch = Bool(false)
    var PoliticsNewArr = [AnyObject]()
    var AllDataArr = [AnyObject]()
    
    var MainDataArr = [AnyObject]()
    
    var DetaileNewsArr = [DetaileNews]()
    
    var m_eLanguageType = eLanguageType.LT_INVALID
    var SelectedIndex = Int(-1)
    var selectedIndexPath = Int(-1)
    var BreakingNewsArr = [AnyObject]()
    var latestNews = [AnyObject]()
    var BreakingArr = [AnyObject]()
    
    var bFirstSection = Bool(true)
    var DateStr = Date()
  
    var ColorArr = [UIColor]()
  //  let dotView : DotsLoader! = nil
    
    @IBOutlet weak var viewInfo: UIView!
    
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SelectedIndex = -1
        selectedIndexPath = -1
        bFirstSection = true
        self.loaderView.isHidden = false

        
        self.ColorArr = [Color.MKColor.Red.P400, Color.MKColor.Blue.P400, Color.MKColor.Orange.P400, Color.MKColor.Green.P400, Color.MKColor.Indigo.P400, Color.MKColor.Amber.P400, Color.MKColor.LightBlue.P400, Color.MKColor.BlueGrey.P400, Color.MKColor.Brown.P400, Color.MKColor.Cyan.P400, Color.MKColor.Teal.P400, Color.MKColor.Lime.P400, Color.MKColor.Pink.P400, Color.MKColor.Brown.P400, Color.MKColor.Purple.P400]
        
        if isConnectedToNetwork()
        {
           self.ViewBar.isHidden = false
            
         //  popUp = KLCPopup()
           self.designView(cView: self.ViewBar)
            
            tblNews.register(UINib(nibName: "FirstNewsCell", bundle: nil), forCellReuseIdentifier: "FirstNewsCell")
            
            tblNews.register(UINib(nibName: "SecondNewsCell", bundle: nil), forCellReuseIdentifier: "SecondNewsCell")
            
            tblNews.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            
           
            tblNews.dataSource = self
             tblNews.delegate   = self
            
            self.tblNews.separatorStyle = .none
            self.tblNews.estimatedRowHeight = 80
            self.tblNews.rowHeight = UITableViewAutomaticDimension
            
            setFirstData()
            
            let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            dismissKeyboardGesture.delegate = self
            self.tblNews.addGestureRecognizer(dismissKeyboardGesture)
            
        }else{
            
            self.ViewBar.isHidden = true
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "No internet connection", textColor: UIColor.white, interval: 2)
        }
    
// Show ads
        
        bannerView.adUnitID = "ca-app-pub-5349935640076581/1498791760"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
      
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.tblNews))!{
            return false
        }
        
        return true
    }
    
    func getLatestNews(url : String)
    {
       // var latestNew = [AnyObject]()
        let newUrl = url + "wp-json/wp/v2/posts/?per_page=12&fields=title,id,date,link,content,better_featured_image"
        
        self.latestNews.removeAll(keepingCapacity: false)
        self.BreakingArr.removeAll(keepingCapacity: false)
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = . reloadIgnoringLocalAndRemoteCacheData
        
        var req = URLRequest(url: URL(string: newUrl)!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        Alamofire.request(req).validate().responseJSON { (response) in
         
            print(response)
            
           // self.loaderView.stopAnimating()
            
            if let lcBreakingNews = response.result.value
            {
                self.BreakingNewsArr = lcBreakingNews as! [AnyObject]
            }
        
            if self.BreakingNewsArr.isEmpty == false
            {
                for (index, value) in self.BreakingNewsArr.enumerated()
                {
                    if index >= 6
                    {
                        self.latestNews.append(value)
                    }else{
                        self.BreakingArr.append(value)
                    }
                }
                
            }else
            {
                let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "No Any news in selected language, Please change the language", textColor: UIColor.white, interval: 2)
            }

            self.getCategoryList(url: url)

        }
    }

    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func designView(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden = true

        sideMenus()
        customizeNavBar()
     }
    
    func setFirstData()
    {
        let setLanguage = UserDefaults.standard.integer(forKey: "ENG")
        
        switch setLanguage
        {
        case 1:
            self.SelectedLanguage(languagePath: "en")
            let latestEnUrl = "https://www.mumbaipress.com/"
            self.getLatestNews(url: latestEnUrl)
            break
            
        case 2:
            self.SelectedLanguage(languagePath: "hi-IN")
            let latestHinUrl = "https://www.mumbaipress.com/hindi/"
            self.getLatestNews(url: latestHinUrl)
            break
            
        case 3:
            self.SelectedLanguage(languagePath: "ur-IN")
            let latestUrduUrl = "https://www.mumbaipress.com/urdu/"
            self.getLatestNews(url: latestUrduUrl)
            break
            
        default:
            self.SelectedLanguage(languagePath: "en")
            let latestDeUrl = "https://www.mumbaipress.com/"
            self.getLatestNews(url: latestDeUrl)
            break
        }
    }
    
    func sideMenus()
    {
        revealViewController().navigationController?.navigationBar.isHidden = true
        if revealViewController() != nil {
            
            self.menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            revealViewController().rightViewRevealWidth = 110
         }
    }
    
    func customizeNavBar() {
        
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 87/255, blue: 35/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    func getCategoryList(url : String)
    {
        let CategoryUrl = url + "wp-json/wp-api-menus/v2/menus/169"
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = . reloadIgnoringLocalAndRemoteCacheData
        var req = URLRequest(url: URL(string: CategoryUrl)!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        Alamofire.request(req).validate().responseJSON { (response) in
            print(response)
            

          guard let data = response.result.value as? NSDictionary else { return }
            //let data = response.result.value as! NSDictionary
            let TitleArr = data["items"] as! [AnyObject]
            
            self.SectionTitleArr.removeAll(keepingCapacity: false)
            self.AllDataArr.removeAll(keepingCapacity: false)
            
            self.SectionTitleArr.append("Breaking News")
            self.SectionTitleArr.append("Latest News")
            
            self.SelectedIndex = self.latestNews.count - 1
            
            for dictTitle in TitleArr
            {
                let Cat_id = dictTitle["categories_id"] as! Int
                let Cat_name = dictTitle["title"] as! String
                
                let setLanguage = UserDefaults.standard.integer(forKey: "ENG")
                
                switch setLanguage
                {
                case 1:
                    self.SelectedLanguage(languagePath: "en")
                    
                    let URl = "https://www.mumbaipress.com/wp-json/wp/v2/posts/?categories="

                    self.getNews(catId: Cat_id, Url: URl,catName: Cat_name)
                    
                    break
                    
                case 2:
                    self.SelectedLanguage(languagePath: "hi-IN")
                    let URl = "https://www.mumbaipress.com/hindi/wp-json/wp/v2/posts/?categories="
                    
                    self.getNews(catId: Cat_id, Url: URl,catName: Cat_name)
                    
                    break
                    
                case 3:
                    self.SelectedLanguage(languagePath: "ur-IN")
                    let URl = "https://www.mumbaipress.com/urdu/wp-json/wp/v2/posts/?categories="
                    
                    self.getNews(catId: Cat_id, Url: URl,catName: Cat_name)
                    
                    break
                    
                default:
                    self.SelectedLanguage(languagePath: "en")
                    let URl = "https://www.mumbaipress.com/wp-json/wp/v2/posts/?categories="
                    
                    self.getNews(catId: Cat_id, Url: URl,catName: Cat_name)
                    break
                }
                
            }
            
            //self.tblNews.reloadData()
        }
      
    }
    
    func getRandomColor() -> UIColor{
     //   Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 0.9)
    }
    
    func getNews(catId: Int, Url: String,catName:String)
    {

           let finalUrl = Url + "\(catId)&per_page=5&fields=id,date,title,content,better_featured_image,link"
     
        print(finalUrl)
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = . reloadIgnoringLocalAndRemoteCacheData
        
        var req = URLRequest(url: URL(string: finalUrl)!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        Alamofire.request(req).validate().responseJSON { (response) in
            print(response)
          
            self.loaderView.stopAnimating()

            self.loaderView.isHidden = true

        guard let Response = response.result.value else{
                return
            }
            
            self.PoliticsNewArr = Response as! [AnyObject]
        
                self.tblNews.isHidden = false
                self.ViewBar.isHidden = false
                self.MainDataArr.removeAll(keepingCapacity: false)
            if !self.PoliticsNewArr.isEmpty
            {
                self.SectionTitleArr.append(catName)
            }
                for (_,lcDict) in self.PoliticsNewArr.enumerated()
                {
                    self.SelectedIndex += 1
                    var DictData = lcDict as! [String : AnyObject]
                    
                    DictData["IndexValue"] = self.SelectedIndex as AnyObject
                    print("\(DictData["IndexValue"])")
                    self.MainDataArr.append(DictData as AnyObject)
                   
                }
            
            if self.MainDataArr.isEmpty == false
            {
                self.AllDataArr.append(self.MainDataArr as AnyObject)
                self.tblNews.reloadData()
            }
             
            
            }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        print("sectionCount= \(SectionTitleArr.count)")
        return SectionTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return SectionTitleArr[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(self.PoliticsNewArr.count)
        if section == 0
        {
            return 1
        }else {
           if section == 1
           {
             return self.latestNews.count
           }else{
            if self.PoliticsNewArr.count > 1
            {
                return self.PoliticsNewArr.count
            }
            
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         var sourceImg : String = ""
        
        if indexPath.section == 0     // show breaking news
        {
            let cCollectionViewCell = tblNews.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionViewCell
           cCollectionViewCell.SetData(TopNewsData: BreakingArr)
            return cCollectionViewCell
            
        }else if indexPath.section == 1   // show latest news
        {
           
            let DictData = self.latestNews[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondNewsCell", for: indexPath) as! SecondNewsCell
            
            let titleNews = DictData["title"] as! NSDictionary
            let renNews = titleNews["rendered"] as! String
           
             
           if let imgDict = DictData["better_featured_image"] as? NSDictionary
           {
            cell.delegate = self
            if imgDict.count != 0
            {
                sourceImg = imgDict["source_url"] as! String
                let url = URL(string: sourceImg)
                cell.imgNewS.kf.setImage(with: url)
                
            }
           }
            else{
                cell.imgNewS.image = UIImage(named: "backimg")
            }
            
            
            let url = URL(string: sourceImg)
            cell.imgNewS.kf.setImage(with: url)
            let cDate = DictData["date"] as! String
            cell.lblDATE.text = cDate.datesetting()
           let lcFormatStr = changestr(stringTochange: renNews)
             cell.lbltitle.text = lcFormatStr.replacingHTMLEntities!
            cell.btnyoutb.isHidden = true
            
            return cell
            
        }else{
          if indexPath.section >= 2
            {
                print("indexPath.section =\(indexPath.section)")
                print("indexPath.section - 2 =\(indexPath.section - 2)")
                if indexPath.section - 2 < self.AllDataArr.count
                {
                    var lcDataArr = self.AllDataArr[indexPath.section - 2] as! [AnyObject]
            
                if indexPath.row == 0
                {
                    
                    let DictData = lcDataArr[indexPath.row]
                    
                    let cell = tblNews.dequeueReusableCell(withIdentifier: "FirstNewsCell", for: indexPath) as! FirstNewsCell
                    cell.delegate = self
                    let titleNews = DictData["title"] as! NSDictionary
                    let renNews = titleNews["rendered"] as! String
                    let cDate = DictData["date"] as! String
                    
                   
                    if let imgDict = DictData["better_featured_image"] as? NSDictionary
                    {
                        sourceImg = imgDict["source_url"] as! String
                        let url = URL(string: sourceImg)
                        cell.imgNews.kf.setImage(with: url)
                        
                    }else{
                          cell.imgNews.image = UIImage(named: "backimg")
                    }
                    
                    let url = URL(string: sourceImg)
                    cell.imgNews.kf.setImage(with: url)
                
                    cell.btnYoutube.isHidden = true
                    let index = DictData["IndexValue"] as! Int
                    cell.imgNews.tag = index
                    cell.lblDate.text = cDate.datesetting()
                    let lcFormatStr = changestr(stringTochange: renNews)
                    cell.lblTitle.text = lcFormatStr.replacingHTMLEntities!
                    return cell
                }else
                {
                    
                    let DictData = lcDataArr[indexPath.row]
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SecondNewsCell", for: indexPath) as! SecondNewsCell
                    
                    let titleNews = DictData["title"] as! NSDictionary
                    let renNews = titleNews["rendered"] as! String
                    let cDate = DictData["date"] as! String
                    
                    let imgDict = DictData["better_featured_image"] as! NSDictionary
                    cell.delegate = self
                    if imgDict.count != 0
                    {
                        sourceImg = imgDict["source_url"] as! String
                        let url = URL(string: sourceImg)
                        cell.imgNewS.kf.setImage(with: url)
                        
                        
                    }else{
                        cell.imgNewS.image = UIImage(named: "backimg")
                    }

                    let url = URL(string: sourceImg)
                    cell.imgNewS.kf.setImage(with: url)
               
                    let index = DictData["IndexValue"] as! Int
                    cell.btnyoutb.isHidden = true
                    cell.imgNewS.tag = index
                    
                    cell.lblDATE.text = cDate.datesetting()
                    let lcFormatStr = changestr(stringTochange: renNews)
                    cell.lbltitle.text = lcFormatStr.replacingHTMLEntities!
                    return cell
                }
              }
            }else
            {
                self.tblNews.isHidden = true
                let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "No Any news in Urdu, Please change the language", textColor: UIColor.white, interval: 2)
            }
          }
        return UITableViewCell()
     
}

     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {

        
        let header = view as! UITableViewHeaderFooterView
     //   header.backgroundView?.backgroundColor = getRandomColor()
    
        let randomColor = ColorArr[Int(arc4random_uniform(UInt32(ColorArr.count)))]
        
        header.backgroundView?.backgroundColor = randomColor
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont(name: "Raleway-SemiBold", size: 22)
        header.textLabel?.textAlignment = .center

    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {

      if indexPath.section == 0
     {
        return 200.0
      }else if indexPath.section == 1
      {
        return 150
      }else {
          if indexPath.row == 0
          {
            return 280
          }else{
            return 150
           }
        }
    }
   
    func SetData(lcDict: NSDictionary, index: Int)
    {
        var sourceImg = String()
            let Link = lcDict["link"] as! String
            let titleNews = lcDict["title"] as! NSDictionary
            let renNews = titleNews["rendered"] as! String
            let cDate = lcDict["date"] as! String
            let contentNew = lcDict["content"] as! NSDictionary
            let renDetailDesc = contentNew["rendered"] as! String
        
        
        let imgDict = lcDict["better_featured_image"] as! NSDictionary
        
        if imgDict.count != 0
        {
            sourceImg = imgDict["source_url"] as! String
        }else{
            sourceImg = ""
        }
        
        self.DetaileNewsArr.append(DetaileNews(date: cDate.datesetting(), title: renNews, url: sourceImg, DetailsDesc: renDetailDesc, nIndex: index, link: Link))
        
    }
    
    func PassNewsAllData(lcAllData: [AnyObject])
   {
        for (_,Value) in lcAllData.enumerated()
        {
        let lcData = Value as! [AnyObject]
        
        for (index,lcDict) in lcData.enumerated()
        {
            SetData(lcDict: lcDict as! NSDictionary, index: index)
         }
       }
   }
    
    func PassData(lcAllData: [AnyObject])
    {
        for (index,lcDict) in lcAllData.enumerated()
        {
            SetData(lcDict: lcDict as! NSDictionary, index: index)
        }
    }
    
    @IBAction func btnLanguage_click(_ sender: Any)
    {
        popUp.contentView = viewLanguage
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
    popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }
    
    func SelectedLanguage(languagePath: String)
    {
        let path = Bundle.main.path(forResource: languagePath, ofType: "lproj")
        let bundal = Bundle.init(path: path!)
     
        homeKey = (bundal?.localizedString(forKey: "Home", value: nil, table: nil))!
        VideoKey = (bundal?.localizedString(forKey: "Video", value: nil, table: nil))!
        ReporterKey = (bundal?.localizedString(forKey: "Reporter", value: nil, table: nil))!
        AboutUsKey = (bundal?.localizedString(forKey: "About", value: nil, table: nil))!
        TermsKey = (bundal?.localizedString(forKey: "Term", value: nil, table: nil))!
        DisclaimerKey = (bundal?.localizedString(forKey: "Disclaimer", value: nil, table: nil))!
        ContactKey = (bundal?.localizedString(forKey: "Contact", value: nil, table: nil))!
        UploadKey = (bundal?.localizedString(forKey: "Upload", value: nil, table: nil))!
        TodaysNewsKey = (bundal?.localizedString(forKey: "TodaysNews", value: nil, table: nil))!
         ImpLinksKey = (bundal?.localizedString(forKey: "ImportantLinks", value: nil, table: nil))!
         LoginKey = (bundal?.localizedString(forKey: "Login", value: nil, table: nil))!
         NewsKey = (bundal?.localizedString(forKey: "ReportSection", value: nil, table: nil))!
         UpdateNews = (bundal?.localizedString(forKey: "UpdateNews", value: nil, table: nil))!

    }
    
    @IBAction func btnOK_languageClick(_ sender: Any)
    {
        popUp.dismiss(true)
        self.loaderView.isHidden = false
        self.loaderView.startAnimating()

        switch m_eLanguageType.rawValue
        {
        case 1:
            SelectedLanguage(languagePath: "en")
            UserDefaults.standard.set(1, forKey: "ENG")
            //getCategoryList(url: "https://www.mumbaipress.com/")
            getLatestNews(url: "https://www.mumbaipress.com/")
            break
            
        case 2:
            SelectedLanguage(languagePath: "hi-IN")
            UserDefaults.standard.set(2, forKey: "ENG")
            //getCategoryList(url: "https://www.mumbaipress.com/hindi/")
            getLatestNews(url: "https://www.mumbaipress.com/hindi/")
            
            break
            
        case 3:
            SelectedLanguage(languagePath: "ur-IN")
            UserDefaults.standard.set(3, forKey: "ENG")
           // getCategoryList(url: "https://www.mumbaipress.com/urdu/")
            getLatestNews(url: "https://www.mumbaipress.com/urdu/")
        //   setupGlobalAppearance()
            break
            
        default:
            print("")
        }
        
    }
    
    @IBAction func btnSearch_OnClick(_ sender: Any)
    {
        let searchVc = storyBrd.instantiateViewController(withIdentifier: "TestSearchVC") as! TestSearchVC
        
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
    
    @IBAction func btnEnglish_click(_ sender: Any)
    {
      m_eLanguageType = eLanguageType.LT_ENGLISH
        
       btnEnglish.backgroundColor = UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
        btn_Urdu.backgroundColor = UIColor.clear
        btn_hindi.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnHindi_click(_ sender: Any)
    {
       
       m_eLanguageType = eLanguageType.LT_HINDI
        
        btn_hindi.backgroundColor = UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
        btnEnglish.backgroundColor = UIColor.clear
        btn_Urdu.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnUrdu_click(_ sender: Any)
    {
      //  setupGlobalAppearance()
        m_eLanguageType = eLanguageType.LT_URDU
        
        btn_Urdu.backgroundColor = UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
        btnEnglish.backgroundColor = UIColor.clear
        btn_hindi.backgroundColor = UIColor.clear
    }
    
    func setupGlobalAppearance(){
        
        //global Appearance settings
//        let customFont = UIFont.appRegularFontWith(size: 17)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: customFont], for: .normal)
//        UITextField.appearance().substituteFontName = .App.regularFont
//        UILabel.appearance().substituteFontName = Constants.App.regularFont
//        UILabel.appearance().substituteFontNameBold = Constants.App.boldFont
        
        
//        let customFont = UIFont.init(name: "Fajer Noori Nastalique", size: 18)
//
//
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: customFont!], for: .normal)
        
       
        UILabel.appearance().font = UIFont(name: "Fajer Noori Nastalique", size: 18)
        
        UITextField.appearance().font = UIFont(name: "Fajer Noori Nastalique", size: 18)
        
        UITextView.appearance().font = UIFont(name: "Fajer Noori Nastalique", size: 18)
        
//        UILabel.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Fajer Noori Nastalique"))
//
//        UITextView.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Fajer Noori Nastalique"))
//
//         UITextField.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Fajer Noori Nastalique"))
        
        
        
    }
    
    
    
    ///////////////   TIME- FUNCTIONS     ///////////////////////
    
   
    func getDate(dateString: String) -> NSDate? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //Getting this right is very important!
        guard let date = dateFormatter.date(from: "\(dateString)") else {
            //handle error
            return nil
        }
        return DateStr as NSDate
    }

    func changestr(stringTochange:String)-> String {
        
        let str = stringTochange.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
      //  let str1 = str.replacingOccurrences(of: "[&#1234567890;]", with: "", options: .regularExpression, range: nil)
       // print(str1)
        return str
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected")
        sendDataToNext(indexPath: indexPath)
    }
    
    func didSelected(_ sender: SecondNewsCell)
    {
        guard let indexPath = tblNews.indexPath(for: sender) else { return }
        sendDataToNext(indexPath: indexPath)
    }
    
    
    func didSelectedFirstCell(_ sender: FirstNewsCell)
    {
        guard let indexPath = tblNews.indexPath(for: sender) else { return }
        sendDataToNext(indexPath: indexPath)
    }
    
    func sendDataToNext(indexPath: IndexPath)
    {
     
        self.DetaileNewsArr.removeAll(keepingCapacity: false)
        self.PassData(lcAllData: self.latestNews)
        self.PassNewsAllData(lcAllData: self.AllDataArr)
        
        let lcNewCnt = self.DetaileNewsArr.count
        
        if indexPath.section == 1
        {
            selectedIndexPath = indexPath.row
        }else{
            if indexPath.row == 0
            {
                let cell = tblNews.cellForRow(at: indexPath) as! FirstNewsCell
                selectedIndexPath = cell.imgNews.tag
            }else{
                let cell = tblNews.cellForRow(at: indexPath) as! SecondNewsCell
                selectedIndexPath = cell.imgNewS.tag
            }
        }
        
        
        let newsVc = storyBrd.instantiateViewController(withIdentifier: "DetailNewsScrollVC") as! DetailNewsScrollVC
        
        newsVc.setImageToView(newsarr: self.DetaileNewsArr , nSelectedIndex: selectedIndexPath, nTotalNews: lcNewCnt )
        
        let appdel = UIApplication.shared.delegate as! AppDelegate
        
        let childVc =  appdel.window?.rootViewController?.childViewControllers[0] as! SWRevealViewController
        childVc.navigationController?.pushViewController(newsVc, animated: true)
    }
    
}

extension String {
    var replacingHTMLEntities: String? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil).string
        } catch {
            return nil
        }
    }
}


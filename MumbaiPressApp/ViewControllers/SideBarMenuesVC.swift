//
//  SiswMenuesVC.swift
//  MumbaiPressApp
//
//  Created by user on 15/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

enum eMenuItemType : Int
{
    case MT_INVALID   = 0
    case MT_HOME      = 1
    case MT_ABOUTUS   = 2
    case MT_TERMS     = 3
    case MT_REPORTER  = 4
    case MT_LOGIN     = 5
    case MT_DISCLAIMER  = 6
    case MT_CONTACTS    = 7
    case MT_UPDATESNEWS = 8
    case MT_IMPLINKS  = 9
    case MT_HINDI    = 10
    case MT_URDU     = 11
    case MDT_ALLAPIMENU = 12
    case MD_VIDEOLIST   = 13
    case MD_AUDIOLIST   = 14
    case MD_REPORTSECTION  = 15
    case MD_TODAYSNEWS  = 16
    
}

class MenuItem : NSObject
{
    var m_cMenuName : String?
    var m_bCanBeExapanded  = false     // Bool to determine whether the cell can be expanded
    var m_bIsExapanded     = false    // it is already exapnd
    var m_nLevel           : Int?
    var m_eFTMenuItemType  = eMenuItemType.MT_INVALID
    var m_cParrentMenu     : MenuItem?
    var m_cData            : NSObject?
    var m_cSubMenuArray    : [MenuItem] = [MenuItem]()
    var m_nCategoryId      : Int?
    
    override init()
    {
        self.m_cMenuName    = ""
        self.m_bCanBeExapanded  = false     // Bool to determine whether the cell can be expanded
        self.m_bIsExapanded     = false    // it is already exapnd
        self.m_nLevel           =  0
        self.m_eFTMenuItemType  = eMenuItemType.MT_INVALID
        self.m_cParrentMenu     = nil
        self.m_cSubMenuArray    = [MenuItem]()
        self.m_nCategoryId      = 0
    }
    
    init(cMenuname : String, nLevel : Int, cParrentMenu : MenuItem?, eFTMenuItemType : eMenuItemType,nCategoryId : Int)
    {
        self.m_cMenuName    = cMenuname
        self.m_bCanBeExapanded  = false     // Bool to determine whether the cell can be expanded
        self.m_bIsExapanded     = false    // it is already exapnd
        self.m_nLevel           =  nLevel
        self.m_eFTMenuItemType  =   eFTMenuItemType
        self.m_cParrentMenu     = cParrentMenu
        self.m_cSubMenuArray    = [MenuItem]()
        self.m_nCategoryId      = nCategoryId
    }
}


class SideBarMenusVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var SideBarTbl: UITableView!
    @IBOutlet weak var MainView: UIView!
    
    var m_cMenuItemArr = [MenuItem]()
  
    var subTitle : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SideBarTbl.dataSource = self
        self.SideBarTbl.delegate    = self
        
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        
        self.SideBarTbl.register(nib, forCellReuseIdentifier: "MenuCell")
        
        self.SideBarTbl.estimatedRowHeight = 140
        self.SideBarTbl.rowHeight = UITableViewAutomaticDimension

      
        
    }
    
    func SelectedLanguage(languagePath: String)
    {
        let path = Bundle.main.path(forResource: languagePath, ofType: "lproj")
        let bundal = Bundle.init(path: path!)
    
    }
    
    func getCategoryList(url: String)
    {
        let CategoryUrl = url
        
        Alamofire.request(CategoryUrl, method: .get, parameters: nil).responseJSON { (resp) in
            
            let data = resp.result.value as! [String : AnyObject]
            let TitleArr = data["items"] as! [AnyObject]
            
            self.m_cMenuItemArr.removeAll(keepingCapacity: false)
            
            let lcHome = MenuItem(cMenuname: homeKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_HOME, nCategoryId : 0)
            self.m_cMenuItemArr.append(lcHome)
            
            let lcUpdatedNews = MenuItem(cMenuname: UpdateNews, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_UPDATESNEWS, nCategoryId : 0)
            self.m_cMenuItemArr.append(lcUpdatedNews)
            
            
            let lcVideo = MenuItem(cMenuname: VideoKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MD_VIDEOLIST, nCategoryId: 0)
             self.m_cMenuItemArr.append(lcVideo)
            
            let lcTodaysNews = MenuItem(cMenuname: TodaysNewsKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MD_TODAYSNEWS, nCategoryId: 0)
             self.m_cMenuItemArr.append(lcTodaysNews)
            
           

            for DictItem in TitleArr
            {
                let lcMenuItem = MenuItem(cMenuname: DictItem["title"] as! String, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MDT_ALLAPIMENU, nCategoryId : DictItem["categories_id"] as! Int)
                
                let ChildrenArr = DictItem["children"] as! [AnyObject]
                
                if ChildrenArr.isEmpty == false
                {
                    lcMenuItem.m_bCanBeExapanded = true
                    lcMenuItem.m_cSubMenuArray.removeAll(keepingCapacity: false)
                    for (_,SubDictItem) in ChildrenArr.enumerated()
                    {
                        
                        let lcSubMenuItem = MenuItem(cMenuname: SubDictItem["title"] as! String, nLevel: 1, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MDT_ALLAPIMENU, nCategoryId : SubDictItem["categories_id"] as! Int)
                        
                        lcMenuItem.m_cSubMenuArray.append(lcSubMenuItem)
                    }
                    
                }
                
                self.m_cMenuItemArr.append(lcMenuItem)
            
            }
            
            let lcImpLinks = MenuItem(cMenuname: ImpLinksKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_IMPLINKS, nCategoryId : 0)
             self.m_cMenuItemArr.append(lcImpLinks)
            
            let lcAboutUs = MenuItem(cMenuname: AboutUsKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_ABOUTUS, nCategoryId : 0)
            self.m_cMenuItemArr.append(lcAboutUs)
            
            let lcTerms = MenuItem(cMenuname: TermsKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_TERMS, nCategoryId : 0)
            self.m_cMenuItemArr.append(lcTerms)

            
            let lcDisclaimer = MenuItem(cMenuname: DisclaimerKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_DISCLAIMER, nCategoryId : 0)
            self.m_cMenuItemArr.append(lcDisclaimer)

            
            let lcContacts = MenuItem(cMenuname: ContactKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_CONTACTS, nCategoryId : 0)
            self.m_cMenuItemArr.append(lcContacts)
 
           
            let result = UserDefaults.standard.array(forKey: "userdata") as? [AnyObject]
            if result != nil
            {
                 let lcLogin = MenuItem(cMenuname: NewsKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_LOGIN, nCategoryId : 0)
                  self.m_cMenuItemArr.append(lcLogin)
                
           
            }else
            {
                let lcReporter = MenuItem(cMenuname: ReporterKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_REPORTER, nCategoryId : 0)
                self.m_cMenuItemArr.append(lcReporter)

                
                let lcLogin = MenuItem(cMenuname: LoginKey, nLevel: 0, cParrentMenu: nil, eFTMenuItemType: eMenuItemType.MT_LOGIN, nCategoryId : 0)
                  self.m_cMenuItemArr.append(lcLogin)
                
            }
            
            DispatchQueue.main.async {
                self.SideBarTbl.reloadData()
            }
            
        }
        
    }
    
    
    func ExpandCellsFromIndexOf(cFTMenuItem: MenuItem, cIndexPath: IndexPath, cTableView: UITableView)-> Void
    {
        if(cFTMenuItem.m_cSubMenuArray.count>0)
        {
            cFTMenuItem.m_bIsExapanded = true
            var i = 0
            
            for lcmenuItem in cFTMenuItem.m_cSubMenuArray
            {
                self.m_cMenuItemArr.insert(lcmenuItem, at: cIndexPath.row+i+1)
                i += 1;
            }
            
            let cExpandedRange = NSMakeRange(cIndexPath.row, i)
            var cIndexPaths = [IndexPath]()
            
            for i in 0..<cExpandedRange.length
            {
                cIndexPaths.append(IndexPath(row: cExpandedRange.location+i+1, section: 0))
            }
            
            cTableView.insertRows(at: cIndexPaths, with: .left)
            
            let lcParentCell = cTableView.cellForRow(at: cIndexPath) as! MenuCell
            
            lcParentCell.btnExpandCollapse.setImage(UIImage(named: "UpArrow"), for: .normal)
            
        }
    }
    
    func CollapseCellsFromIndexOf(cMenuItem: MenuItem, cIndexpath: IndexPath, cTableView: UITableView)
    {
        let lnCollapseCol = self.NumberOfCellToCollapsed(cFTMenuItem: cMenuItem)
        
        let lnEnd = cIndexpath.row + 1 + lnCollapseCol
        
        let lcCollapseRange = ((cIndexpath.row + 1) ..< lnEnd)
        
        self.m_cMenuItemArr.removeSubrange(lcCollapseRange)
        cMenuItem.m_bIsExapanded = false
        
        var lcIndexPaths = [IndexPath]()
        for i in 0..<lcCollapseRange.count
        {
            lcIndexPaths.append(IndexPath(row: lcCollapseRange.startIndex+i, section: 0))
        }
        
        cTableView.deleteRows(at: lcIndexPaths, with: .right)
        
        let lcParantCell = cTableView.cellForRow(at: cIndexpath) as! MenuCell
        
        lcParantCell.btnExpandCollapse.setImage(UIImage(named: "DownArrow"), for: .normal)
    }
    
    func NumberOfCellToCollapsed(cFTMenuItem: MenuItem)-> Int
    {
        var lnTotal = 0
        
        if(cFTMenuItem.m_bIsExapanded)
        {
            cFTMenuItem.m_bIsExapanded = false
            let lcSubMenuItems = cFTMenuItem.m_cSubMenuArray
            lnTotal = lcSubMenuItems.count
            
            
            for lcMenuItems in lcSubMenuItems
            {
                lnTotal += self.NumberOfCellToCollapsed(cFTMenuItem: lcMenuItems)
            }
        }
        return lnTotal
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
     
        let setLanguage = UserDefaults.standard.integer(forKey: "ENG")
        
        switch setLanguage
        {
        case 1:
            self.SelectedLanguage(languagePath: "en")
            let engUrl = "https://www.mumbaipress.com/wp-json/wp-api-menus/v2/menus/169"
            getCategoryList(url: engUrl)
            break
            
        case 2:
            self.SelectedLanguage(languagePath: "hi-IN")
            let hindiUrl = "https://www.mumbaipress.com/hindi/wp-json/wp-api-menus/v2/menus/169"
            getCategoryList(url: hindiUrl)
            break
            
        case 3:
            self.SelectedLanguage(languagePath: "ur-IN")
            let urduUrl = "https://www.mumbaipress.com/urdu/wp-json/wp-api-menus/v2/menus/169"
            getCategoryList(url: urduUrl)
            break
            
        default:
            self.SelectedLanguage(languagePath: "en")
            let enURl = "https://www.mumbaipress.com/wp-json/wp-api-menus/v2/menus/169"
            getCategoryList(url: enURl)
            
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.m_cMenuItemArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.SideBarTbl.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let lcmenuItem = self.m_cMenuItemArr[indexPath.row]
        
        if let lnMenulevel = lcmenuItem.m_nLevel
        {
            cell.lblMenuList.text = String(repeating: Character(" "), count: lnMenulevel * 4)  + lcmenuItem.m_cMenuName!
        }
        
        
        if lcmenuItem.m_cSubMenuArray.isEmpty == false
        {
            cell.btnExpandCollapse.isHidden = false
        }else{
            cell.btnExpandCollapse.isHidden = true
        }
        
        cell.indentationWidth = 20
        //cell.btnExpandCollapse.tag = indexPath.row
        
        cell.btnExpandCollapse.addTarget(self, action: #selector(ExpandCellOnClick(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func ExpandCellOnClick(_ button: UIButton)
    {
        
        let ButtonPosition = button.convert(CGPoint.init(x: 5.0, y: 5.0), to: self.SideBarTbl)
        
        let indexPath = self.SideBarTbl.indexPathForRow(at: ButtonPosition)
        
        
        let lcMenuItem = self.m_cMenuItemArr[(indexPath?.row)!]
        
        if lcMenuItem.m_bCanBeExapanded
        {
            if lcMenuItem.m_bIsExapanded
            {
                self.CollapseCellsFromIndexOf(cMenuItem: lcMenuItem, cIndexpath: indexPath!, cTableView: self.SideBarTbl)
            }else{
                self.ExpandCellsFromIndexOf(cFTMenuItem: lcMenuItem, cIndexPath: indexPath!, cTableView: self.SideBarTbl)
            }
            return
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let lcMenuItem = self.m_cMenuItemArr[indexPath.row]
        
        print("Id : \(lcMenuItem.m_nCategoryId!)")
        
        switch lcMenuItem.m_eFTMenuItemType.rawValue
        {
        case 1:
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
            
            revealViewController().pushFrontViewController(homeVC, animated: true)
            break
            
        case 2:
            let aboutUsVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVc") as! AboutUsVc
            
            revealViewController().pushFrontViewController(aboutUsVC, animated: true)
            break
            
        case 3:
            let Termvc = self.storyboard?.instantiateViewController(withIdentifier: "TermPageVc") as! TermPageVc
            
            revealViewController().pushFrontViewController(Termvc, animated: true)
            break
            
        case 4:
            let ReporterVc = self.storyboard?.instantiateViewController(withIdentifier: "NewReporterFormVC") as! NewReporterFormVC
            
            revealViewController().pushFrontViewController(ReporterVc, animated: true)
            break
            
        case 5:
            let LoginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc
            
            
            let result = UserDefaults.standard.array(forKey: "userdata") as? [AnyObject]
            if result != nil {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
                let yourViewController: Upload_LogoutVc = storyboard.instantiateViewController(withIdentifier: "Upload_LogoutVc") as! Upload_LogoutVc
               
                revealViewController().pushFrontViewController(yourViewController, animated: true)
                
            }else{
                let yourViewController: LoginVc = storyboard!.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc
                
                revealViewController().pushFrontViewController(yourViewController, animated: true)
            }
            
        
            break
            
        case 6:
            let dicVc = self.storyboard?.instantiateViewController(withIdentifier: "DisclaimerPageVc") as! DisclaimerPageVc
            
            revealViewController().pushFrontViewController(dicVc, animated: true)
            break
            
        case 7:
            let contVc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVc") as! ContactUsVc
            
            revealViewController().pushFrontViewController(contVc, animated: true)
            break
            
        case 8:
            let UpdateVc = self.storyboard?.instantiateViewController(withIdentifier: "UpdatesNewsVC") as! UpdatesNewsVC
            
            revealViewController().pushFrontViewController(UpdateVc, animated: true)
            break
            
        case 9:
            let ImpLinkVc = self.storyboard?.instantiateViewController(withIdentifier: "ImportantsLinksVC") as! ImportantsLinksVC
            
            revealViewController().pushFrontViewController(ImpLinkVc, animated: true)
            break
            
            
        case 12: let CategoriesVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesNewsDataVc") as! CategoriesNewsDataVc
        
        CategoriesVC.setId(CatId: lcMenuItem.m_nCategoryId!, CatName: lcMenuItem.m_cMenuName!)
        
        revealViewController().pushFrontViewController(CategoriesVC, animated: true)
        
            break
       
        case 13:
            let VideoVc = self.storyboard?.instantiateViewController(withIdentifier: "VideoListNewsVc") as! VideoListNewsVc
            
             revealViewController().pushFrontViewController(VideoVc, animated: true)
//            guard let url = URL(string: "https://www.youtube.com/channel/UCkS_zQPVxu-Rj0JsuUusZHA/videos")
//                else{
//                    return
//            }
//            UIApplication.shared.open(url, options: [:], completionHandler: {(status) in })
            
          
            break
            
        case 16:
            let TodayNewsVc = self.storyboard?.instantiateViewController(withIdentifier: "TodaysNewsVc") as! TodaysNewsVc
            
            revealViewController().pushFrontViewController(TodayNewsVc, animated: true)
            break
            
        default:
            print("No Match")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}

//
//  ImportantsLinksVC.swift
//  MumbaiPressApp
//
//  Created by user on 27/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class ImportantsLinksVC: UIViewController, TableViewDelegateDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate
{

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var Viewbar: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    var searchActive = Bool(false)
    var LinkArr = [AnyObject]()
    var filtered = NSArray()
    var DataArr = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblView.dataSource = self
        self.tblView.delegate = self
         self.searchActive = false
       self.searchbar.delegate = self
        self.tblView.separatorStyle = .none
        self.tblView.estimatedRowHeight = 80
        self.tblView.rowHeight = UITableViewAutomaticDimension
        
        self.Viewbar.designCell()
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(hidekeyboard))
        dismissKeyboard.delegate = self
        tblView.addGestureRecognizer(dismissKeyboard)
        getLinks()
    }

    @objc func hidekeyboard()
    {
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.tblView))!
        {
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //////////*************    SEARCH - METHODS  *********///////////////////
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        let predicate = NSPredicate(format: "mil_name CONTAINS[c]  %@", searchText)
        
        self.filtered = self.DataArr.filter { predicate.evaluate(with: $0) } as NSArray
        
        print("names = ,\(self.filtered)")
        if(filtered.count == 0)
        {
            searchActive = false
            
        } else {
            searchActive = true
            
        }
        
        self.tblView.reloadData()
        
    }
    
    
    ////////////******     TABLEVIEW - METHODS    **********////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchActive
        {
            return self.filtered.count
        }
        return self.LinkArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblView.dequeueReusableCell(withIdentifier: "ImpLinkCell", for: indexPath) as! ImpLinkCell
        
        var lcDict: [String: AnyObject]!
        
        if searchActive
        {
            lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
        }else{
            lcDict = self.LinkArr[indexPath.row] as! [String: AnyObject]
        }
        
        cell.lblLink.text = (lcDict["mil_name"] as! String)
        
        let ImgPath = "http://www.mumbaipress.com/urdu/wp-content/uploads/important_link_img/"
        
        let sourceImg = lcDict["mil_image"] as! String
        let url = URL(string: ImgPath + "\(sourceImg)")
        cell.ImgLink.kf.setImage(with: url)
        
        cell.backView.designCell()
        return cell
    }

   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var lcDict: [String: AnyObject]!
        
                if searchActive
                {
                    lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
                    guard let url = URL(string: lcDict["mil_url"] as! String)
                        else{
                            return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: {(status) in })
                }else{
        let lcDict = self.LinkArr[indexPath.row]
        guard let url = URL(string: lcDict["mil_url"] as! String)
            else{
                return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: {(status) in })
    }
        
    }
    
    
////////////*****    EXTRA - FUNCTIONS   ////////////////////////
    
    override func viewWillAppear(_ animated: Bool) {
        sideMenus()
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

    func getLinks()
    {
        let LinkUrl = "https://www.mumbaipress.com/urdu/wp-content/themes/mumbai_press/API/getImportantLink.php"
        
        Alamofire.request(LinkUrl, method: .get, parameters: nil).responseJSON { (resp) in
            //           print(resp)
            
            let JSON = resp.result.value as! NSDictionary
            self.LinkArr = JSON["msg"] as! [AnyObject]
            self.DataArr = self.LinkArr.map ({ $0 }) as NSArray
            self.tblView.reloadData()
            
        }
        
    }
    
    
    
    
}

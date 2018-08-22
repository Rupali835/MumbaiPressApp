//
//  TestSearchVC.swift
//  MumbaiPressApp
//
//  Created by user on 12/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SHSnackBarView

class TestSearchVC: UIViewController,  TableViewDelegateDataSource, UISearchBarDelegate, UISearchDisplayDelegate,SecondNewsCellDelegate
{
    @IBOutlet weak var tblSearchNews: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var SearchArr = [AnyObject]()
    var searchActive = Bool(false)
    var DataArr = NSArray()
    var filtered = NSArray()
    let snackbarView = snackBar()
    let storyBrd = UIStoryboard(name: "Main", bundle: nil)
    var DetaileNewsArr = [DetaileNews]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        tblSearchNews.addGestureRecognizer(dismissKeyboardGesture)
        
        tblSearchNews.register(UINib(nibName: "SecondNewsCell", bundle: nil), forCellReuseIdentifier: "SecondNewsCell")
        
        self.tblSearchNews.separatorStyle = .none
        self.tblSearchNews.estimatedRowHeight = 80
        self.tblSearchNews.rowHeight = UITableViewAutomaticDimension
        
        searchBar.delegate = self
        
        tblSearchNews.delegate = self
        tblSearchNews.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationController?.navigationBar.isHidden = false
        customizeNavBar()
    }
   
    
// TABLEVIEW - METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SearchArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let lcDict = self.SearchArr[indexPath.item]
        
        let date = lcDict["date"] as! String
        let Title = lcDict["title"] as! NSDictionary
        let render = Title["rendered"] as! String
        let imgDict = lcDict["better_featured_image"] as! NSDictionary
        let sourceImg = imgDict["source_url"] as! String
        
        let cell = tblSearchNews.dequeueReusableCell(withIdentifier: "SecondNewsCell", for: indexPath) as! SecondNewsCell
        cell.delegate = self
        cell.lblDATE.text = date.datesetting()
        
        let lcFormatStr = changestr(stringTochange: render)
        cell.lbltitle.text = lcFormatStr.replacingHTMLEntities!
     //   cell.lbltitle.text = changestr(stringTochange: render)
        
        let url = URL(string: sourceImg)
        cell.imgNewS.kf.setImage(with: url)
        
        cell.btnyoutb.isHidden = true
        return cell
        
    }
    
    func didSelected(_ sender: SecondNewsCell)
    {
        guard let indexPath = tblSearchNews.indexPath(for: sender) else { return }
        let newsVc = storyBrd.instantiateViewController(withIdentifier: "DetailNewsScrollVC") as! DetailNewsScrollVC
        
        
        self.DetaileNewsArr.removeAll(keepingCapacity: false)
        
        for (index,lcDict) in self.SearchArr.enumerated()
        {
            
            print("lcDictCount: \(lcDict.count)")
            print("lcDict: \(lcDict)")
            
            let Link = lcDict["link"] as! String
            let titleNews = lcDict["title"] as! NSDictionary
            let renNews = titleNews["rendered"] as! String
            let cDate = lcDict["date"] as! String
            let contentNew = lcDict["content"] as! NSDictionary
            let renDetailDesc = contentNew["rendered"] as! String
            let imgDict = lcDict["better_featured_image"] as! NSDictionary
            let sourceImg = imgDict["source_url"] as! String
            
            self.DetaileNewsArr.append(DetaileNews(date: cDate.datesetting(), title: renNews, url: sourceImg, DetailsDesc: renDetailDesc, nIndex: index, link: Link ))
            
        }
        
        newsVc.setImageToView(newsarr: self.DetaileNewsArr, nSelectedIndex: indexPath.row, nTotalNews: self.DetaileNewsArr.count)
        
        self.navigationController?.pushViewController(newsVc, animated: true)

    }

   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155.0
    }
    
    
    
    
    
  // SEARCHBAR - METHODS
    
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
        let searchWord = searchBar.text
        getSearchData(searchStr: searchWord!)
    }
    
  
    
 // EXTRA - METHODS
    
    func getSearchData(searchStr: String)
    {
        let searchUrl = "https://www.mumbaipress.com/wp-json/wp/v2/posts?search=\(searchStr)"
        Alamofire.request(searchUrl, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            self.SearchArr = resp.result.value as! [AnyObject]
            
            if self.SearchArr.count == 0
            {
                let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "No data found", textColor: UIColor.white, interval: 2)
            }
            
            self.tblSearchNews.reloadData()
        }
        
    }
    
    
    func customizeNavBar()
    {
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
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
    }
    
    func changestr(stringTochange:String)-> String {
        
        let str = stringTochange.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
        
    }
    

}

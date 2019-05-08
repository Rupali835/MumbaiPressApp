

import UIKit
import Alamofire
import Kingfisher

class containerVC: UIViewController {

    @IBOutlet weak var collview: UICollectionView!
    
    var ImgStr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImge()

    }
    
    func getImge()
    {
        let imgurl = "https://www.mumbaipress.com/urdu/wp-json/wp/v2/pages/?slug=Home"
        
        Alamofire.request(imgurl, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSArray
                
                let dict = json[0] as! NSDictionary
                let content = dict["content"] as! NSDictionary
                let render = content["rendered"] as! String
                print(render)
            
                let lcFormatStr = self.changestr(stringTochange: render)
                let src = lcFormatStr.replacingHTMLEntities
                print(src)
                self.ImgStr = [src!]
                
                break
            case .failure(_):
                break
            }
        }
    }

    func changestr(stringTochange:String)-> String {
        
        let str = stringTochange.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
        
    }
    
    @IBAction func btnclose_Onclick(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
extension containerVC : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collview.dequeueReusableCell(withReuseIdentifier: "containerCell", for: indexPath) as! containerCell
      
        let lcdict = self.ImgStr[indexPath.row]
        cell.imgAd.image = UIImage(named: lcdict)
        let url = URL(string: lcdict)
        cell.imgAd.kf.setImage(with: url)
        return cell
    }
}

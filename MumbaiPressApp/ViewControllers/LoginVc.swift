//
//  LoginVc.swift
//  MumbaiPressApp
//
//  Created by user on 11/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SHSnackBarView

class LoginVc: UIViewController {

    
    @IBOutlet weak var txtPassword: HoshiTextField!
    @IBOutlet weak var txtUserNm: HoshiTextField!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var btnLogin: MKButton!
    @IBOutlet weak var backView: UIView!
    
    let snackbarView = snackBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designCell(cView: ViewBar)
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        backView.addGestureRecognizer(dismissKeyboardGesture)

        self.btnLogin.backgroundColor = UIColor(red:0.60, green:0.02, blue:0.06, alpha:1.0)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
    }
    
    
    func getAccess()
    {
        let LoginUrl = "https://www.mumbaipress.com/wp-content/themes/mumbai_press/API/login_api.php"
        
        let param : [String: String] =
            [
                "user_email": txtUserNm.text!,
                "user_password" : txtPassword.text!
            ]
        
        Alamofire.request(LoginUrl, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            let Dict = resp.result.value as! NSDictionary
            let msg = Dict["msg"] as! String
            if msg == "success"
            {
                let Data = Dict["data"] as! [AnyObject]
                print(Data)
                
          let userdata = UserDefaults.standard.set(Data, forKey: "userdata")
                
                let reportVc = self.storyboard?.instantiateViewController(withIdentifier: "Upload_LogoutVc") as! Upload_LogoutVc
                self.revealViewController().pushFrontViewController(reportVc, animated: true)
   
                
            }else{
                let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Credential did not match. Please Retry", textColor: UIColor.white, interval: 2)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        sideMenus()
        
    }
   
    @IBAction func btnLogin_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)
        self.getAccess()
    }
    
    func sideMenus()
    {
        if revealViewController() != nil {
            
            btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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
    
    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
        
    }
    
}

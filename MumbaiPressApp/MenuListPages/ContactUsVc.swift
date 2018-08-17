//
//  ContactUsVc.swift
//  MumbaiPressApp
//
//  Created by user on 15/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SHSnackBarView

class ContactUsVc: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    
    @IBOutlet weak var txtSubject: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var txtname: HoshiTextField!
    @IBOutlet weak var ViewBar: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    var formValid = Bool(true)
     let snackbarView = snackBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        designCell(cView: ViewBar)
    
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        backView.addGestureRecognizer(dismissKeyboardGesture)
        
        txtname.delegate = self
        txtEmail.delegate = self
        txtSubject.delegate = self
        txtMessage.delegate = self
        
        btnSend.layer.cornerRadius = 15.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUsVc.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUsVc.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
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
    
    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == txtMessage{
            txtMessage.text = nil
            txtMessage.textColor = UIColor.black
        }
        
    }
    
    @IBAction func btnSend_Click(_ sender: Any)
    {
        self.Valid()
    }
    
    func Valid()
    {
        formValid = true
        if txtname.text == ""
        {
            
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter name", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        if txtEmail.text == ""
        {
            
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter email", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        if !(txtEmail.text?.isValidEmail())! {
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter valid email", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        if txtSubject.text == ""
        {
            
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter email", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        if txtMessage.text == ""
        {
            
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter email", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        if (formValid == true)
        {
            sendData()
        }
    }
    
    
    func sendData()
    {
        let ContactUrl = "https://www.mumbaipress.com/wp-content/themes/mumbai_press/API/contact_us.php"
        
        var param : [String: String] =
            [  "contact_name" : txtname.text!,
               "contact_email" : txtEmail.text!,
               "contact_subject" : txtSubject.text!,
               "contact_msg" : txtMessage.text!
            ]
        Alamofire.request(ContactUrl, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            let JSON = resp.result.value as! NSDictionary
            
        }
        
    }
    
}

//
//  NewsTypeVc.swift
//  MumbaiPressApp
//
//  Created by user on 26/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class NewsTypeVc: UIViewController, UITextViewDelegate
{

    @IBOutlet weak var txtDiscription: UITextView!
    @IBOutlet weak var txtTitle: UITextView!
   
    @IBOutlet weak var btnAudio: UIButton!
    
    @IBOutlet weak var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtTitle.delegate = self
        txtTitle.isScrollEnabled = false

       designCell(cView: backView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
    }
    
    @IBAction func btnAudio_Clicked(_ sender: Any)
    {
        let Newsvc = storyboard?.instantiateViewController(withIdentifier: "RecorderViewController") as! RecorderViewController
        navigationController?.pushViewController(Newsvc, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
    
        let size = CGSize(width: view.frame.width, height: .infinity)
        let EstimateSize = txtTitle.sizeThatFits(size)
        txtTitle.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height
            {
                constraint.constant = EstimateSize.height
            }
        }
    }
}

//
//  AllUploadNewsVc.swift
//  MumbaiPressApp
//
//  Created by user on 13/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import Alamofire
import SHSnackBarView

class ImageData {
    var imgName : String!
    var img : UIImage!
    
    init(imgName: String, img: UIImage) {
        self.imgName = imgName
        self.img = img
    }
}

class AllUploadNewsVc: UIViewController, UITextViewDelegate, MediaDelegate {

    @IBOutlet weak var lc_indicator: UIActivityIndicatorView!
    @IBOutlet var viewUploadMsg: UIView!
    @IBOutlet weak var viewSeeAttach: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tblUploadNews: UITableView!
    @IBOutlet weak var viewFileManager: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var viewAudio: UIView!
    @IBOutlet weak var txtDetailReports: UITextView!
    @IBOutlet weak var txtHeadLine: UITextView!
    
    var cRecordVc : RecorderViewController!
    var videoArr = [URL]()
    var fileName: String!
    var selectedImage: UIImage!
    var ImgArr = [ImageData]()
    var recordARR = [URL]()
    var videoStr : String = ""
     var popUp : KLCPopup!
    var ImgNameArr = [String]()
    var AudioNameArr = [String]()
    var VideoNameArr = [String]()
    var ReporterId : String = ""
    private var toast: JYToast!
    var formValid = Bool(true)
    let snackbarView = snackBar()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        let dict = UserDefaults.standard.array(forKey: "userdata") as! [AnyObject]
        self.ReporterId = dict[0]["mrp_id"] as! String
        
        contentView.addGestureRecognizer(dismissKeyboardGesture)
        
        designCell(cView: viewAudio)
        designCell(cView: viewVideo)
        designCell(cView: viewImage)
        designCell(cView: viewFileManager)
        designCell(cView: viewSeeAttach)

        initUi()
        txtHeadLine.delegate = self
        txtHeadLine.isScrollEnabled = false
        txtDetailReports.delegate = self
        txtDetailReports.isScrollEnabled = false
    
        popUp = KLCPopup()

    }

    private func initUi() {
        toast = JYToast()
    }
    
    override func awakeFromNib()
    {
        self.cRecordVc = self.storyboard?.instantiateViewController(withIdentifier: "RecorderViewController") as! RecorderViewController
        
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.lightGray.cgColor
        cView.backgroundColor = UIColor.white
        
    }
    
    func RecordingData(RecordArr : [URL])
    {
        self.recordARR = RecordArr
        self.AudioNameArr.removeAll(keepingCapacity: false)
        for recoder in RecordArr
        {
            self.AudioNameArr.append(recoder.lastPathComponent)
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
   
    

    func textViewDidChange(_ textView: UITextView)
    {
       
        let size = CGSize(width: view.frame.width, height: .infinity)
        
        if textView == txtDetailReports
        {
            let EstimateSize = txtDetailReports.sizeThatFits(size)
            txtDetailReports.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height
                {
                    constraint.constant = EstimateSize.height
                }
            }
        }
        if textView == txtHeadLine
        {
            let EstimateSize = txtDetailReports.sizeThatFits(size)
            txtDetailReports.constraints.forEach { (constraint) in
                if constraint.firstAttribute == .height
                {
                    constraint.constant = EstimateSize.height
                }
            }
        }
        
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == txtDetailReports
        {
            if txtDetailReports.text == "TAP HERE TO WRITE"
            {
                txtDetailReports.text = nil
                txtDetailReports.textColor = UIColor.black
            }
          
        }
        if textView == txtHeadLine
        {
            if txtHeadLine.text == "TAP HERE TO WRITE"
            {
                txtHeadLine.text = nil
                txtHeadLine.textColor = UIColor.black
            }
           
        }
      
    }
    
    
    @IBAction func btnAudio_Click(_ sender: Any)
    {
        self.view.endEditing(true)
        self.cRecordVc.view.frame = self.view.bounds
        self.cRecordVc.delegate = self
        self.view.addSubview(self.cRecordVc.view)
        self.cRecordVc.view.clipsToBounds = true
    }
  
    @IBAction func btnVideo_Click(_ sender: Any)
    {
        self.view.endEditing(true)
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func btnImage_Click(_ sender: Any)
    {
        self.view.endEditing(true)
        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
            
            self.ImgNameArr.removeAll(keepingCapacity: false)
            
            for lcAttachment in CDBAttachmentArr
            {
                
                self.fileName = lcAttachment.fileName
                self.ImgNameArr.append(self.fileName)
                lcAttachment.loadOriginalImage(completion: {image in
               //     self.imgProfile.image = image
                    self.selectedImage = image
                    
                    self.ImgArr.append(ImageData(imgName: self.fileName, img: self.selectedImage))
                    
                })
                
            }
            
        }, cancel: nil)
        
        attachmentPickerController.mediaType = .image
        attachmentPickerController.mediaType = .video
        attachmentPickerController.capturedVideoQulity = UIImagePickerControllerQualityType.typeHigh
        attachmentPickerController.allowsMultipleSelection = false
        attachmentPickerController.allowsSelectionFromOtherApps = false
        attachmentPickerController.present(on: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        customizeNavBar()
        
    }
    
    func customizeNavBar() {
        
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
    
    @IBAction func btnSeeAttchment_Click(_ sender: Any)
    {
        let mediaVC = self.storyboard?.instantiateViewController(withIdentifier: "MediaCollectionVC") as! MediaCollectionVC
        mediaVC.VideoARR = self.videoArr
        mediaVC.IMGArr = self.ImgArr
        self.navigationController?.pushViewController(mediaVC, animated: true)
    }
    
    @IBAction func btnSubmit_Click(_ sender: Any)
    {
        formValid = true
        if txtHeadLine.text == ""
        {
            
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter headline", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        if txtDetailReports.text == ""
        {
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter Qualification", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        
        
        if (formValid == true)
        {
            UploadNews()
            
        }

    }
    
    func UploadNews()
    {
        popUp.contentView = viewUploadMsg
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        
        
            var arrIMG: String!
            var arrAUD: String!
            var arrVID: String!
            
            if self.ImgNameArr.isEmpty
            {
                arrIMG = "0"
            }else{
                
                arrIMG = String(self.self.ImgNameArr.count)
            }
            
            if self.AudioNameArr.isEmpty
            {
                arrAUD = "0"
            }else{
                arrAUD = String(self.AudioNameArr.count)
            }
            
            if self.VideoNameArr.isEmpty
            {
                arrVID = "0"
            }else{
                
                
                arrVID = String(self.VideoNameArr.count)
            }
            
            let mediaUrl = "https://www.mumbaipress.com/wp-content/themes/mumbai_press/API/upload_report.php"
            
            let param : [String: String] =
                [  "Reporter_Id": self.ReporterId,
                   "Headline": txtHeadLine.text,
                   "Report_details": txtDetailReports.text,
                   "count_image": arrIMG!,
                   "count_audio": arrAUD!,
                   "count_video": arrVID!
            ]
            
            print(param)
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    if self.ImgNameArr.isEmpty
                    {
                        print("no Image for upload")
                    }else{
                        for (index,lcImage) in self.ImgArr.enumerated()
                        {
                            let image = lcImage.img
                            let imgNo = index + 1
                            print(imgNo)
                            let data = UIImageJPEGRepresentation(image!,0.0)
                            multipartFormData.append(data!, withName: "Image_name_file"+String(format:"%d",imgNo), fileName: self.fileName, mimeType: "image/jpeg")
                            
                        }
                    }
                    
                    
                    if self.AudioNameArr.isEmpty
                    {
                        print("No Audio Selected")
                    }else{
                        for (index, lcAudioFile) in self.recordARR.enumerated()
                        {
                            let imgNo = index + 1
                            print(imgNo)
                            let voiceData = try? Data(contentsOf: lcAudioFile)
                            
                            multipartFormData.append(voiceData!, withName: "Audio_name_file"+String(format:"%d",imgNo), fileName: self.AudioNameArr[index], mimeType: "audio/m4a")
                        }
                        
                    }
                    
                    if self.VideoNameArr.isEmpty
                    {
                        print("No Video Selected")
                    }else{
                        for (index,lcFileVideoPath) in self.videoArr.enumerated()
                        {
                            var movieData:Data?
                            do{
                                let imgNo = index + 1
                                print(imgNo)
                                movieData = try Data.init(contentsOf: lcFileVideoPath)
                                multipartFormData.append(movieData!, withName: "Video_name_file"+String(format:"%d",imgNo), fileName: self.VideoNameArr[index], mimeType: "video/mov")
                                
                            }catch {
                                print("error")
                            }
                        }
                    }
                    
                    
                    for (key, val) in param {
                        multipartFormData.append((val as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
                    }
            },
                
                usingThreshold : SessionManager.multipartFormDataEncodingMemoryThreshold,
                to : mediaUrl,
                method: .post)
            { (result) in
                
                //  let indicator = MKActivityIndicator()
                self.lc_indicator.startAnimating()
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value as? [String: Any] {
                            print("Response : ",JSON)
                            
                            self.lc_indicator.stopAnimating()
                            self.popUp.dismiss(true)
                             let Msg = JSON["msg"] as! String
                           
                           
                            
                            if Msg == "success"
                            {
                                self.showAlert(title: "Success", Msg: "Your Report has been submitted. It will be published once verified")
                            }
                            if Msg == "Fail"
                            {
                                self.showAlert(title: "failed", Msg: "Your Report not submitted. please retry")
                                
                            }
                            
                            
                          
                            
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
                
            }
            
        }
    
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }

}


extension AllUploadNewsVc: UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerControllerMediaURL] as? URL,
     //       let urlT = url(string: self.videoStr),
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else { return }
        self.videoArr.append(url)
        self.VideoNameArr.append(url.lastPathComponent)
        print("video String: \(self.videoArr[0])")

        
        // Handle a movie capture
        UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func showAlert(title: String, Msg: String)
    {
        let alertController = UIAlertController(title: title, message:
            Msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let imgTitle = UIImage(named:"M")
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgViewTitle.image = imgTitle
        
        alertController.view.addSubview(imgViewTitle)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    

    
}

// MARK: - UINavigationControllerDelegate

extension AllUploadNewsVc: UINavigationControllerDelegate {
}





//
//  ReporterFormVC.swift
//  MumbaiPressApp
//
//  Created by user on 15/06/18.
//  Copyright © 2018 user. All rights reserved.
//

//import UIKit
//import MBPhotoPicker
//import SHSnackBarView
//import Alamofire
//import AVFoundation
//
//class Repoter: NSObject {
//    var name: String!
//    var profile_count: String!
//    var mrp_profile_pic: URL!
//    var email: String!
//    var contact: String!
//    var gender: String!
//    var qualification: String!
//    var news_language: String!
//    var about_repoter: String!
//    var reference: String!
//    var count: String!
//    var document: URL!
//}
//class ReporterFormVC: UIViewController, UITextViewDelegate, TableViewDelegateDataSource, UITextFieldDelegate
//{
//
//    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
//    @IBOutlet var viewAddReference: UIView!
//    @IBOutlet weak var btnURDU: CheckboxButton!
//    @IBOutlet weak var btnHINDI: CheckboxButton!
//    @IBOutlet weak var btnENGLISH: CheckboxButton!
//    @IBOutlet weak var txtAboutSelf: UITextView!
//    @IBOutlet weak var btnReporterAtRef: DLRadioButton!
//    @IBOutlet var viewReferences: UIView!
//    @IBOutlet weak var txtRefContactNo: UITextField?
//    @IBOutlet weak var txtRefName: UITextField?
//    @IBOutlet weak var txtContactNo: UITextField!
//    @IBOutlet weak var txtEmailId: UITextField!
//    @IBOutlet weak var txtName: UITextField!
//    @IBOutlet weak var btnTakePhoto: UIButton!
//    @IBOutlet weak var imgProfile: UIImageView!
//    @IBOutlet weak var btnYesRef: DLRadioButton!
//    @IBOutlet weak var viewInfo: UIView!
//    @IBOutlet weak var viewProfile: UIView!
//    @IBOutlet weak var btnMale: DLRadioButton!
//
//    @IBOutlet weak var lblCountWords: UILabel!
//    @IBOutlet weak var ViewBar: UIView!
//    @IBOutlet weak var menuBtn: UIButton!
//
//    @IBOutlet weak var txtDOB: UITextField!
//
//    @IBOutlet weak var txtQualification: UITextField!
//    @IBOutlet weak var tblReferenceInfo: UITableView!
//
//     var popUp : KLCPopup!
//     var formValid = Bool(true)
//    lazy var photo = MBPhotoPicker()
//    let snackbarView = snackBar()
//    let datepicker = UIDatePicker()
//    let toolBar = UIToolbar()
//    var DateStr : String?
//    var NumberArray : [String] = []
//    var NameArray : [String] = []
//    var selectedGender: String!
//    var selectedLanguage: String!
//    var references: String!
//    var rep_Type: String?
//    var DictArr = [[String: String]]()
//    var langArr = [String]()
//     var DBAttachmentArr = [DBAttachment]()
//    var repoter = Repoter()
//
//    var gender: String!
//
//    var selectedImage: UIImage!
//    var DocumentselectedImage: UIImage!
//    var filePath: String!
//    var fileURL: URL!
//    var fileName: String!
//    var DocumentImageFileName: String!
//    var DocumentFileURL: URL!
//    var DocumentFileName: String?
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//
//       updateCharacterCount()
//
//        imgProfile.clipsToBounds = true
//        imgProfile.layer.borderWidth = 2.0
//    //    imgProfile.layer.masksToBounds = true
//        imgProfile.layer.borderColor = UIColor(red:0.64, green:0.04, blue:0.11, alpha:1.0).cgColor
//
//
//        designCell(cView: ViewBar)
//        designCell(cView: viewProfile)
//        designCell(cView: viewInfo)
//        btnMale.isMultipleSelectionEnabled = false
//        btnReporterAtRef.isMultipleSelectionEnabled = false
//        tblReferenceInfo.delegate = self
//        tblReferenceInfo.dataSource = self
//        txtAboutSelf.delegate = self
//       txtAboutSelf.isScrollEnabled = false
//        txtContactNo.delegate = self
//
//        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//
//        viewInfo.addGestureRecognizer(dismissKeyboardGesture)
//         popUp = KLCPopup()
//
//         tblReferenceInfo.register(UINib(nibName: "ReferenceNameCell", bundle: nil), forCellReuseIdentifier: "ReferenceNameCell")
//
//        txtRefContactNo?.delegate = self
//        txtRefName?.delegate = self
//    }
//
//    func textViewDidChange(_ textView: UITextView)
//    {
//        updateCharacterCount()
//
//        let size = CGSize(width: view.frame.width, height: .infinity)
//        let EstimateSize = txtAboutSelf.sizeThatFits(size)
//        txtAboutSelf.constraints.forEach { (constraint) in
//            if constraint.firstAttribute == .height
//            {
//                constraint.constant = EstimateSize.height
//                contentViewHeight.constant = 1200 + EstimateSize.height
//            }
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
//    {
//        self.view.endEditing(true)
//    }
//
//    @objc func hideKeyboard()
//    {
//        self.view.endEditing(true)
//
//    }
//
//    func designCell(cView : UIView)
//    {
//        cView.layer.shadowOpacity = 0.7
//        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        cView.layer.shadowRadius = 4.0
//        cView.layer.shadowColor = UIColor.gray.cgColor
//        cView.backgroundColor = UIColor.white
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.NumberArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferenceNameCell", for: indexPath)as! ReferenceNameCell
//
//        cell.lblNameRef.text = NameArray[indexPath.row]
//        cell.lblContactRef.text = NumberArray[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100.0
//    }
//
//    func Validation()
//    {
//        formValid = true
//        if txtName.text == ""
//        {
//
//            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
//            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter name", textColor: UIColor.white, interval: 2)
//            formValid = false
//            return
//        }
//        if txtEmailId.text == ""
//        {
//
//            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
//            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter email", textColor: UIColor.white, interval: 2)
//            formValid = false
//            return
//        }
//
//        if !(txtEmailId.text?.isValidEmail())! {
//            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
//            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter Correct email", textColor: UIColor.white, interval: 2)
//            formValid = false
//            return
//        }
//        if (txtContactNo.text?.count)! < 10  {
//            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
//            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter Contact number", textColor: UIColor.white, interval: 2)
//            formValid = false
//            return
//        }
//
//
//
//        if txtDOB.text == ""
//        {
//
//            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
//            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please Select Date", textColor: UIColor.white, interval: 2)
//            formValid = false
//            return
//        }
//
//        if txtQualification.text == ""
//        {
//
//            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
//            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter Qualification", textColor: UIColor.white, interval: 2)
//            formValid = false
//            return
//        }
//
//
//        if (formValid == true)
//        {
//           sendData()
//        }
//
//    }
//
//
//    func sendData()
//    {
//
//        repoter.name = txtName.text
//
//        if self.selectedImage != nil{
//            repoter.profile_count = "1"
//        }else{
//            repoter.profile_count = "0"
//        }
//
//        repoter.email = txtEmailId.text
//        repoter.contact = txtContactNo.text
//        repoter.gender = self.selectedGender
//        repoter.qualification = txtQualification.text
//        repoter.news_language = self.selectedLanguage
//        repoter.about_repoter = txtAboutSelf.text
//
//
//        if self.DictArr.isEmpty == true
//        {
//            self.references = "NF"
//        }
//        else{
//            self.references = self.json(from: self.DictArr)
//        }
//        repoter.reference = self.references
//
//        repoter.document = URL(fileURLWithPath: "")
//
//        if self.DocumentFileName != nil{
//            repoter.count = "1"
//        }else{
//          repoter.count = "0"
//        }
//
//
//        let Reporturl = "https://mumbaipress.com/wp-content/themes/mumbai_press/API/insertRepoter.php"
//
//        var param : [String: String] =
//            [  "name": repoter.name,
//            //   "profile_count": repoter.profile_count,
//               "profile_count": repoter.profile_count,
//                "email": repoter.email,
//                "contact": repoter.contact,
//                "gender": repoter.gender,
//                "qualification": repoter.qualification,
//                "news_language": repoter.news_language,
//                "about_reporter":  repoter.about_repoter,
//                "reference": repoter.reference,
//                 "count": repoter.count
//        ]
//
//        print(param)
//
//
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//
//                if self.selectedImage != nil
//                {
//                      let data = UIImageJPEGRepresentation(self.selectedImage,0.0)
//                multipartFormData.append(data!, withName: "mrp_profile_pic", fileName: self.fileName, mimeType: "image/jpeg")
//
//                }
//
//                if self.DocumentFileURL != nil
//                {
//                    multipartFormData.append(self.DocumentFileURL, withName: "Document1" , fileName: self.DocumentFileName!, mimeType: "pdf/text")
//                }else{
//                    if self.DocumentselectedImage != nil{
//                        let data = UIImageJPEGRepresentation(self.DocumentselectedImage,0.0)
//                        multipartFormData.append(data!, withName: "Document1", fileName: self.DocumentImageFileName, mimeType: "image/jpeg")
//                    }
//
//                }
//
//
//                for (key, val) in param {
//                    multipartFormData.append((val as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
//                }
//        },
//            to: Reporturl,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        if let jsonResponse = response.result.value as? [String: Any] {
//                            print(jsonResponse)
//
//                        }
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//        })
//
//
//    }
//
//
//
//
//
//
//    override func viewWillAppear(_ animated: Bool) {
//         navigationController?.navigationBar.isHidden = true
//        customizeViewBar()
//        sideMenus()
//
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//        if textView == txtAboutSelf{
//            txtAboutSelf.text = nil
//            txtAboutSelf.textColor = UIColor.black
//        }
//    }
//
//    @IBAction func didTapPhotoPicker(_ sender: AnyObject)
//    {
//        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
//
//            for lcAttachment in CDBAttachmentArr
//            {
//                self.fileName = lcAttachment.fileName
//
//                lcAttachment.loadOriginalImage(completion: {image in
//
//                    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
//
//                    self.imgProfile.image = image
//                    self.selectedImage = image
//               })
//
//            }
//
//        }, cancel: nil)
//
//        attachmentPickerController.mediaType = .image
//        attachmentPickerController.mediaType = .video
//        attachmentPickerController.capturedVideoQulity = UIImagePickerControllerQualityType.typeHigh
//        attachmentPickerController.allowsMultipleSelection = false
//        attachmentPickerController.allowsSelectionFromOtherApps = false
//        attachmentPickerController.present(on: self)
//
//
//    }
//
//
//
//    @IBAction func btnDone_click(_ sender: Any)
//    {
//
//        Validation()
//
//    }
//
//    func customizeViewBar() {
//
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func sideMenus()
//    {
//        if revealViewController() != nil {
//
//            menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//            revealViewController().rearViewRevealWidth = 310
//            revealViewController().rightViewRevealWidth = 130
//
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//
//        }
//    }
//
//    @IBAction func menuBarbtn_Click(_ sender: Any)
//    {
//        if revealViewController() != nil
//        {
//            revealViewController().rearViewRevealWidth = 310
//            revealViewController().rightViewRevealWidth = 130
//
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//
//        }
//    }
//
//    @IBAction func btnAddReference(_ sender: Any)
//    {
//        viewAddReference.isHidden = false
//        viewReferences.isHidden = true
//        popUp.contentView = viewAddReference
//        popUp.maskType = .dimmed
//        popUp.shouldDismissOnBackgroundTouch = false
//        popUp.shouldDismissOnContentTouch = false
//        popUp.showType = .slideInFromRight
//        popUp.dismissType = .slideOutToLeft
//        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
//    }
//
//    @IBAction func btnSeeReferences_click(_ sender: Any)
//    {
//        viewReferences.isHidden = false
//        viewAddReference.isHidden = true
//        popUp.contentView = viewReferences
//        popUp.maskType = .dimmed
//        popUp.shouldDismissOnBackgroundTouch = true
//        popUp.shouldDismissOnContentTouch = false
//        popUp.showType = .slideInFromRight
//        popUp.dismissType = .slideOutToLeft
//        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
//    }
//
//    @IBAction func btnAddAttachment_click(_ sender: Any)
//    {
//        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
//
//
//            for lcAttachment in CDBAttachmentArr
//            {
//                self.DocumentFileName = lcAttachment.fileName
//               self.DocumentImageFileName = lcAttachment.fileName
//
//                lcAttachment.loadOriginalImage(completion: {image in
//                    self.DocumentselectedImage = image
//                })
//
//                self.DocumentFileURL = lcAttachment.url
//                print("URL = \(self.DocumentFileURL)")
//            }
//
//        }, cancel: nil)
//
//        attachmentPickerController.mediaType = .image
//        attachmentPickerController.mediaType = .video
//        attachmentPickerController.capturedVideoQulity = UIImagePickerControllerQualityType.typeHigh
//        attachmentPickerController.allowsMultipleSelection = false
//        attachmentPickerController.allowsSelectionFromOtherApps = true
//        attachmentPickerController.present(on: self)
//
//
//    }
//
//
//    @IBAction func btnAddRefe_onClick(_ sender: Any)
//    {
//        guard let name = txtRefName?.text
//            else {
//                popUp.dismiss(true)
//                return
//            }
//        guard let contactNo = txtRefContactNo?.text
//            else {
//                 popUp.dismiss(true)
//                return
//
//        }
//        guard let repType = self.rep_Type
//            else {
//              popUp.dismiss(true)
//              return
//        }
//
//        let lcDict: [String: String] = ["rep_type": repType, "rep_name": name, "rep_number": contactNo]
//
//        if (txtRefName?.text != "") && (txtRefContactNo?.text != "")
//        {
//            self.DictArr.append(lcDict)
//            self.references = self.json(from: self.DictArr)
//
//            print(self.references)
//        }
//
//        if let name = txtRefName?.text
//        {
//            NameArray.append(name)
//        }
//
//        if let no = txtRefContactNo?.text
//        {
//            NumberArray.append(no)
//        }
//        popUp.dismiss(true)
//        tblReferenceInfo.reloadData()
//        tblReferenceInfo.isHidden = false
//        txtRefContactNo?.text = ""
//        txtRefName?.text = ""
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//        txtRefName?.resignFirstResponder()
//        txtRefContactNo?.resignFirstResponder()
//        return true
//    }
//
//
//    @IBAction func btnReporterAtRef_Click(_ sender: Any)
//    {
//        let abc =  (sender as AnyObject).tag
//        if abc == 1
//        {
//            self.rep_Type = "1"
//
//        }else{
//            self.rep_Type = "2"
//
//        }
//
//    }
//
//    func json(from object:Any) -> String? {
//        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
//        {
//            return nil
//        }
//
//        return String(data: data, encoding: String.Encoding.utf8)
//    }
//
//    @IBAction func btnSeeAttachment_click(_ sender: Any) {
//    }
//
//    @IBAction func btnENG_OnClick(_ sender: Any)
//    {
//
//      if btnENGLISH.on
//        {
//           self.langArr.append("1")
//        }else{
//        for (index,lcLangvalue) in self.langArr.enumerated()
//        {
//            if lcLangvalue == "1"
//            {
//                self.langArr.remove(at: index)
//            }
//        }
//        }
//        self.selectedLanguage = json(from: self.langArr)
//    }
//
//    @IBAction func btnHINDI_OnClick(_ sender: Any)
//    {
//
//        if btnHINDI.on
//        {
//            self.langArr.append("2")
//        }else{
//            for (index,lcLangvalue) in self.langArr.enumerated()
//            {
//                if lcLangvalue == "2"
//                {
//                    self.langArr.remove(at: index)
//                }
//            }
//        }
//
//        self.selectedLanguage = json(from: self.langArr)
//    }
//
//    @IBAction func btnURDU_OnClick(_ sender: Any)
//    {
//
//        if btnURDU.on
//        {
//            self.langArr.append("3")
//        }else{
//            for (index,lcLangvalue) in self.langArr.enumerated()
//            {
//                if lcLangvalue == "3"
//                {
//                   self.langArr.remove(at: index)
//                }
//            }
//        }
//        self.selectedLanguage = json(from: self.langArr)
//    }
//
//    @IBAction func btnMALE_OnClick(_ sender: Any)
//    {
//        self.selectedGender = "Male"
//    }
//
//    @IBAction func btnFEMALE_OnClick(_ sender: Any)
//    {
//        self.selectedGender = "Female"
//    }
//
//    @IBAction func btnOTHER_OnClick(_ sender: Any)
//    {
//        self.selectedGender = "Other"
//    }
//
//    func updateCharacterCount() {
//        let summaryCount = self.txtAboutSelf.text.characters.count
//
//        self.lblCountWords.text = "\((0) + summaryCount)/250"
//
//
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
//        if(textView == txtAboutSelf)
//        {
//            return textView.text.characters.count +  (text.characters.count - range.length) <= 250
//        }
//        return false
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        guard let text = txtContactNo.text else { return true }
//        let newLength = text.characters.count + string.characters.count - range.length
//
//        return newLength <= 10 // Bool
//
//
//    }
//}


//extension String {
//
//    func fileName() -> String {
//        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
//    }
//
//    func fileExtension() -> String {
//        return NSURL(fileURLWithPath: self).pathExtension ?? ""
//    }
//}



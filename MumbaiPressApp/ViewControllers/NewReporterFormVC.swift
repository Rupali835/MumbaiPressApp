

import UIKit
import Alamofire
import SHSnackBarView

class ReferencsData {
    var RefName : String!
    var refContact : String!
    var refType : String!
    var refTblInt : Int!
    
    init(RefName: String, refContact: String, refType: String, refTblInt: Int)
    {
        self.RefName = RefName
        self.refContact = refContact
        self.refType = refType
        self.refTblInt = refTblInt
    }
}

class RepoterData: NSObject {
    var name: String!
    var profile_count: String!
    var mrp_profile_pic: URL!
    var email: String!
    var contact: String!
    var gender: String!
    var qualification: String!
    var news_language: String!
    var about_repoter: String!
    var reference: String!
    var count: String!
    var document: URL!
}

class NewReporterFormVC: UIViewController, UITextFieldDelegate, TableViewDelegateDataSource, UITextViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
   
   
    @IBOutlet weak var scrollView: SPKeyBoardAvoiding!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnTermsAgree: CheckboxButton!
    @IBOutlet weak var btnHINDI: CheckboxButton!
    @IBOutlet weak var btnURDU: CheckboxButton!
    @IBOutlet weak var btnENGLISH: CheckboxButton!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var txtAboutSelf: UITextView!
    @IBOutlet weak var lblCountWords: UILabel!
    @IBOutlet weak var txtQualification: HoshiTextField!
    @IBOutlet weak var txtContactNo: HoshiTextField!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnMale: DLRadioButton!
    @IBOutlet weak var HgtOfAboutSelfView: NSLayoutConstraint!
    @IBOutlet var viewTerms: UIView!
    @IBOutlet weak var TopOfBtnSubmit: NSLayoutConstraint!
    @IBOutlet weak var TopOfTermsView: NSLayoutConstraint!
    @IBOutlet weak var tblDocument: UITableView!
    @IBOutlet weak var HgtOfDocumentView: NSLayoutConstraint!
    @IBOutlet weak var HgtOfContentView: NSLayoutConstraint!
    @IBOutlet weak var viewReference: UIView!
    @IBOutlet weak var tblReferenceInfo: UITableView!
    @IBOutlet weak var HgtOfRefTable: NSLayoutConstraint!
    @IBOutlet weak var HgtOfRefView: NSLayoutConstraint!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var Viewbar: UIView!
    @IBOutlet weak var txtName: HoshiTextField!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var txtRef_repname: HoshiTextField!
    @IBOutlet weak var btnRef_reporter: DLRadioButton!
    @IBOutlet weak var HgtOfDocTbl: NSLayoutConstraint!
    @IBOutlet weak var refTblView: UIView!
    @IBOutlet weak var txtRef_repcontact: HoshiTextField!
    
    var SelectedRow: Int!
    var popUp : KLCPopup!
    var formValid = Bool(true)
    var TblInt : Int = 0
    let snackbarView = snackBar()
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var DateStr : String?
    var NumberArray : [String] = []
    var NameArray : [String] = []
    var selectedGender: String!
    var selectedLanguage: String!
    var references: String!
    var rep_Type: String?
    var DictArr = [[String: String]]()
    var langArr = [String]()
    var DBAttachmentArr = [DBAttachment]()
    var repoter = RepoterData()
    var docArr = [String]()
    
    var tblHeightOfRef: CGFloat?
    var tblHeightOfDoc: CGFloat?
    
    var gender: String!
    
    var selectedImage: UIImage!
    var DocumentselectedImage: UIImage!
    var filePath: String!
    var fileURL: URL!
    var fileName: String!
    var DocumentImageFileName: String!
    var DocumentFileURL: URL!
    var DocumentFileName: String?
    var refArr = [ReferencsData]()
    
    var NewRefArr = [[String:String]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.HgtOfContentView.constant = 1200
        self.Viewbar.designCell()
        sideMenus()
        self.SelectedRow = -1
        self.TblInt = 0
        tblDocument.register(UINib(nibName: "cellForVideo", bundle: nil), forCellReuseIdentifier: "cellForVideo")
        tblDocument.delegate = self
        tblDocument.dataSource = self
        
        tblReferenceInfo.register(UINib(nibName: "ReferenceNameCell", bundle: nil), forCellReuseIdentifier: "ReferenceNameCell")
        tblReferenceInfo.delegate = self
        tblReferenceInfo.dataSource = self
        
        popUp = KLCPopup()

        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKeyboardGesture.delegate = self
        self.mainView.addGestureRecognizer(dismissKeyboardGesture)
        self.viewReference.addGestureRecognizer(dismissKeyboardGesture)
        self.btnMale.isMultipleSelectionEnabled = false
        self.btnRef_reporter.isMultipleSelectionEnabled = false
        self.HgtOfRefTable.constant = 0
        self.HgtOfDocTbl.constant = 0
        txtRef_repcontact.delegate = self
        txtRef_repname.delegate = self
        self.tblReferenceInfo.separatorStyle = .none
        
        self.btnProfile.clipsToBounds = true
        self.btnProfile.layer.cornerRadius = self.btnProfile.frame.size.height/2
        self.btnProfile.layer.borderWidth = 1.5
        self.btnProfile.layer.borderColor = UIColor(red:0.63, green:0.05, blue:0.10, alpha:1.0).cgColor
        
        self.updateCharacterCount()
        
        self.txtName.delegate = self
        self.txtEmail.delegate = self
        self.txtAboutSelf.delegate = self
        self.txtQualification.delegate = self
        self.txtContactNo.delegate = self
        self.txtRef_repcontact.delegate = self
        self.txtRef_repname.delegate = self
        
        self.txtAboutSelf.layer.borderWidth = 1
        self.txtAboutSelf.layer.borderColor = UIColor(red:0.63, green:0.05, blue:0.10, alpha:1.0).cgColor
        
         self.scrollView.delegate = self;
        
    }

    
//////////////////////////      KEYBOARD-METHOD    ////////////////////
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.mainView))!
        {
            self.view.endEditing(true)
            return false
        }
        return true
    }
 
    
    
    //////////////////////    TEXTFIELD - METHODS   /////////////////
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        print("textFieldDidBeginEditing")
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool
    {
        scoreText.resignFirstResponder()
      
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == txtAboutSelf)
        {
            return textView.text.characters.count +  (text.characters.count - range.length) <= 250
        }
        return false
    
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == txtContactNo
        {
            guard let text = txtContactNo.text else { return true }
              let newLength = text.characters.count + string.characters.count - range.length

            return newLength <= 10 // Bool
        }
        if textField == txtRef_repcontact
        {
            guard let text = txtRef_repcontact.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length

            return newLength <= 10 // Bool
        }
        return true
    
    }

    
    func textViewDidChange(_ textView: UITextView)
    {
        updateCharacterCount()
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == txtAboutSelf
        {
            if txtAboutSelf.text == "TAP HERE TO WRITE"
            {
                txtAboutSelf.text = nil
                txtAboutSelf.textColor = UIColor.black
            }
         
        }
    }
    
//********************     BUTTONS - ACTIONS      *******************//
  
   
    @IBAction func btnEng_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)
        if btnENGLISH.on
        {
            self.langArr.append("1")
        }else{
            for (index,lcLangvalue) in self.langArr.enumerated()
            {
                if lcLangvalue == "1"
                {
                    self.langArr.remove(at: index)
                }
            }
        }
        self.selectedLanguage = json(from: self.langArr)
    }
    
    @IBAction func btnHindi_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)

        if btnHINDI.on
        {
            self.langArr.append("2")
        }else{
            for (index,lcLangvalue) in self.langArr.enumerated()
            {
                if lcLangvalue == "2"
                {
                    self.langArr.remove(at: index)
                }
            }
        }
        
        self.selectedLanguage = json(from: self.langArr)

    }
    
    @IBAction func btnUrdu_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)

        if btnURDU.on
        {
            self.langArr.append("3")
        }else{
            for (index,lcLangvalue) in self.langArr.enumerated()
            {
                if lcLangvalue == "3"
                {
                    self.langArr.remove(at: index)
                }
            }
        }
        self.selectedLanguage = json(from: self.langArr)
    }
    
    @IBAction func btnProfile_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)

        self.TakePhoto()
    }
    
    @IBAction func btnMale_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)

       let Gender =  (sender as AnyObject).tag
        
        if Gender == 1
        {
            self.selectedGender = "Male"
        }else if Gender == 2
        {
            self.selectedGender = "Female"
        }else{
            self.selectedGender = "Other"
        }
    }
   
    @IBAction func btnTermsOk_click(_ sender: Any)
    {
        self.view.endEditing(true)

       popUp.dismiss(true)
    }
    
    @IBAction func btnSubmit_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)
        self.Validation()
    }
    
    @IBAction func btnTerms_OnClick(_ sender: Any)
    {
        viewTerms.isHidden = false
        viewReference.isHidden = true
        popUp.contentView = viewTerms
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)

    }
    
    
    @IBAction func btnAddAttachment_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)

       self.SelectedRow = 2
        self.TakeDocument()
    }
    
    @IBAction func btnOpenRefView_OnClick(_ sender: Any)
    {
        self.view.endEditing(true)

        txtRef_repname.text = ""
        txtRef_repcontact.text = ""
        viewTerms.isHidden = true
        viewReference.isHidden = false
        popUp.contentView = viewReference
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = false
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
    }
    
    @IBAction func btnRef_reporter_onClick(_ sender: Any)
    {
        self.view.endEditing(true)

        self.SelectedRow = 1
        let abc =  (sender as AnyObject).tag
        if abc == 1
        {
            self.rep_Type = "1"
            
        }else{
            self.rep_Type = "2"
            
        }
    }
    
    @IBAction func btnRef_send_onClick(_ sender: Any)
    {
        guard let name = txtRef_repname.text
            else{
                self.popUp.dismiss(true)
                return
            }
        
        guard let contact = txtRef_repcontact.text
            else{
                self.popUp.dismiss(true)
                return
        }
        
        guard let repType = self.rep_Type
            else {
            popUp.dismiss(true)
                return
        }
        
        var RefDict = [String: String]()
        
        if (txtRef_repname.text != "") && (txtRef_repcontact.text != "")
        {
            self.refArr.append(ReferencsData(RefName: name, refContact: contact, refType: repType, refTblInt: 1))
        
            RefDict["rep_name"] = name
             RefDict["rep_number"] = contact
             RefDict["rep_type"] = repType
            
          self.NewRefArr.append(RefDict)
            
        }
        
        self.tblReferenceInfo.reloadData()
        self.setTableViewHeight(ArrCount: self.refArr.count)
        popUp.dismiss(true)
        
    }
    
  
 //////************     TABLEVIEW - METHODS   *************////////////
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if tableView == tblReferenceInfo
       {
        return self.refArr.count
       }else{
        return self.docArr.count
        }
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblReferenceInfo
        {
            let cell = tblReferenceInfo.dequeueReusableCell(withIdentifier: "ReferenceNameCell", for: indexPath) as! ReferenceNameCell
            
            let lcRef = refArr[indexPath.row]
            
            cell.lblNameRef.text = lcRef.RefName
            cell.lblContactRef.text = lcRef.refContact
            
            if lcRef.refType == "1"
            {
                cell.lblRefType.text = "Reporter"
            }else{
                cell.lblRefType.text = "Personality"
            }
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(Delete_Click(sender:)), for: .touchUpInside)
            
            return cell
            
        }else{
            
            let cell = tblDocument.dequeueReusableCell(withIdentifier: "cellForVideo", for: indexPath) as!cellForVideo
           
           cell.lblAudioVideo.text = docArr[indexPath.row]
           
            cell.btnDeletaDocmnt.tag = indexPath.row
            cell.btnDeletaDocmnt.addTarget(self, action: #selector(DeleteDocumnt_Click(sender:)), for: .touchUpInside)
            return cell
        }
        
       
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblReferenceInfo{
             return 100.0
        }else{
            return 70.0
        }
    }

    
  ///////////////////////     EXTRA - METHODS   ////////////////////////
   
    
    func setTableViewHeight(ArrCount: Int)
    {
        
        if self.SelectedRow == 1
        {
            tblHeightOfRef = CGFloat(100 * ArrCount)
            self.HgtOfRefTable.constant = tblHeightOfRef!
            
        }else{
            tblHeightOfDoc = CGFloat(80 * ArrCount)
            self.HgtOfDocTbl.constant = tblHeightOfDoc!
        }
        
        if let tblHeightOfRef = self.tblHeightOfRef
        {
          if let tblHeightOfDoc = self.tblHeightOfDoc
          {
            self.HgtOfContentView.constant = 1200 + tblHeightOfRef + tblHeightOfDoc
          }else{
                self.HgtOfContentView.constant = 1200 + tblHeightOfRef
            }
        }
        
        
        if let tblHeightOfDoc = self.tblHeightOfDoc
        {
           if let tblHeightOfRef = self.tblHeightOfRef
           {
            self.HgtOfContentView.constant = 1200 + tblHeightOfRef + tblHeightOfDoc
           }else{
            self.HgtOfContentView.constant = 1200 + tblHeightOfDoc
            }
        }
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
    
    func TakeDocument()
    {
        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
            
            
            for lcAttachment in CDBAttachmentArr
            {
                self.DocumentFileName = lcAttachment.fileName
                self.DocumentImageFileName = lcAttachment.fileName
                
                lcAttachment.loadOriginalImage(completion: {image in
                    self.DocumentselectedImage = image
                })
                
                self.DocumentFileURL = lcAttachment.url
                print("URL = \(self.DocumentFileURL)")
                
                self.docArr.append(lcAttachment.fileName!)
                self.tblDocument.reloadData()
                self.setTableViewHeight(ArrCount: self.docArr.count)
                
            }
            
        }, cancel: nil)
        
        
        attachmentPickerController.mediaType = .image
        attachmentPickerController.mediaType = .video
        attachmentPickerController.capturedVideoQulity = UIImagePickerControllerQualityType.typeHigh
        attachmentPickerController.allowsMultipleSelection = false
        attachmentPickerController.allowsSelectionFromOtherApps = true
        attachmentPickerController.present(on: self)
        
        
    }
    
    func TakePhoto()
    {
        let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
            
            for lcAttachment in CDBAttachmentArr
            {
                self.fileName = lcAttachment.fileName
                
                lcAttachment.loadOriginalImage(completion: {image in
                    
                 self.btnProfile.setImage(image, for: .normal)
                 self.btnProfile.layer.cornerRadius = self.btnProfile.frame.size.height / 2
                self.selectedImage = image
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
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    @objc func Delete_Click(sender: AnyObject)
    {
        let alert = UIAlertController(title: "MumbaiPress", message: "Are you sure to delete this?", preferredStyle: UIAlertControllerStyle.actionSheet)

        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in

            let nIndex = sender.tag
            
            let refArrObj = self.refArr[nIndex!]
            
            self.SelectedRow = refArrObj.refTblInt
            
            self.refArr.remove(at: nIndex!)
            
            self.tblReferenceInfo.reloadData()
            self.setTableViewHeight(ArrCount: self.refArr.count)
          
        }

        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    @objc func DeleteDocumnt_Click(sender: AnyObject)
    {
        let alert = UIAlertController(title: "MumbaiPress", message: "Are you sure to delete this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let nIndex = sender.tag
            self.docArr.remove(at: nIndex!)
            self.SelectedRow = 2
            self.tblDocument.reloadData()
            self.setTableViewHeight(ArrCount: self.docArr.count)
            
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    

    func Validation()
    {
        formValid = true
        if txtName.text == ""
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
        
        if txtContactNo.text == ""
        {
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter Contact number", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        
        if ((txtContactNo.text?.count)! < 10) && ((txtContactNo.text?.count)! > 10)
        {
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter valid Contact number", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        
        if txtQualification.text == ""
        {

            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please enter Qualification", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }

        if (btnENGLISH.on == false) && (btnHINDI.on == false) && (btnURDU.on == false)
            {
                let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please select News language", textColor: UIColor.white, interval: 2)
                formValid = false
                return
            }
        
        if (btnMale.tag != 1) && (btnMale.tag != 2) && (btnMale.tag != 3)
        {
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please select gender", textColor: UIColor.white, interval: 2)
            formValid = false
            return
        }
        
        if btnTermsAgree.on == false
        {
            let snackbarBgColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
            self.snackbarView.showSnackBar(view: self.view, bgColor: snackbarBgColor, text: "Please agree Terms and conditions", textColor: UIColor.white, interval: 2)
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
        
        repoter.name = txtName.text
        
        if self.selectedImage != nil{
            repoter.profile_count = "1"
        }else{
            repoter.profile_count = "0"
        }
        
        repoter.email = txtEmail.text
        repoter.contact = txtContactNo.text
        repoter.gender = self.selectedGender
        repoter.qualification = txtQualification.text
        repoter.news_language = self.selectedLanguage
        repoter.about_repoter = txtAboutSelf.text
        
        
        if self.refArr.isEmpty == true
        {
            self.references = "NF"
        }
        else{
            self.references = self.json(from: self.NewRefArr)
        }
        repoter.reference = self.references
        
        repoter.document = URL(fileURLWithPath: "")
        
        if self.DocumentFileName != nil{
            repoter.count = "1"
        }else{
            repoter.count = "0"
        }
        
 
        let Reporturl = "https://mumbaipress.com/wp-content/themes/mumbai_press/API/insertRepoter.php"
        
        let param : [String: String] =
            [  "name": repoter.name,
               //   "profile_count": repoter.profile_count,
                "profile_count": repoter.profile_count,
                "email": repoter.email,
                "contact": repoter.contact,
                "gender": repoter.gender,
                "qualification": repoter.qualification,
                "news_language": repoter.news_language,
                "about_reporter":  repoter.about_repoter,
                "reference": repoter.reference,
                "count": repoter.count
             ]
        
        print(param)
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                if self.selectedImage != nil
                {
                    let data = UIImageJPEGRepresentation(self.selectedImage,0.0)
                    multipartFormData.append(data!, withName: "mrp_profile_pic", fileName: self.fileName, mimeType: "image/jpeg")
                    
                }
                
                if self.DocumentFileURL != nil
                {
                    multipartFormData.append(self.DocumentFileURL, withName: "Document1" , fileName: self.DocumentFileName!, mimeType: "pdf/text")
                }else{
                    if self.DocumentselectedImage != nil{
                        let data = UIImageJPEGRepresentation(self.DocumentselectedImage,0.0)
                        multipartFormData.append(data!, withName: "Document1", fileName: self.DocumentImageFileName, mimeType: "image/jpeg")
                    }
                    
                }
                
                for (key, val) in param {
                    multipartFormData.append((val as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
                }
        },
            to: Reporturl,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let jsonResponse = response.result.value as? [String: Any] {
                            print(jsonResponse)
                            
        let Msg = jsonResponse["msg"] as! String
                            
        if Msg == "Not Uploaded, Not Uploaded"
        {
            self.showAlert(title: "Failed", Msg: "Your Image or document not uploaded, Please try again")
            
        }else if Msg == "success"
        {
            self.showAlert(title: "Success", Msg: "Your Application has been submitted. We will contact you on your email once verified")
            
        }else if Msg == "Email Already Exist"
        {
            self.showAlert(title: "Failed", Msg: "Your input email or contact is already exits, Please try with another")
            
        }else if Msg == "Contact No Already Exist"
        {
            self.showAlert(title: "Failed", Msg: "Your input email or contact is already exits, Please try with another")
        }else if Msg == "fail"
        {
            self.showAlert(title: "Failed", Msg: "Something went wrong, Please retry")
                            }

            }
        }
               
        case .failure(let encodingError):
            print(encodingError)
                }
        })
        
        
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
    
    
    func updateCharacterCount() {
        let summaryCount = self.txtAboutSelf.text.characters.count
        
        self.lblCountWords.text = "\((0) + summaryCount)/250"
        
        
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         self.view.endEditing(true)
    }
}

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


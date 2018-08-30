//
//  MediaCollectionVC.swift
//  MumbaiPressApp
//
//  Created by user on 15/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices

class MediaCollectionVC: UIViewController, TableViewDelegateDataSource
{
   
    @IBOutlet weak var segmentCntl: UISegmentedControl!
    @IBOutlet weak var tblMedia: UITableView!
    
    var IMGArr = [ImageData]()
    var VideoARR = [URL]()
    var recordings = [URL]()
    var player: AVAudioPlayer!
    var selectedIndex : Int! = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.selectedIndex = 1
         tblMedia.register(UINib(nibName: "UploadMediaCell", bundle: nil), forCellReuseIdentifier: "UploadMediaCell")
        
         tblMedia.register(UINib(nibName: "cellForVideo", bundle: nil), forCellReuseIdentifier: "cellForVideo") 
        
        tblMedia.delegate = self
        tblMedia.dataSource = self
        tblMedia.separatorStyle = .none
        
        // set the recordings array
        listRecordings()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(MediaCollectionVC.longPress(_:)))
        recognizer.minimumPressDuration = 0.5 //seconds
        recognizer.delegate = self
        recognizer.delaysTouchesBegan = true
        self.tblMedia?.addGestureRecognizer(recognizer)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(MediaCollectionVC.doubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.delaysTouchesBegan = true
        self.tblMedia?.addGestureRecognizer(doubleTap)
    }

   
    
    @IBAction func Onsegment_Click(_ sender: Any)
    {
        switch segmentCntl.selectedSegmentIndex
        {
        case 0:
            self.selectedIndex = 1
           
            break
            
        case 1:
            self.selectedIndex = 2
            break
            
        case 2:
            self.selectedIndex = 3
            break
            
        default:
            print("")
        }
         tblMedia.reloadData()
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch selectedIndex {
        case 1:
             return self.recordings.count
            
        case 2:
            return self.VideoARR.count
        
        case 3:
            return self.IMGArr.count
        default:
            print("")
        }
        return 0
       
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
     //     designCell(cView: cell.backView)
        
        switch selectedIndex {
        case 1:
            
              let cell = tblMedia.dequeueReusableCell(withIdentifier: "cellForVideo", for: indexPath) as! cellForVideo
            cell.lblAudioVideo.text = recordings[indexPath.row].lastPathComponent
              designCell(cView: cell.backView)
              cell.btnDeletaDocmnt.isHidden = true
              return cell
            
        case 2:
            
              let cell = tblMedia.dequeueReusableCell(withIdentifier: "cellForVideo", for: indexPath) as! cellForVideo
            cell.lblAudioVideo.text = VideoARR[indexPath.row].lastPathComponent
               designCell(cView: cell.backView)
              cell.btnDeletaDocmnt.isHidden = true
              return cell
            
        
        case 3:
            
              let cell = tblMedia.dequeueReusableCell(withIdentifier: "UploadMediaCell", for: indexPath) as! UploadMediaCell
            let lcImagData = IMGArr[indexPath.row]
            cell.lblMedia.text = lcImagData.imgName
            cell.imgMedia.image = lcImagData.img
              designCell(cView: cell.backView)
              return cell

        default:
            print("")
        }
        
    return UITableViewCell()
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        switch selectedIndex {
        case 1:
                print("selected \(recordings[(indexPath as NSIndexPath).row].lastPathComponent)")
             play(recordings[indexPath.row])
            break
            
        case 2:
            let url = self.VideoARR[indexPath.row]
            
            let player = AVPlayer(url: url)
            let vcPlayer = AVPlayerViewController()
            vcPlayer.player = player
            self.present(vcPlayer, animated: true, completion: nil)

            break
            
        default:
            print("")
        }
    
    
       
    }
    
    func play(_ url: URL)
    {
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            self.player = nil
            print(error.localizedDescription)
            print("AVAudioPlayer init failed")
        }
        
    }
    
    func listRecordings() {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: documentsDirectory,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            self.recordings = urls.filter({ (name: URL) -> Bool in
                return name.pathExtension == "m4a"
            })
            
//            self.VideoARR = urls.filter({ (name: URL) -> Bool in
//                return name.pathExtension == "MOV"
//            })
            
            
        } catch {
            print(error.localizedDescription)
            print("something went wrong listing recordings")
        }
        
    }
    
    @objc func longPress(_ rec: UILongPressGestureRecognizer) {
        if rec.state != .ended {
            return
        }
        let p = rec.location(in: self.tblMedia)
        if let indexPath = self.tblMedia?.indexPathForRow(at: p)
        {
            if selectedIndex == 1
            {
                askToDelete(indexPath.row, Arr: recordings)
            }else if selectedIndex == 2{
                 askToDelete(indexPath.row, Arr: VideoARR)
            }else{
                
                let alert = UIAlertController(title: "Delete",
                                              message: "Delete a selected ?",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
                   
                    self.IMGArr.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.tblMedia?.reloadData()
                    }

                }))
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in
                    print("no was tapped")
                }))
                self.present(alert, animated: true, completion: nil)
        
            }
             
        }
        
    }
    
    @objc func doubleTap(_ rec: UITapGestureRecognizer) {
        if rec.state != .ended {
            return
        }
        
        let p = rec.location(in: self.tblMedia)
       if let indexPath = self.tblMedia?.indexPathForRow(at: p)
       {
        
        if self.selectedIndex == 1{
            askToRename(indexPath.row, Arr: recordings)
        }else if self.selectedIndex == 2{
            askToRename(indexPath.row, Arr: VideoARR)
        }
       
        }
        
        
    }
    
    func askToDelete(_ row: Int, Arr: [URL])
    {
        print(Arr[row])
        let alert = UIAlertController(title: "Delete",
                                      message: "Delete Recording \(Arr[row].lastPathComponent)?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            print("yes was tapped \(Arr[row])")
            self.deleteRecording(Arr[row])
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in
            print("no was tapped")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    func askToRename(_ row: Int, Arr: [URL]) {
        let recording = Arr[row]
        
        let alert = UIAlertController(title: "Rename",
                                      message: "Rename Recording \(recording.lastPathComponent)?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            [unowned alert] _ in
            print("yes was tapped \(Arr[row])")
            if let textFields = alert.textFields {
                let tfa = textFields as [UITextField]
                let text = tfa[0].text
                let url = URL(fileURLWithPath: text!)
                self.renameRecording(recording, to: url)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in
            print("no was tapped")
        }))
        alert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter a filename"
            textfield.text = "\(recording.lastPathComponent)"
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func renameRecording(_ from: URL, to: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let toURL = documentsDirectory.appendingPathComponent(to.lastPathComponent)
        
        print("renaming file \(from.absoluteString) to \(to) url \(toURL)")
        let fileManager = FileManager.default
        fileManager.delegate = self
        do {
            try FileManager.default.moveItem(at: from, to: toURL)
        } catch {
            print(error.localizedDescription)
            print("error renaming recording")
        }
        DispatchQueue.main.async {
            self.listRecordings()
            self.tblMedia?.reloadData()
        }
    }
    
    
    func deleteRecording(_ url: URL) {
        
        print("removing file at \(url.absoluteString)")
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
            print("error deleting recording")
        }
        
        DispatchQueue.main.async {
            self.listRecordings()
            self.tblMedia?.reloadData()
        }
    }
}

extension MediaCollectionVC: FileManagerDelegate {
    
    func fileManager(_ fileManager: FileManager, shouldMoveItemAt srcURL: URL, to dstURL: URL) -> Bool {
        
        print("should move \(srcURL) to \(dstURL)")
        return true
    }
    
}

extension MediaCollectionVC: UIGestureRecognizerDelegate {
    
}

extension MediaCollectionVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerControllerMediaURL] as? URL
            else { return }
        
        dismiss(animated: true) {
            let player = AVPlayer(url: url)
            let vcPlayer = AVPlayerViewController()
            vcPlayer.player = player
            self.present(vcPlayer, animated: true, completion: nil)
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension MediaCollectionVC: UINavigationControllerDelegate {
}


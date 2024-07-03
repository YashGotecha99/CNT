//
//  AddFilesVC.swift
//  TimeControllApp
//
//  Created by mukesh on 11/07/22.
//

import UIKit

protocol AddFilesVCDelegate: AnyObject {
    func checkFilesSegmentIndex(segmentIndex: Int)
}

class AddFilesVC: BaseViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addFileTitleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var uploadingImgVw: UIView!
    @IBOutlet weak var uploadingCollectionVw: UICollectionView!
    
    var selectedFilesSegmmentIndex = Int()
    weak var delegate : AddFilesVCDelegate?
    
    var filesID = Int()
    var imagePicker: UIImagePickerController!
    var arrAttachmentsData : [[String:Any]] = []
    var uploadAttachmentsArray = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        addFileTitleLbl.text = LocalizationKey.addFile.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        uploadingCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue)

        getMyFilesAttechmentsData(id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
    }
   
    
    @IBAction func backBtnClicked(_ sender: Any) {
        delegate?.checkFilesSegmentIndex(segmentIndex: selectedFilesSegmmentIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        updateMyIdAPI(id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
//        delegate?.checkFilesSegmentIndex(segmentIndex: selectedFilesSegmmentIndex)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImageClicked(_ sender: Any) {
        showActionSheet()
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: "", message: LocalizationKey.action.localizing(), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: LocalizationKey.uploadDocuments.localizing(), style: .default , handler:{ (UIAlertAction)in
            self.ChoosenPDF()
        }))
        
        alert.addAction(UIAlertAction(title: LocalizationKey.camera.localizing(), style: .default , handler:{ (UIAlertAction)in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func openCamera(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let source = picker.sourceType
        print("source", source)
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //        if source != .camera{
        guard let mediaMetadata = info[.mediaMetadata] as? [String:Any] else {
            // fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }
        if  let tiff = mediaMetadata["{TIFF}"] as? [String:Any]{
            if  let name = tiff["DateTime"] as? String{
                CameraImageManager.saveImage(imageName: "\(name).jpg", image: image)
                let nameURL = CameraImageManager.getImagePathFromDiskWith(fileName: "\(name).jpg")
                let str_Path = nameURL?.lastPathComponent ?? ""
                
                let imageData:NSData = image.jpegData(compressionQuality: 0.1)! as NSData
                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", imageData: strBase64, fileName: str_Path , type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                    print("User image upload successfully")
                    var attachmentsDetails = [String:Any]()
                    attachmentsDetails["id"] = attachIds
                    attachmentsDetails["filename"] = str_Path
                    attachmentsDetails["filetype"] = "docs"
                    attachmentsDetails["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0"
                    attachmentsDetails["to_model"] = "Timelog"
                    attachmentsDetails["to_id"] = 0
                    
                    self.arrAttachmentsData.append(attachmentsDetails)

                    if (self.uploadAttachmentsArray == ""){
                        self.uploadAttachmentsArray = String(attachIds)
                    }
                    else {
                        self.uploadAttachmentsArray = self.uploadAttachmentsArray + "," + String(attachIds)
                    }
                    
                    if self.arrAttachmentsData.count > 0 {
                        self.uploadingCollectionVw.isHidden = false
                    } else {
                        self.uploadingCollectionVw.isHidden = true
                    }
                    self.uploadingCollectionVw.reloadData()
                }
            }
        }
    }
}


// MARK: Document Picker:-
extension AddFilesVC : UIDocumentPickerDelegate {
    
    func ChoosenPDF() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .text, .gif, .pdf, .rtf], asCopy: true)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url: NSURL = (urls[0] as? NSURL)!
        let fileExtension = url.pathExtension
        var filetension = url.lastPathComponent
        filetension = filetension?.replacingOccurrences(of: "", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        var myData = NSData(contentsOf: url as URL)
        let convertURL =  url as URL
        
        let fileData = try? Data.init(contentsOf: convertURL)
        let fileStream:String = fileData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) ?? ""
        AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", imageData: fileStream, fileName: filetension ?? "", type: "document") { (errorMsg,loginMessage,attachIds)  in
            print("User attachment upload successfully")
            var attachmentsDetails = [String:Any]()
            attachmentsDetails["id"] = attachIds
            attachmentsDetails["filename"] = filetension
            attachmentsDetails["filetype"] = "docs"
            attachmentsDetails["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0"
            attachmentsDetails["to_model"] = "Timelog"
            attachmentsDetails["to_id"] = 0
            
            self.arrAttachmentsData.append(attachmentsDetails)

            if (self.uploadAttachmentsArray == ""){
                self.uploadAttachmentsArray = String(attachIds)
            }
            else {
                self.uploadAttachmentsArray = self.uploadAttachmentsArray + "," + String(attachIds)
            }
            
            if self.arrAttachmentsData.count > 0 {
                self.uploadingCollectionVw.isHidden = false
            } else {
                self.uploadingCollectionVw.isHidden = true
            }
            self.uploadingCollectionVw.reloadData()
        }
    }
}

//MARK: - CollectionView Delegate & Datasource
extension AddFilesVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAttachmentsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = uploadingCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue, for: indexPath) as? UploadDocumentsCVC else {
            return UICollectionViewCell()
        }
        
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(arrAttachmentsData[indexPath.row]["id"] ?? 0)")
        cell.imgUpload.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))

        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(self.clickToCloseBtn), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 118.0
        let itemHeight = 92.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        
        if let url = URL(string: strUrl + "/\(arrAttachmentsData[indexPath.row]["id"] ?? 0)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func clickToCloseBtn(_ sender: UIButton) {
        let id = sender.tag
        print("id ", id)
        arrAttachmentsData.remove(at: id)
        var stringArray = uploadAttachmentsArray.components(separatedBy: ",")

        if id >= 0 && id < stringArray.count {
            stringArray.remove(at: id)
            uploadAttachmentsArray = stringArray.joined(separator: ",")
            print(uploadAttachmentsArray)
            
        } else {
            print("Invalid index")
        }
        uploadingCollectionVw.reloadData()
    }
}


//MARK: Extension Api's
extension AddFilesVC {
    func getMyFilesByIDAPI() -> Void {
        let param = [String:Any]()
        print(param)

        MyFilesVM.shared.getMyFilesByIdData(parameters: param, isAuthorization: true, userId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", fileId: filesID) { [self] obj in
            self
            print("My Files Response is : ", obj.extradoc)
            
        }
    }
    
    func getMyFilesAttechmentsData(id: String) -> Void {
        let param = [String:Any]()
        MyFilesVM.shared.getMyFilesAttechmentsApi(parameters: param, id: id, isAuthorization: true) { [self] obj,responseData  in
            
            if obj.user?.attachmentsData?.count ?? 0 > 0 {
                uploadingImgVw.isHidden = false
            } else {
                uploadingImgVw.isHidden = true
            }
            
            for i in 0..<(obj.user?.attachmentsData?.count ?? 0) {
                var attachmentsDetails = [String:Any]()
                attachmentsDetails["id"] = obj.user?.attachmentsData?[i].id
                attachmentsDetails["filename"] = obj.user?.attachmentsData?[i].filename
                attachmentsDetails["filetype"] = obj.user?.attachmentsData?[i].filetype
                attachmentsDetails["user_id"] = obj.user?.attachmentsData?[i].user_id
                attachmentsDetails["to_model"] = obj.user?.attachmentsData?[i].to_model
                attachmentsDetails["to_id"] = obj.user?.attachmentsData?[i].to_id
                self.arrAttachmentsData.append(attachmentsDetails)
            }
            uploadAttachmentsArray = obj.user?.attachments ?? ""
            
            self.uploadingCollectionVw.reloadData()
        }
    }
    
    func updateMyIdAPI(id: String) -> Void {
        var param = [String:Any]()
        
        param["attachments"] = uploadAttachmentsArray
        
        print(param)

        MyFilesVM.shared.updateMyFilesAttechmentsApi(parameters: param, isAuthorization: true, id: id) { [self] obj in
            
            delegate?.checkFilesSegmentIndex(segmentIndex: selectedFilesSegmmentIndex)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

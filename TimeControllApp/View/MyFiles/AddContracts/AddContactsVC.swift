//
//  AddContactsVC.swift
//  TimeControllApp
//
//  Created by mukesh on 11/07/22.
//

import UIKit

class AddContactsVC: BaseViewController,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var descriptionTxtVw: UITextView!
    @IBOutlet weak var addContractTitleLbl: UILabel!
    @IBOutlet weak var contractNameLbl: UILabel!
    @IBOutlet weak var contractNameTxt: UITextField!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var uploadDocumnetsVw: UIView!
    @IBOutlet weak var uploadDocumentsCollectionVw: UICollectionView!
    @IBOutlet weak var availableImg: UIImageView!
    
    var selectedFilesSegmmentIndex = Int()
    weak var delegate : AddFilesVCDelegate?
    
    var contractID = Int()
    var contractAttechmentsData : [MyFilesByIdAttachments]? = []
    var arrAttachmentsData : [[String:Any]] = []
    var imagePicker: UIImagePickerController!
    var uploadAttachmentsArray = ""
    var uploadAttachmentsArrayData = [String] ()

    var availableImgFlag : Bool = true
    var comingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        descriptionTxtVw.delegate = self
//        descriptionTxtVw.text = "Type something here..."
//        descriptionTxtVw.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        if selectedFilesSegmmentIndex == 1 {
            addContractTitleLbl.text = LocalizationKey.contracts.localizing()
        } else {
            addContractTitleLbl.text = LocalizationKey.internalDOC.localizing()
        }
        contractNameLbl.text = LocalizationKey.contractName.localizing()
        contractNameTxt.placeholder = LocalizationKey.enterContractName.localizing()
        descriptionLbl.text = LocalizationKey.dESCRIPTION.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        uploadDocumentsCollectionVw.delegate = self
        uploadDocumentsCollectionVw.dataSource = self

        uploadDocumentsCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue)
        
        if comingFrom == "Details" {
            getMyContractsByIDAPI()
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        delegate?.checkFilesSegmentIndex(segmentIndex: selectedFilesSegmmentIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if contractNameTxt.text == "" {
            if selectedFilesSegmmentIndex == 1 {
                Toast.show(message: "Please enter the contract name", controller: self)
            } else {
                Toast.show(message: "Please enter the internal doc name", controller: self)
            }
        } else {
            if comingFrom == "Details" {
                updateMyContractsOrInternalDocByIDAPI()
            } else {
                addMyContractsOrInternalDocByIDAPI()
            }
        }
    }
    
    
    @IBAction func availableForAllBtnAction(_ sender: Any) {
        if availableImgFlag {
            availableImgFlag = false
            self.availableImg.image = UIImage(named: "ic_selectCheckBox")
        } else {
            availableImgFlag = true
            self.availableImg.image = UIImage(named: "ic_deselectCheckBox")
        }
    }
    
    @IBAction func btnUploadDocumentsActions(_ sender: Any) {
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
                    print("self.arrAttachmentsData is : ", self.arrAttachmentsData)
                    print("self.arrAttachmentsData count is : ", self.arrAttachmentsData.count)

                    
                    if (self.uploadAttachmentsArray == ""){
                        self.uploadAttachmentsArray = String(attachIds)
                    }
                    else {
                        self.uploadAttachmentsArray = self.uploadAttachmentsArray + "," + String(attachIds)
                    }
                    self.uploadAttachmentsArrayData.append(String(attachIds))
                    
                    if self.arrAttachmentsData.count > 0 {
                        self.uploadDocumnetsVw.isHidden = false
                    } else {
                        self.uploadDocumnetsVw.isHidden = true
                    }
                    
                    self.uploadDocumentsCollectionVw.reloadData()
                }
            }
        }
    }
}

//MARK: - CollectionView Delegate & Datasource
extension AddContactsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAttachmentsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = uploadDocumentsCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue, for: indexPath) as? UploadDocumentsCVC else {
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
        uploadDocumentsCollectionVw.reloadData()
    }
}

// MARK: Document Picker:-
extension AddContactsVC : UIDocumentPickerDelegate {
    
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
            self.uploadAttachmentsArrayData.append(String(attachIds))
            
            if self.arrAttachmentsData.count > 0 {
                self.uploadDocumnetsVw.isHidden = false
            } else {
                self.uploadDocumnetsVw.isHidden = true
            }
            self.uploadDocumentsCollectionVw.reloadData()
        }
    }
}


//MARK: Extension Api's
extension AddContactsVC {
    func getMyContractsByIDAPI() -> Void {
        var param = [String:Any]()
        print(param)

        MyFilesVM.shared.getMyContractsByIdData(parameters: param, isAuthorization: true, contractId: contractID) { [self] obj in
            self
            print("My Files Response is : ", obj.extradoc)
            contractNameTxt.text = obj.extradoc?.name
            descriptionTxtVw.text = obj.extradoc?.description
            self.contractAttechmentsData = obj.extradoc?.extraDocAttachments
            if obj.extradoc?.extraDocAttachments?.count ?? 0 > 0 {
                uploadDocumnetsVw.isHidden = false
            } else {
                uploadDocumnetsVw.isHidden = true
            }
            arrAttachmentsData = []
            
            for i in 0..<(obj.extradoc?.extraDocAttachments?.count ?? 0) {
                var attachmentsDetails = [String:Any]()
                attachmentsDetails["id"] = obj.extradoc?.extraDocAttachments?[i].id
                attachmentsDetails["filename"] = obj.extradoc?.extraDocAttachments?[i].filename
                attachmentsDetails["filetype"] = obj.extradoc?.extraDocAttachments?[i].filetype
                attachmentsDetails["user_id"] = obj.extradoc?.extraDocAttachments?[i].user_id
                attachmentsDetails["to_model"] = obj.extradoc?.extraDocAttachments?[i].to_model
                attachmentsDetails["to_id"] = obj.extradoc?.extraDocAttachments?[i].to_id
                self.arrAttachmentsData.append(attachmentsDetails)
            }
            uploadAttachmentsArray = obj.extradoc?.attachments ?? ""
            
            if comingFrom == "Details" {
                if obj.extradoc?.data?.disableAvailableForEverybody ?? false {
                    availableImgFlag = obj.extradoc?.data?.disableAvailableForEverybody ?? true
                    self.availableImg.image = UIImage(named: "ic_deselectCheckBox")
                } else {
                    availableImgFlag = obj.extradoc?.data?.disableAvailableForEverybody ?? false
                    self.availableImg.image = UIImage(named: "ic_selectCheckBox")
                }
            } else {
                availableImgFlag = true
            }
            
            uploadDocumentsCollectionVw.reloadData()
        }
    }
    
    func updateMyContractsOrInternalDocByIDAPI() -> Void {
        var param = [String:Any]()
        var data = [String:Any]()
        data["disableAvailableForEverybody"] = availableImgFlag
        
        param["attachments"] = uploadAttachmentsArray
        param["description"] = descriptionTxtVw.text
        param["doc_type"] = selectedFilesSegmmentIndex == 1 ? "contracts" : "internal"
        param["id"] = contractID
        param["name"] = contractNameTxt.text
        param["data"] = data
        
        print(param)

        MyFilesVM.shared.updateContractOrInternalDocByIdData(parameters: param, isAuthorization: true, contractId: contractID) { [self] obj in
            print("Update Contract Or Internal Doc By Id Data is : ", obj)
            
            delegate?.checkFilesSegmentIndex(segmentIndex: selectedFilesSegmmentIndex)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func addMyContractsOrInternalDocByIDAPI() -> Void {
        var param = [String:Any]()
        var data = [String:Any]()
        data["disableAvailableForEverybody"] = availableImgFlag
        
        param["attachments"] = uploadAttachmentsArray
        param["description"] = descriptionTxtVw.text
        param["doc_type"] = selectedFilesSegmmentIndex == 1 ? "contracts" : "internal"
        param["name"] = contractNameTxt.text
        param["data"] = data
        
        print(param)

        MyFilesVM.shared.addContractOrInternalDocByIdData(parameters: param, isAuthorization: true) { [self] obj in
            print("ADD Contract Or Internal Doc By Id Data is : ", obj)
            
            delegate?.checkFilesSegmentIndex(segmentIndex: selectedFilesSegmmentIndex)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

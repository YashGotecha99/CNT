//
//  UploadDocChecklistVC.swift
//  TimeControllApp
//
//  Created by mukesh on 07/08/22.
//

import UIKit

protocol UploadDocChecklistVCDelegate: class {
    func onAccepted()
}

class UploadDocChecklistVC: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var uploadSignatureBgImg: UIImageView!
    @IBOutlet weak var uploadSignatureImg: UIImageView!
    @IBOutlet weak var changeSignatureView: UIView!
    
    @IBOutlet weak var adminCollectionVw: UICollectionView!
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var memberAttachmentView: UIView!
    
    @IBOutlet weak var memberCollectionVw: UICollectionView!
    
    @IBOutlet weak var checklistTitleLbl: UILabel!
    @IBOutlet weak var staticInspectionLbl: UILabel!
    @IBOutlet weak var staticAttachmentsLbl: UILabel!
    @IBOutlet weak var staticCommentLbl: UILabel!
    @IBOutlet weak var staticSignatureLbl: UILabel!
    @IBOutlet weak var staticUploadFilesLbl: UILabel!
    @IBOutlet weak var staticDeviationLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    @IBOutlet weak var openImgView: UIView!
    @IBOutlet weak var viewImg: UIImageView!
    
    
    var signatureImg: UIImage?
    var element : Elements?
    var mainElement : Elements?
    var checkListID = 0
    
    var adminAttachmentsArray : [String] = []
    var memberAttachmentsArray : [String] = []
    var memberAttachmentData = ""
    
    weak var delegate : UploadDocChecklistVCDelegate?
    var isSignedRequired : Bool?
    var isPhotoRequired : Bool?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        checklistTitleLbl.text = LocalizationKey.checklist.localizing()
        staticInspectionLbl.text = LocalizationKey.inspection.localizing()
        staticAttachmentsLbl.text = LocalizationKey.attachments.localizing()
        staticCommentLbl.text = LocalizationKey.comment.localizing()
        staticSignatureLbl.text = LocalizationKey.signature.localizing()
        staticUploadFilesLbl.text = LocalizationKey.uploadFiles.localizing()
        staticDeviationLbl.text = LocalizationKey.deviation.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
    }
    
    func configUI(){
        openImgView.isHidden = true
        
        nameLbl.text = element?.name
        commentTxt.text = element?.comment_by_user
        
        if element?.signature != nil && element?.signature != "" {
            signatureImg = convertBase64StringToImage(imageBase64String: element?.signature ?? "")
            uploadSignatureBgImg.image = signatureImg
            uploadSignatureBgImg.contentMode = .scaleAspectFit
            uploadSignatureBgImg.layer.borderWidth = 0.5
            
            changeSignatureView.isHidden = false
            uploadSignatureImg.isHidden = true
        }
        if element?.comment == "" || element?.comment == nil {
            descView.isHidden = true
        } else {
            descView.isHidden = false
            descLbl.text = element?.comment
        }
        if element?.attachments == "" || element?.attachments == nil {
            attachmentView.isHidden = true
        } else {
            attachmentView.isHidden = false
            adminAttachmentsArray = element?.attachments?.components(separatedBy: ",") ?? []
        }
        
        if element?.attachments_by_user == "" || element?.attachments_by_user == nil {
            memberAttachmentView.isHidden = true
        }else {
            memberAttachmentView.isHidden = false
            memberAttachmentsArray = element?.attachments_by_user?.components(separatedBy: ",") ?? []
            memberAttachmentData = element?.attachments_by_user ?? ""
        }
        
        adminCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
    }
    @IBAction func saveBtn(_ sender: Any) {
        
        if isSignedRequired ?? false && signatureImg == nil {
            showAlert(message: LocalizationKey.pleaseEnterSignature.localizing(), strtitle: LocalizationKey.error.localizing())
        } else if isPhotoRequired ?? false && memberAttachmentData == "" {
            showAlert(message: LocalizationKey.pleaseUploadPhoto.localizing(), strtitle: LocalizationKey.error.localizing())
        } else {
            self.checkListCheck()
        }
    }
    @IBAction func uploadMemberDocBtn(_ sender: Any) {
//        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .text, .gif, .pdf, .rtf])
//        documentPicker.delegate = self
//        documentPicker.modalPresentationStyle = .overFullScreen
//
//        present(documentPicker, animated: true)
        
//        showActionSheet()
        
        
        ImagePickerManager().pickImage(self){ [self] image,path  in
            print(path)
            let imageData:NSData = image.jpegData(compressionQuality: 0.1)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", imageData: strBase64, fileName: path, type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                print("User attachment upload successfully")
    //            uploadLatestID = String(attachIds)
                if (self.memberAttachmentData == ""){
                    self.memberAttachmentData = String(attachIds)
                }
                else {
                    self.memberAttachmentData = self.memberAttachmentData + "," + String(attachIds)
                }
                self.memberAttachmentsArray.append(String(attachIds))
                self.memberCollectionVw.reloadData()
                self.memberAttachmentView.isHidden = false
            }
        }
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
    
    @IBAction func viewImgcrossBtnAction(_ sender: Any) {
        openImgView.isHidden = true
    }
    
    @IBAction func addSignatureBtn(_ sender: Any) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeSignatureBtn(_ sender: Any) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func addDeviationBtnAction(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "AddDeviationVC") as! AddDeviationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func openCamera(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let source = picker.sourceType
        print("source", source)
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
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
                
                AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", imageData: strBase64, fileName: str_Path, type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                    print("User attachment upload successfully")
        //            uploadLatestID = String(attachIds)
                    if (self.memberAttachmentData == ""){
                        self.memberAttachmentData = String(attachIds)
                    }
                    else {
                        self.memberAttachmentData = self.memberAttachmentData + "," + String(attachIds)
                    }
                    self.memberAttachmentsArray.append(String(attachIds))
                    self.memberCollectionVw.reloadData()
                    self.memberAttachmentView.isHidden = false
                }
            }
        }
    }
    
}

// MARK: Document Picker:-x
extension UploadDocChecklistVC : UIDocumentPickerDelegate {
    
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
//            uploadLatestID = String(attachIds)
            if (self.memberAttachmentData == ""){
                self.memberAttachmentData = String(attachIds)
            }
            else {
                self.memberAttachmentData = self.memberAttachmentData + "," + String(attachIds)
            }
            self.memberAttachmentsArray.append(String(attachIds))
            self.memberCollectionVw.reloadData()
            self.memberAttachmentView.isHidden = false
        }
    }
}

//extension UploadDocChecklistVC : UIDocumentPickerDelegate {
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//
//    }
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        dismiss(animated: true)
//
//        // Copy the file with FileManager
//        print("Documnet URL is : ", urls)
//
//        let url: NSURL = (urls[0] as? NSURL)!
//        let fileExtension = url.pathExtension
//        var filetension = url.lastPathComponent
//        filetension = filetension?.replacingOccurrences(of: "", with: "", options: NSString.CompareOptions.literal, range: nil)
//
//        var myData = NSData(contentsOf: url as URL)
//
//
//        let convertURL =  url as URL
//
//        let fileData = try? Data.init(contentsOf: convertURL)
//        let fileStream:String = fileData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) ?? ""
////
//        AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", imageData: fileStream, fileName: filetension ?? "", type: "document") { (errorMsg,loginMessage,attachIds)  in
//            print("User attachment upload successfully")
////            uploadLatestID = String(attachIds)
//            if (self.memberAttachmentData == ""){
//                self.memberAttachmentData = String(attachIds)
//            }
//            else {
//                self.memberAttachmentData = self.memberAttachmentData + "," + String(attachIds)
//            }
//            self.memberAttachmentsArray.append(String(attachIds))
//            self.memberCollectionVw.reloadData()
//            self.memberAttachmentView.isHidden = false
//        }
//    }
//}

extension UploadDocChecklistVC : SignatureProtocol {
    func signatureImg(signatureImage: UIImage) {
        signatureImg = signatureImage
        uploadSignatureBgImg.image = signatureImage
        uploadSignatureBgImg.contentMode = .scaleAspectFit
        uploadSignatureBgImg.layer.borderWidth = 0.5
        
        changeSignatureView.isHidden = false
        uploadSignatureImg.isHidden = true
    }
}

//MARK: - CollectionView Delegate & Datasource
extension UploadDocChecklistVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == adminCollectionVw) {
            return adminAttachmentsArray.count
        } else {
            return memberAttachmentsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = adminCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
            return UICollectionViewCell()
        }
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        if (collectionView == adminCollectionVw) {
            cell.crossView.isHidden = true
            let url = URL(string: strUrl + "/\(adminAttachmentsArray[indexPath.row])")
            cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        } else {
            cell.crossView.isHidden = false
            let url = URL(string: strUrl + "/\(memberAttachmentsArray[indexPath.row])")
            cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(self.clickToCloseBtn), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 90.0
        let itemHeight = 90.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        if (collectionView == adminCollectionVw) {
            let url = URL(string: strUrl + "/\(adminAttachmentsArray[indexPath.row])")
            viewImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        } else {
            let url = URL(string: strUrl + "/\(memberAttachmentsArray[indexPath.row])")
            viewImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        }
        openImgView.isHidden = false
    }
    
    @objc func clickToCloseBtn(_ sender: UIButton) {
        let id = sender.tag
        memberAttachmentsArray.remove(at: id)
        memberCollectionVw.reloadData()
        if memberAttachmentsArray.count > 0 {
            memberAttachmentView.isHidden = false
        } else {
            memberAttachmentView.isHidden = true
        }
    }
    
}

extension UploadDocChecklistVC {
    private func checkListCheck(){
        var param = [String:Any]()
        
        param["id"] = self.checkListID
        param["status"] = "Done"
        
        var elementData = [String:Any]()
        elementData["id"] =  element?.id
        elementData["name"] =  element?.name
        elementData["parent_id"] = element?.parent_id
        elementData["client_id"] = element?.client_id
        elementData["comment"] = element?.comment
        elementData["attachments"] = element?.attachments
        elementData["created_by"] = element?.created_by
        elementData["updated_by"] = 0
        elementData["created_at"] = element?.created_at
        elementData["updated_at"] = ""
        elementData["hints"] = element?.hints
        elementData["elements"] = []
        elementData["status"] = element?.status
        elementData["updated_by_name"] = ""
        elementData["due_date"] = element?.due_date
        
        elementData["comment_by_user"] = commentTxt.text
        elementData["attachments_by_user"] = "\(memberAttachmentsArray.joined(separator: ","))"
        if signatureImg != nil {
            elementData["signature"] = "data:image/png;base64," + (convertImageToBase64String(img: signatureImg ?? UIImage()) ?? "")
        }
        
        param["element_data"] = elementData
        print(param)
        
        CheckListVM.shared.checkListCheck(parameters: param){ [self] obj in
            showAlert(message: obj.message ?? "", strtitle: LocalizationKey.success.localizing()) {_ in
                self.navigationController?.popViewController(animated: true)
                delegate?.onAccepted()
            }
        }
    }
}

//
//  AddDeviationVC.swift
//  TimeControllApp
//
//  Created by mukesh on 07/08/22.
//

import UIKit

class AddDeviationVC: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var element : Elements?
    var mainElement : Elements?
    var checkListID = 0
    var selectedCheckList : ChecklistsRows?

    @IBOutlet weak var projectTxt: UITextField!
    @IBOutlet weak var subjectTxt: UITextField!
    @IBOutlet weak var deviationDetailsTxt: UITextField!
    @IBOutlet weak var urgencyTxt: UITextField!
    
    @IBOutlet weak var attachmentsView: UIView!
    @IBOutlet weak var addDeviationAttachment: UICollectionView!
    
    @IBOutlet weak var createDeviationTitleLbl: UILabel!
    @IBOutlet weak var staticProjectLbl: UILabel!
    @IBOutlet weak var staticDeviationSubjectLbl: UILabel!
    @IBOutlet weak var staticDeviationDetailsLbl: UILabel!
    @IBOutlet weak var staticUrgencyLbl: UILabel!
    @IBOutlet weak var staticUploadFilesLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var openImgView: UIView!
    @IBOutlet weak var viewImg: UIImageView!
    
    
    var imagePicker: UIImagePickerController!
    var uploadAttachmentsArray = ""
    var uploadAttachmentsArrayData = [String] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        projectTxt.text = selectedCheckList?.project_name
        subjectTxt.text = selectedCheckList?.name
        deviationDetailsTxt.text = element?.name
        
        addDeviationAttachment.delegate = self
        addDeviationAttachment.dataSource = self
        
        openImgView.isHidden = true
        attachmentsView.isHidden = true
        addDeviationAttachment.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
    }
    
    func setUpLocalization(){
        createDeviationTitleLbl.text = LocalizationKey.createDeviation.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        staticProjectLbl.text = LocalizationKey.project.localizing()
        projectTxt.placeholder = LocalizationKey.enterProject.localizing()
        staticDeviationSubjectLbl.text = LocalizationKey.project.localizing()
        subjectTxt.placeholder = LocalizationKey.enterSubject.localizing()
        staticDeviationDetailsLbl.text = LocalizationKey.project.localizing()
        deviationDetailsTxt.placeholder = LocalizationKey.enterProject.localizing()
        staticUrgencyLbl.text = LocalizationKey.urgency.localizing()
        urgencyTxt.placeholder = LocalizationKey.enterUrgency.localizing()
        staticUploadFilesLbl.text = LocalizationKey.uploadFiles.localizing()
    }
    
    @IBAction func viewImgcrossBtnAction(_ sender: Any) {
        openImgView.isHidden = true
    }
    
    @IBAction func btnSaveDeviation(_ sender: Any) {
        if (subjectTxt.text == "") {
            self.showAlert(message: LocalizationKey.pleaseEnterDeviationSubject.localizing(), strtitle: "")
        } else if (deviationDetailsTxt.text == "") {
            self.showAlert(message: LocalizationKey.pleaseEnterDeviationDetails.localizing(), strtitle: "")
        } else {
            saveChecklistDeviation()
        }
    }
    
    @IBAction func btnClickedUpload(_ sender: Any) {
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
                
                AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "", imageData: strBase64, fileName: str_Path , type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                    print("User image upload successfully")
                    if (self.uploadAttachmentsArray == ""){
                        self.uploadAttachmentsArray = String(attachIds)
                    }
                    else {
                        self.uploadAttachmentsArray = self.uploadAttachmentsArray + "," + String(attachIds)
                    }
                    self.attachmentsView.isHidden = false
                    self.uploadAttachmentsArrayData.append(String(attachIds))
                    self.addDeviationAttachment.reloadData()
                }
            }
        }
    }
}

// MARK: Document Picker:-x
extension AddDeviationVC : UIDocumentPickerDelegate {
    
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
        
        AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "", imageData: fileStream, fileName: filetension ?? "", type: "document") { (errorMsg,loginMessage,attachIds)  in
            print("User attachment upload successfully")
            if (self.uploadAttachmentsArray == ""){
                self.uploadAttachmentsArray = String(attachIds)
            }
            else {
                self.uploadAttachmentsArray = self.uploadAttachmentsArray + "," + String(attachIds)
            }
            self.attachmentsView.isHidden = false
            self.uploadAttachmentsArrayData.append(String(attachIds))
            self.addDeviationAttachment.reloadData()
        }
    }
}

//MARK: - CollectionView Delegate & Datasource
extension AddDeviationVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadAttachmentsArrayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = addDeviationAttachment.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
            return UICollectionViewCell()
        }
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(uploadAttachmentsArrayData[indexPath.row])")
        cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        cell.crossView.isHidden = true
//        cell.btnCross.addTarget(self, action: #selector(self.btnClickedCross), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 84.0
        let itemHeight = 84.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        uploadAttachmentsArrayData.remove(at: indexPath.row)
//        addDeviationAttachment.reloadData()
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(uploadAttachmentsArrayData[indexPath.row])")
        viewImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        openImgView.isHidden = false
    }
}

extension AddDeviationVC {
    private func saveChecklistDeviation(){
        var param = [String:Any]()
        
        param["attachments"] = uploadAttachmentsArray
        param["comments"] = deviationDetailsTxt.text ?? ""
        param["element_id"] = element?.id
        param["id"] = selectedCheckList?.id
        param["subject"] = subjectTxt.text

        print(param)
        
        DeviationsVM.shared.createChecklistDeviation(parameters: param){ [self] obj in
            showAlert(message: LocalizationKey.checklistDeviationCreatedSuccessfully.localizing(), strtitle: "Success") {_ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

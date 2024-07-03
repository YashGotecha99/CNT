//
//  CreateDeviationVC.swift
//  TimeControllApp
//
//  Created by mukesh on 19/07/22.
//

import UIKit

class CreateDeviationVC: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var reportedByLbl: UILabel!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var selectedProjectView: UIView!
    @IBOutlet weak var selectedProjectLbl: UILabel!
    @IBOutlet weak var selectedProjectLocationLbl: UILabel!
    
    @IBOutlet weak var selectedTaskView: UIView!
    @IBOutlet weak var selectedTaskLbl: UILabel!
    @IBOutlet weak var selectedTaskLocationLbl: UILabel!
    
    @IBOutlet weak var subjectTxt: UITextField!
    @IBOutlet weak var deviationDetailsTxt: UITextView!
    
    @IBOutlet weak var btnNormal: UIButton!
    @IBOutlet weak var btnUrgent: UIButton!
    @IBOutlet weak var btnCritical: UIButton!
    
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var attachmentCollectionVw: UICollectionView!
    
    @IBOutlet weak var causeOfDeviationTxt: UITextView!
    @IBOutlet weak var consequenceDeviationTxt: UITextView!
    @IBOutlet weak var whatCanBeDoneTxt: UITextView!
    @IBOutlet weak var howToPreventTxt: UITextView!
    @IBOutlet weak var myselfSwitch: UISwitch!
    @IBOutlet weak var dueDateTxt: UITextField!
    @IBOutlet weak var howToCorrectTxt: UITextView!
    @IBOutlet weak var howToCorrectView: UIView!
    @IBOutlet weak var howToStopTxt: UITextView!
    @IBOutlet weak var howToStopView: UIView!
    @IBOutlet weak var howWeFix: UITextView!
    @IBOutlet weak var howToFixView: UIView!
    
    @IBOutlet weak var createDeviationTitleLbl: UILabel!
    @IBOutlet weak var staticStatusLbl: UILabel!
    @IBOutlet weak var staticReportedBy: UILabel!
    @IBOutlet weak var selectProjectLbl: UILabel!
    @IBOutlet weak var selectTaskLbl: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var deviationDetailsLbl: UILabel!
    @IBOutlet weak var urgencyLbl: UILabel!
    @IBOutlet weak var normalLbl: UILabel!
    @IBOutlet weak var urgentLbl: UILabel!
    @IBOutlet weak var criticalLbl: UILabel!
    @IBOutlet weak var deviationAttachmentLbl: UILabel!
    @IBOutlet weak var caughtDeviationDetailsLbl: UILabel!
    @IBOutlet weak var estimatedcauseofdeviationLbl: UILabel!
    @IBOutlet weak var estimatedConsequenceOfTheDeviationLbl: UILabel!
    @IBOutlet weak var describeWhatCanBeDoneLbl: UILabel!
    @IBOutlet weak var describeHowToPreventItLbl: UILabel!
    @IBOutlet weak var deviationControlLbl: UILabel!
    @IBOutlet weak var iAmDoingItMyselfLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var howToCorrectLbl: UILabel!
    @IBOutlet weak var howToStopItHappenAgainLbl: UILabel!
    @IBOutlet weak var saveBtnObj: UIButton!
    @IBOutlet weak var howDidWeFixThisLbl: UILabel!
    @IBOutlet weak var projectSelectedLbl: UILabel!
    @IBOutlet weak var taskSelectedLbl: UILabel!
    
    @IBOutlet weak var cancelBtnObj: UIBarButtonItem!
    
    @IBOutlet weak var doneBtnObj: UIBarButtonItem!
    
    @IBOutlet weak var openImgView: UIView!
    @IBOutlet weak var viewImg: UIImageView!
    
    var projectId = String()
    var taskId = String()
    
    var selectedType = "normal"
    
    var attachmentsArray : [String] = []
    var attachmentData = ""
    
    var isMyself = true
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var datePickerVw: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var deviationDueDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
    }
    
    func setUpLocalization() {
        createDeviationTitleLbl.text = LocalizationKey.createDeviation.localizing()
        staticStatusLbl.text = LocalizationKey.status.localizing()
        staticReportedBy.text = LocalizationKey.reportedBy.localizing()
        selectProjectLbl.text = LocalizationKey.selectProject.localizing()
        selectTaskLbl.text = LocalizationKey.taskName.localizing()
        projectSelectedLbl.text = LocalizationKey.selected.localizing()
        taskSelectedLbl.text = LocalizationKey.selected.localizing()
        subjectLbl.text = LocalizationKey.subject.localizing()
        subjectTxt.placeholder = LocalizationKey.subject.localizing()
        deviationDetailsLbl.text = LocalizationKey.deviationDetails.localizing()
        urgencyLbl.text = LocalizationKey.urgency.localizing()
        normalLbl.text = LocalizationKey.normal.localizing()
        urgentLbl.text = LocalizationKey.urgent.localizing()
        criticalLbl.text = LocalizationKey.critical.localizing()
        deviationAttachmentLbl.text = LocalizationKey.deviationAttachments.localizing()
        caughtDeviationDetailsLbl.text = LocalizationKey.caughtDeviationDetails.localizing()
        estimatedcauseofdeviationLbl.text = LocalizationKey.estimatedCauseOfDeviation.localizing()
        estimatedConsequenceOfTheDeviationLbl.text = LocalizationKey.estimatedConsequenceOfTheDeviation.localizing()
        describeWhatCanBeDoneLbl.text = LocalizationKey.describeWhatCanBeDone.localizing()
        describeHowToPreventItLbl.text = LocalizationKey.describeHowToPreventIt.localizing()
        deviationControlLbl.text = LocalizationKey.deviationControl.localizing()
        iAmDoingItMyselfLbl.text = LocalizationKey.iAmDoingItMyself.localizing()
        dueDateLbl.text = LocalizationKey.dueDate.localizing()
        dueDateTxt.placeholder = LocalizationKey.enterDueDate.localizing()
        howToCorrectLbl.text = LocalizationKey.howToCorrect.localizing()
        howToStopItHappenAgainLbl.text = LocalizationKey.howToStopItHappenAgain.localizing()
        howDidWeFixThisLbl.text = LocalizationKey.howDidWeFixThis.localizing()
        saveBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)
        cancelBtnObj.title = LocalizationKey.cancel.localizing()
        doneBtnObj.title = LocalizationKey.done.localizing()
    }
    
    func configUI() {
        
        reportedByLbl.text = UserDefaults.standard.string(forKey: UserDefaultKeys.userName)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        deviationDueDate = formatter.string(for: date)!
        
        selectedProjectView.isHidden = true
        selectedTaskView.isHidden = true
        attachmentView.isHidden = true
        openImgView.isHidden = true
        
        btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        
        attachmentCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
    }
    
    //MARK: Button Actions
    
    @IBAction func viewImgcrossBtnAction(_ sender: Any) {
        openImgView.isHidden = true
    }
    
    @IBAction func btnProjectNameAction(_ sender: UIButton) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectProjectVC") as! SelectProjectVC
        vc.mode = "no-acl"
        vc.module = "no-module"
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnTaskNameAction(_ sender: Any) {
        if self.projectId.isEmpty || self.projectId == "0" {
            self.showAlert(message: LocalizationKey.pleaseAddProject.localizing(), strtitle: "")
            return
        }
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectTasksVC") as! SelectTasksVC
        vc.delegate = self
        vc.projectId = projectId
        vc.isComingFrom = "CreateShiftVC" //
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnNormal(_ sender: Any) {
        selectedType = "normal"
        btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    @IBAction func btnUrgent(_ sender: Any) {
        selectedType = "urgent"
        btnUrgent.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    @IBAction func btnParentalLeave(_ sender: Any) {
        selectedType = "critical"
        btnCritical.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    
    @IBAction func uploadMemberDocBtn(_ sender: Any) {
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
                
                AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", imageData: strBase64, fileName: str_Path, type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                    print("User attachment upload successfully")
        //            uploadLatestID = String(attachIds)
                    if (self.attachmentData == ""){
                        self.attachmentData = String(attachIds)
                    }
                    else {
                        self.attachmentData = self.attachmentData + "," + String(attachIds)
                    }
                    self.attachmentsArray.append(String(attachIds))
                    self.attachmentCollectionVw.reloadData()
                    self.attachmentView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func myselfSwitchChanged(_ sender: UISwitch) {
        if isMyself {
            howToCorrectView.isHidden = true
            howToStopView.isHidden = true
            howToFixView.isHidden = true
            isMyself = false
        } else {
            howToCorrectView.isHidden = false
            howToStopView.isHidden = false
            howToFixView.isHidden = false
            isMyself = true
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if (taskId == "") {
            self.showAlert(message: LocalizationKey.pleaseAddTaskOrProject.localizing(), strtitle: "")
        }else if subjectTxt.text == "" {
            self.showAlert(message: LocalizationKey.pleaseAddSubject.localizing(), strtitle: "")
        }else if deviationDetailsTxt.text == "" {
            self.showAlert(message: LocalizationKey.pleaseAddDeviationDetails.localizing(), strtitle: "")
        }else if dueDateTxt.text == "" {
            self.showAlert(message: LocalizationKey.pleaseAddDueDate.localizing(), strtitle: "")
        }else {
            self.createDeviation()
        }
    }
    
    @IBAction func btnClickedDueDateAction(_ sender: Any) {
        datePickerVw.isHidden = false
    }

    @IBAction func datePickerDoneClicked(_ sender: Any) {
        datePickerVw.isHidden = true
        dueDateTxt.text = deviationDueDate
    }
    
    @IBAction func datePickerCancelClicked(_ sender: Any) {
        datePickerVw.isHidden = true
    }
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        deviationDueDate = formatter.string(for: sender.date) ?? ""
    }

}

// MARK: Document Picker:-x
extension CreateDeviationVC : UIDocumentPickerDelegate {
    
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
            if (self.attachmentData == ""){
                self.attachmentData = String(attachIds)
            }
            else {
                self.attachmentData = self.attachmentData + "," + String(attachIds)
            }
            self.attachmentsArray.append(String(attachIds))
            self.attachmentCollectionVw.reloadData()
            self.attachmentView.isHidden = false
        }
    }
}

//MARK: Delegate
extension CreateDeviationVC : SelectProjectProtocol,AddTaskProjectNameProtocol {
    func projectId(projectId: String, projectName: String) {
        selectedProjectView.isHidden = false
        selectedProjectLbl.text = "\(projectId) | \(projectName)"
        self.projectId = projectId
    }
    func getTaskProjectName(projectId: String, taskId: String) {
        selectedTaskView.isHidden = false
        selectedTaskLbl.text = "\(taskId) | \(projectId)"
        self.taskId = taskId
    }
}

//MARK: - CollectionView Delegate & Datasource
extension CreateDeviationVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = attachmentCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
            return UICollectionViewCell()
        }
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(attachmentsArray[indexPath.row])")
        cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        
        cell.crossView.isHidden = false
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(self.clickToCloseBtn), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 90.0
        let itemHeight = 90.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(attachmentsArray[indexPath.row])")
        viewImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        openImgView.isHidden = false
    }
    
    @objc func clickToCloseBtn(_ sender: UIButton) {
        let id = sender.tag
        attachmentsArray.remove(at: id)
        self.attachmentCollectionVw.reloadData()
    }
}

extension CreateDeviationVC {
    private func createDeviation(){
        var param = [String:Any]()
        
        param["assigned_id"] = 0
        param["attachments"] = attachmentData
        param["comments"] = deviationDetailsTxt.text ?? ""
        param["due_date"] = deviationDueDate
        param["id"] = 0
        param["myself"] = isMyself
        param["project_id"] = projectId
        param["spent_hours"] = 0
        param["spent_other"] = 0
        param["spent_rate"] = 0
        param["spent_total"] = 0
        param["subject"] = subjectTxt.text ?? ""
        param["task_id"] = taskId
        param["txt_cause"] = causeOfDeviationTxt.text ?? ""
        param["txt_consequence"] = consequenceDeviationTxt.text ?? ""
        param["txt_tbd"] = whatCanBeDoneTxt.text ?? ""
        param["txt_prevent"] = howToPreventTxt.text ?? ""
        
        param["urgency"] = selectedType
        
        param["txt_how_to_correct"] = isMyself ? howToCorrectTxt.text ?? "" : ""
        param["txt_how_to_stop"] = isMyself ? howToStopTxt.text ?? "" : ""
        param["txt_fix"] = isMyself ? howWeFix.text ?? "" : ""
        
        var data = [String:Any]()
        param["data"] = data
        
        print(param)
        
        DeviationsVM.shared.createDeviation(parameters: param){ [self] obj in
            showAlert(message: LocalizationKey.deviationCreatedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.navigationController?.popViewController(animated: true)
            }
            print(obj)
            print("Stop")
        }
    }
}

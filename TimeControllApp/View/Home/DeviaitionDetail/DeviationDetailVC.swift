//
//  DeviationDetailVC.swift
//  TimeControllApp
//
//  Created by mukesh on 20/07/22.
//
import UIKit
import SVProgressHUD

protocol DeviationVCDelegate: AnyObject {
    func checkSegmentIndex(segmentIndex: Int)
}

class DeviationDetailVC: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var deviationDetailsLbl: UIView!
    @IBOutlet weak var deviationtblVw: UITableView!
    var selectedSegmmentIndex = Int()
    var selectedDeviationsID = Int()
    weak var delegate : DeviationVCDelegate?
    var deviationsDetailsData : DeviationDetails?

    var arrAttachmentsData = [[String:Any]]()
    var imagePicker: UIImagePickerController!

    var projectId = String()
    var taskId = String()
    
    var projectName = String()
    var taskName = String()

    var resposibilityId = String()
    var resposibilityName = String()
 
    var attachmentManually = Bool()
    @IBOutlet weak var datePickerVw: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var deviationDueDate = ""
    @IBOutlet weak var btnObjSave: UIButton!
    @IBOutlet weak var deviationDetailsTitleLbl: UILabel!
    @IBOutlet weak var cancelBtnObj: UIBarButtonItem!
    @IBOutlet weak var doneBtnObj: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        getDeviationsByID(deviationsID: selectedDeviationsID)
        // Do any additional setup after loading the view.
    }

    func setUpLocalization() {
        deviationDetailsTitleLbl.text = LocalizationKey.deviationDetails.localizing()
        cancelBtnObj.title = LocalizationKey.cancel.localizing()
        doneBtnObj.title = LocalizationKey.done.localizing()
        btnObjSave.setTitle(LocalizationKey.save.localizing(), for: .normal)
    }
    
    func configUI() {
        deviationtblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.DeviationDetailTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.DeviationDetailTVC.rawValue)
        
        deviationtblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.DeviationDocTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.DeviationDocTVC.rawValue)
        
        deviationtblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.DeviationCreateDetailTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.DeviationCreateDetailTVC.rawValue)
        
        deviationtblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.DeviationProjectTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.DeviationProjectTVC.rawValue)
        datePicker.minimumDate = Date()
        deviationtblVw.reloadData()
    }

    @IBAction func btnBackAction(_ sender: Any) {
        delegate?.checkSegmentIndex(segmentIndex: selectedSegmmentIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnClickedProjectName(_ sender: UIButton) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectProjectVC") as! SelectProjectVC
        vc.mode = "managers"
        vc.module = "no-module"
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @objc func btnClickedTaskName(_ sender: UIButton) {
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
    
    @objc func btnClickedResponsibilty(_ sender: UIButton) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectEmplyeeVC") as! SelectEmplyeeVC
        vc.delegate = self
        vc.deviationId = deviationsDetailsData?.id ?? 0
        vc.projectId = projectId
        vc.assigneeId = resposibilityId
        vc.lastAssigneeId = resposibilityId
        vc.isComingFrom = "DeviationDetails"
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @objc func clickToImageUpload(_ sender: UIButton) {
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
                
                AllUsersVM.shared.saveUserAttachment(imageId: "\(deviationsDetailsData?.assigned_id ?? 0)", imageData: strBase64, fileName: str_Path , type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                    print("User image upload successfully")
                    var attachmentsDetails = [String:Any]()
                    attachmentsDetails["id"] = attachIds
                    attachmentsDetails["filename"] = str_Path
                    attachmentsDetails["filetype"] = "image"
                    attachmentsDetails["user_id"] = "\(self.deviationsDetailsData?.assigned_id ?? 0)"
                    attachmentsDetails["to_model"] = "Deviation"
                    attachmentsDetails["to_id"] = attachIds
                    
                    self.arrAttachmentsData.append(attachmentsDetails)
                    self.deviationtblVw.reloadData()
                }
            }
        }
    }
    
    @objc func btnClickedDueDate(_ sender: UIButton) {
        datePickerVw.isHidden = false
        deviationsDetailsData?.due_date = deviationDueDate
        self.deviationtblVw.reloadData()
    }
    
    @IBAction func datePickerDoneClicked(_ sender: Any) {
        datePickerVw.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        deviationDueDate = formatter.string(for: datePicker.date) ?? ""
        self.deviationtblVw.reloadData()
    }
    
    @IBAction func datePickerCancelClicked(_ sender: Any) {
        datePickerVw.isHidden = true
    }
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        deviationDueDate = formatter.string(for: sender.date) ?? ""
        self.deviationtblVw.reloadData()
    }
    
    @IBAction func btnClickedSave(_ sender: Any) {
        if deviationDueDate != ""  {
            upadateDeviationByID(deviationsID: selectedDeviationsID)
        } else {
            self.showAlert(message: LocalizationKey.pleaseAddDueDate.localizing(), strtitle: "")
        }
    }
}

//MARK: Delegate
extension DeviationDetailVC : SelectProjectProtocol,AddTaskProjectNameProtocol,SelectEmployeeProtocol, DeviationDocDetailsTVCDelegate, DeviationProjectTVCDelegate {
    
    func projectId(projectId: String, projectName: String) {
        self.projectId = projectId
        self.projectName = projectName
        self.deviationtblVw.reloadData()
    }
    func getTaskProjectName(projectId: String, taskId: String) {
        self.taskId = taskId
        self.taskName = projectId
        self.deviationtblVw.reloadData()
    }
    func employeeId(empId: String, empName: String) {
        self.resposibilityId = empId
        self.resposibilityName = empName
        deviationsDetailsData?.assignee?.id = Int(empId)
        attachmentManually = true
        
        if empId == "" {
            deviationsDetailsData?.assignee = nil
            self.resposibilityId = String()
            self.resposibilityName = String()
            attachmentManually = false
        }
        
        getDeviationsByID(deviationsID: selectedDeviationsID)
        self.deviationtblVw.reloadData()
    }
    func onUrgencyUpdated(uregencyData: String) {
        deviationsDetailsData?.urgency = uregencyData
    }
    func onTextViewDidEndEditingData(textViewData: String, textViewType: String) {
        
        if (textViewType == "txt_cause") {
            deviationsDetailsData?.txt_cause = textViewData
        } else if (textViewType == "txt_consequence") {
            deviationsDetailsData?.txt_consequence = textViewData
        } else if (textViewType == "txt_tbd") {
            deviationsDetailsData?.txt_tbd = textViewData
        } else if (textViewType == "txt_prevent") {
            deviationsDetailsData?.txt_prevent = textViewData
        } else if (textViewType == "txt_how_to_correct") {
            deviationsDetailsData?.txt_how_to_correct = textViewData
        } else if (textViewType == "txt_how_to_stop") {
            deviationsDetailsData?.txt_how_to_stop = textViewData
        } else if (textViewType == "txt_fix") {
            deviationsDetailsData?.txt_fix = textViewData
        } else if (textViewType == "spent_hours") {
            deviationsDetailsData?.spent_hours = Int(textViewData)
        } else if (textViewType == "spent_rate") {
            deviationsDetailsData?.spent_rate = Int(textViewData)
        } else if (textViewType == "spent_other") {
            deviationsDetailsData?.spent_other = Int(textViewData)
        } else if (textViewType == "spent_total") {
            deviationsDetailsData?.spent_total = Int(textViewData)
        } else if (textViewType == "subject") {
            deviationsDetailsData?.subject = textViewData
            self.deviationtblVw.reloadData()
        } else if (textViewType == "comments") {
            deviationsDetailsData?.comments = textViewData
            self.deviationtblVw.reloadData()
        }
    }
    
    func deviationAttachmentAfterDelete(afterDeleterAttachmentData : [[String:Any]]) {
        arrAttachmentsData = afterDeleterAttachmentData
    }
}

// MARK: Document Picker:-x
extension DeviationDetailVC : UIDocumentPickerDelegate {
    
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
        
        AllUsersVM.shared.saveUserAttachment(imageId: "\(deviationsDetailsData?.assigned_id ?? 0)", imageData: fileStream, fileName: filetension ?? "", type: "document") { (errorMsg,loginMessage,attachIds)  in
            print("User attachment upload successfully")
            var attachmentsDetails = [String:Any]()
            attachmentsDetails["id"] = attachIds
            attachmentsDetails["filename"] = filetension
            attachmentsDetails["filetype"] = "document"
            attachmentsDetails["user_id"] = "\(self.deviationsDetailsData?.assigned_id ?? 0)"
            attachmentsDetails["to_model"] = "Deviation"
            attachmentsDetails["to_id"] = attachIds
            
            self.arrAttachmentsData.append(attachmentsDetails)
            self.deviationtblVw.reloadData()
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension DeviationDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            if section == 3 {
                return deviationsDetailsData?.data?.history?.count ?? 0
            }
            return 1
        } else {
            if section == 2 {
                return deviationsDetailsData?.data?.history?.count ?? 0
            }
            return 1
        }
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DeviationDetailTVC.rawValue, for: indexPath) as? DeviationDetailTVC else { return UITableViewCell() }
                cell.setData(deviationsDetailsData: deviationsDetailsData)
                return cell
            } else if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DeviationProjectTVC.rawValue, for: indexPath) as? DeviationProjectTVC else { return UITableViewCell() }
                cell.delegate = self
                cell.setData(deviationsDetailsData: deviationsDetailsData, projectID: self.projectId, projectName: self.projectName, taskID: self.taskId, taskName: self.taskName)
                cell.btnProjectName.addTarget(self, action: #selector(self.btnClickedProjectName), for: .touchUpInside)
                cell.btnTaskName.addTarget(self, action: #selector(self.btnClickedTaskName), for: .touchUpInside)
                return cell
            }
            else if indexPath.section == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DeviationDocTVC.rawValue, for: indexPath) as? DeviationDocTVC else { return UITableViewCell() }
//                cell.setData(deviationsDetailsData: deviationsDetailsData, arrAttahmentsData: arrAttachmentsData)
                cell.delegate = self
                cell.setData(deviationsDetailsData: deviationsDetailsData, arrAttahmentsData: arrAttachmentsData, attachementManually: attachmentManually, responsibleId: resposibilityId, responsibleName: resposibilityName, deviationDueDate: deviationDueDate)
                cell.btnBrowseToUpload.addTarget(self, action: #selector(self.clickToImageUpload), for: .touchUpInside)
                cell.btnResponsibilty.addTarget(self, action: #selector(self.btnClickedResponsibilty), for: .touchUpInside)
                cell.btnDueDate.addTarget(self, action: #selector(self.btnClickedDueDate), for: .touchUpInside)
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DeviationCreateDetailTVC.rawValue, for: indexPath) as? DeviationCreateDetailTVC else { return UITableViewCell() }
    //        cell.setData(deviationsDetailsData: deviationsDetailsData?.data?.history[inde])
            cell.nameLbl.text = deviationsDetailsData?.data?.history?[indexPath.row].user?.name
            cell.dateLbl.text = deviationsDetailsData?.data?.history?[indexPath.row].timestamp?.convertAllFormater(formated: "EEE, MMM-dd-yyyy, hh:mm")
            cell.trasitionLbl.text = deviationsDetailsData?.data?.history?[indexPath.row].transitionState
            return cell
        } else {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DeviationDetailTVC.rawValue, for: indexPath) as? DeviationDetailTVC else { return UITableViewCell() }
                cell.setData(deviationsDetailsData: deviationsDetailsData)
                return cell
            } else if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DeviationDocTVC.rawValue, for: indexPath) as? DeviationDocTVC else { return UITableViewCell() }
//                cell.setData(deviationsDetailsData: deviationsDetailsData, arrAttahmentsData: arrAttachmentsData)
                cell.delegate = self
                cell.setData(deviationsDetailsData: deviationsDetailsData, arrAttahmentsData: arrAttachmentsData, attachementManually: attachmentManually, responsibleId: resposibilityId, responsibleName: resposibilityName, deviationDueDate: deviationDueDate)
                cell.btnBrowseToUpload.addTarget(self, action: #selector(self.clickToImageUpload), for: .touchUpInside)
                cell.btnResponsibilty.addTarget(self, action: #selector(self.btnClickedResponsibilty), for: .touchUpInside)
                cell.btnDueDate.addTarget(self, action: #selector(self.btnClickedDueDate), for: .touchUpInside)
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.DeviationCreateDetailTVC.rawValue, for: indexPath) as? DeviationCreateDetailTVC else { return UITableViewCell() }
    //        cell.setData(deviationsDetailsData: deviationsDetailsData?.data?.history[inde])
            cell.nameLbl.text = deviationsDetailsData?.data?.history?[indexPath.row].user?.name
            cell.dateLbl.text = deviationsDetailsData?.data?.history?[indexPath.row].timestamp?.convertAllFormater(formated: "EEE, MMM-dd-yyyy, hh:mm")
            cell.trasitionLbl.text = deviationsDetailsData?.data?.history?[indexPath.row].transitionState
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 305.0
        }
        return UITableView.automaticDimension
    }
    
}

//MARK: APi Work in View controller
extension DeviationDetailVC{

    func getDeviationsByID(deviationsID: Int) -> Void {
        SVProgressHUD.show()
        let param = [String:Any]()
        print(param)
        DeviationsVM.shared.getDeviationsByID(parameters: param, id: deviationsID, isAuthorization: true) { [self] obj in
            self.deviationsDetailsData = obj.deviation
            if (deviationsDetailsData?.project?.id != nil) {
                self.projectId = "\(deviationsDetailsData?.project?.id ?? 0)"
                self.projectName = deviationsDetailsData?.project?.name ?? ""
            }
                        
            if (deviationsDetailsData?.task?.id  != nil) {
                self.taskId = "\(deviationsDetailsData?.task?.id ?? 0)"
                self.taskName = deviationsDetailsData?.task?.name ?? ""
            }
                        
            self.resposibilityId = "\(deviationsDetailsData?.assignee?.id ?? 0)"
            
            attachmentManually = false
            deviationDueDate = deviationsDetailsData?.due_date ?? ""
            
            for i in 0..<(self.deviationsDetailsData?.deviationAttachments?.count ?? 0) {
                var attachmentsDetails = [String:Any]()
                attachmentsDetails["id"] = self.deviationsDetailsData?.deviationAttachments?[i].id
                attachmentsDetails["filename"] = self.deviationsDetailsData?.deviationAttachments?[i].filename
                attachmentsDetails["filetype"] = self.deviationsDetailsData?.deviationAttachments?[i].filetype
                attachmentsDetails["user_id"] = self.deviationsDetailsData?.deviationAttachments?[i].user_id
                attachmentsDetails["to_model"] = self.deviationsDetailsData?.deviationAttachments?[i].to_model
                attachmentsDetails["to_id"] = self.deviationsDetailsData?.deviationAttachments?[i].to_id
                arrAttachmentsData.append(attachmentsDetails)
            }
            self.deviationtblVw.reloadData()
        }
    }
    
    func upadateDeviationByID(deviationsID: Int) -> Void {
        SVProgressHUD.show()
        var param = [String:Any]()
        
        var deviationAttachments = ""
        for i in 0 ..< arrAttachmentsData.count {
            if (deviationAttachments == ""){
                deviationAttachments = "\(arrAttachmentsData[i]["id"] ?? "")"
            }
            else {
                deviationAttachments = deviationAttachments + "," + "\(arrAttachmentsData[i]["id"] ?? "")"
            }
        }
        
        param["assigned_id"] = attachmentManually ? self.resposibilityId : deviationsDetailsData?.assigned_id
        param["attachments"] = deviationAttachments
        param["comments"] = deviationsDetailsData?.comments
//        param["data"] = deviationsDetailsData?.data
        param["due_date"] = deviationDueDate
        param["id"] = deviationsDetailsData?.id
//        param["myself"] = "undefined"
        param["project_id"] = self.projectId
        param["spent_hours"] = deviationsDetailsData?.spent_hours
        param["spent_other"] = deviationsDetailsData?.spent_other
        param["spent_rate"] = deviationsDetailsData?.spent_rate
        param["spent_total"] = deviationsDetailsData?.spent_total
        param["subject"] = deviationsDetailsData?.subject
        param["task_id"] = self.taskId
        param["txt_cause"] = deviationsDetailsData?.txt_cause
        param["txt_consequence"] = deviationsDetailsData?.txt_consequence
        param["txt_fix"] = deviationsDetailsData?.txt_fix
        param["txt_how_to_correct"] = deviationsDetailsData?.txt_how_to_correct
        param["txt_how_to_stop"] = deviationsDetailsData?.txt_how_to_stop
        param["txt_prevent"] = deviationsDetailsData?.txt_prevent
        param["txt_tbd"] = deviationsDetailsData?.txt_tbd
        param["urgency"] = deviationsDetailsData?.urgency
        
        print("Update deviation param is : ", param)
        
        
        DeviationsVM.shared.updateDeviation(parameters: param, id: deviationsID, isAuthorization: true) { [self] obj in
            
            showAlert(message: LocalizationKey.deviationUpdatedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//
//  AddVacationVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit

class AddVacationVC: BaseViewController, SelectProjectProtocol,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnPaid: UIButton!
    @IBOutlet weak var btnNotPaid: UIButton!
    
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var fromDateTxtField: UITextField!
    @IBOutlet weak var toDateTxtField: UITextField!
    
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var employedSinceLbl: UILabel!
    @IBOutlet weak var totalDays: UILabel!
    @IBOutlet weak var uploadImage: UIImageView!
    
    @IBOutlet weak var projectNameTxtFirld: UITextField!
    
    @IBOutlet weak var typeTableview: UITableView!
    @IBOutlet weak var vacationTypeHeightConstrains: NSLayoutConstraint!
    
    @IBOutlet weak var registerVacationTitleLbl: UILabel!
    @IBOutlet weak var staticYearLbl: UILabel!
    @IBOutlet weak var staticEmployedSinceLbl: UILabel!
    @IBOutlet weak var staticTotalVacationLbl: UILabel!
    @IBOutlet weak var staticRestVacation: UILabel!
    @IBOutlet weak var staticRegisteredVacations: UILabel!
    @IBOutlet weak var staticTotalVacationsLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var staticTotalDaysLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var attachmentsLbl: UILabel!
    @IBOutlet weak var commentVw: UITextView!
    
    var fromDate = ""
    var toDate = ""
    var isPaid = false
    var selectedDate = ""
    var projectId = String()
    var selectedImage: UIImage?
    var typeArray : [Vacation_types]?
    var selectedIndex = 0
    @IBOutlet weak var saveBtnObj: UIButton!
    
    var vacationsAbsenceData : Yearly?
    var employeePercent : String = ""
    @IBOutlet weak var totalVacationsLbl: UILabel!
    @IBOutlet weak var registeredVacationsLbl: UILabel!
    @IBOutlet weak var restVacationLbl: UILabel!
    var isComingFrom = ""
    var vacationID = Int()
    var userID = Int()
    
    var selectedVacationAbsenceSegmmentIndex = Int()
    weak var delegate : VacationAbsenceVCDelegate?
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var attachmentCollectionVw: UICollectionView!
    
    var attachmentsArray : [String] = []
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        btnNotPaid.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        currentDate = getCurrentDateFromGMT()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        registerVacationTitleLbl.text = LocalizationKey.registerVacation.localizing()
        staticYearLbl.text = LocalizationKey.year.localizing()
        staticEmployedSinceLbl.text = LocalizationKey.employedSince.localizing()
        staticTotalVacationLbl.text = LocalizationKey.totalVacations.localizing()
        staticRestVacation.text = LocalizationKey.restVacations.localizing()
        registerVacationTitleLbl.text = LocalizationKey.registeredVacations.localizing()
        staticTotalVacationsLbl.text = LocalizationKey.totalVacations.localizing()
        typeLbl.text = LocalizationKey.type.localizing()
        projectNameLbl.text = LocalizationKey.projectName.localizing()
        projectNameTxtFirld.placeholder = LocalizationKey.enterProjectName.localizing()
        fromLbl.text = LocalizationKey.fromStacic.localizing()
        toLbl.text = LocalizationKey.to.localizing()
        totalDays.text = LocalizationKey.totalDays.localizing()
        commentLbl.text = LocalizationKey.comment.localizing()
        attachmentsLbl.text = LocalizationKey.attachments.localizing()
        saveBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        employedSinceLbl.text = employeePercent + "%"

//        totalVacationsLbl.text = "\(vacationsAbsenceData?.vacationsTotal ?? 0)"
//        registeredVacationsLbl.text = "\(vacationsAbsenceData?.vacationsLeft ?? 0)"
//        restVacationLbl.text = "\(vacationsAbsenceData?.vacationDays ?? 0)"
    }
    
    func configUI() {
        btnNotPaid.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwDatePicker.addGestureRecognizer(tap)
        vwDatePicker.isHidden = true
        attachmentView.isHidden = true
                
        fromDateTxtField.text = getDateFormattedString(date: currentDate, dateFormat: "dd.MM.yyyy")
        toDateTxtField.text = getDateFormattedString(date: currentDate, dateFormat: "dd.MM.yyyy")
        fromDate = getDateFormattedString(date: currentDate, dateFormat: "yyyy-MM-dd")
        toDate = getDateFormattedString(date: currentDate, dateFormat: "yyyy-MM-dd")
        
        yearLbl.text = getDateFormattedString(date: currentDate, dateFormat: "yyyy")
        employedSinceLbl.text = getDateFormattedString(date: currentDate, dateFormat: "yyyy")
        
        if GlobleVariables.clientControlPanelConfiguration?.data?.extendedRules?.vacation_types?.count ?? 0 > 0 {
            typeArray = GlobleVariables.clientControlPanelConfiguration?.data?.extendedRules?.vacation_types
            vacationTypeHeightConstrains.constant = CGFloat(30 * (GlobleVariables.clientControlPanelConfiguration?.data?.extendedRules?.vacation_types?.count ?? 0))
        } else {
            typeArray = []
            if let url = Bundle.main.url(forResource: "vacationType", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    typeArray = try decoder.decode([Vacation_types].self, from: data)
                    vacationTypeHeightConstrains.constant = CGFloat(30 * (typeArray?.count ?? 0))
                } catch {
                    print("error:\(error)")
                }
            }
        }
        
        typeTableview.register(UINib.init(nibName: TABLE_VIEW_CELL.VacationTypeTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.VacationTypeTVC.rawValue)
        attachmentCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
        
        if isComingFrom == "Details" {
            usersData(userID: userID)
            self.getVacationDataByID(vacationID: vacationID)
        } else {
            totalVacationsLbl.text = "\(vacationsAbsenceData?.vacationsTotal ?? 0)"
            registeredVacationsLbl.text = "\(vacationsAbsenceData?.vacationsLeft ?? 0)"
            restVacationLbl.text = "\(vacationsAbsenceData?.vacationDays ?? 0)"
        }
    }
    
    @IBAction func backVacationBtnAction(_ sender: Any) {
        self.delegate?.checkVacationAbsenceSegmentIndex(segmentIndex: self.selectedVacationAbsenceSegmmentIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    func chooseDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let chooseDate = dateFormatter.string(from: datePicker.date)
        
        
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        let serverDate = serverDateFormatter.string(from: datePicker.date)
        
        if selectedDate == "fromDate" {
            if chooseDate > toDateTxtField.text ?? dateFormatter.string(from: currentDate) {
                fromDateTxtField.text = chooseDate
                toDateTxtField.text = chooseDate
                fromDate = serverDate
                toDate = serverDate
                self.totalDays.text = "1"
            } else {
                fromDateTxtField.text = chooseDate
                fromDate = serverDate
                let toDate = dateFormatter.date(from: toDateTxtField.text ?? dateFormatter.string(from: currentDate))
                self.totalDays.text = "\((toDate?.days(from: datePicker.date) ?? 0) + 2)"
            }
            
        } else {
            if let date1 = dateFormatter.date(from: chooseDate),
               let date2 = dateFormatter.date(from: fromDateTxtField.text ?? dateFormatter.string(from: currentDate)) {
                
                if date1 < date2 {
                    presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.fromDateMustBeLessThenToDate.localizing())
                } else {
                    toDateTxtField.text = chooseDate
                    toDate = serverDate
                    let fromDate = dateFormatter.date(from: fromDateTxtField.text ?? dateFormatter.string(from: currentDate))
                    self.totalDays.text = "\((datePicker.date.days(from: fromDate ?? currentDate)) + 1)"
                }
            } else {
                print("Invalid date format")
            }
//            if chooseDate < fromDateTxtField.text ?? dateFormatter.string(from: Date()) {
//                presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.fromDateMustBeLessThenToDate.localizing())
//            } else {
//                toDateTxtField.text = chooseDate
//                toDate = serverDate
//                let fromDate = dateFormatter.date(from: fromDateTxtField.text ?? dateFormatter.string(from: Date()))
//                self.totalDays.text = "\((datePicker.date.days(from: fromDate ?? Date())) + 1)"
//            }
        }
        vwDatePicker.isHidden = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        vwDatePicker.isHidden = true
    }
    
    //MARK: Delegate
    
    func projectId(projectId: String, projectName: String) {
        self.projectNameTxtFirld.text = "\(projectId) | \(projectName)"
        self.projectId = projectId
    }
    
    
    //MARK: Button Actions
    
    @IBAction func btnProjectNameAction(_ sender: UIButton) {
        
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectProjectVC") as! SelectProjectVC
        vc.mode = "managers"
        vc.module = "no-module"
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func fromDatePickerBtnAction(_ sender: Any) {
        selectedDate = "fromDate"
        vwDatePicker.isHidden = false
    }
    
    @IBAction func toDatePicketBtnAction(_ sender: Any) {
        selectedDate = "toDate"
        vwDatePicker.isHidden = false
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        chooseDate()
    }
    
    @IBAction func btnCancelAction(_ sender: UIBarButtonItem) {
        vwDatePicker.isHidden = true
        
    }
    
    @IBAction func btnPaid(_ sender: Any) {
        isPaid = true
        btnPaid.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnNotPaid.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    @IBAction func btnNotPaid(_ sender: Any) {
        isPaid = false
        btnNotPaid.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnPaid.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    
    @IBAction func btnUploadFiles(_ sender: Any) {
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
                    self.attachmentsArray.append(String(attachIds))
                    self.attachmentCollectionVw.reloadData()
                    self.attachmentView.isHidden = false
                }
            }
        }
    }

    @IBAction func btnSave(_ sender: Any) {
//        if projectId == "" {
//            showAlert(message: LocalizationKey.pleaseSelectProject, strtitle: LocalizationKey.error.localizing())
//        } else {
//            addVacationApi()
//        }
        
        if isComingFrom == "Details" {
            updateVacationApi(vacationID: vacationID)
        } else {
            addVacationApi()
        }
    }
    
}

//MARK: - CollectionView Delegate & Datasource
extension AddVacationVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = attachmentCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
            return UICollectionViewCell()
        }
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        cell.crossView.isHidden = false
        let url = URL(string: strUrl + "/\(attachmentsArray[indexPath.row])")
        cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(self.clickToCloseBtn), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 90.0
        let itemHeight = 90.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
//        if (collectionView == adminCollectionVw) {
//            let url = URL(string: strUrl + "/\(adminAttachmentsArray[indexPath.row])")
//            viewImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
//        } else {
//            let url = URL(string: strUrl + "/\(memberAttachmentsArray[indexPath.row])")
//            viewImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
//        }
//        openImgView.isHidden = false
//    }
    
    @objc func clickToCloseBtn(_ sender: UIButton) {
        let id = sender.tag
        attachmentsArray.remove(at: id)
        attachmentCollectionVw.reloadData()
        if attachmentsArray.count > 0 {
            attachmentView.isHidden = false
        } else {
            attachmentView.isHidden = true
        }
    }
    
}

extension AddVacationVC : UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

    }
    
    func ChoosenPDF() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .text, .gif, .pdf, .rtf], asCopy: true)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        dismiss(animated: true)
        print("Documnet URL is : ", urls)
        
        let url: NSURL = (urls[0] as? NSURL)!
        let fileExtension = url.pathExtension
        var filetension = url.lastPathComponent
        filetension = filetension?.replacingOccurrences(of: "", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        var myData = NSData(contentsOf: url as URL)
        
        
        let convertURL =  url as URL
        
        let fileData = try? Data.init(contentsOf: convertURL)
        let fileStream:String = fileData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) ?? ""
//
        AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", imageData: fileStream, fileName: filetension ?? "", type: "document") { (errorMsg,loginMessage,attachIds)  in
            print("User attachment upload successfully")
//            uploadLatestID = String(attachIds)
            self.attachmentsArray.append(String(attachIds))
            self.attachmentCollectionVw.reloadData()
            self.attachmentView.isHidden = false
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension AddVacationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return typeArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.VacationTypeTVC.rawValue, for: indexPath) as? VacationTypeTVC
        else { return UITableViewCell() }
        guard  let data = typeArray?[indexPath.row] else {
            return cell
        }
        
        cell.titleLbl.text = data.name
        if selectedIndex == indexPath.row {
            cell.btnSelect.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        } else {
            cell.btnSelect.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        selectedIndex = indexPath.row

        typeTableview.reloadData()
        
    }
}

//MARK: Extension Api's
extension AddVacationVC {
    private func addVacationApi(){
        var param = [String:Any]()
        
        param["from"] = fromDate
        param["to"] = toDate
        param["project_id"] = Int(projectId)
        param["status"] = "active"
        param["total_days"] = Int(totalDays.text ?? "0")
        param["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        param["vacation_type"] = typeArray?[selectedIndex].code
        param["attachments"] = attachmentsArray.joined(separator: ",")
        param["comments"] = commentVw.text
        
        print(param)
        
        VacationAbsenceVM.shared.createVacation(parameters: param){ [self] obj in
            showAlert(message: LocalizationKey.vacationCreatedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.delegate?.checkVacationAbsenceSegmentIndex(segmentIndex: self.selectedVacationAbsenceSegmmentIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func getVacationDataByID(vacationID : Int){
        var param = [String:Any]()

        VacationAbsenceVM.shared.getVacationDataByID(parameters: param, id: vacationID){ [self] obj in
            
            print("Vacation data is : ", obj)
            
            for i in 0..<(typeArray?.count ?? 0) {
                if typeArray?[i].code == obj.vacation?.vacation_type {
                    selectedIndex = i
                }
            }
            typeTableview.reloadData()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let strFromDate = dateFormatter.date(from: obj.vacation?.from ?? "")
            let strToDate = dateFormatter.date(from: obj.vacation?.to ?? "")
            
            fromDateTxtField.text = getDateFormattedString(date: strFromDate ?? currentDate, dateFormat: "dd.MM.yyyy")
            toDateTxtField.text = getDateFormattedString(date: strToDate ?? currentDate, dateFormat: "dd.MM.yyyy")
            fromDate = getDateFormattedString(date: strFromDate ?? currentDate, dateFormat: "yyyy-MM-dd")
            toDate = getDateFormattedString(date: strToDate ?? currentDate, dateFormat: "yyyy-MM-dd")

//            commentVw.text = obj.vacation?.comments
            
            totalDays.text = "\(obj.vacation?.total_days ?? 0)"
            commentVw.text = obj.vacation?.comments ?? ""

            let attachmentData = obj.vacation?.attachments?.split(separator: ",")
            
            if attachmentData?.count ?? 0 > 0 {
                for index in 0..<(attachmentData?.count ?? 0) {
                    attachmentsArray.append(String(attachmentData?[index] ?? ""))
                }
                self.attachmentCollectionVw.reloadData()
                self.attachmentView.isHidden = false
            }
        }
    }
    
    private func updateVacationApi(vacationID : Int){
        var param = [String:Any]()
        
        param["from"] = fromDate
        param["to"] = toDate
        param["project_id"] = Int(projectId)
        param["status"] = "active"
        param["total_days"] = Int(totalDays.text ?? "0")
        param["user_id"] = userID
        param["vacation_type"] = typeArray?[selectedIndex].code
        param["attachments"] = attachmentsArray.joined(separator: ",")
        param["comments"] = commentVw.text
        
        print(param)
        
        VacationAbsenceVM.shared.updateVacationDataByID(parameters: param,id: vacationID){ [self] obj in
            showAlert(message: LocalizationKey.vacationCreatedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.delegate?.checkVacationAbsenceSegmentIndex(segmentIndex: self.selectedVacationAbsenceSegmmentIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func usersData(userID : Int) {
        var param = [String:Any]()
        
        AllUsersVM.shared.getVacationsUsersData(parameters: param, id: "\(userID)", isAuthorization: true) { [self] obj in
            
            print(obj)
            
            totalVacationsLbl.text = "\(obj.user?.totals?.yearly?.vacationsTotal ?? 0)"
            registeredVacationsLbl.text = "\(obj.user?.totals?.yearly?.vacationsLeft ?? 0)"
            restVacationLbl.text = "\(obj.user?.totals?.yearly?.vacationDays ?? 0)"
        }
    }
}

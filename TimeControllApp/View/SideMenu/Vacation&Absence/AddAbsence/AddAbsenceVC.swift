//
//  AddAbsenceVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit

class AddAbsenceVC: BaseViewController, SelectProjectProtocol, SelectChildProtocol,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnPaid: UIButton!
    @IBOutlet weak var btnNotPaid: UIButton!
    
    @IBOutlet weak var btnSickLeave: UIButton!
    @IBOutlet weak var btnMedicalLeave: UIButton!
    @IBOutlet weak var btnParentalLeave: UIButton!
    @IBOutlet weak var GradeSlider: UISlider!
    @IBOutlet weak var GradeSliderValue: UILabel!
    
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var toDateTxtField: UITextField!
    @IBOutlet weak var fromDateTxtField: UITextField!
    
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var employedSinceLbl: UILabel!
    
    @IBOutlet weak var projectNameTxtFirld: UITextField!
    @IBOutlet weak var totalDays: UILabel!
    
    @IBOutlet weak var enterSickLeaveAmountTxt: UITextField!
    @IBOutlet weak var uploadImage: UIImageView!
    
    @IBOutlet weak var typeTableview: UITableView!
    @IBOutlet weak var absenceTypeHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var registerAbsenceTitleLbl: UILabel!
    @IBOutlet weak var staticYearLbl: UILabel!
    @IBOutlet weak var staticEmployementLbl: UILabel!
    @IBOutlet weak var staticTotalLeavesLbl: UILabel!
    @IBOutlet weak var staticSickLeavesLbl: UILabel!
    @IBOutlet weak var staticUtilizedLeavesLbl: UILabel!
    @IBOutlet weak var staticParentalLeavesLbl: UILabel!
    @IBOutlet weak var leaveTypeLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var staticTotalDaysLbl: UILabel!
    @IBOutlet weak var employmentGradeLbl: UILabel!
    
    @IBOutlet weak var staticHoursLbl: UILabel!
    @IBOutlet weak var staticTotalHoursLbl: UILabel!
    @IBOutlet weak var staticTotalToPayLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var totalHoursLbl: UILabel!
    @IBOutlet weak var totalToPayLbl: UILabel!
    
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var attachmentsLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var staticPaidLbl: UILabel!
    @IBOutlet weak var staticNotPaidLbl: UILabel!
    @IBOutlet weak var staticCriticalLbl: UILabel!
    @IBOutlet weak var staticEnterSickLeaveAmount: UILabel!
    @IBOutlet weak var childVwHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectChildVw: UIView!
    
    var fromDate = ""
    var toDate = ""
    var isPaid = true
    var selectedLeaveType = 0
    var selectedDate = ""
    var projectId = String()
    var selectedImage: UIImage?
    var typeArray : [Absent_types]?
    var selectedIndex = 0
    var gradeValue = 0
    
    var totalPayFinal = 0.0
    @IBOutlet weak var totalLeavesLbl: UILabel!
    @IBOutlet weak var utilizedLeavesLbl: UILabel!
    @IBOutlet weak var sickLeavesLbl: UILabel!
    @IBOutlet weak var parentalLeavesLbl: UILabel!
    
    @IBOutlet weak var staticChild: UILabel!
    @IBOutlet weak var selectChildTxt: UITextField!
    
    @IBOutlet weak var commentVw: UITextView!
    
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var attachmentCollectionVw: UICollectionView!
    @IBOutlet weak var employmentGradeView: UIView!
    @IBOutlet weak var sickLeaveStackView: UIStackView!
    @IBOutlet weak var hoursView: UIView!
    
    var vacationsAbsenceData : Yearly?
    var employeePercent : String = ""
    
    var selectedChildsData: Kids?
    var selectedChildsIndex : Int = 0
    
    var selectedVacationAbsenceSegmmentIndex = Int()
    weak var delegate : VacationAbsenceVCDelegate?
    
    var isComingFrom = ""
    var absenceID = Int()
    var userID = Int()
    
    var imagePicker: UIImagePickerController!
    
    var attachmentsArray : [String] = []
//    var attachmentData = ""
    
    
    @IBOutlet weak var sickLeaveCycleVw: UIView!
    @IBOutlet weak var staticSickLeaveCycleLbl: UILabel!
    @IBOutlet weak var sickLeaveCycleLbl: UILabel!
    
    var selectedLangCode = ""
    
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childVwHeightConstraint.constant = 0
        selectChildVw.isHidden = true
        setUpLocalization()
        configUI()
        selectedLangCode = UserDefaults.standard.string(forKey: UserDefaultKeys.selectedLanguageCode) ?? "en"
        currentDate = getCurrentDateFromGMT()
//        getTranslationFromAPI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        registerAbsenceTitleLbl.text = LocalizationKey.registerAbsence.localizing()
        
        staticYearLbl.text = LocalizationKey.year.localizing()
        staticEmployementLbl.text = LocalizationKey.employement.localizing()
        staticTotalLeavesLbl.text = LocalizationKey.totalLeaves.localizing()
        staticSickLeavesLbl.text = LocalizationKey.sickLeaves.localizing()
        staticUtilizedLeavesLbl.text = LocalizationKey.utilizedLeaves.localizing()
        staticParentalLeavesLbl.text = LocalizationKey.parentalLeaves.localizing()
        leaveTypeLbl.text = LocalizationKey.leaveType.localizing()
        typeLbl.text = LocalizationKey.type.localizing()
        staticPaidLbl.text = LocalizationKey.paid.localizing()
        staticNotPaidLbl.text = LocalizationKey.notPaid.localizing()
        staticCriticalLbl.text = LocalizationKey.critical.localizing()
        projectNameLbl.text = LocalizationKey.projectName.localizing()
        projectNameTxtFirld.placeholder = LocalizationKey.enterProjectName.localizing()
        fromLbl.text = LocalizationKey.fromStacic.localizing()
        toLbl.text = LocalizationKey.to.localizing()
        employmentGradeLbl.text = LocalizationKey.employmentGradeIn.localizing()
        staticHoursLbl.text = LocalizationKey.hours.localizing()
        staticTotalHoursLbl.text = LocalizationKey.totalHours.localizing()
        staticTotalToPayLbl.text = LocalizationKey.totalToPay.localizing()
        commentLbl.text = LocalizationKey.comment.localizing()
        attachmentsLbl.text = LocalizationKey.attachments.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        staticChild.text = LocalizationKey.child.localizing()
        selectChildTxt.text = LocalizationKey.selectChild.localizing()
        
        employedSinceLbl.text = employeePercent + "%"
    }
    
    func configUI() {
        btnPaid.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnSickLeave.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwDatePicker.addGestureRecognizer(tap)
        vwDatePicker.isHidden = true
        attachmentView.isHidden = true
                
        fromDateTxtField.text = getDateFormattedString(date: currentDate, dateFormat: "dd.MM.yyyy")
        toDateTxtField.text = getDateFormattedString(date: currentDate, dateFormat: "dd.MM.yyyy")
        fromDate = getDateFormattedString(date: currentDate, dateFormat: "yyyy-MM-dd")
        toDate = getDateFormattedString(date: currentDate, dateFormat: "yyyy-MM-dd")
        
        yearLbl.text = getDateFormattedString(date: currentDate, dateFormat: "yyyy")
//        employedSinceLbl.text = getDateFormattedString(date: Date(), dateFormat: "yyyy")
        
        if GlobleVariables.clientControlPanelConfiguration?.data?.extendedRules?.vacation_types?.count ?? 0 > 0 {
            typeArray = GlobleVariables.clientControlPanelConfiguration?.data?.extendedRules?.absent_types
            absenceTypeHeightConstrains.constant = CGFloat(30 * (GlobleVariables.clientControlPanelConfiguration?.data?.extendedRules?.absent_types?.count ?? 0))
        } else {
            typeArray = []
            if let url = Bundle.main.url(forResource: "absenceType", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    typeArray = try decoder.decode([Absent_types].self, from: data)
                    absenceTypeHeightConstrains.constant = CGFloat(30 * (typeArray?.count ?? 0))
                } catch {
                    print("error:\(error)")
                }
            }
        }
        
        typeTableview.register(UINib.init(nibName: TABLE_VIEW_CELL.VacationTypeTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.VacationTypeTVC.rawValue)
        attachmentCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
        
        if isComingFrom == "Details" {
            usersData(userID: userID)
            self.getAbsenceDataByID(absenceID: absenceID)
        } else {
            let totalLeaves = (vacationsAbsenceData?.childDays ?? 0) + (vacationsAbsenceData?.clearancesLeft ?? 0)
            totalLeavesLbl.text = "\(totalLeaves)"
            
            sickLeavesLbl.text = "\(vacationsAbsenceData?.selfClearances ?? 0) / \(vacationsAbsenceData?.clearancesLeft ?? 0)"
            
            let utilizedLeaves = (vacationsAbsenceData?.selfClearances ?? 0) + (vacationsAbsenceData?.doctorClearances ?? 0)
            utilizedLeavesLbl.text = "\(utilizedLeaves)"
            
            parentalLeavesLbl.text = "\(vacationsAbsenceData?.doctorClearances ?? 0) / \(vacationsAbsenceData?.childDays ?? 0)"
            datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 3, to: currentDate)
            
            if vacationsAbsenceData?.userSickLeaveCycle?.cycleStartDate != nil {
                sickLeaveCycleVw.isHidden = false
                sickLeaveCycleLbl.text = "\(vacationsAbsenceData?.userSickLeaveCycle?.cycleStartDate ?? "")\n\(vacationsAbsenceData?.userSickLeaveCycle?.cycleEndDate ?? "")"
            } else {
                sickLeaveCycleVw.isHidden = true
            }
        }
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            staticEnterSickLeaveAmount.isHidden = true
            enterSickLeaveAmountTxt.isHidden = true
            employmentGradeView.isHidden = true
            sickLeaveStackView.isHidden  = true
            hoursView.isHidden = true
        } else {
            GradeSlider.setValue(100.0, animated: false)
            self.GradeChanged(GradeSlider)
            staticEnterSickLeaveAmount.isHidden = false
            enterSickLeaveAmountTxt.isHidden = false
            employmentGradeView.isHidden = false
            sickLeaveStackView.isHidden  = false
            hoursView.isHidden = false
        }
    }
    
    
    @IBAction func backAbsenceBtnAction(_ sender: Any) {
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
            print("chooseDate is ", chooseDate)
            print("fromDateTxtField.text is ", fromDateTxtField.text)
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
//            
//            if chooseDate < fromDateTxtField.text ?? dateFormatter.string(from: Date()) {
//                presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.fromDateMustBeLessThenToDate.localizing())
//            } else {
//                toDateTxtField.text = chooseDate
//                toDate = serverDate
//                let fromDate = dateFormatter.date(from: fromDateTxtField.text ?? dateFormatter.string(from: Date()))
//                self.totalDays.text = "\((datePicker.date.days(from: fromDate ?? Date())) + 1)"
//            }
        }
        //        totalPayFinal = Double((String(format: "%.3f", totalHours))) ?? 0.0

        if isPaid {
            totalHoursLbl.text = "\(Double(String(format: "%.3f",((Float(hoursLbl.text ?? "0.0") ?? 0.0) * (Float(totalDays.text ?? "0.0") ?? 0.0)))) ?? 0.0)"
            
            if enterSickLeaveAmountTxt.text != "0" {
                self.totalToPayLbl.text = "\(Double(String(format: "%.3f",((Float(self.totalHoursLbl.text ?? "0.0") ?? 0.0) * (Float(enterSickLeaveAmountTxt.text ?? "0.0") ?? 0.0)))) ?? 0.0)"
            }
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
    
    func selectedChild(selectedChildData: Kids, selectedChildIndex : Int) {
        selectedChildsData = selectedChildData
        selectedChildsIndex = selectedChildIndex
        selectChildTxt.text = selectedChildData.name
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
    
    @IBAction func btnSelectChildNameAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddChildVC") as! AddChildVC
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
        
        GradeSlider.setValue(0.0, animated: true)
        GradeSliderValue.text = "\(Int(GradeSlider.value))%"
        hoursLbl.text = "0.0"
        totalHoursLbl.text = "0.0"
        totalToPayLbl.text = "0"
        enterSickLeaveAmountTxt.text = "0"
    }
    @IBAction func btnSickLeave(_ sender: Any) {
        selectedLeaveType = 0
        btnSickLeave.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnMedicalLeave.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnParentalLeave.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    @IBAction func btnMedicalLeave(_ sender: Any) {
        selectedLeaveType = 1
        btnMedicalLeave.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnSickLeave.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnParentalLeave.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    @IBAction func btnParentalLeave(_ sender: Any) {
        selectedLeaveType = 2
        btnParentalLeave.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnSickLeave.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnMedicalLeave.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    @IBAction func GradeChanged(_ sender: UISlider) {
        GradeSliderValue.text = "\(Int(sender.value))%"
        
        if isPaid {
            let hours = ((Int(sender.value)) * 75)
            hoursLbl.text = "\(Float(hours) / 1000)"
            totalHoursLbl.text = "\(Double(String(format: "%.3f",((Float(hours) / 1000) * (Float(totalDays.text ?? "0.0") ?? 0.0)))) ?? 0.0)"
            if enterSickLeaveAmountTxt.text != "0" {
                self.totalToPayLbl.text = "\(Double(String(format: "%.3f", ((Float(self.totalHoursLbl.text ?? "0.0") ?? 0.0) * (Float(enterSickLeaveAmountTxt.text ?? "0.0") ?? 0.0)))) ?? 0.0)"
            }
        }
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
        //            uploadLatestID = String(attachIds)
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
//        }
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm" && enterSickLeaveAmountTxt.text == "" {
            showAlert(message: LocalizationKey.pleaseEnterSickLeaveAmount, strtitle: LocalizationKey.error.localizing())
        }
        else {
            if typeArray?[selectedIndex].code == "child" && selectedChildsIndex == 0{
                showAlert(message: LocalizationKey.pleaseSelectChild.localizing(), strtitle: LocalizationKey.error.localizing())
            } else {
                if isComingFrom == "Details" {
                    updateAbsenceApi(absenceID: absenceID)
                } else {
                    addAbsenceApi()
                }
            }
        }
    }
}

//MARK: - CollectionView Delegate & Datasource
extension AddAbsenceVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
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

extension AddAbsenceVC : UIDocumentPickerDelegate {
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

//MARK: - Textfield Delegate Methods
extension AddAbsenceVC: UITextFieldDelegate {
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let searchText = enterSickLeaveAmountTxt.text! + string
        print(searchText)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if self.isPaid {
                self.totalToPayLbl.text = "\((Float(self.totalHoursLbl.text ?? "0.0") ?? 0.0) * (Float(searchText) ?? 0.0))"
            }
        }
        return true
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension AddAbsenceVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return typeArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.VacationTypeTVC.rawValue, for: indexPath) as? VacationTypeTVC
        else { return UITableViewCell() }
        guard  let data = typeArray?[indexPath.row] else {
            return cell
        }
        
        if data.code == "self" {
            cell.titleLbl.text = LocalizationKey.sickLeave.localizing()
        } else if data.code == "doctor" {
            cell.titleLbl.text = LocalizationKey.doctorClarification.localizing()
        } else if data.code == "child" {
            cell.titleLbl.text = LocalizationKey.parentalLeave.localizing()
        } else {
            cell.titleLbl.text = data.name
        }
        
//        cell.titleLbl.text = data.name
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
        if typeArray?[indexPath.row].code == "child" {
            childVwHeightConstraint.constant = 76
            selectChildVw.isHidden = false
        } else {
            childVwHeightConstraint.constant = 0
            selectChildVw.isHidden = true
        }
        if indexPath.row == 0 {
            datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 3, to: currentDate)
        } else if indexPath.row == 1 {
            datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 15000, to: currentDate)
        } else {
            datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 10, to: currentDate)
        }
        
        typeTableview.reloadData()
    }
}


//MARK: Extension Api's
extension AddAbsenceVC {
    private func addAbsenceApi(){
        var param = [String:Any]()
        
        param["from"] = fromDate
        param["to"] = toDate
        param["project_id"] = projectId
        param["status"] = "active"
        param["total_days"] = totalDays.text ?? "0"
        param["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        param["leave_type"] = isPaid ? "paid" : "nonpaid"
        param["absence_type"] = typeArray?[selectedIndex].code
        param["absence_payment_per_day"] = enterSickLeaveAmountTxt.text
        param["absence_total_payment"] = totalToPayLbl.text
        param["attachments"] = attachmentsArray.joined(separator: ",")
        param["employement_grade"] = "\(Int(GradeSlider.value))"
        param["hours"] = hoursLbl.text
        param["total_hours"] = totalHoursLbl.text
        param["comments"] = commentVw.text

        if typeArray?[selectedIndex].code == "child" {
            param["child"] = "\(selectedChildsIndex)"
            var childData = [String:Any]()
            var child = [String:Any]()
            child["chronic_disease"] = selectedChildsData?.chronic_disease
            child["chronic_permission"] = selectedChildsData?.chronic_permission
            child["date"] = selectedChildsData?.date
            child["key"] = selectedChildsData?.key
            child["name"] = selectedChildsData?.name
            childData["child"] = child
            childData["child_index"] = "\(selectedChildsIndex)"
            param["data"] = childData
        }
        
        print("Absence Params : ", param)
        
        VacationAbsenceVM.shared.createAbsence(parameters: param){ [self] obj in
            print(obj.message)
            
            showAlert(message: LocalizationKey.absenceCreatedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.delegate?.checkVacationAbsenceSegmentIndex(segmentIndex: self.selectedVacationAbsenceSegmmentIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func getAbsenceDataByID(absenceID : Int){
        var param = [String:Any]()

        VacationAbsenceVM.shared.getAbsenceDataByID(parameters: param, id: absenceID){ [self] obj in
            
            print("Absence data is : ", obj)
            
            for i in 0..<(typeArray?.count ?? 0) {
                if typeArray?[i].code == obj.absence?.absence_type {
                    selectedIndex = i
                }
                
                if typeArray?[i].code == "child" {
                    childVwHeightConstraint.constant = 76
                    selectChildVw.isHidden = false
//                    selectedChildsData = obj.absence?.childData?.child
//                    selectedChildsIndex = obj.absence?.childData?.child_index
                    selectChildTxt.text = obj.absence?.childData?.child?.name
                } else {
                    childVwHeightConstraint.constant = 0
                    selectChildVw.isHidden = true
                }
            }
            
            if obj.absence?.leave_type == "paid" {
                isPaid = true
                btnPaid.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
                btnNotPaid.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            } else {
                isPaid = false
                btnPaid.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
                btnNotPaid.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let strFromDate = dateFormatter.date(from: obj.absence?.from ?? "")
            let strToDate = dateFormatter.date(from: obj.absence?.to ?? "")
            
            fromDateTxtField.text = getDateFormattedString(date: strFromDate ?? currentDate, dateFormat: "dd.MM.yyyy")
            toDateTxtField.text = getDateFormattedString(date: strToDate ?? currentDate, dateFormat: "dd.MM.yyyy")
            fromDate = getDateFormattedString(date: strFromDate ?? currentDate, dateFormat: "yyyy-MM-dd")
            toDate = getDateFormattedString(date: strToDate ?? currentDate, dateFormat: "yyyy-MM-dd")

            hoursLbl.text = "\(obj.absence?.hours ?? 0)"
            totalHoursLbl.text = "\(obj.absence?.total_days ?? 0)"
            enterSickLeaveAmountTxt.text = "\(obj.absence?.absence_payment_per_day ?? 0)"
//            totalToPayLbl.text = obj.absence.absence_total_payment
            totalDays.text = "\(obj.absence?.total_days ?? 0)"
            GradeSliderValue.text = "\(obj.absence?.employement_grade ?? 0)" + "%"
            GradeSlider.setValue(Float(obj.absence?.employement_grade ?? Int(0.0)), animated: true)
            commentVw.text = obj.absence?.comments
            
            let attachmentData = obj.absence?.attachments?.split(separator: ",")
            
            if attachmentData?.count ?? 0 > 0 {
                for index in 0..<(attachmentData?.count ?? 0) {
                    attachmentsArray.append(String(attachmentData?[index] ?? ""))
                }
                self.attachmentCollectionVw.reloadData()
                self.attachmentView.isHidden = false
            }
            
            if isPaid {
                
                if enterSickLeaveAmountTxt.text != "0" {
                    self.totalToPayLbl.text = "\(Double(String(format: "%.3f",((obj.absence?.hours ?? 0.0) * (Float(obj.absence?.absence_payment_per_day ?? 0) )))) ?? 0.0)"
                }
            }
            typeTableview.reloadData()
        }
    }
    
    private func updateAbsenceApi(absenceID : Int){
        var param = [String:Any]()
        
        param["from"] = fromDate
        param["to"] = toDate
        param["project_id"] = projectId
        param["status"] = "active"
        param["total_days"] = totalDays.text ?? "0"
        param["user_id"] = userID
        param["leave_type"] = isPaid ? "paid" : "nonpaid"
        param["absence_type"] = typeArray?[selectedIndex].code
        param["absence_payment_per_day"] = enterSickLeaveAmountTxt.text
        param["absence_total_payment"] = totalToPayLbl.text
        param["attachments"] = attachmentsArray.joined(separator: ",")
        param["employement_grade"] = "\(Int(GradeSlider.value))"
        param["hours"] = hoursLbl.text
        param["total_hours"] = totalHoursLbl.text
        param["comments"] = commentVw.text

        if typeArray?[selectedIndex].code == "child" {
            param["child"] = "\(selectedChildsIndex)"
            var childData = [String:Any]()
            var child = [String:Any]()
            child["chronic_disease"] = selectedChildsData?.chronic_disease
            child["chronic_permission"] = selectedChildsData?.chronic_permission
            child["date"] = selectedChildsData?.date
            child["key"] = selectedChildsData?.key
            child["name"] = selectedChildsData?.name
            childData["child"] = child
            childData["child_index"] = "\(selectedChildsIndex)"
            param["data"] = childData
        }
        
        print("Absence Params : ", param)
        
        VacationAbsenceVM.shared.updateAbsenceDataByID(parameters: param, id: absenceID){ [self] obj in
            
            print("Response is : ", obj)
            
            showAlert(message: LocalizationKey.absenceCreatedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.delegate?.checkVacationAbsenceSegmentIndex(segmentIndex: self.selectedVacationAbsenceSegmmentIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func usersData(userID : Int) {
        var param = [String:Any]()
        
        AllUsersVM.shared.getVacationsUsersData(parameters: param, id: "\(userID)", isAuthorization: true) { [self] obj in
            
            print(obj)
            
            let totalLeaves = (obj.user?.totals?.yearly?.childDays ?? 0) + (obj.user?.totals?.yearly?.clearancesLeft ?? 0)
            totalLeavesLbl.text = "\(totalLeaves)"
            
            sickLeavesLbl.text = "\(obj.user?.totals?.yearly?.selfClearances ?? 0) / \(obj.user?.totals?.yearly?.clearancesLeft ?? 0)"
            
            let utilizedLeaves = (obj.user?.totals?.yearly?.selfClearances ?? 0) + (obj.user?.totals?.yearly?.doctorClearances ?? 0)
            utilizedLeavesLbl.text = "\(utilizedLeaves)"
            
            parentalLeavesLbl.text = "\(obj.user?.totals?.yearly?.doctorClearances ?? 0) / \(obj.user?.totals?.yearly?.childDays ?? 0)"
            datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 3, to: currentDate)
            
            if obj.user?.totals?.yearly?.userSickLeaveCycle?.cycleStartDate != nil {
                sickLeaveCycleVw.isHidden = false
                sickLeaveCycleLbl.text = "\(obj.user?.totals?.yearly?.userSickLeaveCycle?.cycleStartDate ?? "")\n\(obj.user?.totals?.yearly?.userSickLeaveCycle?.cycleEndDate ?? "")"
            } else {
                sickLeaveCycleVw.isHidden = true
            }
            
        }
    }
    
    private func getTranslationFromAPI(){
        var param = [String:Any]()
       
        print("GetTranslationFromAPI Params : ", param)
        
        VacationAbsenceVM.shared.getTranslationFromAPI(parameters: param, langCode: selectedLangCode){ [self] obj in
            
            print("Response is : ", obj)
        }
    }
}

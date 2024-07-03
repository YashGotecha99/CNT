//
//  AddWorkDocumentVC.swift
//  TimeControllApp
//
//  Created by mukesh on 16/07/22.
//

import UIKit
import CoreLocation
import MediaPlayer
import MobileCoreServices
import SVProgressHUD

enum SelectTimeType:String {
    case StartTime = "StartTime"
    case EndTime = "EndTime"
    case BreakTime = "BreakTime"
    case Overtime100 = "Overtime100"
    case Overtime50 = "Overtime50"
    case OvertimeOther = "OvertimeOther"
}

class AddWorkDocumentVC: BaseViewController, SignatureProtocol, TaskMapVCProtocol, CLLocationManagerDelegate, UploadDocumentProtocol, PassengerProtocol, AddTaskProjectNameProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var vwTimePicker: UIView!
    @IBOutlet weak var registerMilesBtn: UIButton!
    @IBOutlet weak var extrapassengerBtn: UIButton!
    @IBOutlet weak var otherExpenseBtn: UIButton!
    @IBOutlet weak var extraWorkBtn: UIButton!
    @IBOutlet weak var registerMilesVw: UIView!
    @IBOutlet weak var extraPassengerVw: UIView!
    @IBOutlet weak var otherExpenseVw: UIView!
    @IBOutlet weak var extraWorkVw: UIView!
    @IBOutlet weak var blackBackgroundVw: UIView!
    @IBOutlet weak var addDoctblVw: UITableView!
    
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var extraWorkDocCollectionVw: UICollectionView!
    @IBOutlet weak var otherExpenseCollectionVw: UICollectionView!
    
    
    @IBOutlet weak var extraWorkHourTxtField: UITextField!
    @IBOutlet weak var expenseTypeTxtField: UITextField!
    @IBOutlet weak var extraWorkCommentTxtVw: UITextView!
    
    @IBOutlet weak var extraWorkCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var extraWorkTopVw: NSLayoutConstraint!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    
    @IBOutlet weak var passengerTxtField: UITextField!
    
    @IBOutlet weak var distanceTxtField: UITextField!
    @IBOutlet weak var distanceFromTxtField: UITextField!
    @IBOutlet weak var distanceToTxtField: UITextField!
    
    
    @IBOutlet weak var otherExpenseCostTxtField: UITextField!
    @IBOutlet weak var otheExpenseTypeTxtField: UITextField!
    @IBOutlet weak var otherExpenseCommentTxtVw: UITextView!
    @IBOutlet weak var topOtherExpenseConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherExpenseHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickerExpenseVw: UIPickerView!
    
    @IBOutlet weak var expenseChooseVw: UIView!
    
    @IBOutlet weak var openImgView: UIView!
    @IBOutlet weak var viewImg: UIImageView!
    
    var uploadAttachmentsArray = ""
    var uploadAttachmentsArrayData = [String] ()
    var userID = String()
    var uploadDcoumentType = ""
    var arrExtraDataAttachments = ""
    var arrExpenseDataAttachments = ""

    // MARK: Properties
    public var workHourModel = AddWorkDocumentModel()
    var counter = 0
    var timer = Timer()
    
    var comingFrom = ""
    var index = 1
    var id = String()
    var taskId = String()
    var selectedDate = "Date"
    var finalDate = ""
    
    var lat = String()
    var long = String()
    var taskName = String()
    var timelogData : Timelog?
    var taskDetails : Task?
    var signatureImg: UIImage?
    
    var selectedImage: UIImage?
    
    var selectTimeType: SelectTimeType?
    
    var selectedTime = Int()
    
    var startTime = Int()
    var endTime = Int()
    var breakTime = 0
    var takeBreak = Bool()
    
    var defaultOvertimeArray = [Overtime(key: "50%",value: "00:00"),Overtime(key: "100%",value: "00:00"),Overtime(key: "Other",value: "00:00")]
    
    var selectedOvertime = ""
    
    let locationManager = CLLocationManager()
    var currentCorrdinate = CLLocationCoordinate2D()
    
    var workDetailModel = [WorkDetailsModel]()
    
    var totalWorkingHour = String()
    
    var totalOverTime = String()
    
    var totalTime = Int()
    
    var passengerDataIndex = 0
    
    var attechmentsData : [[String:Any]] = []
    
    var isPaused = false

    var arrAttachmentsData = [[String:Any]]()

    var imagePicker: UIImagePickerController!

    public var homeModel = HomeViewModel()

    var timelogChange = false
    
    var selectedWorkHoursSegmmentIndex = Int()
    weak var delegate : WorkHoursVCDelegate?

    var isAdjustActualTime = false

    //MARK: Localizations

    @IBOutlet weak var mainWorkHoursLbl: UILabel!
    @IBOutlet weak var saveBtnObj: UIButton!
    @IBOutlet weak var staticExtraWorkLbl: UILabel!
    @IBOutlet weak var staticExpenseTypeLbl: UILabel!
    @IBOutlet weak var staticExtraWorkHoursLbl: UILabel!
    @IBOutlet weak var staticExtraWorkHoursCommentLbl: UILabel!
    @IBOutlet weak var staticExtraWorkHoursUploadedDocumentsLbl: UILabel!
    @IBOutlet weak var extraWorkHoursSaveBtnObj: UIButton!
    @IBOutlet weak var staticExtraWorkHoursUploadingDocumentsLbl: UILabel!
    
    @IBOutlet weak var staticOtherExpensesTitleLbl: UILabel!
    @IBOutlet weak var staticOtherExpensesTypeLbl: UILabel!
    @IBOutlet weak var staticOtherExpensesCostLbl: UILabel!
    @IBOutlet weak var staticOtherExpensesCommentLbl: UILabel!
    @IBOutlet weak var staticOtherExpensesUploadedDocumentsLbl: UILabel!
    @IBOutlet weak var otherExpensesSaveBtnObj: UIButton!
    @IBOutlet weak var staticOtherExpensesUploadingDocumentsLbl: UILabel!
    
    @IBOutlet weak var staticExtraPassengerTitleLbl: UILabel!
    @IBOutlet weak var staticExtraPassengerNameLbl: UILabel!
    @IBOutlet weak var extraPassengerSaveBtnObj: UIButton!
    
    @IBOutlet weak var staticRegisterMilesTitleLbl: UILabel!
    @IBOutlet weak var staticDistanceLbl: UILabel!
    @IBOutlet weak var staticDistanceFromLbl: UILabel!
    @IBOutlet weak var staticDistanceToLbl: UILabel!
    @IBOutlet weak var registerMilesSaveBtnObj: UIButton!

    @IBOutlet weak var datePickerCancelBtnObj: UIBarButtonItem!
    @IBOutlet weak var datePickerDoneBtnObj: UIBarButtonItem!

    @IBOutlet weak var timePickerCancelBtnObj: UIBarButtonItem!
    @IBOutlet weak var timePickerDoneBtnObj: UIBarButtonItem!

    @IBOutlet weak var expenseChooseCancelBtnObj: UIBarButtonItem!
    @IBOutlet weak var expenseChooseDoneBtnObj: UIBarButtonItem!

    
    var selectedOvertimeIndexpath = Int()
    var currentDateFromGMT = Date()
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        
        // Do any additional setup after loading the view.
        
        DispatchQueue.global().async {
            if self.comingFrom == "workHourDetail" {
                self.hitWorkHoursDetailsApi(id: self.id)
                self.hitTaskNameApi(taskId: self.taskId)
                self.getCurrentLocation()
                self.dashboardApi()
            }
            else {
                self.getCurrentLocation()
                if self.timelogData?.data?.overtimes == nil {
                    self.timelogData = Timelog(id: 0, status: "", user_id: 0, for_date: "", from: 0, to: 0, break: 0, total_hours_overtime: 0, total_hours_normal: 0, comments: "", description: "", data: Datas(workplace: "", address: "", passangers: [], expenses: [], extraWork: [], attachments: "", distance: 0.0, signature: "", overtimes: OvertimesData(fifty: Fifty(code: "50", multiplier: 0, name: "50", value: "00:00"), hundred: Hundred(code: "100", multiplier: 0, name: "100", value: "00:00"), other: Other(code: "Other", multiplier: 0, name: "Other", value: "00:00")), overtime_array: GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtime_types ?? [], shiftId: 0, anomalyTrackerReason: AnomalyTrackerReasonData(startReason: StartReasonData(reason: "", autoAdjust: false, sendNotification: false, value: "", code: "", actualTime: 0))), gps_data: Gps_data(task: "", end: EndData(coords: Coords(altitude: 0, altitudeAccuracy: 0, latitude: 0.0, accuracy: 0, longitude: 0.0, heading: 0.0, speed: 0.0), timestamp: 0.0, locationString: "", decision: "", is_ok: true), start: StartData(coords: Coords(altitude: 0, altitudeAccuracy: 0, latitude: 0.0, accuracy: 0, longitude: 0.0, heading: 0.0, speed: 0.0), timestamp: 0.0, locationString: "", decision: "", is_ok: true)), tracker_status: "", location_string: "", client_id: 0, user: User(first_name: "", last_name: "", social_number: ""), gps: Gps(task: "", start_diff: "", end_diff: ""), Attachments: [], createdAt: "", anomaly: AnomalyWorkhourData(start: StartAnomalyWorkHour(is_early: false, is_offsite: false,is_late: false, comment: ""), end: EndAnomalyWorkHour(is_early: false, is_offsite: false,is_late: false, comment: "")))
                }
            }
        }
        
       // locationManager.requestWhenInUseAuthorization()

    }
    
    func setUpLocalization(){
        datePicker.maximumDate = currentDateFromGMT
        mainWorkHoursLbl.text = LocalizationKey.workHours.localizing()
        saveBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        staticExtraWorkLbl.text = LocalizationKey.extraWork.localizing()
        staticExpenseTypeLbl.text = LocalizationKey.typeOfExtraWork.localizing()
        expenseTypeTxtField.placeholder = LocalizationKey.chooseTypeOfExtraWork.localizing()
        staticExtraWorkHoursLbl.text = LocalizationKey.extraHours.localizing()
        extraWorkHourTxtField.placeholder = LocalizationKey.enterCost.localizing()
        staticExtraWorkHoursCommentLbl.text = LocalizationKey.comment.localizing()
        staticExtraWorkHoursUploadedDocumentsLbl.text = LocalizationKey.uploadedDocuments.localizing()
        staticExtraWorkHoursUploadingDocumentsLbl.text = LocalizationKey.uploadDocuments.localizing()
        extraWorkHoursSaveBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        staticOtherExpensesTitleLbl.text = LocalizationKey.otherExpenses.localizing()
        staticOtherExpensesTypeLbl.text = LocalizationKey.expensesType.localizing()
        otheExpenseTypeTxtField.placeholder = LocalizationKey.enterExpensesType.localizing()
        staticOtherExpensesCostLbl.text = LocalizationKey.cost.localizing()
        otherExpenseCostTxtField.placeholder = LocalizationKey.enterCost.localizing()
        staticOtherExpensesCommentLbl.text = LocalizationKey.comment.localizing()
        staticOtherExpensesUploadedDocumentsLbl.text = LocalizationKey.uploadedDocuments.localizing()
        staticOtherExpensesUploadingDocumentsLbl.text = LocalizationKey.uploadDocuments.localizing()
        otherExpensesSaveBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        staticExtraPassengerTitleLbl.text = LocalizationKey.extraPassenger.localizing()
        staticExtraPassengerNameLbl.text = LocalizationKey.passengerName.localizing()
        passengerTxtField.placeholder = LocalizationKey.enterYourPassengerName.localizing()
        extraPassengerSaveBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)

        staticRegisterMilesTitleLbl.text = LocalizationKey.registerMiles.localizing()
        staticDistanceLbl.text = LocalizationKey.distance.localizing()
        distanceTxtField.placeholder = LocalizationKey.enterDistance.localizing()
        staticDistanceFromLbl.text = LocalizationKey.from.localizing()
        distanceFromTxtField.placeholder = LocalizationKey.enterAddress.localizing()
        staticDistanceToLbl.text = LocalizationKey.to.localizing()
        distanceToTxtField.placeholder = LocalizationKey.enterAddress.localizing()
        registerMilesSaveBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        datePickerCancelBtnObj.title = LocalizationKey.cancel.localizing()
        datePickerDoneBtnObj.title = LocalizationKey.done.localizing()
        
        timePickerCancelBtnObj.title = LocalizationKey.cancel.localizing()
        timePickerDoneBtnObj.title = LocalizationKey.done.localizing()
        
        expenseChooseCancelBtnObj.title = LocalizationKey.cancel.localizing()
        expenseChooseDoneBtnObj.title = LocalizationKey.done.localizing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.timer.invalidate()
    }
    
    
    func getCurrentLocation() {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

      //  DispatchQueue.main.async {
            // your code here
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
       // }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentCorrdinate = locValue
    }
    
    var distanceToUsersCurrentLocation: Double {
        let manager = CLLocationManager() //location manager for user's current location
        let destinationCoordinates = CLLocation(latitude: (Double(lat) ?? 0.0), longitude: (Double(long) ?? 0.0)) //coordinates for destinastion
        // let destinationCoordinates = CLLocation(latitude: (30.7046), longitude: (76.7179)) //coordinates for destinastion
        
        let selfCoordinates = CLLocation(latitude: (currentCorrdinate.latitude ?? 0.0), longitude: (currentCorrdinate.longitude ?? 0.0))
        
        //   let selfCoordinates = CLLocation(latitude: (30.7377), longitude: (76.6792)) //user's location
        return selfCoordinates.distance(from: destinationCoordinates) //return distance in **meters**
    }
    
    //MARK: Functions
    func configUI() {
        openImgView.isHidden = true
        userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? ""
        pickerExpenseVw.delegate = self
        pickerExpenseVw.dataSource = self
        
        expenseChooseVw.isHidden = true
        if workHourModel.extraWorkPDFData.count == 0 {
            otherExpenseHeightConstraint.constant = 0.0
            topOtherExpenseConstraint.constant = 0.0
        } else {
            otherExpenseHeightConstraint.constant = 125.0
            topOtherExpenseConstraint.constant = 16.0
        }
        
        if self.workHourModel.extraWorkPDFData.count == 0 {
            self.extraWorkCollectionHeight.constant = 0.0
            self.extraWorkTopVw.constant = 0.0
        } else {
            self.extraWorkCollectionHeight.constant = 125.0
            self.extraWorkTopVw.constant = 16.0
        }
        
        extraWorkDocCollectionVw.delegate = self
        extraWorkDocCollectionVw.dataSource = self
        otherExpenseCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
        extraWorkDocCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
        
        self.timer.invalidate()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwDatePicker.addGestureRecognizer(tap)
        let timePicker = UITapGestureRecognizer(target: self, action: #selector(self.timePickerTap(_:)))
        vwTimePicker.addGestureRecognizer(timePicker)
        
        vwDatePicker.isHidden = true
        
//        if comingFrom == "workHourDetail" {
            index = 5
            addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.RegiterMilesTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.RegiterMilesTVC.rawValue)
            
            addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.PassengerTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.PassengerTVC.rawValue)
            
            addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ExtraWorkTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ExtraWorkTVC.rawValue)
            
            addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.OtherExpenseTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.OtherExpenseTVC.rawValue)
            
//            addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.OverTimes.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.OverTimes.rawValue)
            
//        }
        addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.AddWorkDocTaskTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AddWorkDocTaskTVC.rawValue)
        
        addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.UploadOtherDocWorkTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.UploadOtherDocWorkTVC.rawValue)
        
        addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.AddOnWorkTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AddOnWorkTVC.rawValue)
        
        addDoctblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.OverTimes.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.OverTimes.rawValue)

        defaultTimeToMinute()
        addDoctblVw.reloadData()
    }
    
    
    //MARK: Button Actions
    @IBAction func btnBackAction(_ sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.checkWorkHoursDetails)
        delegate?.checkWorkHoursSegmentIndex(segmentIndex: selectedWorkHoursSegmmentIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Delegate
    
//    func uploadDocumentUpdatedData(uploadDocumentData: [String]) {
//        uploadAttachmentsArrayData = uploadDocumentData
//        addDoctblVw.reloadData()
//    }
    
    func openImageInViewImage(url: URL?) {
        viewImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        openImgView.isHidden = false
    }
    
    func uploadDocumentUpdatedData(uploadDocumentData: [[String:Any]]) {
//        uploadAttachmentsArrayData = uploadDocumentData
        self.arrAttachmentsData = uploadDocumentData
        addDoctblVw.reloadData()
    }

    func deletePassengerData (passengerData : [Passenger]) {
        self.workHourModel.passengerData = passengerData
        addDoctblVw.reloadData()
    }
    
    func signatureImg(signatureImage: UIImage) {
        
        signatureImg = signatureImage
        
//        addDoctblVw.reloadSections(IndexSet(integer: 7), with: .none)
        
           addDoctblVw.reloadData()
        
    }
    
    func selectedCorrdinates(lat: String, long: String) {
        
        //  self.txtGPSData.text = "\(lat), \(long)"
        self.lat = lat
        self.long = long
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        vwDatePicker.isHidden = true
    }
    
    @objc func timePickerTap(_ sender: UITapGestureRecognizer? = nil) {
        vwTimePicker.isHidden = true
    }
    
    @objc func clickToOpenExtraWork(_ sender: UIButton) {
        blackBackgroundVw.isHidden = false
        extraWorkVw.isHidden = false
        extraWorkBtn.isHidden = false
    }
    
    @objc func clickToOpenOtherExpense(_ sender: UIButton) {
        blackBackgroundVw.isHidden = false
        otherExpenseVw.isHidden = false
        otherExpenseBtn.isHidden = false
    }
    
    @objc func clickToOpenExtraPassengers(_ sender: UIButton) {
        blackBackgroundVw.isHidden = false
        extraPassengerVw.isHidden = false
        extrapassengerBtn.isHidden = false
    }
    
    @objc func clickToRegisterKilometer(_ sender: UIButton) {
        blackBackgroundVw.isHidden = false
        registerMilesVw.isHidden = false
        registerMilesBtn.isHidden = false
    }
    
    @objc func clickToSignature(_ sender: UIButton) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToChangeSignature(_ sender: UIButton) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func clickToImageUpload(_ sender: UIButton) {
//        ImagePickerManager().pickImage(self){ [self] image,path  in
//            print(path)
//            selectedImage = image
//            addDoctblVw.reloadData()
////            addDoctblVw.reloadSections(IndexSet(integer: 7), with: .none)
//        }
        
//        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .text, .gif, .pdf, .rtf])
//        documentPicker.delegate = self
//        documentPicker.modalPresentationStyle = .overFullScreen
//
//        present(documentPicker, animated: true)
        
        showActionSheet()
//        uploadDcoumentType = "ImageUpload"
//        ChoosenPDF()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

    }

//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urls: URL) {
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        dismiss(animated: true)
//        // Copy the file with FileManager
//        print("Documnet URL is : ", urls)
//
//        let url: NSURL = (urls[0] as? NSURL)!
//        let fileExtension = url.pathExtension
//        var filetension = url.lastPathComponent
//        filetension = filetension?.replacingOccurrences(of: "", with: "", options: NSString.CompareOptions.literal, range: nil)
//
//        var myData = NSData(contentsOf: url as URL)
//        let convertURL =  url as URL
//
//        let fileData = try? Data.init(contentsOf: convertURL)
//        let fileStream:String = fileData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) ?? ""
////
//        AllUsersVM.shared.saveUserAttachment(imageId: userID, imageData: fileStream, fileName: filetension ?? "", type: "document") { (errorMsg,loginMessage,attachIds)  in
//            print("User attachment upload successfully")
////            uploadLatestID = String(attachIds)
//            if (self.uploadAttachmentsArray == ""){
//                self.uploadAttachmentsArray = String(attachIds)
//            }
//            else {
//                self.uploadAttachmentsArray = self.uploadAttachmentsArray + "," + String(attachIds)
//            }
//            self.uploadAttachmentsArrayData.append(String(attachIds))
//            self.addDoctblVw.reloadData()
//        }
//    }
    
    
    func showActionSheet() {
        let alert = UIAlertController(title: "", message: LocalizationKey.action.localizing(), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: LocalizationKey.uploadDocuments.localizing(), style: .default , handler:{ (UIAlertAction)in
            self.uploadDcoumentType = "ImageUpload"
            self.ChoosenPDF()
        }))
        
        alert.addAction(UIAlertAction(title: LocalizationKey.camera.localizing(), style: .default , handler:{ (UIAlertAction)in
            self.uploadDcoumentType = "ImageUpload"
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
        //        var picker = UIImagePickerController();
        ////        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        ////            var imagePicker = UIImagePickerController()
        ////            imagePicker.delegate = self
        ////            imagePicker.sourceType = .camera;
        ////            imagePicker.allowsEditing = false
        ////            self.present(imagePicker, animated: true, completion: nil)
        ////        }
        ////
        //        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
        //            picker.sourceType = .camera
        //            self.present(picker, animated: true, completion: nil)
        //        }
        //        else {
        //            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .actionSheet)
        //            let ok = UIAlertAction(title: "Ok", style: .default){
        //                UIAlertAction in
        //            }
        //            alert.addAction(ok)
        //            self.present(alert, animated: true, completion: nil)
        //        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }

    // For Swift 4.2+
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
                
                if extraWorkVw.isHidden == false {
                    saveAttachment(base64: strBase64, fileType: "jpeg", fileName: str_Path)
                } else if otherExpenseVw.isHidden == false {
                    saveAttachment(base64: strBase64, fileType: "jpeg", fileName: str_Path)
                }
                
                if (uploadDcoumentType == "ImageUpload") {
                    AllUsersVM.shared.saveUserAttachment(imageId: userID, imageData: strBase64, fileName: str_Path , type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                        print("User image upload successfully")
                        var attachmentsDetails = [String:Any]()
                        attachmentsDetails["id"] = attachIds
                        attachmentsDetails["filename"] = str_Path
                        attachmentsDetails["filetype"] = "docs"
                        attachmentsDetails["user_id"] = self.timelogData?.user_id
                        //                attachmentsDetails["location"] = self.attechmentsData?[i].location
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
                        self.addDoctblVw.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: Button Actions
    @IBAction func crossBtnAction(_ sender: UIButton) {
        if sender.tag == 0 {
            extraWorkVw.isHidden = true
            extraWorkBtn.isHidden = true
        } else if sender.tag == 1 {
            otherExpenseVw.isHidden = true
            otherExpenseBtn.isHidden = true
        } else if sender.tag == 2 {
            extraPassengerVw.isHidden = true
            extrapassengerBtn.isHidden = true
        } else if sender.tag == 3 {
            registerMilesVw.isHidden = true
            registerMilesBtn.isHidden = true
        }
        blackBackgroundVw.isHidden = true
    }
    
    @objc func openDatePicker(sender: UIButton){
        vwDatePicker.isHidden = false
    }
    
    @objc func openTask(sender: UIButton){
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectTasksVC") as! SelectTasksVC
        vc.isComingFrom = "addWorkHour"
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openMap(sender: UIButton){
        let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "TaskMapVC") as! TaskMapVC
        vc.lat = self.lat as String
        vc.long = self.long as String
        vc.isMapFrom = "WorkHours"
        vc.isTimelogData = timelogData
        vc.delegate = self
        vc.currentTaskName = taskDetails?.name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func startTime(sender: UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format
        let date = dateFormatter.date(from: logTime(time: startTime))
        timePicker.date = date ?? currentDateFromGMT
        selectedTime = startTime
        
        print(logTime(time: startTime))
        selectTimeType = SelectTimeType.StartTime
        vwTimePicker.isHidden = false
    }
    
    @objc func endTime(sender: UIButton){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.time_format
        let date = dateFormatter.date(from: logTime(time: endTime))
        timePicker.date = date ?? currentDateFromGMT
        selectedTime = endTime
        
        selectTimeType = SelectTimeType.EndTime
        vwTimePicker.isHidden = false
    }
    
    @objc func breakTime(sender: UIButton) {
        
        print(breakTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "H:mm"
        let date = dateFormatter.date(from: "0:00")
        timePicker.date = date ?? currentDateFromGMT
        selectedTime = 0
        
        selectTimeType = SelectTimeType.BreakTime
        vwTimePicker.isHidden = false
    }
    
    @objc func startEnd(sender: UIButton) {
        print(distanceToUsersCurrentLocation)
        if distanceToUsersCurrentLocation > 1000 {
            self.showAlert(message: "\(LocalizationKey.youAreNotUnder500Meter.localizing())\(distanceToUsersCurrentLocation)", strtitle: LocalizationKey.alert.localizing())
            return
        }
        if timelogData?.status == WorkType.Draft.rawValue {
            if timer.isValid {
                finishTaskApi(id: id)
            }
            else {
                startTaskApi(id: id)
            }
        }
    }
    
    @objc func btnBreak(sender: UIButton) {
        
        if distanceToUsersCurrentLocation > 1000 {
            
            self.showAlert(message: "\(LocalizationKey.youAreNotUnder500Meter.localizing())\(distanceToUsersCurrentLocation)", strtitle: LocalizationKey.alert.localizing())
            return
        }
        
        print(distanceToUsersCurrentLocation)

        if timer.isValid {

            breakStartApi(id: id)

        }
        else {
            breakStopApi(id: id)

        }
    }
    
    @IBAction func viewImgcrossBtnAction(_ sender: Any) {
        openImgView.isHidden = true
    }
    
    @IBAction func btnDonaAction(_ sender: UIBarButtonItem) {
        vwDatePicker.isHidden = true
        finalDate = selectedDate
        
        addDoctblVw.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
    @IBAction func btnCancelAction(_ sender: UIBarButtonItem) {
        vwDatePicker.isHidden = true
    }
    
    
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(for: sender.date))
        selectedDate = formatter.string(for: sender.date) ?? ""
    }
    
    
    @IBAction func TimePickerValueChanged(_ sender: UIDatePicker) {
        let cDate = currentDateFromGMT
        
        let hoursDate = DateFormatter()
        hoursDate.dateFormat = "H"
        let hours = Int(hoursDate.string(for: sender.date) ?? "") ?? 0
        
        let minutesDate = DateFormatter()
        minutesDate.dateFormat = "mm"
        let minutes = Int(minutesDate.string(for: sender.date) ?? "") ?? 0
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "H:mm" //"h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        
        switch selectTimeType {
        case .StartTime:
            
            selectedTime = hours * 60 + minutes
            
           // let totalWorkingHours = Helper.minutesToHoursAndMinutes(timelogData?.total_hours_normal ?? 0)
            
//            hmsFrom(seconds: Int((timelogData?.total_hours_normal ?? 0)*60)) { hour, minute, second in
//                let hour = self.getStringFrom(seconds: hour)
//                let minute = self.getStringFrom(seconds: minute)
//                let second = self.getStringFrom(seconds: second)
//                self.totalWorkingHour = "\(hour):\(minute)"
//
//                self.totalTime = "\(hour):\(minute):\(second)"
//            }
            
           // self.startTime = selectedTime
        case .EndTime:
            
            selectedTime = hours * 60 + minutes
            
           // self.endTime = selectedTime
        case .BreakTime:
            selectedTime = hours * 60 + minutes
            
                //self.breakTime = selectedTime
            
        case .Overtime50,.Overtime100,.OvertimeOther:
            selectedOvertime = formatter.string(for: sender.date) ?? ""
        default:
            break
        }
        
        if let selectPickerDate = formatter.string(for: sender.date) {
            
            print(selectPickerDate)
            
           // selectedTime = selectPickerDate
        }
        // selectedDate = formatter.string(for: sender.date) ?? ""
    }
    
    func defaultTimeToMinute () {
        let cDate = currentDateFromGMT
        
        let hoursDate = DateFormatter()
        hoursDate.dateFormat = "H"
        let hours = Int(hoursDate.string(for: cDate) ?? "") ?? 0
        
        let minutesDate = DateFormatter()
        minutesDate.dateFormat = "mm"
        let minutes = Int(minutesDate.string(for: cDate) ?? "") ?? 0
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "H:mm" //"h:mm a"
        formatter.locale = Locale(identifier: "en_US")
                
        selectedTime = hours * 60 + minutes
        startTime = selectedTime
        endTime = selectedTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatter.string(for: cDate) ?? ""
        finalDate = selectedDate
        
        selectedOvertime = formatter.string(for: currentDateFromGMT) ?? ""
    }
    
    @IBAction func btnDoneTimePickerAction(_ sender: UIBarButtonItem) {
//        switch selectTimeType {
//        case .StartTime:
//
//            if self.selectedTime > self.endTime {
////                self.showAlert(message: LocalizationKey.yourStartTimeIsNotGreaterThanYourEndTime.localizing(), strtitle: LocalizationKey.alert.localizing())
//                self.startTime = selectedTime
//                self.totalTime = (1440 - self.startTime + self.endTime - self.breakTime)
//                self.addDoctblVw.reloadData()
//
//            } else {
//                if self.startTime != selectedTime {
//                    self.timelogChange = true
//                } else {
//                    self.timelogChange = false
//                }
//                self.startTime = selectedTime
//                self.totalTime = self.endTime - self.startTime - self.breakTime
//                self.addDoctblVw.reloadData()
//            }
//        case .EndTime:
//            if self.startTime > self.selectedTime {
////                self.showAlert(message: LocalizationKey.yourStartTimeIsNotGreaterThanYourEndTime.localizing(), strtitle: LocalizationKey.alert.localizing())
//                self.endTime = selectedTime
//                self.totalTime = (1440 - self.startTime + self.endTime - self.breakTime)
//                self.addDoctblVw.reloadData()
//            } else {
//                if self.endTime != selectedTime {
//                    self.timelogChange = true
//                } else {
//                    self.timelogChange = false
//                }
//                self.endTime = selectedTime
//                self.totalTime = self.endTime - self.startTime - self.breakTime
//                self.addDoctblVw.reloadData()
//            }
//
//           // self.endTime = selectedTime
//        case .BreakTime:
//
//            if selectedTime > self.totalTime {
//                self.showAlert(message: LocalizationKey.yourBreakTimeIsNotGreaterThanYourTotalWorkingHours.localizing(), strtitle: LocalizationKey.alert.localizing())
//            } else {
//                self.breakTime = selectedTime
//
////                self.totalTime = self.endTime - self.startTime - self.breakTime
//                self.totalTime = self.totalTime - self.breakTime
//                self.addDoctblVw.reloadData()
//            }
//           // self.breakTime = selectedTime
//            print("selectedOvertime is : ", selectedOvertime)
//        case .Overtime50:
////            timelogData?.data?.overtimes?.fifty?.value = selectedOvertime
//            timelogData?.data?.overtime_array?[selectedOvertimeIndexpath].value = selectedOvertime
//
//            let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "H:mm"
//
//            var totalMinutes: Int = 0
//            let allHoursArray = timelogData?.data?.overtime_array
//
//            for obj in allHoursArray ?? [] {
//                if let date = dateFormatter.date(from: obj.value ?? "00:00") {
//                    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
//                    totalMinutes += (components.hour ?? 0) * 60 + (components.minute ?? 0)
//                }
//            }
//
//            let hours = totalMinutes / 60
//            let minutes = totalMinutes % 60
//
//            print("totalMinutes ",totalMinutes)
//            print("hours ",hours)
//            print("minutes ",minutes)
//            timelogData?.total_hours_overtime = totalMinutes
//            self.addDoctblVw.reloadData()
//
//        case .Overtime100:
//            timelogData?.data?.overtimes?.hundred?.value = selectedOvertime
//            self.addDoctblVw.reloadData()
//
//        case .OvertimeOther:
//            timelogData?.data?.overtimes?.other?.value = selectedOvertime
//            self.addDoctblVw.reloadData()
//        default:
//            break
//        }
        switch selectTimeType {
                case .StartTime:
                    
                    if self.selectedTime > self.endTime {
        //                self.showAlert(message: LocalizationKey.yourStartTimeIsNotGreaterThanYourEndTime.localizing(), strtitle: LocalizationKey.alert.localizing())
                        self.startTime = selectedTime
//                        self.breakTime = 0
                        self.totalTime = (1440 - self.startTime + self.endTime - self.breakTime)
                        self.addDoctblVw.reloadData()

                    } else {
                        if self.startTime != selectedTime {
                            self.timelogChange = true
                        } else {
                            self.timelogChange = false
                        }
                        self.startTime = selectedTime
//                        self.breakTime = 0
                        self.totalTime = self.endTime - self.startTime - self.breakTime
                        self.addDoctblVw.reloadData()
                    }
                case .EndTime:
                    if self.startTime > self.selectedTime {
        //                self.showAlert(message: LocalizationKey.yourStartTimeIsNotGreaterThanYourEndTime.localizing(), strtitle: LocalizationKey.alert.localizing())
                        self.endTime = selectedTime
//                        self.breakTime = 0
                        self.totalTime = (1440 - self.startTime + self.endTime - self.breakTime)
                        self.addDoctblVw.reloadData()
                    } else {
                        if self.endTime != selectedTime {
                            self.timelogChange = true
                        } else {
                            self.timelogChange = false
                        }
                        self.endTime = selectedTime
//                        self.breakTime = 0
                        self.totalTime = self.endTime - self.startTime - self.breakTime
                        self.addDoctblVw.reloadData()
                    }

                   // self.endTime = selectedTime
                case .BreakTime:
                    
                    if self.startTime > self.endTime {
                        let temTotal = (1440 - self.startTime + self.endTime)
                        if temTotal < selectedTime {
                            self.showAlert(message: LocalizationKey.yourBreakTimeIsNotGreaterThanYourTotalWorkingHours.localizing(), strtitle: LocalizationKey.alert.localizing())
                        } else {
                            self.breakTime = selectedTime
                            self.totalTime = temTotal - self.breakTime
                        }
                    } else {
                        if selectedTime > (self.endTime - self.startTime) {
                            self.showAlert(message: LocalizationKey.yourBreakTimeIsNotGreaterThanYourTotalWorkingHours.localizing(), strtitle: LocalizationKey.alert.localizing())
                        } else {
                            self.breakTime = selectedTime
                            self.totalTime = self.endTime - self.startTime - self.breakTime
                        }
                    }
                    self.addDoctblVw.reloadData()
                   // self.breakTime = selectedTime
                    print("selectedOvertime is : ", selectedOvertime)
                case .Overtime50:
        //            timelogData?.data?.overtimes?.fifty?.value = selectedOvertime
                    timelogData?.data?.overtime_array?[selectedOvertimeIndexpath].value = selectedOvertime
                    
                    let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "H:mm"
                        
                    var totalMinutes: Int = 0
                    let allHoursArray = timelogData?.data?.overtime_array
                    
                    for obj in allHoursArray ?? [] {
                        if let date = dateFormatter.date(from: obj.value ?? "00:00") {
                            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                            totalMinutes += (components.hour ?? 0) * 60 + (components.minute ?? 0)
                        }
                    }
                    
                    let hours = totalMinutes / 60
                    let minutes = totalMinutes % 60
                    
                    print("totalMinutes ",totalMinutes)
                    print("hours ",hours)
                    print("minutes ",minutes)
                    timelogData?.total_hours_overtime = totalMinutes
                    self.addDoctblVw.reloadData()
                    
                case .Overtime100:
                    timelogData?.data?.overtimes?.hundred?.value = selectedOvertime
                    self.addDoctblVw.reloadData()
                    
                case .OvertimeOther:
                    timelogData?.data?.overtimes?.other?.value = selectedOvertime
                    self.addDoctblVw.reloadData()
                default:
                    break
                }
        
        addDoctblVw.reloadSections(IndexSet(integer: 0), with: .none)
        vwTimePicker.isHidden = true
    }
    
    func getLatLong(lat: Double, long: Double, addressMap: String, postalCode: String, cityName: String) {
        print("")
        
    }
    
    @IBAction func btnCancelTimePickerAction(_ sender: UIBarButtonItem) {
        vwTimePicker.isHidden = true
    }

    @IBAction func btnSaveAction(_ sender: UIButton) {
        if (comingFrom == "addWorkHour") {
            print("endTime is :", endTime)
            if (taskId == "") {
                self.showAlert(message: LocalizationKey.pleaseAddTaskAndProject.localizing(), strtitle: "")
            } 
//            else if (startTime == 0) {
//                self.showAlert(message: LocalizationKey.pleaseSelectTheStartTime.localizing(), strtitle: "")
//            } else if (endTime == 0) {
//                self.showAlert(message: LocalizationKey.pleaseSelectEndTime.localizing(), strtitle: "")
//            } 
            else if (self.totalTime < self.timelogData?.total_hours_overtime ?? 0) {
                self.showAlert(message: "Total work time is less than overtime", strtitle: "")
            } else {
                saveManualyWorkHourApi()
            }
        }
        else {
            if timelogChange {
                showAlert(title: LocalizationKey.confirmTimeChange.localizing(), message: LocalizationKey.youHaveChangedFromtoTimesThisWillSwitchTimelogToManual.localizing())
            } else if (self.totalTime < self.timelogData?.total_hours_overtime ?? 0) {
                self.showAlert(message: "Total work time is less than overtime", strtitle: "")
            } else {
                saveTaskApi(id: self.id)
            }
        }
    }
    
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            // start work
            self.saveTaskApi(id: self.id)
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func chooseOtherExpenseBtnAction(_ sender: Any) {
        uploadDcoumentType = "OtherExpense"
        self.showActionSheet()
//        ChoosenPDF()
    }
    
    
    @IBAction func chooseExtraWorkDocBtnAction(_ sender: Any) {
        uploadDcoumentType = "ExtraWork"
        self.showActionSheet()
//        ChoosenPDF()
    }
    
    func getTaskProjectName(projectId: String, taskId: String) {
        print("Project Id : ", projectId)
        print("Task Id : ", taskId)
        self.taskId = taskId
        self.hitTaskNameApi(taskId: taskId)
    }
    
    @IBAction func extraWorkSaveBtn(_ sender: Any) {
        if expenseTypeTxtField.text == "" {
            self.showAlert(message: LocalizationKey.pleaseChooseTypeOfExtraWork.localizing(), strtitle: "")
        } else if extraWorkHourTxtField.text == "" {
            self.showAlert(message: LocalizationKey.pleaseEnterExtraWorkHour.localizing(), strtitle: "")
        } else if extraWorkCommentTxtVw.text == "" {
            self.showAlert(message: LocalizationKey.pleaseAddComment.localizing(), strtitle: "")
        } else{
            
            workHourModel.workingHourdata.removeAll()
            
//            workHourModel.extraWorkData.append(ExtraWork.init(workHourType: "extraWork", extraWork: expenseTypeTxtField.text ?? "", extraHours: extraWorkHourTxtField.text ?? "", extraWorkComment: extraWorkCommentTxtVw.text ?? "", extraWorkAllPDF: workHourModel.extraWorkPDFData))
            
            workHourModel.extraWorkData.append(ExtraWork.init(workHourType: "extraWork", extraWork: expenseTypeTxtField.text ?? "", extraHours: extraWorkHourTxtField.text ?? "", extraWorkComment: extraWorkCommentTxtVw.text ?? "", extraWorkAllPDF: arrExtraDataAttachments))

            
            workHourModel.workHourData.append(allWorkHourData.init(workHourType: "extraWork", passengerName: [], registerMiles: [], expenseTypes: [], extraWork: workHourModel.extraWorkData))
            
            for i in 0..<workHourModel.expenseTypesData.count {
                workHourModel.workingHourdata.append(ExpenseTypes.init(workHourType: "expenseData", expenseType: workHourModel.expenseTypesData[i].workHourType, expenseCost: workHourModel.expenseTypesData[i].expenseCost, expenseComment: workHourModel.expenseTypesData[i].expenseComment, expenseAllPDF: workHourModel.expenseTypesData[i].expenseAllPDF))
            }
            
            
            for i in 0..<workHourModel.extraWorkData.count {
               
                workHourModel.workingHourdata.append(ExpenseTypes.init(workHourType: "extraWork", expenseType: workHourModel.extraWorkData[i].extraWork, expenseCost: workHourModel.extraWorkData[i].extraHours, expenseComment: workHourModel.extraWorkData[i].extraWorkComment, expenseAllPDF: workHourModel.extraWorkData[i].extraWorkAllPDF))
            }
            
            blackBackgroundVw.isHidden = true
            extraPassengerVw.isHidden = true
            extrapassengerBtn.isHidden = true
            otherExpenseVw.isHidden = true
            extraWorkVw.isHidden = true
            extraWorkBtn.isHidden = true
            passengerTxtField.text = ""
            extraWorkHourTxtField.text = ""
            extraWorkCommentTxtVw.text = ""
            workHourModel.extraWorkPDFData = []
            extraWorkDocCollectionVw.reloadData()
            arrExtraDataAttachments = ""
            configUI()
            addDoctblVw.reloadData()
        }
    }
    
    @IBAction func extraPassengerSaveBtn(_ sender: Any) {
        if passengerTxtField.text == "" {
            self.showAlert(message: LocalizationKey.pleaseEnterPassengerName.localizing(), strtitle: "")
        } else {
            workHourModel.passengerData.append(Passenger.init(passengerName: passengerTxtField.text ?? ""))
//            if workHourModel.passengerData.count == 1 {
               // workHourModel.workHourData.append(allWorkHourData.init(workHourType: "Passenger", passengerName: workHourModel.passengerData, registerMiles: [], expenseTypes: [], extraWork: []))
                workHourModel.workHourData.insert(allWorkHourData.init(workHourType: "Passenger", passengerName: workHourModel.passengerData, registerMiles: [], expenseTypes: [], extraWork: []), at: 0)
               // workHourModel.workHourData.insert(contentsOf: allWorkHourData.init(workHourType: "Passenger", passengerName: workHourModel.passengerData, registerMiles: [], expenseTypes: [], extraWork: []), at: 0)
//            }
            
            blackBackgroundVw.isHidden = true
            extraPassengerVw.isHidden = true
            extrapassengerBtn.isHidden = true
            passengerTxtField.text = ""
            addDoctblVw.reloadData()
        }
    }
    
    @IBAction func registerMilesSaveBtn(_ sender: Any) {
        if distanceTxtField.text == "" {
            self.showAlert(message: LocalizationKey.pleaseEnterDistance.localizing(), strtitle: "")
        } else if distanceFromTxtField.text == "" {
            self.showAlert(message: LocalizationKey.pleaseEnterStartLocation.localizing(), strtitle: "")
        } else if distanceToTxtField.text == "" {
            self.showAlert(message: LocalizationKey.pleaseEnterStopLocation.localizing(), strtitle: "")
        } else{
            let distanceData = Double(distanceTxtField.text ?? "0.0") ?? 0.0
            workHourModel.registerMilesData.append(RegisterMiles.init(distance: distanceData, distanceFrom: distanceFromTxtField.text ?? "", distanceTo: distanceToTxtField.text ?? ""))
            
            workHourModel.workHourData.append(allWorkHourData.init(workHourType: "registerMiles", passengerName: [], registerMiles: workHourModel.registerMilesData, expenseTypes: [], extraWork: []))
            addDoctblVw.reloadData()
            registerMilesVw.isHidden = true
            registerMilesBtn.isHidden = true
            blackBackgroundVw.isHidden = true
        }
    }
    
    @IBAction func expenseSaveBtn(_ sender: Any) {
        if otheExpenseTypeTxtField.text == "" {
            self.showAlert(message: LocalizationKey.pleaseChooseExpenseType.localizing(), strtitle: "")
        } else if otherExpenseCostTxtField.text == "" {
            self.showAlert(message: LocalizationKey.pleaseEnterCost.localizing(), strtitle: "")
        } else if otherExpenseCommentTxtVw.text == "" {
            self.showAlert(message: LocalizationKey.pleaseAddComment.localizing(), strtitle: "")
        } else{
            
         //   workHourModel.workingHourdata.removeAll()
            workHourModel.workingHourdata.removeAll()
//            workHourModel.expenseTypesData.append(ExpenseTypes.init(workHourType: "expenseData", expenseType: otheExpenseTypeTxtField.text ?? "", expenseCost: otherExpenseCostTxtField.text ?? "", expenseComment: otherExpenseCommentTxtVw.text ?? "", expenseAllPDF: workHourModel.otherExpensePDFData))
            
            workHourModel.expenseTypesData.append(ExpenseTypes.init(workHourType: "expenseData", expenseType: otheExpenseTypeTxtField.text ?? "", expenseCost: otherExpenseCostTxtField.text ?? "", expenseComment: otherExpenseCommentTxtVw.text ?? "", expenseAllPDF: arrExpenseDataAttachments))

            
            workHourModel.workHourData.append(allWorkHourData.init(workHourType: "expenseData", passengerName: [], registerMiles: [], expenseTypes: workHourModel.expenseTypesData, extraWork: []))
            
            
            for i in 0..<workHourModel.expenseTypesData.count {
                workHourModel.workingHourdata.append(ExpenseTypes.init(workHourType: "expenseData", expenseType: workHourModel.expenseTypesData[i].expenseType, expenseCost: workHourModel.expenseTypesData[i].expenseCost, expenseComment: workHourModel.expenseTypesData[i].expenseComment, expenseAllPDF: workHourModel.expenseTypesData[i].expenseAllPDF))
            }
            
            
            for i in 0..<workHourModel.extraWorkData.count {
               
                workHourModel.workingHourdata.append(ExpenseTypes.init(workHourType: "extraWork", expenseType: workHourModel.extraWorkData[i].extraWork, expenseCost: workHourModel.extraWorkData[i].extraHours, expenseComment: workHourModel.extraWorkData[i].extraWorkComment, expenseAllPDF: workHourModel.extraWorkData[i].extraWorkAllPDF))
            }
            
            
            blackBackgroundVw.isHidden = true
            extraPassengerVw.isHidden = true
            extrapassengerBtn.isHidden = true
            otherExpenseVw.isHidden = true
            passengerTxtField.text = ""
            otheExpenseTypeTxtField.text = ""
            otherExpenseCostTxtField.text = ""
            otherExpenseCommentTxtVw.text = ""
            workHourModel.otherExpensePDFData = []
            otherExpenseCollectionVw.reloadData()
            arrExpenseDataAttachments = ""
            configUI()
            addDoctblVw.reloadData()

        }
    }
    
    @IBAction func expenseTypeDoneVw(_ sender: Any) {
        vwTimePicker.isHidden = true
        expenseChooseVw.isHidden = true
    }
    
    @IBAction func cancelExpenseTypeVw(_ sender: Any) {
        vwTimePicker.isHidden = true
        expenseChooseVw.isHidden = true
        
        if otherExpenseVw.isHidden == false {
            otheExpenseTypeTxtField.text = ""
            
        } else {
            expenseTypeTxtField.text = ""
        }
    }
    
    
    @IBAction func chooseExpenseTypeBtnAction(_ sender: UIButton) {
        vwTimePicker.isHidden = false
        expenseChooseVw.isHidden = false
        
        pickerExpenseVw.reloadAllComponents()
    }
    
    
}

// MARK: Document Picker:-
extension AddWorkDocumentVC : UIDocumentPickerDelegate {
    
    func ChoosenPDF() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .text, .gif, .pdf, .rtf], asCopy: true)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        var PDFUrl = NSURL(string: pdfPath)
//        convert pdfPath string to NSURL
//        var myData = NSData(contentsOfURL: PDFUrl!)
        
        let url: NSURL = (urls[0] as? NSURL)!
        let fileExtension = url.pathExtension
        var filetension = url.lastPathComponent
        filetension = filetension?.replacingOccurrences(of: "", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        var myData = NSData(contentsOf: url as URL)
        let convertURL =  url as URL
        
        let fileData = try? Data.init(contentsOf: convertURL)
        let fileStream:String = fileData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) ?? ""

        if extraWorkVw.isHidden == false {
           // workHourModel.extraWorkPDFData.append(expensePDF.init(expensePDF: convertURL, expenseBase64: fileStream))
            saveAttachment(base64: fileStream, fileType: "docs", fileName: filetension ?? "")
           // workHourModel.extraWorkPDFData.append(extraWorkPDF.init(extraWorkPDF: convertURL))
           // extraWorkDocCollectionVw.reloadData()
        } else if otherExpenseVw.isHidden == false {
           // workHourModel.otherExpensePDFData.append(expensePDF.init(expensePDF: convertURL, expenseBase64: fileStream))
            saveAttachment(base64: fileStream, fileType: "docs", fileName: filetension ?? "")
           // otherExpenseCollectionVw.reloadData()
        }
        
        if (uploadDcoumentType == "ImageUpload") {
            AllUsersVM.shared.saveUserAttachment(imageId: userID, imageData: fileStream, fileName: filetension ?? "", type: "document") { (errorMsg,loginMessage,attachIds)  in
                print("User attachment upload successfully")
//                var uploadAttachments = [[String:Any]]()
//                var uploadAttachmentsDetails = [String:Any]()
//                uploadAttachmentsDetails["id"] = attachIds
//                uploadAttachmentsDetails["filename"] = filetension
//                uploadAttachmentsDetails["filetype"] = "document"
//                uploadAttachmentsDetails["user_id"] = timelogData?.user_id
////                uploadAttachments["location"] = timelogData?.data?.overtimes?.fifty?.code
//                uploadAttachmentsDetails["to_model"] = "Timelog"
//                uploadAttachmentsDetails["to_id"] = attachIds
//                uploadAttachmentsDetails["data"] = []
////                uploadAttachments["code"] = timelogData?.data?.overtimes?.fifty?.code
////                uploadAttachments["code"] = timelogData?.data?.overtimes?.fifty?.code
//
//                self.attechmentsData?.append(uploadAttachmentsDetails)
                
    //            uploadLatestID = String(attachIds)
                
                var attachmentsDetails = [String:Any]()
                attachmentsDetails["id"] = attachIds
                attachmentsDetails["filename"] = filetension
                attachmentsDetails["filetype"] = "docs"
                attachmentsDetails["user_id"] = self.timelogData?.user_id
//                attachmentsDetails["location"] = self.attechmentsData?[i].location
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
                self.addDoctblVw.reloadData()
            }
        }
         print(url)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension AddWorkDocumentVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
//        if comingFrom == "workHourDetail" {
//            return 5+workHourModel.workingHourdata.count+passengerDataIndex
//        }
//        return 3
        
//        if comingFrom == "workHourDetail" {
            return 7
//        }
//        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 2) {
            return workHourModel.registerMilesData.count > 0 ? 1 : 0
        }
        else if (section == 3) {
            return workHourModel.passengerData.count > 0 ? 1 : 0
        }
        else if (section == 4) {
            return (workHourModel.expenseTypesData.count > 0 || workHourModel.extraWorkData.count > 0 )  ? (workHourModel.expenseTypesData.count + workHourModel.extraWorkData.count) : 0
//            return workHourModel.workingHourdata.count > 0 ? workHourModel.workingHourdata.count : 0
        }
//        else if (section == 5) {
//            return workHourModel.extraWorkData.count > 0 ? workHourModel.extraWorkData.count : 0
//        }
        else if (section == 1) {
//            return ((timelogData?.data?.overtimes) != nil) ? 1 : 0
            let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
            let userIDAPI =  "\(timelogData?.user_id ?? 0)"

//            if self.comingFrom == "workHourDetail" {
//                if timelogData?.data?.overtimes != nil {
//                    return 1
//                } else {
//                    if (GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false && userID == userIDAPI) {
//                        return 0
//                    } else if (!(GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false) && userID != userIDAPI) {
//                        return 0
//                    } else {
//                        return 1
//                    }
//                }
//            }
//            else {
//                if (GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false) {
//                    return 0
//                } else {
//                    return 1
//                }
//            }
            
            /*
            if self.comingFrom == "workHourDetail" {
                if timelogData?.data?.overtime_array != nil {
                    return 1
                } else {
                    if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false || GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
                        return 0
                    } else if (GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false) {
                        if (userID == userIDAPI) {
                            return 0
                        } else {
                            return 1
                        }
                    } else {
                        if (userID == userIDAPI) {
                            return 1
                        } else {
                            return 0
                        }
                    }
                }
            } else {
                if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
                    return 1
                } else {
                    if (GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false) {
                        return 0
                    } else {
                        return 1
                    }
                }
            }
             */
            
            
            /*
            if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtime_types?.count ?? 0 < 1 || (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false || GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
                    return 0
            } else if (GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs == "gps") {
                if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.pmManagesOvertime ?? false {
                    if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
                        return 1
                    } else {
                        return 0
                    }
                } else {
                    if (userID == userIDAPI) {
                        return 1
                    } else {
                        return 0
                    }
                }
            } else {
                return 1
            }
             
            */
            if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtime_types?.count ?? 0 < 1 {
                return 0
            } else {
                return 1
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if comingFrom == "workHourDetail" {
        if tableView == addDoctblVw {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AddWorkDocTaskTVC.rawValue, for: indexPath) as? AddWorkDocTaskTVC else { return UITableViewCell() }
                cell.delegate = self
                if timelogData?.status == WorkType.Draft.rawValue {
                    cell.breakTimeVw.isHidden = false
                    cell.totalTimeVw.isHidden = true
                    cell.endTimeVw.isHidden = true
                }
                else {
                    cell.breakTimeVw.isHidden = true
                    cell.totalTimeVw.isHidden = false
                    cell.endTimeVw.isHidden = false
                }
                cell.dashboardScheduleData = homeModel.dashboardScheduleData
                cell.lblDate.text = finalDate
                
                cell.currentTimelogData = timelogData
                cell.lblTask.text = taskDetails?.name ?? LocalizationKey.selectTask.localizing()
                
                cell.lblProjectName.text = taskDetails?.project?.name ?? LocalizationKey.selectProject.localizing()
                
                let from = Helper.minutesToHoursAndMinutes(startTime)
                
                //MARK: Change the time formate from configuration
//                cell.lblStartTime.text = "\(from.hours):\(from.leftMinutes)"
                cell.lblStartTime.text = logTime(time: startTime)
                
                let to = Helper.minutesToHoursAndMinutes(self.endTime)
                
                //MARK: Change the time formate from configuration
//                cell.lblEndTime.text = "\(to.hours):\(to.leftMinutes)"
                cell.lblEndTime.text = logTime(time: endTime)
                
                let breaktimes = Helper.minutesToHoursAndMinutes(breakTime)
                cell.lblBreakTime.text = "\(breaktimes.hours):\(breaktimes.leftMinutes)"
                
                hmsFrom(seconds: Int((totalTime)*60)) { hour, minute, second in
                    let hour = self.getStringFrom(seconds: hour)
                    let minute = self.getStringFrom(seconds: minute)
                    let second = self.getStringFrom(seconds: second)
                    //totalWorkingHour = "\(hour):\(minute)"
                    cell.totalTimeLbl.text = "\(hour):\(minute):\(second)"
                }
                
                //                cell.lblLocation.text = timelogData?.data?.workplace ?? ""
                cell.lblLocation.text = "\(timelogData?.gps_data?.start?.locationString ?? LocalizationKey.gpsTurnOffByUser.localizing())"
                if ((timelogData?.gps_data?.start) != nil) {
                    cell.gpsStartTimeLbl.text = timelogData?.gps_data?.start?.decision == "ok" ? LocalizationKey.approved.localizing() : timelogData?.gps_data?.start?.decision == "off-bounds" ? LocalizationKey.offSetArea.localizing() : timelogData?.gps_data?.start?.decision == "no-gps" ? LocalizationKey.noGPS.localizing() : LocalizationKey.manualOffArea.localizing()
                }
                if ((timelogData?.gps_data?.end) != nil) {
                    cell.gpsEndTimeLbl.text = timelogData?.gps_data?.end?.decision == "ok" ? LocalizationKey.approved.localizing() : timelogData?.gps_data?.end?.decision == "off-bounds" ? LocalizationKey.offSetArea.localizing() : timelogData?.gps_data?.end?.decision == "no-gps" ? LocalizationKey.noGPS.localizing() : LocalizationKey.manualOffArea.localizing()
                }
                
                cell.lblOngoingTime.text = isAdjustActualTime ? timeString(time: TimeInterval(counter)) : "00:00:00"
                cell.runTimerLbl.text = isAdjustActualTime ? timeString(time: TimeInterval(counter)) : "00:00:00"
                
                // cell.totalTimeLbl.text = totalTime
                
                //                cell.brakTimeStackVw.isHidden = true
                //
                //                cell.vwBreak.isHidden = true
                //                if timelogData?.status == WorkType.Draft.rawValue {
                //                    cell.vwBreak.isHidden = false
                //                    if self.timer.isValid {
                //                        cell.lblTakeBreak.text = "Take Break"
                //                        cell.lblStartEnd.text = "Finish Now"
                //                    }
                //                    else {
                //                        if takeBreak {
                //                            cell.lblTakeBreak.text = "Finish Break"
                //                        }  else {
                //                            cell.lblStartEnd.text = "Start Now"
                //                        }
                //                    }
                //                }
                
                if comingFrom != "workHourDetail" {
                    cell.btnDate.addTarget(self, action: #selector(openDatePicker(sender:)), for: .touchUpInside)
                    cell.btnTask.addTarget(self, action: #selector(openTask(sender:)), for: .touchUpInside)
                    cell.btnStartEnd.addTarget(self, action: #selector(startEnd(sender:)), for: .touchUpInside)
                    cell.btnBreak.addTarget(self, action: #selector(btnBreak(sender:)), for: .touchUpInside)
//                    cell.btnOpenMap.addTarget(self, action: #selector(openMap(sender:)), for: .touchUpInside)
                }
                
                if (timelogData != nil && timelogData?.status != "approved") {
                    cell.btnStartTime.addTarget(self, action: #selector(startTime(sender:)), for: .touchUpInside)
                    cell.btnEndTime.addTarget(self, action: #selector(endTime(sender:)), for: .touchUpInside)
                    cell.btnBreakTime.addTarget(self, action: #selector(breakTime(sender:)), for: .touchUpInside)
                }
                
                if ((timelogData?.gps_data?.start?.locationString) != nil) {
                    cell.btnOpenMap.addTarget(self, action: #selector(openMap(sender:)), for: .touchUpInside)
                }
                // cell.vwStartTime.isHidden = true
                
                if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.hideBreakButton ?? false {
                    cell.breakVw.isHidden = true
                } else {
                    cell.breakVw.isHidden = false
                }
                
                return cell
            }
            else if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.OverTimes.rawValue, for: indexPath) as? OverTimes else { return UITableViewCell() }
                
//                cell.arrOvertimeTypes = timelogData?.data?.overtimes
                cell.arrOvertimeTypes = timelogData?.data?.overtime_array

//                cell.defaultArray = defaultOvertimeArray
                
                cell.clvOverTime.reloadData()
                
                cell.delegate = self
                
                return cell
            }
            
            else if indexPath.section == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.RegiterMilesTVC.rawValue, for: indexPath) as? RegiterMilesTVC else { return UITableViewCell() }
                
                cell.lblDistance.text = "\(workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distance)"
                cell.lblFrom.text = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distanceFrom
                cell.lblTo.text = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distanceTo
                return cell
            }
            
            else if indexPath.section == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.PassengerTVC.rawValue, for: indexPath) as? PassengerTVC else { return UITableViewCell() }
                
                cell.delegate = self
                cell.arrPassangers = workHourModel.passengerData  //timelogData?.data?.passangers ?? []
                cell.clvPassanger.reloadData()
                
                return cell
            }
            
            else if indexPath.section == 4 {
                if workHourModel.workingHourdata[indexPath.row].workHourType == "expenseData"  {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.OtherExpenseTVC.rawValue, for: indexPath) as? OtherExpenseTVC else { return UITableViewCell() }
                    
//                    if (workHourModel.expenseTypesData == 0) {
//                        cell.otherExpenseLblHeight.constant = 17.00
//                    }
//                    else {
//                        cell.otherExpenseLblHeight.constant = 0.00
//                    }
                    
                    cell.expenseTypeLbl.text = workHourModel.workingHourdata[indexPath.row].expenseType
//                    cell.costExpenseLbl.text = "$\(workHourModel.workingHourdata[indexPath.row].expenseCost)"
                    cell.costExpenseLbl.text = "$\(workHourModel.workingHourdata[indexPath.row].expenseCost)"
                    cell.commentLbl.text = workHourModel.workingHourdata[indexPath.row].expenseComment
                    
                    if workHourModel.workingHourdata[indexPath.row].expenseAllPDF.count != 0 {
                        cell.docCollectionVwHeight.constant = 84.0
                    } else {
                        cell.docCollectionVwHeight.constant = 0.0
                    }
                    
                    let attachIDs = workHourModel.workingHourdata[indexPath.row].expenseAllPDF.components(separatedBy: ",")
                    cell.expensePDFData = attachIDs
                    cell.docExpenseCollectionVw.reloadData()
                    return cell
                }
                else if workHourModel.workingHourdata[indexPath.row].workHourType == "extraWork" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ExtraWorkTVC.rawValue, for: indexPath) as? ExtraWorkTVC else { return UITableViewCell() }
                    cell.titleExtraHoursLbl.text = workHourModel.workingHourdata[indexPath.row].expenseType
                    cell.extraHoursLbl.text = "$\(workHourModel.workingHourdata[indexPath.row].expenseCost)"
                    cell.extraWorkCommentLbl.text = workHourModel.workingHourdata[indexPath.row].expenseComment
                    
                    if workHourModel.workingHourdata[indexPath.row].expenseAllPDF.count != 0 {
                        cell.extraWorkCVCHeight.constant = 84.0
                    } else {
                        cell.extraWorkCVCHeight.constant = 0.0
                    }
                    let attachIDs = workHourModel.workingHourdata[indexPath.row].expenseAllPDF.components(separatedBy: ",")

                    cell.extraWorkPDFData = attachIDs
                    cell.extraWorkDocCollectionVw.reloadData()
                    return cell
                }
            }
            
            else if indexPath.section == 5 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AddOnWorkTVC.rawValue, for: indexPath) as? AddOnWorkTVC else { return UITableViewCell() }
                cell.extraWorkBtn.tag = indexPath.row
                cell.extraWorkBtn.addTarget(self, action: #selector(self.clickToOpenExtraWork), for: .touchUpInside)
                
                cell.otherExpensesBtn.tag = indexPath.row
                cell.otherExpensesBtn.addTarget(self, action: #selector(self.clickToOpenOtherExpense), for: .touchUpInside)
                
                cell.extraPassengerBtn.tag = indexPath.row
                cell.extraPassengerBtn.addTarget(self, action: #selector(self.clickToOpenExtraPassengers), for: .touchUpInside)
                
                cell.registerkilometerBtn.tag = indexPath.row
                cell.registerkilometerBtn.addTarget(self, action: #selector(self.clickToRegisterKilometer), for: .touchUpInside)
                return cell
            }
            else  {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.UploadOtherDocWorkTVC.rawValue, for: indexPath) as? UploadOtherDocWorkTVC else { return UITableViewCell() }
                cell.delegate = self
                
                cell.btnSignature.addTarget(self, action: #selector(self.clickToSignature), for: .touchUpInside)
                cell.btnChangeSignature.addTarget(self, action: #selector(self.clickToChangeSignature), for: .touchUpInside)
                if signatureImg != nil {
                    
                    cell.imgAddSignature.isHidden = true
                    cell.imgSignature.isHidden = true
                    cell.imgSetSignature.isHidden = false
                    //            cell.imgSignature.image = self.signatureImg
                    cell.imgSetSignature.image = self.signatureImg
                    cell.changeSignatureVw.isHidden = false
                }
                
                cell.btnBrowseToUpload.addTarget(self, action: #selector(self.clickToImageUpload), for: .touchUpInside)
                
                //        if selectedImage != nil {
                //
                //            cell.imgUploadIcon.isHidden = true
                //            cell.imgUpload.image = self.selectedImage
                //
                //        }
                if (self.arrAttachmentsData.count ?? 0 > 0) {
                    cell.uploadDocumentsVw.isHidden = false
                }
                else {
                    cell.uploadDocumentsVw.isHidden = true
                }
                cell.setUI(arrDocumentsData: self.arrAttachmentsData )
//                cell.totalWOrkingHours.text = totalWorkingHour
//                let totalNomalHours = ((self.timelogData?.total_hours_normal ?? 0) - (self.timelogData?.total_hours_overtime ?? 0))
//                let totalNomalHours = (self.timelogData?.total_hours_normal ?? 0)
                let totalNomalHours = (self.totalTime ) - (self.timelogData?.total_hours_overtime ?? 0)
                let workHours = Helper.minutesToHoursAndMinutes(totalNomalHours)
                cell.totalWOrkingHours.text = "\(workHours.hours):\(workHours.leftMinutes)"

//                cell.overtimeHours.text = totalOverTime
                let overtimeHours = Helper.minutesToHoursAndMinutes(self.timelogData?.total_hours_overtime ?? 0)
                cell.overtimeHours.text = "\(overtimeHours.hours):\(overtimeHours.leftMinutes)"
                
                cell.descriptionTxtVw.text = timelogData?.description
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("IndexPath is : ", indexPath)
        if indexPath.section == 4 {
            if workHourModel.workingHourdata[indexPath.row].workHourType == "expenseData"  {
                workHourModel.workingHourdata.remove(at: indexPath.row)
//                workHourModel.expenseTypesData.remove(at: indexPath.row)
                addDoctblVw.reloadData()
            } else if workHourModel.workingHourdata[indexPath.row].workHourType == "extraWork" {
                workHourModel.workingHourdata.remove(at: indexPath.row)
//                workHourModel.extraWorkData.remove(at: indexPath.row)
                addDoctblVw.reloadData()
            }
        }
    }
    
    func getExactCurrentTimeInMinutes() -> Int {
        let timeZone = TimeZone(identifier: "GMT")!
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        let currentDate1 = dateFormatter.string(from: currentDateFromGMT)
        print("getCurrentTime: \(currentDate1)")
        
        let currentDateSplit = currentDate1.components(separatedBy: ":")
        let currentHours: String = currentDateSplit[0]
        let currentMinute: String = currentDateSplit[1]
        
       return (Int(currentHours)! + (GlobleVariables.timezoneGMT ?? 0)) * 60 + Int(currentMinute)!
    }
    
    func timerCalling() {
        let date = currentDateFromGMT
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "HH"
        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL)
//        let hoursToMinute = ((Int(dateFormatter.string(from: date)) ?? 0) + 2) * 60
//        let hoursToMinute = base_url == "https://tidogkontroll.no/api/" ? ((Int(dateFormatter.string(from: date)) ?? 0) + 2) * 60 : ((Int(dateFormatter.string(from: date)) ?? 0) - 4) * 60
//        let hoursToMinute = base_url == "https://timeandcontrol.com/api/" ? ((Int(dateFormatter.string(from: date)) ?? 0) - 4) * 60 : ((Int(dateFormatter.string(from: date)) ?? 0) + 2) * 60
        
        let currentTimeInMinutes = getExactCurrentTimeInMinutes()
        
        if timelogData?.anomaly?.start?.is_early ?? false && timelogData?.data?.anomalyTrackerReason?.startReason?.autoAdjust ?? false && currentTimeInMinutes < timelogData?.from ?? 0 {
            isAdjustActualTime = false
            addDoctblVw.reloadSections(IndexSet(integer: 0), with: .none)
        } else {
            isAdjustActualTime = true
            let hoursToMinute = ((Int(dateFormatter.string(from: date)) ?? 0) + (GlobleVariables.timezoneGMT ?? 0)) * 60
            
            dateFormatter.dateFormat = "mm"
            var totalMinutes = (hoursToMinute + (Int(dateFormatter.string(from: date)) ?? 0)) - (timelogData?.from ?? 0) - (timelogData?.break ?? 0)
            
            if totalMinutes < 0 {
                totalMinutes += (24 * 60)
            }
            
            counter = totalMinutes * 60
            if (!isPaused) {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            }
        }
    }
}


//MARK: Extension Api's
extension AddWorkDocumentVC {
    
    private func dashboardApi(){
        SVProgressHUD.show()
        homeModel.dashboard(){ (errorMsg,loginMessage) in
            SVProgressHUD.dismiss()
            print("Schedule is :", self.homeModel.dashboardScheduleData)
            
        }
    }
    
    func hitWorkHoursDetailsApi(id: String) -> Void {
        print(id)
        
        let param = [String:Any]()
        WorkHourVM.shared.workHourDetailsApi(parameters: param, id: id, isAuthorization: true) { [self] obj,responseData  in
            
            print(obj.message ?? "")
            
            self.workDetailModel.append(obj)
            
            self.timelogData = obj.timelog
            
            if timelogData?.status == "approved" {
                saveBtnObj.isHidden = true
            } else if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" && GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs == "gpsmanual" && self.timelogData?.status != "draft" {
                saveBtnObj.isHidden = true
            } else {
                saveBtnObj.isHidden = false
            }
            
            if comingFrom != "workHourDetail" {
                if (self.timelogData?.data?.overtime_array == nil) {
                    self.timelogData = Timelog(id: self.timelogData?.id ?? 0, status: self.timelogData?.status ?? "", user_id: self.timelogData?.user_id ?? 0, for_date: self.timelogData?.for_date ?? "", from: self.timelogData?.from ?? 0, to: self.timelogData?.to ?? 0, break: self.timelogData?.break ?? 0, total_hours_overtime: self.timelogData?.total_hours_overtime ?? 0, total_hours_normal: self.timelogData?.total_hours_normal ?? 0, comments: self.timelogData?.comments ?? "", description: self.timelogData?.description ?? "", data: Datas(workplace: self.timelogData?.data?.workplace ?? "", address: self.timelogData?.data?.address ?? "", passangers: self.timelogData?.data?.passangers ?? [], expenses: self.timelogData?.data?.expenses ?? [], extraWork: self.timelogData?.data?.extraWork ?? [], attachments: self.timelogData?.data?.attachments ?? "", distance: self.timelogData?.data?.distance ?? 0.0, signature: self.timelogData?.data?.signature ?? "", overtimes: OvertimesData(fifty: Fifty(code: "50", multiplier: 0, name: "50", value: "00:00"), hundred: Hundred(code: "100", multiplier: 0, name: "100", value: "00:00"), other: Other(code: "Other", multiplier: 0, name: "Other", value: "00:00")), overtime_array: GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtime_types ?? [], shiftId: timelogData?.data?.shiftId ?? 0, anomalyTrackerReason: AnomalyTrackerReasonData(startReason: StartReasonData(reason: "", autoAdjust: false, sendNotification: false, value: "", code: "", actualTime: 0))), gps_data: Gps_data(task: self.timelogData?.gps_data?.task ?? "", end: EndData(coords: Coords(altitude: self.timelogData?.gps_data?.end?.coords?.altitude ?? 0, altitudeAccuracy: self.timelogData?.gps_data?.end?.coords?.altitudeAccuracy ?? 0, latitude: self.timelogData?.gps_data?.end?.coords?.latitude ?? 0.0, accuracy: self.timelogData?.gps_data?.end?.coords?.accuracy ?? 0, longitude: self.timelogData?.gps_data?.end?.coords?.longitude ?? 0.0, heading: self.timelogData?.gps_data?.end?.coords?.heading ?? 0.0, speed: self.timelogData?.gps_data?.end?.coords?.speed ?? 0.0), timestamp: self.timelogData?.gps_data?.end?.timestamp ?? 0.0, locationString: self.timelogData?.gps_data?.end?.locationString ?? "", decision: self.timelogData?.gps_data?.end?.decision ?? "", is_ok: self.timelogData?.gps_data?.end?.is_ok ?? true), start: StartData(coords: Coords(altitude: self.timelogData?.gps_data?.start?.coords?.altitude ?? 0, altitudeAccuracy: self.timelogData?.gps_data?.start?.coords?.altitudeAccuracy ?? 0, latitude: self.timelogData?.gps_data?.start?.coords?.latitude ?? 0.0, accuracy: self.timelogData?.gps_data?.start?.coords?.accuracy ?? 0, longitude: self.timelogData?.gps_data?.start?.coords?.longitude ?? 0.0, heading: self.timelogData?.gps_data?.start?.coords?.heading ?? 0.0, speed: self.timelogData?.gps_data?.start?.coords?.speed ?? 0.0), timestamp: self.timelogData?.gps_data?.start?.timestamp ?? 0.0, locationString: self.timelogData?.gps_data?.start?.locationString ?? "", decision: self.timelogData?.gps_data?.start?.decision ?? "", is_ok: self.timelogData?.gps_data?.start?.is_ok ?? true)), tracker_status: self.timelogData?.tracker_status ?? "", location_string: self.timelogData?.location_string ?? "", client_id: self.timelogData?.client_id ?? 0, user: User(first_name: "", last_name: "", social_number: ""), gps: Gps(task: self.timelogData?.gps?.task ?? "", start_diff: self.timelogData?.gps?.start_diff ?? "", end_diff: self.timelogData?.gps?.end_diff ?? ""), Attachments: self.timelogData?.Attachments ?? [], createdAt: self.timelogData?.createdAt ?? "", anomaly: AnomalyWorkhourData(start: StartAnomalyWorkHour(is_early: self.timelogData?.anomaly?.start?.is_early ?? false, is_offsite: self.timelogData?.anomaly?.start?.is_offsite ?? false,is_late: self.timelogData?.anomaly?.start?.is_late ?? false, comment: self.timelogData?.anomaly?.start?.comment ?? ""), end: EndAnomalyWorkHour(is_early: self.timelogData?.anomaly?.end?.is_early ?? false, is_offsite: self.timelogData?.anomaly?.end?.is_offsite ?? false,is_late: self.timelogData?.anomaly?.end?.is_late ?? false, comment: self.timelogData?.anomaly?.end?.comment ?? "")))
                }
            } else {
                let tempOvertimeArray = self.timelogData?.data?.overtime_array
                self.timelogData?.data?.overtime_array = GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtime_types
                for indexData in 0..<(self.timelogData?.data?.overtime_array?.count ?? 0) {
                    for tempIndexData in 0..<(tempOvertimeArray?.count ?? 0) {
                        if tempOvertimeArray?[tempIndexData].code == self.timelogData?.data?.overtime_array?[indexData].code {
                            self.timelogData?.data?.overtime_array?[indexData].value = tempOvertimeArray?[tempIndexData].value
                        }
                    }
                }
            }
                        
            self.finalDate = obj.timelog?.for_date?.convertforDate() ?? ""
            
            let corrdinates = obj.timelog?.gps_data?.task
            let fullNameArr = corrdinates?.components(separatedBy: ",")
            
            self.lat = fullNameArr?.first ?? ""
            self.long = fullNameArr?.last ?? ""
            
            self.startTime = timelogData?.from ?? 0
            
            self.endTime = timelogData?.to ?? 0
            
            self.breakTime = timelogData?.break ?? 0
            
//            self.totalTime = self.endTime - self.startTime - self.breakTime
//            self.totalTime = timelogData?.total_hours_normal ?? 0
            self.totalTime = (timelogData?.total_hours_normal ?? 0) + (timelogData?.total_hours_overtime ?? 0)
            
//            self.attechmentsData = self.timelogData?.Attachments as! [[String : Any]]
            
            for i in 0..<(self.timelogData?.Attachments?.count ?? 0) {
                var attachmentsDetails = [String:Any]()
                attachmentsDetails["id"] = self.timelogData?.Attachments?[i].id
                attachmentsDetails["filename"] = self.timelogData?.Attachments?[i].filename
                attachmentsDetails["filetype"] = self.timelogData?.Attachments?[i].filetype
                attachmentsDetails["user_id"] = self.timelogData?.Attachments?[i].user_id
//                attachmentsDetails["location"] = self.attechmentsData?[i].location
                attachmentsDetails["to_model"] = self.timelogData?.Attachments?[i].to_model
                attachmentsDetails["to_id"] = self.timelogData?.Attachments?[i].to_id
//                attachmentsDetails["created_at"] = self.attechmentsData?[i].created_at
//                attachmentsDetails["updated_at"] = self.attechmentsData?[i].updated_at
                arrAttachmentsData.append(attachmentsDetails)
            }
            
//            for i in 0..<(attechmentsData.count ?? 0) {
//                self.uploadAttachmentsArrayData.append(String(attechmentsData?[i].id ?? 0))
//            }
            
           // let totalWorkingHours = Helper.minutesToHoursAndMinutes(timelogData?.total_hours_normal ?? 0)
            
          //  totalWorkingHour = "\(totalWorkingHours.hours):\(totalWorkingHours.leftMinutes)"
            
         //   let totalOvertimes = Helper.minutesToHoursAndMinutes(timelogData?.total_hours_overtime ?? 0)
            
            hmsFrom(seconds: Int((timelogData?.total_hours_overtime ?? 0)*60)) { hour, minute, second in
                let hour = getStringFrom(seconds: hour)
                let minute = getStringFrom(seconds: minute)
                let second = getStringFrom(seconds: second)
                totalOverTime = "\(hour):\(minute)"
            }
          //  totalOverTime = "\(totalOvertimes.hours):\(totalOvertimes.leftMinutes)"
            
            if timelogData?.status == WorkType.Draft.rawValue {
                
                //                if let timestamp = timelogData?.from {
                if (timelogData?.tracker_status == "break") {
                    isPaused = true
                    timerCalling()
                }
                else {
                    isPaused = false
                    timerCalling()
                }
//                timerCalling()
                //                    let time = Date(timeIntervalSince1970: TimeInterval(startTime))
                //                    print(time)
                //                    let seconds = Date().seconds(from: time)
                //                    print(seconds)
                //                    counter = seconds
                //
                //                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                //                }
            }
            
            if (((obj.timelog?.data?.distance) != nil) && ((timelogData?.data?.workplace) != nil) && ((timelogData?.data?.address) != nil)) {
                workHourModel.registerMilesData.append(RegisterMiles.init(distance: timelogData?.data?.distance ?? 0.0 , distanceFrom: timelogData?.data?.workplace ?? "", distanceTo: timelogData?.data?.address ?? ""))
                
                workHourModel.workHourData.append(allWorkHourData.init(workHourType: "registerMiles", passengerName: [], registerMiles: workHourModel.registerMilesData, expenseTypes: [], extraWork: []))
            }
            
            for indexs in 0..<(obj.timelog?.data?.passangers?.count ?? 0) {
                workHourModel.passengerData.append(Passenger.init(passengerName: obj.timelog?.data?.passangers?[indexs] ?? ""))
                if workHourModel.passengerData.count == 1 {
                    passengerDataIndex = 1
                   // workHourModel.workHourData.append(allWorkHourData.init(workHourType: "Passenger", passengerName: workHourModel.passengerData, registerMiles: [], expenseTypes: [], extraWork: []))
                    workHourModel.workHourData.insert(allWorkHourData.init(workHourType: "Passenger", passengerName: workHourModel.passengerData, registerMiles: [], expenseTypes: [], extraWork: []), at: 0)
                   // workHourModel.workHourData.insert(contentsOf: allWorkHourData.init(workHourType: "Passenger", passengerName: workHourModel.passengerData, registerMiles: [], expenseTypes: [], extraWork: []), at: 0)
                }
            }
             
            for indexs in 0..<(obj.timelog?.data?.expenses?.count ?? 0){
                workHourModel.otherExpensePDFData.removeAll()
                let attachIDs = obj.timelog?.data?.expenses?[indexs].attachIds?.components(separatedBy: ",") ?? []
                // DispatchQueue.main.async {
//                for i in 0..<attachIDs.count {
//                    if arrExpenseDataAttachments == "" {
//                        arrExpenseDataAttachments = attachIDs[i]
//                    }
//                    else {
//                        arrExpenseDataAttachments = arrExpenseDataAttachments + "," + attachIDs[i]
//                    }
//                    if let urls =  URL(string: "https://tidogkontroll.no/api/attachments/\(attachIDs[i])") {
//                        // DispatchQueue.global().async {
//                        let fileData = try? Data.init(contentsOf: urls)
//                        let fileStream:String = fileData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) ?? ""
//
//                        workHourModel.otherExpensePDFData.append(expensePDF.init(expensePDF: urls, expenseBase64: fileStream))
//
//                        //  }
//                    }
//
//                    //   }
//                }
                
//                workHourModel.expenseTypesData.append(ExpenseTypes.init(workHourType: "expenseData", expenseType: obj.timelog?.data?.expenses?[indexs].type ?? "", expenseCost: obj.timelog?.data?.expenses?[indexs].value ?? "", expenseComment: obj.timelog?.data?.expenses?[indexs].comment ?? "", expenseAllPDF: workHourModel.otherExpensePDFData))
                
                workHourModel.expenseTypesData.append(ExpenseTypes.init(workHourType: "expenseData", expenseType: obj.timelog?.data?.expenses?[indexs].type ?? "", expenseCost: obj.timelog?.data?.expenses?[indexs].value ?? "", expenseComment: obj.timelog?.data?.expenses?[indexs].comment ?? "", expenseAllPDF: obj.timelog?.data?.expenses?[indexs].attachIds ?? ""))

                
                // Your code here
                // print(obj.timelog?.data?.expenses?[indexs].attachIds?.components(separatedBy: ","))
                //  workHourModel.expenseTypesData.append(workHourModel.extraWorkPDFData)
            }

            for i in 0..<workHourModel.expenseTypesData.count {
                workHourModel.workingHourdata.append(ExpenseTypes.init(workHourType: "expenseData", expenseType: workHourModel.expenseTypesData[i].expenseType, expenseCost: workHourModel.expenseTypesData[i].expenseCost, expenseComment: workHourModel.expenseTypesData[i].expenseComment, expenseAllPDF: workHourModel.expenseTypesData[i].expenseAllPDF))
            }
            
            for indexs in 0..<(obj.timelog?.data?.extraWork?.count ?? 0){
                workHourModel.extraWorkPDFData.removeAll()
                
                let attachIDs = obj.timelog?.data?.extraWork?[indexs].attachIds?.components(separatedBy: ",") ?? []
                
//                for i in 0..<attachIDs.count {
//                    if arrExtraDataAttachments == "" {
//                        arrExtraDataAttachments = attachIDs[i]
//                    }
//                    else {
//                        arrExtraDataAttachments = arrExtraDataAttachments + "," + attachIDs[i]
//                    }
//                    if let urls =  URL(string: "https://tidogkontroll.no/api/attachments/\(attachIDs[i])") {
//                        // DispatchQueue.global().async {
//                        let fileData = try? Data.init(contentsOf: urls)
//                        let fileStream:String = fileData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)) ?? ""
//
//                        workHourModel.extraWorkPDFData.append(expensePDF.init(expensePDF: urls, expenseBase64: fileStream))
//
//                        // }
//                    }
//                }
                
//                workHourModel.extraWorkData.append(ExtraWork.init(workHourType: "extraWork", extraWork: obj.timelog?.data?.extraWork?[indexs].type ?? "", extraHours: obj.timelog?.data?.extraWork?[indexs].value ?? "", extraWorkComment: obj.timelog?.data?.extraWork?[indexs].comment ?? "", extraWorkAllPDF: workHourModel.extraWorkPDFData))
                
                workHourModel.extraWorkData.append(ExtraWork.init(workHourType: "extraWork", extraWork: obj.timelog?.data?.extraWork?[indexs].type ?? "", extraHours: obj.timelog?.data?.extraWork?[indexs].value ?? "", extraWorkComment: obj.timelog?.data?.extraWork?[indexs].comment ?? "", extraWorkAllPDF: obj.timelog?.data?.extraWork?[indexs].attachIds ?? ""))
                
                //                print(obj.timelog?.data?.expenses?[indexs].attachIds?.components(separatedBy: ","))
                //  workHourModel.expenseTypesData.append(workHourModel.extraWorkPDFData)
                
            }

            for i in 0..<workHourModel.extraWorkData.count {
                workHourModel.workingHourdata.append(ExpenseTypes.init(workHourType: "extraWork", expenseType: workHourModel.extraWorkData[i].extraWork, expenseCost: workHourModel.extraWorkData[i].extraHours, expenseComment: workHourModel.extraWorkData[i].extraWorkComment, expenseAllPDF: workHourModel.extraWorkData[i].extraWorkAllPDF))
            }
            
            
            
//            for indexs in 0..<(obj.timelog?.data?.expenses?.count ?? 0){
//                workHourModel.expenseTypesData.append(<#T##newElement: ExpenseTypes##ExpenseTypes#>)
//            }
//
//
//            for i in 0..<workHourModel.expenseTypesData.count {
//                workHourModel.workingHourdata.append(ExpenseTypes.init(workHourType: "expenseData", expenseType: workHourModel.expenseTypesData[i].workHourType, expenseCost: workHourModel.expenseTypesData[i].expenseCost, expenseComment: workHourModel.expenseTypesData[i].expenseComment, expenseAllPDF: workHourModel.expenseTypesData[i].expenseAllPDF))
//            }
            
            if (obj.timelog?.data?.signature != nil || obj.timelog?.data?.signature != "") {
                let url = URL(string: obj.timelog?.data?.signature ?? "")
                
                guard let url = URL(string: obj.timelog?.data?.signature ?? "") else {
                    addDoctblVw.reloadData()
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    if let imageData = try? Data(contentsOf: url) {
                        if let loadedImage = UIImage(data: imageData) {
                            self?.signatureImg = loadedImage
                        }
                    }
                }
//                let data = try? Data(contentsOf: url!)
//                if let imageData = data {
//                    let image = UIImage(data: imageData)
//                    signatureImg = image
//                }
            }
            
            addDoctblVw.reloadData()
        }
    }
    
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {

            completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)

    }

    func getStringFrom(seconds: Int) -> String {

        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    func hitTaskNameApi(taskId: String) -> Void {
        print(id)
        var param = [String:Any]()
        WorkHourVM.shared.workGetTaskApi(parameters: param, id: taskId, isAuthorization: true) { [self] obj in
            
            print(obj.message)
            
            //  self.taskName = obj.task?.name ?? ""
            
            self.taskDetails = obj.task
            
            addDoctblVw.reloadData()
        }
    }
    
    func saveManualyWorkHourApi() {
        var param = [String:Any]()
        
        param["task_id"] = taskId
//        param["workplace"] = timelogData?.data?.workplace ?? ""
        param["from"] = startTime
        param["to"] =  endTime
        param["break"] = breakTime
//        param["total_hours_normal"] = self.endTime - self.startTime - self.breakTime //timelogData?.total_hours_normal
//        param["total_hours_normal"] = self.totalTime
        param["total_hours_normal"] = self.totalTime - (self.timelogData?.total_hours_overtime ?? 0)

        param["total_hours_overtime"] = timelogData?.total_hours_overtime
        param["for_date"] = finalDate //"2022-08-10" 21-11-2022
        
        var data = [String:Any]()
        if (workHourModel.registerMilesData.count != 0) {
            data["workplace"] = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distanceFrom
            data["address"] = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distanceTo
            data["distance"] = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distance
            param["distance"] = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distance
        }
        //        data["emergencyClose"] = true

        var overtimes = [String:Any]()
                
        var fifty = [String:Any]()
        fifty["code"] = timelogData?.data?.overtimes?.fifty?.code
        fifty["multiplier"] = timelogData?.data?.overtimes?.fifty?.multiplier
        fifty["name"]  = timelogData?.data?.overtimes?.fifty?.name
        fifty["value"] = timelogData?.data?.overtimes?.fifty?.value
        overtimes["50"] = fifty
        
        var hundreds = [String:Any]()
        hundreds["code"] = timelogData?.data?.overtimes?.hundred?.code
        hundreds["multiplier"] = timelogData?.data?.overtimes?.hundred?.multiplier
        hundreds["name"]  = timelogData?.data?.overtimes?.hundred?.name
        hundreds["value"] = timelogData?.data?.overtimes?.hundred?.value
        overtimes["100"] = hundreds
        
        var others = [String:Any]()
        others["code"] = timelogData?.data?.overtimes?.other?.code
        others["multiplier"] = timelogData?.data?.overtimes?.other?.multiplier
        others["name"]  = timelogData?.data?.overtimes?.other?.name
        others["value"] = timelogData?.data?.overtimes?.other?.value
        overtimes["other"] = others
        
//        data["overtimes"] = overtimes
        
//        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false) || (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
//            // message
////            Toast.show(message: "Overtime is being calculated Automatic or Weekly", controller: UIViewController())
//        } else {
//            if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
//                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
//                    data["overtime_array"] = overtimesData
//                } else {
//                    // Message
////                    Toast.show(message: "PM cannot manage overtime", controller: UIViewController())
//                }
//            } else {
//                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
//                    // message
////                    Toast.show(message: "Only PM can manage overtime", controller: UIViewController())
//                } else {
//                    data["overtime_array"] = overtimesData
//                }
//            }
//        }
        
        var overtimesData = [[String:Any]]()

        for overtimeIndex in 0..<(self.timelogData?.data?.overtime_array?.count ?? 0) {
            var overtimeDetails = [String:Any]()
            if timelogData?.data?.overtime_array?[overtimeIndex].value == "00:00" ||  timelogData?.data?.overtime_array?[overtimeIndex].value == "0:00" || timelogData?.data?.overtime_array?[overtimeIndex].value == nil {
                print("Nort added")
                
            } else {
                overtimeDetails["code"] = timelogData?.data?.overtime_array?[overtimeIndex].code
                overtimeDetails["multiplier"] = timelogData?.data?.overtime_array?[overtimeIndex].multiplier
                overtimeDetails["name"] = timelogData?.data?.overtime_array?[overtimeIndex].name
                overtimeDetails["value"] = timelogData?.data?.overtime_array?[overtimeIndex].value
                overtimesData.append(overtimeDetails)
            }
        }
        data["overtime_array"] = overtimesData
        
        if signatureImg != nil {
            data["signature"]  = "data:image/png;base64," + (convertImageToBase64String(img: self.signatureImg ?? UIImage()) ?? "")
        }
        
        var expenses = [[String:Any]]()
        var extraWork = [[String:Any]]()

        for indexs in 0..<(workHourModel.workingHourdata.count){
            
            print("workHourModel.workingHourdata", workHourModel.workingHourdata)
            
            if workHourModel.workingHourdata[indexs].workHourType == "expenseData"  {
                var expensesDetails = [String:Any]()
                expensesDetails["type"] = workHourModel.workingHourdata[indexs].expenseType
//                expensesDetails["value"] = "$\(workHourModel.workingHourdata[indexs].expenseCost)"
                expensesDetails["value"] = workHourModel.workingHourdata[indexs].expenseCost
                expensesDetails["comment"] = workHourModel.workingHourdata[indexs].expenseComment
                if (arrExpenseDataAttachments != "") {
                    expensesDetails["attachIds"] = arrExpenseDataAttachments
                }
                expenses.append(expensesDetails)
            }
            else if workHourModel.workingHourdata[indexs].workHourType == "extraWork"  {
                var extraDetails = [String:Any]()
                extraDetails["type"] = workHourModel.workingHourdata[indexs].expenseType
//                extraDetails["value"] = "$\(workHourModel.workingHourdata[indexs].expenseCost)"
                extraDetails["value"] = workHourModel.workingHourdata[indexs].expenseCost
                extraDetails["comment"] = workHourModel.workingHourdata[indexs].expenseComment
                if (arrExtraDataAttachments != "") {
                    extraDetails["attachIds"] = arrExtraDataAttachments
                }
                extraWork.append(extraDetails)
            }
        }
        data["expenses"] = expenses
        data["extraWork"] = extraWork

        var passengers = [String] ()
        for indexs in 0..<(workHourModel.passengerData.count){
            passengers.append(workHourModel.passengerData[indexs].passengerName)
        }
        
        data["passangers"] = passengers

        param["data"] =  data
        
        
//        if selectedImage != nil {
//            param["signature"]  = convertImageToBase64String(img: self.signatureImg ?? UIImage())
//        }
    
//        param["Attachments"] = uploadAttachmentsArrayData
        param["Attachments"] = arrAttachmentsData
//        param["id"] = self.timelogData?.id
        param["status"] = "active"
        param["user_id"] = self.timelogData?.user_id
        param["description"] = timelogData?.description
        
//        var gpsdata = [String:Any]()
//        gpsdata["task"] = "\(lat),\(long)"
//        gpsdata["end"] = ["cron": true]
//        param["gps_data"] = gpsdata
//        var cron = [String: Any]()
//        gpsdata["end"] = cron
//        cron["cron"] =  true
        
        param["tracker_running"] = false
        param["tracker_status"] = "manual"
//        param["client_id"] = self.timelogData?.client_id

        //        var User = [String:Any]()
        //        //   param["User"] = User
        //        User["first_name"] = "Client2"
        //        User["last_name"] = "Member"
        //        User["social_number"] = ""
//        param["User"] = self.timelogData?.user
//        param["breakMinutes"] = 0
        param["total_hours_overall"] = (self.timelogData?.total_hours_normal ?? 0) + (self.timelogData?.total_hours_overtime ?? 0)
        
//        param["total_weekly_hours_in_mins"] = 0
//        param["weekStartDate"] = "2022-08-06T00:00:00.000Z"
//        param["weekEndDate"] = "2022-08-12T00:00:00.000Z"
        //   param["is_holiday"] = "null"
        //    param["comments"] = "null"
        //  param["status_note"] = "null"
        //   param["status_changed_by"] =  "null"
        //    param["status_changed_on"] =  "null"
        //   param["tip_id"] =  "null"
        
        
        
        //  param["gps_status"] =  "null"
        // param["gps_start_data"] = "null"
        //  param["gps_end_data"] =  "null"
        //   param["paid_hours"] = "null"
        //   param["location_string"] = "null"
        //   param["user_image_attachment_id"] = "null"
//        param["createdAt"] = "2022-08-10T12:04:23.832Z"
//        param["updatedAt"] = "2022-08-11T00:00:02.473Z"
        
        
//        var Gps = [String:Any]()
//        //  param["Gps"] = Gps
//        Gps["task"] =  "22.9949088,72.60880259999999"
//        Gps["start_diff"] = ""
//        Gps["end_diff"] =  ""
        
        //   param["intermediateSave"] = "false"
        
        
        var startGps = [String:Any]()

        var coords = [String:Any]()
        let timestamp = currentDateFromGMT.timeIntervalSince1970
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:self.currentCorrdinate.latitude, longitude: self.currentCorrdinate.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                coords["latitude"] = self.currentCorrdinate.latitude
                coords["longitude"] = self.currentCorrdinate.longitude

                startGps["coords"] = coords
                startGps["timestamp"] = timestamp
                startGps["locationString"] = addressString
                                    
                param["startGps"] = startGps
                param["endGps"] = startGps

                print("self.currentCorrdinate.latitude is : ", self.currentCorrdinate.latitude)
                print("self.currentCorrdinate.longitude is : ", self.currentCorrdinate.longitude)

                print("Param data is : ", param)

                WorkHourVM.shared.addWorkHoursManualyApi(parameters: param, isAuthorization: true) { [self] obj in

                    print(obj.message)
                    UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.checkWorkHoursDetails)
                    delegate?.checkWorkHoursSegmentIndex(segmentIndex: selectedWorkHoursSegmmentIndex)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
//        WorkHourVM.shared.addWorkHoursManualyApi(parameters: param, isAuthorization: true) { [self] obj in
//
//            print(obj.message)
//            self.navigationController?.popViewController(animated: true)
//
//        }
    }
    
    func convertUserToDictionary(user: User?) -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["first_name"] = user?.first_name ?? ""
        dictionary["last_name"] = user?.last_name ?? ""
        dictionary["social_number"] = user?.social_number ?? ""
        return dictionary
    }
    
    func saveTaskApi(id: String) {
        var param = [String:Any]()
        
        var start = [String:Any]()
        var end = [String:Any]()
        var anamoly = [String:Any]()

        param["task_id"] = taskId
        param["workplace"] = timelogData?.data?.workplace ?? ""
        param["from"] = startTime
        param["to"] =  endTime
        param["break"] = breakTime
//        param["total_hours_normal"] = self.endTime - self.startTime - self.breakTime  // timelogData?.total_hours_normal
//        param["total_hours_normal"] = self.totalTime
        param["total_hours_normal"] = self.totalTime - (self.timelogData?.total_hours_overtime ?? 0)
        param["total_hours_overtime"] = timelogData?.total_hours_overtime
        param["for_date"] = finalDate //"2022-08-10" 21-11-2022
        
        var data = [String:Any]()
        if (workHourModel.registerMilesData.count != 0) {
            data["workplace"] = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distanceFrom
            data["address"] = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distanceTo
            data["distance"] = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distance
            param["distance"] = workHourModel.registerMilesData[workHourModel.registerMilesData.count - 1].distance
        }
        //        data["emergencyClose"] = true

        var overtimes = [String:Any]()
                
        var fifty = [String:Any]()
        fifty["code"] = timelogData?.data?.overtimes?.fifty?.code
        fifty["multiplier"] = timelogData?.data?.overtimes?.fifty?.multiplier
        fifty["name"]  = timelogData?.data?.overtimes?.fifty?.name
        fifty["value"] = timelogData?.data?.overtimes?.fifty?.value
        overtimes["50"] = fifty
        
        var hundreds = [String:Any]()
        hundreds["code"] = timelogData?.data?.overtimes?.hundred?.code
        hundreds["multiplier"] = timelogData?.data?.overtimes?.hundred?.multiplier
        hundreds["name"]  = timelogData?.data?.overtimes?.hundred?.name
        hundreds["value"] = timelogData?.data?.overtimes?.hundred?.value
        overtimes["100"] = hundreds
        
        var others = [String:Any]()
        others["code"] = timelogData?.data?.overtimes?.other?.code
        others["multiplier"] = timelogData?.data?.overtimes?.other?.multiplier
        others["name"]  = timelogData?.data?.overtimes?.other?.name
        others["value"] = timelogData?.data?.overtimes?.other?.value
        overtimes["other"] = others
        
//        data["overtimes"] = overtimes
        var overtimesData = [[String:Any]]()

        for overtimeIndex in 0..<(self.timelogData?.data?.overtime_array?.count ?? 0) {
            var overtimeDetails = [String:Any]()
            
            if timelogData?.data?.overtime_array?[overtimeIndex].value == "00:00" ||  timelogData?.data?.overtime_array?[overtimeIndex].value == "0:00" || timelogData?.data?.overtime_array?[overtimeIndex].value == nil {
                print("Nort added")
            } else {
                overtimeDetails["code"] = timelogData?.data?.overtime_array?[overtimeIndex].code
                overtimeDetails["multiplier"] = timelogData?.data?.overtime_array?[overtimeIndex].multiplier
                overtimeDetails["name"] = timelogData?.data?.overtime_array?[overtimeIndex].name
                overtimeDetails["value"] = timelogData?.data?.overtime_array?[overtimeIndex].value
                overtimesData.append(overtimeDetails)
            }
        }
        data["overtime_array"] = overtimesData
        
//        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false) || (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
//            // message
////            Toast.show(message: "Overtime is being calculated Automatic or Weekly", controller: UIViewController())
//        } else {
//            if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
//                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
//                    data["overtimes"] = overtimesData
//                } else {
//                    // Message
////                    Toast.show(message: "PM cannot manage overtime", controller: UIViewController())
//                }
//            } else {
//                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
//                    // message
////                    Toast.show(message: "Only PM can manage overtime", controller: UIViewController())
//                } else {
//                    data["overtimes"] = overtimesData
//                }
//            }
//        }
        
        
        if signatureImg != nil {
            data["signature"]  = "data:image/png;base64," + (convertImageToBase64String(img: self.signatureImg ?? UIImage()) ?? "")
        }
        
        var expenses = [[String:Any]]()
        var extraWork = [[String:Any]]()

        for indexs in 0..<(workHourModel.workingHourdata.count){
            
            print("workHourModel.workingHourdata", workHourModel.workingHourdata)
            
            if workHourModel.workingHourdata[indexs].workHourType == "expenseData"  {
                var expensesDetails = [String:Any]()
                expensesDetails["type"] = workHourModel.workingHourdata[indexs].expenseType
//                expensesDetails["value"] = "$\(workHourModel.workingHourdata[indexs].expenseCost)"
                expensesDetails["value"] = workHourModel.workingHourdata[indexs].expenseCost
                expensesDetails["comment"] = workHourModel.workingHourdata[indexs].expenseComment
//                if (arrExpenseDataAttachments != "") {
                if (workHourModel.workingHourdata[indexs].expenseAllPDF != "") {
                    //                    expensesDetails["attachIds"] = arrExpenseDataAttachments
                    expensesDetails["attachIds"] = workHourModel.workingHourdata[indexs].expenseAllPDF
                }
                expenses.append(expensesDetails)
            }
            else if workHourModel.workingHourdata[indexs].workHourType == "extraWork"  {
                var extraDetails = [String:Any]()
                extraDetails["type"] = workHourModel.workingHourdata[indexs].expenseType
//                extraDetails["value"] = "$\(workHourModel.workingHourdata[indexs].expenseCost)"
                extraDetails["value"] = workHourModel.workingHourdata[indexs].expenseCost
                extraDetails["comment"] = workHourModel.workingHourdata[indexs].expenseComment
//                if (arrExtraDataAttachments != "") {
                if (workHourModel.workingHourdata[indexs].expenseAllPDF != "") {
//                    extraDetails["attachIds"] = arrExtraDataAttachments
                    extraDetails["attachIds"] = workHourModel.workingHourdata[indexs].expenseAllPDF
                }
                extraWork.append(extraDetails)
            }
        }
        data["expenses"] = expenses
        data["extraWork"] = extraWork

        var passengers = [String] ()
        for indexs in 0..<(workHourModel.passengerData.count){
            passengers.append(workHourModel.passengerData[indexs].passengerName)
        }
        
        data["passangers"] = passengers

        
        var documentAttachment = ""
        for i in 0..<(self.arrAttachmentsData.count ) {
            if (documentAttachment == ""){
                documentAttachment = "\(self.arrAttachmentsData[i]["id"] ?? "")"
            }
            else {
                documentAttachment = documentAttachment + "," + "\(self.arrAttachmentsData[i]["id"] ?? "")"
            }
        }
        var documentAttachmentData = [String:Any]()
        data["attachments"] = documentAttachment
//        param["data"] = documentAttachmentData

        param["data"] =  data
        
        
//        if selectedImage != nil {
//            param["signature"]  = convertImageToBase64String(img: self.signatureImg ?? UIImage())
//        }
    
        param["Attachments"] = arrAttachmentsData
        param["id"] = self.timelogData?.id
        param["status"] = self.timelogData?.status
        param["user_id"] = self.timelogData?.user_id
        param["description"] = timelogData?.description
        
        var gpsdata = [String:Any]()
        gpsdata["task"] = "\(lat),\(long)"
        gpsdata["end"] = ["cron": true]
        param["gps_data"] = gpsdata
        var cron = [String: Any]()
        gpsdata["end"] = cron
        cron["cron"] =  true
        
        param["tracker_running"] = false
        param["tracker_status"] = self.timelogData?.tracker_status
        param["client_id"] = self.timelogData?.client_id

        //        var User = [String:Any]()
        //        //   param["User"] = User
        //        User["first_name"] = "Client2"
        //        User["last_name"] = "Member"
        //        User["social_number"] = ""
        param["User"] = self.convertUserToDictionary(user: self.timelogData?.user)
        param["breakMinutes"] = 0
        param["total_hours_overall"] = (self.timelogData?.total_hours_normal ?? 0) + (self.timelogData?.total_hours_overtime ?? 0)
        
        start["is_early"] = self.timelogData?.anomaly?.start?.is_early
        start["is_offsite"] = self.timelogData?.anomaly?.start?.is_offsite
        start["comment"] = self.timelogData?.anomaly?.start?.comment

        end["is_early"] = self.timelogData?.anomaly?.end?.is_early
        end["is_offsite"] = self.timelogData?.anomaly?.end?.is_offsite
        end["comment"] = self.timelogData?.anomaly?.end?.comment

        anamoly["start"] = start
        anamoly["end"] = end
        
        param["anomaly"] = anamoly
        
//        param["total_weekly_hours_in_mins"] = 0
//        param["weekStartDate"] = "2022-08-06T00:00:00.000Z"
//        param["weekEndDate"] = "2022-08-12T00:00:00.000Z"
        //   param["is_holiday"] = "null"
        //    param["comments"] = "null"
        //  param["status_note"] = "null"
        //   param["status_changed_by"] =  "null"
        //    param["status_changed_on"] =  "null"
        //   param["tip_id"] =  "null"
        
        
        
        //  param["gps_status"] =  "null"
        // param["gps_start_data"] = "null"
        //  param["gps_end_data"] =  "null"
        //   param["paid_hours"] = "null"
        //   param["location_string"] = "null"
        //   param["user_image_attachment_id"] = "null"
//        param["createdAt"] = "2022-08-10T12:04:23.832Z"
//        param["updatedAt"] = "2022-08-11T00:00:02.473Z"
        
        
//        var Gps = [String:Any]()
//        //  param["Gps"] = Gps
//        Gps["task"] =  "22.9949088,72.60880259999999"
//        Gps["start_diff"] = ""
//        Gps["end_diff"] =  ""
        
        //   param["intermediateSave"] = "false"
        
        print("Param data is : ", param)
        
        WorkHourVM.shared.saveTasksApi(parameters: param, id: id, isAuthorization: true) { [self] obj in

            print(obj.message)
            UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.checkWorkHoursDetails)
            delegate?.checkWorkHoursSegmentIndex(segmentIndex: selectedWorkHoursSegmmentIndex)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func startTaskApi(id: String) {
        var param = [String:Any]()
        
        var startGps = [String:Any]()
        
        var coords = [String:Any]()
        let timestamp = currentDateFromGMT.timeIntervalSince1970
        
        coords["altitude"] = 316.7545471191406
        coords["altitudeAccuracy"] = 12.765711784362793
        coords["latitude"] = lat
        coords["accuracy"] =  41
        coords["longitude"] = long
        coords["heading"] = -1
        coords["speed"] = -1
        
        startGps["coords"] = coords
        startGps["timestamp"] = timestamp
        startGps["locationString"] = "Mohali Bypass"
        startGps["decision"] =  "off-bounds"
        startGps["is_ok"] = false
        startGps["diff"] = false
        
        param["startGps"] = startGps
        param["locationString"] = "Mohali Bypass"
        
        print(param)
        WorkHourVM.shared.startTakApi(parameters: param, id: id, isAuthorization: true) { [self] obj in
            
            print(obj.timelog?.status)
            
            self.timer.invalidate()
            
            // start the timer
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        }
    }
    
    private func saveAttachment(base64:String,fileType:String,fileName:String){
        
        SVProgressHUD.show()
        WorkHourVM.shared.saveAttachment(imageData: base64, fileName: fileName, type: fileType) { (errorMsg,loginMessage,attachIds)  in
         SVProgressHUD.dismiss()
            
            if errorMsg == true {
               print(attachIds)
//                let url = URL(string: "https://tidogkontroll.no/api/attachments/\(attachIds)")
                let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
                let url = URL(string: strUrl + "/attachments/\(attachIds)")

                if self.extraWorkVw.isHidden == false {
                    
                    if self.arrExtraDataAttachments == "" {
                        self.arrExtraDataAttachments = String(attachIds)
                    }
                    else {
                        self.arrExtraDataAttachments = self.arrExtraDataAttachments + "," + String(attachIds)
                    }
                    
                    self.workHourModel.extraWorkPDFData.append(expensePDF.init(expensePDF: url!, expenseBase64: ""))
                    if self.workHourModel.extraWorkPDFData.count == 0 {
                        self.extraWorkCollectionHeight.constant = 0.0
                        self.extraWorkTopVw.constant = 0.0
                    } else {
                        self.extraWorkCollectionHeight.constant = 125.0
                        self.extraWorkTopVw.constant = 16.0
                    }
                    self.extraWorkDocCollectionVw.reloadData()
                } else if self.otherExpenseVw.isHidden == false {
                    
                    if self.arrExpenseDataAttachments == "" {
                        self.arrExpenseDataAttachments = String(attachIds)
                    }
                    else {
                        self.arrExpenseDataAttachments = self.arrExpenseDataAttachments + "," + String(attachIds)
                    }
                    
                    self.workHourModel.otherExpensePDFData.append(expensePDF.init(expensePDF: url!, expenseBase64: ""))
                    
                    if self.workHourModel.otherExpensePDFData.count == 0 {
                        self.otherExpenseHeightConstraint.constant = 0.0
                        self.topOtherExpenseConstraint.constant = 0.0
                    } else {
                        self.otherExpenseHeightConstraint.constant = 125.0
                        self.topOtherExpenseConstraint.constant = 16.0
                    }
                    
                    self.otherExpenseCollectionVw.reloadData()
                }
                
            } else {
                displayToast(loginMessage)
            }
         }
    }
    
    
    // called every time interval from the timer
    @objc func timerAction() {
        counter += 1
        print("\(counter)")
        addDoctblVw.reloadSections(IndexSet(integer: 0), with: .none)
    }
    
//    func convertImageToBase64String (img: UIImage) -> String {
//        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
//        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
//        return imgString
//    }
    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        // return formated string
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    func finishTaskApi(id: String) {
        var param = [String:Any]()
        
        WorkHourVM.shared.finishTakApi(parameters: param, id: id, isAuthorization: true) { [self] obj in
            
            self.timer.invalidate()
            
            addDoctblVw.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
    
    func breakStartApi(id: String) {
        var param = [String:Any]()
        
        WorkHourVM.shared.breakStartApi(parameters: param, id: id, isAuthorization: true) { [self] obj in
            
            self.takeBreak = true
            print(obj.message ?? "")
            self.timer.invalidate()
            addDoctblVw.reloadSections(IndexSet(integer: 0), with: .none)
            
        }
    }
    
    func breakStopApi(id: String) {
        var param = [String:Any]()
        WorkHourVM.shared.breakStopApi(parameters: param, id: id, isAuthorization: true) { [self] obj in
            self.takeBreak = false
            print(obj.message ?? "")
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            
            addDoctblVw.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
}

//MARK: - CollectionView Delegate & Datasource
extension AddWorkDocumentVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if uploadDcoumentType == "OtherExpense" {
            return workHourModel.otherExpensePDFData.count
        }
        else {
            return workHourModel.extraWorkPDFData.count
        }
            
//        if extraWorkVw.isHidden == false {
//            return workHourModel.extraWorkPDFData.count
//        } //else if otherExpenseVw.isHidden == false {
//        return workHourModel.otherExpensePDFData.count
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if uploadDcoumentType == "OtherExpense" {
            guard let cell = otherExpenseCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
                return UICollectionViewCell()
            }

            cell.uploadImg.sd_setImage(with: workHourModel.otherExpensePDFData[indexPath.row].expensePDF , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            return cell
        }
        else {
            guard let cell = extraWorkDocCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
                return UICollectionViewCell()
            }
            cell.uploadImg.sd_setImage(with: workHourModel.extraWorkPDFData[indexPath.row].expensePDF , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))

            return cell
        }
        
//        guard let cell = extraWorkDocCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
//            return UICollectionViewCell()
//        }
//        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if extraWorkVw.isHidden == false {
            workHourModel.extraWorkPDFData.remove(at: indexPath.row)
            extraWorkDocCollectionVw.reloadData()
            configUI()
        } else {
            workHourModel.otherExpensePDFData.remove(at: indexPath.row)
            otherExpenseCollectionVw.reloadData()
            configUI()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       //if otherExpenseVw.isHidden == false {
//        
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 84.0
        let itemHeight = 84.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension AddWorkDocumentVC : UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if otherExpenseVw.isHidden == false {
            return UserDefaultKeys.expenseTypes.count
        }
        return UserDefaultKeys.extraWork.count
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if otherExpenseVw.isHidden == false {
            return UserDefaultKeys.expenseTypes[row]
        }
        return UserDefaultKeys.extraWork[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if otherExpenseVw.isHidden == false {
            otheExpenseTypeTxtField.text = UserDefaultKeys.expenseTypes[row]
        } else {
            expenseTypeTxtField.text = UserDefaultKeys.extraWork[row]
        }
        
    }
}

extension AddWorkDocumentVC : OverTimesProtocol {
    func overTimeClicked(indexPath: Int) {
//        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false) || (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
//            Toast.show(message: "Overtime is being calculated Automatic or Weekly", controller: self)
//        } else {
//            if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
//                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
//                    selectTimeType = indexPath == 0 ? SelectTimeType.Overtime50 : indexPath == 1 ? SelectTimeType.Overtime100 : SelectTimeType.OvertimeOther
//                    vwTimePicker.isHidden = false
//                } else {
//                    Toast.show(message: "PM cannot manage overtime", controller: self)
//                }
//            } else {
//                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
//                    Toast.show(message: "Only PM can manage overtime", controller: self)
//                } else {
//                    selectTimeType = indexPath == 0 ? SelectTimeType.Overtime50 : indexPath == 1 ? SelectTimeType.Overtime100 : SelectTimeType.OvertimeOther
//                    vwTimePicker.isHidden = false
//                }
//            }
//        }
        
        let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        let userIDAPI =  "\(timelogData?.user_id ?? 0)"

        if self.timelogData?.status == "draft" {
            Toast.show(message: "Cannot add overtime while timesheet in draft", controller: self)
        } else {
            if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtime_types?.count ?? 0 < 1 || (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false || GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
                Toast.show(message: "Overtime is being calculated Automatically", controller: self)
            } else if (GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs == "gps") {
                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
                    if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
                        selectedOvertimeIndexpath = indexPath
                        selectTimeType = SelectTimeType.Overtime50
                        vwTimePicker.isHidden = false
                    } else {
                        Toast.show(message: "Only PM can manage overtime", controller: self)
                    }
                } else {
                    if (userID == userIDAPI) {
                        selectedOvertimeIndexpath = indexPath
                        selectTimeType = SelectTimeType.Overtime50
                        vwTimePicker.isHidden = false
                    } else {
                        if comingFrom == "workHourDetail" {
                            Toast.show(message: "PM can not manage overtime", controller: self)
                        } else {
                            selectedOvertimeIndexpath = indexPath
                            selectTimeType = SelectTimeType.Overtime50
                            vwTimePicker.isHidden = false
                        }
                    }
                }
            } else {
                selectedOvertimeIndexpath = indexPath
                selectTimeType = SelectTimeType.Overtime50
                vwTimePicker.isHidden = false
            }
        }
/*

        if comingFrom == "workHourDetail" {
            if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false) || (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
                Toast.show(message: "Overtime is being calculated Automatic or Weekly", controller: self)
            } else if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
                if (userID == userIDAPI) {
                    Toast.show(message: "Only PM can manage overtime", controller: self)
                } else {
    //                selectTimeType = indexPath == 0 ? SelectTimeType.Overtime50 : indexPath == 1 ? SelectTimeType.Overtime100 : SelectTimeType.OvertimeOther
                    selectedOvertimeIndexpath = indexPath
                    selectTimeType = SelectTimeType.Overtime50
                    vwTimePicker.isHidden = false
                }
            } else {
                if (userID == userIDAPI) {
                    selectedOvertimeIndexpath = indexPath
                    selectTimeType = SelectTimeType.Overtime50
    //                selectTimeType = indexPath == 0 ? SelectTimeType.Overtime50 : indexPath == 1 ? SelectTimeType.Overtime100 : SelectTimeType.OvertimeOther
                    vwTimePicker.isHidden = false
                } else {
                    Toast.show(message: "PM can not manage overtime", controller: self)
                }
            }
        } else {
            if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false) || (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
                Toast.show(message: "Overtime is being calculated Automatic or Weekly", controller: self)
            } else if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
                if (userID == userIDAPI) {
                    Toast.show(message: "Only PM can manage overtime", controller: self)
                } else {
                    //                selectTimeType = indexPath == 0 ? SelectTimeType.Overtime50 : indexPath == 1 ? SelectTimeType.Overtime100 : SelectTimeType.OvertimeOther
                    selectedOvertimeIndexpath = indexPath
                    selectTimeType = SelectTimeType.Overtime50
                    vwTimePicker.isHidden = false
                }
            } else {
                selectedOvertimeIndexpath = indexPath
                selectTimeType = SelectTimeType.Overtime50
                //                selectTimeType = indexPath == 0 ? SelectTimeType.Overtime50 : indexPath == 1 ? SelectTimeType.Overtime100 : SelectTimeType.OvertimeOther
                vwTimePicker.isHidden = false
            }
        }
 */
    }

}

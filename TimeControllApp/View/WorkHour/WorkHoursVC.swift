//
//  WorkHoursVC.swift
//  TimeControllApp
//
//  Created by mukesh on 02/07/22.
//

import UIKit
import SVProgressHUD

enum WorkType:String {
    case Active = "active"
//    case Pending = "pending"
    case Pending = "active,rejected"
    case PendingMember = "draft,active,rejected"
//    case Approved = "approved"
    case Approved = "approved,complete"
    case Draft   =  "draft"
}

enum SelectedTabType:String {
    case Pending = "Pending"
    case Approved = "Approved"
    case AtWork = "At Work"
}

protocol WorkHoursVCDelegate: AnyObject {
    func checkWorkHoursSegmentIndex(segmentIndex: Int)
}

class WorkHoursVC: BaseViewController {
    
    @IBOutlet weak var workHourEmployeeSegment: UISegmentedControl!
    @IBOutlet weak var workProgressStatusSegmentControl: UISegmentedControl!
    @IBOutlet weak var workHourtblView: UITableView!
    
    @IBOutlet weak var vwfilter: UIView!
    
    @IBOutlet weak var vwPicker: UIView!
    @IBOutlet weak var vwFilterContainer: UIView!
    @IBOutlet weak var lblDateFrom: UILabel!
    
    @IBOutlet weak var lblDateTo: UILabel!
    
    @IBOutlet weak var notificationCountView: UIView!
    @IBOutlet weak var notificationCountLbl: UILabel!
    
    private var segmentControlIndex = 0
    
    var arrRows : [Rows]? = []
    
    var arrFilterRows : [Rows]? = []
    
    var selectedTab = String()
    
    public var homeModel = HomeViewModel()
    
    var selectedFromDate = Bool()
    var fromDate = String()
    var toDate = String()
    
    var isLoadingList : Bool = false
    var isMoreWorkHoursData : Bool = true
    
    @IBOutlet weak var btnAddFunction: UIButton!
    @IBOutlet weak var btnAddWorkHours: UIButton!
    
    @IBOutlet weak var anomalyVw: UIView!
    @IBOutlet weak var tripletexVw: UIView!
    @IBOutlet weak var errorTripletexLbl: UILabel!
    @IBOutlet weak var tripletexSwitch: UISwitch!
    
    @IBOutlet weak var startWorkStartedLbl: UILabel!
    @IBOutlet weak var startLocationLbl: UILabel!
    @IBOutlet weak var endWorkFinishedLbl: UILabel!
    @IBOutlet weak var endLocationLbl: UILabel!
    
    @IBOutlet weak var startCommentLbl: UILabel!
    @IBOutlet weak var endCommentLbl: UILabel!

    //MARK: Localizations
    @IBOutlet weak var workHoursTitleLbl: UILabel!
    @IBOutlet weak var mainAnomaliesTitleLbl: UILabel!
    @IBOutlet weak var startAnomaliesTitleLbl: UILabel!
    @IBOutlet weak var staticWorkStatedLbl: UILabel!
    @IBOutlet weak var staticStartLocationLbl: UILabel!
    @IBOutlet weak var endAnomaliesTitleLbl: UILabel!
    @IBOutlet weak var staticWorkFinishedLbl: UILabel!
    @IBOutlet weak var staticEndLocationLbl: UILabel!
    @IBOutlet weak var btnFilterCancelObj: UIBarButtonItem!
    @IBOutlet weak var btnFilterDoneObj: UIBarButtonItem!
    @IBOutlet weak var btnFilterApplyObj: UIButton!
    
    @IBOutlet weak var txtSearch: UITextField!
    var selectedId : String = ""
    var selectedIndexPathId : IndexPath = []
    @IBOutlet weak var confirmationLbl: UILabel!
    @IBOutlet weak var doYouWantToLbl: UILabel!
    @IBOutlet weak var cancelTripletexBtn: UIButton!
    @IBOutlet weak var okTripletexBtn: UIButton!
    
    //MARK: view LifeCycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.notificationCountLbl.text = GlobleVariables.notificationCount > 99 ? "99+" : "\(GlobleVariables.notificationCount)"
        notificationCountView.setNeedsLayout()
        notificationCountView.layer.cornerRadius = notificationCountView.frame.height/2
        notificationCountView.layer.masksToBounds = true
        if GlobleVariables.notificationCount > 0 {
            notificationCountView.isHidden = false
        }else {
            notificationCountView.isHidden = true
        }
        
        txtSearch.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked))
        
        setUpLocalization()
    }
    
    func setUpLocalization(){
        workHoursTitleLbl.text = LocalizationKey.workHours.localizing()
        workProgressStatusSegmentControl.setTitle(LocalizationKey.atWork.localizing(), forSegmentAt: 0)
        workProgressStatusSegmentControl.setTitle(LocalizationKey.pending.localizing(), forSegmentAt: 1)
        workProgressStatusSegmentControl.setTitle(LocalizationKey.approved.localizing(), forSegmentAt: 2)
        
        workHourEmployeeSegment.setTitle(LocalizationKey.pending.localizing(), forSegmentAt: 0)
        workHourEmployeeSegment.setTitle(LocalizationKey.approved.localizing(), forSegmentAt: 1)
        btnFilterCancelObj.title = LocalizationKey.cancel.localizing()
        btnFilterDoneObj.title = LocalizationKey.done.localizing()
        
        mainAnomaliesTitleLbl.text = LocalizationKey.anomalies.localizing()
        startAnomaliesTitleLbl.text = LocalizationKey.startAnomalies.localizing()
        staticWorkStatedLbl.text = LocalizationKey.workStarted.localizing()
        staticStartLocationLbl.text = LocalizationKey.startLocation.localizing()
        endAnomaliesTitleLbl.text = LocalizationKey.endAnomalies.localizing()
        staticWorkFinishedLbl.text = LocalizationKey.workFinished.localizing()
        staticEndLocationLbl.text = LocalizationKey.endLocation.localizing()
        
        txtSearch.placeholder = LocalizationKey.search.localizing()
        
        confirmationLbl.text = LocalizationKey.areYouSureToApproveThis.localizing()
        doYouWantToLbl.text = LocalizationKey.doYouWantToSaveThisHoursToTripletex.localizing()
        cancelTripletexBtn.setTitle(LocalizationKey.cancel.localizing(), for: .normal)
        okTripletexBtn.setTitle(LocalizationKey.ok.localizing(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configUI()
        setUpLocalization()
    }
    
    
    //MARK: Functions.
    func configUI() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        vwfilter.isHidden = true
        vwFilterContainer.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwFilterContainer.addGestureRecognizer(tap)
        
        let vwFilter = UITapGestureRecognizer(target: self, action: #selector(self.vwFilter(_:)))
        vwfilter.addGestureRecognizer(vwFilter)
        
        if !UserDefaults.standard.bool(forKey: UserDefaultKeys.checkWorkHoursDetails) {
            self.txtSearch.text = ""
            fromDate = ""
            toDate = ""

            if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member"{
                self.arrRows = []
                GlobleVariables.page = 0
                workHourEmployeeSegment.selectedSegmentIndex = 0
                workHourEmployeeSegment.isHidden = false
                selectedTab = WorkType.Pending.rawValue
                hitWorkHoursApi(status: WorkType.PendingMember.rawValue, name: "")
            } else {
                self.arrRows = []
                GlobleVariables.page = 0
                workProgressStatusSegmentControl.selectedSegmentIndex = 0
                workProgressStatusSegmentControl.isHidden = false
                selectedTab = WorkType.Draft.rawValue
                hitWorkHoursApi(status: WorkType.Draft.rawValue, name: "")
            }
        }
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        workProgressStatusSegmentControl.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        workProgressStatusSegmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        workProgressStatusSegmentControl.addTarget(self, action: "segmentedControlValueChanged:", for: UIControl.Event.valueChanged)
        workHourEmployeeSegment.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        workHourEmployeeSegment.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        workHourEmployeeSegment.addTarget(self, action: "segmentedEmployeeControlValueChanged:", for: UIControl.Event.valueChanged)
        workHourtblView.register(UINib.init(nibName: TABLE_VIEW_CELL.WorkHourTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.WorkHourTVC.rawValue)
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" && GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs == "gpsmanual" {
            btnAddWorkHours.isHidden = true
        } else {
            btnAddWorkHours.isHidden = false
        }
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.checkWorkHoursDetails)
        workHourtblView.reloadData()
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        self.textFieldShouldReturn(txtSearch)
    }
    
    @objc func swipedRight(){
        self.selectedTab = self.workHourEmployeeSegment.titleForSegment(at: self.workHourEmployeeSegment.selectedSegmentIndex) ?? ""
        if self.selectedTab == SelectedTabType.Pending.rawValue {
            self.workHourEmployeeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            self.hitWorkHoursApi(status: WorkType.Approved.rawValue, name: "")
            self.workHourEmployeeSegment.selectedSegmentIndex = 1
        }
        else if self.selectedTab == SelectedTabType.Approved.rawValue {
            self.workHourEmployeeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.9492231011, green: 0.6871941686, blue: 0.371647954, alpha: 1)
            self.hitWorkHoursApi(status: WorkType.Active.rawValue, name: "")
            self.workHourEmployeeSegment.selectedSegmentIndex = 0
        }
    }

     @objc func swipedLeft(){
         self.selectedTab = self.workHourEmployeeSegment.titleForSegment(at: self.workHourEmployeeSegment.selectedSegmentIndex) ?? ""
         if self.selectedTab == SelectedTabType.Pending.rawValue {
             self.workHourEmployeeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
             self.hitWorkHoursApi(status: WorkType.Approved.rawValue, name: "")
             self.workHourEmployeeSegment.selectedSegmentIndex = 1
         }
         else if self.selectedTab == SelectedTabType.Approved.rawValue {
             self.workHourEmployeeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.9492231011, green: 0.6871941686, blue: 0.371647954, alpha: 1)
             self.hitWorkHoursApi(status: WorkType.Active.rawValue, name: "")
             self.workHourEmployeeSegment.selectedSegmentIndex = 0
             
         }
     }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        segmentControlIndex = sender.selectedSegmentIndex
        GlobleVariables.page = 0
        self.txtSearch.text = ""
        fromDate = ""
        toDate = ""
        self.arrRows = []
        workHourtblView.reloadData()
        if sender.selectedSegmentIndex == 0 {
            workProgressStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            hitWorkHoursApi(status: WorkType.Draft.rawValue, name: "")
            selectedTab = WorkType.Draft.rawValue
        } else if sender.selectedSegmentIndex == 1 {
            workProgressStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9492231011, green: 0.6871941686, blue: 0.371647954, alpha: 1)
            hitWorkHoursApi(status: WorkType.Pending.rawValue, name: "")
            selectedTab = WorkType.Pending.rawValue
        } else {
            workProgressStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            hitWorkHoursApi(status: WorkType.Approved.rawValue, name: "")
            selectedTab = WorkType.Approved.rawValue
        }
    }
    
    @objc func segmentedEmployeeControlValueChanged(_ sender: UISegmentedControl) {
        segmentControlIndex = sender.selectedSegmentIndex
        GlobleVariables.page = 0
        self.txtSearch.text = ""
        fromDate = ""
        toDate = ""
        self.arrRows = []
        workHourtblView.reloadData()
        if sender.selectedSegmentIndex == 0 {
            workHourEmployeeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.9492231011, green: 0.6871941686, blue: 0.371647954, alpha: 1)
            hitWorkHoursApi(status: WorkType.PendingMember.rawValue, name: "")
            selectedTab = WorkType.Pending.rawValue
        } else {
            workHourEmployeeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            hitWorkHoursApi(status: WorkType.Approved.rawValue, name: "")
            selectedTab = WorkType.Approved.rawValue
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        vwFilterContainer.isHidden = true
    }
    
    @objc func vwFilter(_ sender: UITapGestureRecognizer? = nil) {
        
        vwfilter.isHidden = true
    }
    
    func showActionSheet(id:String, taskid: String, indexPathId: IndexPath) {
        
        let alert = UIAlertController(title: "", message: LocalizationKey.action.localizing(), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: LocalizationKey.viewDetails.localizing(), style: .default , handler:{ (UIAlertAction)in
            
            let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "AddWorkDocumentVC") as! AddWorkDocumentVC
            vc.comingFrom = "workHourDetail"
            vc.id = id
            vc.taskId = taskid
            vc.selectedWorkHoursSegmmentIndex = self.segmentControlIndex
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            print("User click Approve button")
        }))
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            
            if arrRows?[indexPathId.row].status == "active" {
                alert.addAction(UIAlertAction(title: LocalizationKey.approve.localizing(), style: .default , handler:{ (UIAlertAction)in
                    
                    if GlobleVariables.integrationDetailsControlPanelConfiguration?.product ?? "" == "tripletex" {
                        self.validateWithTripletexAPI(taskId: taskid)
                        self.tripletexSwitch.setOn(false, animated: false)
                        self.errorTripletexLbl.text = ""
                        self.tripletexVw.isHidden = false
                        self.selectedId = id
                        self.selectedIndexPathId = indexPathId
                    } else {
                        self.showAlert(title: LocalizationKey.alert.localizing(), message: LocalizationKey.areYouSureToApproveThis.localizing(), status: "approve", id: id, indePathId: indexPathId)
                    }
                    //                    self.showAlert(title: LocalizationKey.alert.localizing(), message: LocalizationKey.areYouSureToApproveThis.localizing(), status: "approve", id: id, indePathId: indexPathId)
                    //                    self.approveWorkHoursAPI(id: id, indePathId: indexPathId)
                }))
                
                alert.addAction(UIAlertAction(title: LocalizationKey.reject.localizing(), style: .default , handler:{ (UIAlertAction)in
                    self.showAlert(title: LocalizationKey.alert.localizing(), message: LocalizationKey.areYouSureToRejectThis.localizing(), status: "reject", id: id, indePathId: indexPathId)
                    //                    self.rejectWorkHoursAPI(id: id, indePathId: indexPathId)
                }))
            }
        }
        
        if (checkAnomaly() && (arrRows?[indexPathId.row].anomaly?.start?.is_early ?? false) || (arrRows?[indexPathId.row].anomaly?.start?.is_offsite ?? false) || (arrRows?[indexPathId.row].anomaly?.end?.is_early ?? false) || (arrRows?[indexPathId.row].anomaly?.end?.is_offsite ?? false)) {
            
            alert.addAction(UIAlertAction(title: LocalizationKey.viewAnomaly.localizing(), style: .default , handler:{ (UIAlertAction)in
                
                if (self.arrRows?[indexPathId.row].anomaly?.start?.is_early ?? false) {
                    self.startWorkStartedLbl.text = LocalizationKey.early.localizing()
                    self.startWorkStartedLbl.textColor = VBColorEnum.OrangeColor.getColor()
                } else if (self.arrRows?[indexPathId.row].anomaly?.start?.is_late ?? false) {
                    self.startWorkStartedLbl.text = LocalizationKey.late.localizing()
                    self.startWorkStartedLbl.textColor = VBColorEnum.RedColor.getColor()
                }
                else {
                    self.startWorkStartedLbl.text = LocalizationKey.onTimeAnomaly.localizing()
                    self.startWorkStartedLbl.textColor = VBColorEnum.GreenColor.getColor()
                }
                
                if (self.arrRows?[indexPathId.row].anomaly?.start?.is_offsite ?? false) {
                    self.startLocationLbl.text = LocalizationKey.offSiteAnomaly.localizing()
                    self.startLocationLbl.textColor = VBColorEnum.RedColor.getColor()
                } else {
                    self.startLocationLbl.text = LocalizationKey.onSite.localizing()
                    self.startLocationLbl.textColor = VBColorEnum.GreenColor.getColor()
                }
                
                if (self.arrRows?[indexPathId.row].anomaly?.end?.is_early ?? false) {
                    self.endWorkFinishedLbl.text = LocalizationKey.early.localizing()
                    self.endWorkFinishedLbl.textColor = VBColorEnum.OrangeColor.getColor()
                } else if (self.arrRows?[indexPathId.row].anomaly?.end?.is_late ?? false) {
                    self.endWorkFinishedLbl.text = LocalizationKey.late.localizing()
                    self.endWorkFinishedLbl.textColor = VBColorEnum.RedColor.getColor()
                } else {
                    self.endWorkFinishedLbl.text = LocalizationKey.onTimeAnomaly.localizing()
                    self.endWorkFinishedLbl.textColor = VBColorEnum.GreenColor.getColor()
                }
                
                if (self.arrRows?[indexPathId.row].anomaly?.end?.is_offsite ?? false) {
                    self.endLocationLbl.text = LocalizationKey.offSiteAnomaly.localizing()
                    self.endLocationLbl.textColor = VBColorEnum.RedColor.getColor()
                } else {
                    self.endLocationLbl.text = LocalizationKey.onSite.localizing()
                    self.endLocationLbl.textColor = VBColorEnum.GreenColor.getColor()
                }
                
                self.startCommentLbl.text = "\(LocalizationKey.comment.localizing()) : "  + (self.arrRows?[indexPathId.row].anomaly?.start?.comment ?? "")
                self.endCommentLbl.text = "\(LocalizationKey.comment.localizing()) : " + (self.arrRows?[indexPathId.row].anomaly?.end?.comment ?? "")

                self.anomalyVw.isHidden = false
            }))
        }
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm" {
            if arrRows?[indexPathId.row].status == "approved" {
                alert.addAction(UIAlertAction(title: LocalizationKey.resetApproval.localizing(), style: .default , handler:{ (UIAlertAction)in
                    self.showAlert(title: LocalizationKey.alert.localizing(), message: LocalizationKey.areYouSureToResetThis.localizing(), status: "reset", id: id, indePathId: indexPathId)
                }))
            }
            
            alert.addAction(UIAlertAction(title: LocalizationKey.delete.localizing(), style: .destructive , handler:{ (UIAlertAction)in
                self.showAlert(title: LocalizationKey.alert.localizing(), message: LocalizationKey.areYouSureToDeleteThis.localizing(), status: "delete", id: id, indePathId: indexPathId)
//                self.deleteWorkHoursAPI(id: id, indePathId: indexPathId)
            }))
        }
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.disableDeleteTimelogWhenApproved ?? false) && arrRows?[indexPathId.row].status == "approved" {
                
            } else {
                alert.addAction(UIAlertAction(title: LocalizationKey.delete.localizing(), style: .destructive , handler:{ (UIAlertAction)in
                    print("User click Delete button")
                    self.showAlert(title: LocalizationKey.alert.localizing(), message: LocalizationKey.areYouSureToDeleteThis.localizing(), status: "delete", id: id, indePathId: indexPathId)
//                    self.deleteWorkHoursAPI(id: id, indePathId: indexPathId)
                }))
            }
        }
        
        alert.addAction(UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    //MARK: Check Anomaly
    private func checkAnomaly() -> Bool {
        return GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs != "autoschedule" && GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
    }
    
    @IBAction func btnCloseAnomalyVwAction(_ sender: Any) {
        self.anomalyVw.isHidden = true
    }
    
    //MARK: Buttons Actions
    @IBAction func addWorkHourBtnAction(_ sender: Any) {
        let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "AddWorkDocumentVC") as! AddWorkDocumentVC
        vc.comingFrom = "addWorkHour"
        vc.selectedWorkHoursSegmmentIndex = self.segmentControlIndex
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushNotificationBtnAction(_ sender: Any) {
        
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        vc.selectedWorkHoursSegmmentIndex = self.segmentControlIndex
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Show Alert
    
    func showAlert(title: String, message: String, status: String, id: String, indePathId : IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            if status == "approve" {
                self.approveWorkHoursAPI(id: id, indePathId: indePathId)
            } else if status == "reject" {
                self.rejectWorkHoursAPI(id: id, indePathId: indePathId)
            } else if status == "delete" {
                self.deleteWorkHoursAPI(id: id, indePathId: indePathId)
            } else {
                self.resetApproveWorkHoursAPI(id: id, indePathId: indePathId)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnFilterAction(_ sender: Any) {
        if vwfilter.isHidden {
            vwfilter.isHidden = false
        }
        else {
            vwfilter.isHidden = true
        }
        if fromDate == "" {
            lblDateFrom.text = LocalizationKey.fromDate.localizing()
        } else {
            lblDateFrom.text = fromDate
        }
        
        if fromDate == "" {
            lblDateTo.text = LocalizationKey.toDate.localizing()
        } else {
            lblDateTo.text = toDate
        }
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        vwfilter.isHidden = true
        if selectedTab == WorkType.Pending.rawValue {
            hitWorkHoursApi(status:  WorkType.Pending.rawValue, name: self.txtSearch.text ?? "", withSearch: true)
        }
        else if selectedTab == WorkType.Approved.rawValue {
            hitWorkHoursApi(status:  WorkType.Approved.rawValue, name: self.txtSearch.text ?? "", withSearch: true)
        }
        else if selectedTab == WorkType.Draft.rawValue {
            hitWorkHoursApi(status:  WorkType.Draft.rawValue, name: self.txtSearch.text ?? "", withSearch: true)
        }
//        fromDate = ""
//        toDate = ""
    }
    
    @IBAction func btnClearAction(_ sender: Any) {
        fromDate = ""
        toDate = ""
        lblDateFrom.text = LocalizationKey.fromDate.localizing()
        lblDateTo.text = LocalizationKey.toDate.localizing()
        vwfilter.isHidden = true
        if selectedTab == WorkType.Pending.rawValue {
            hitWorkHoursApi(status:  WorkType.Pending.rawValue, name: self.txtSearch.text ?? "", withSearch: true)
        }
        else if selectedTab == WorkType.Approved.rawValue {
            hitWorkHoursApi(status:  WorkType.Approved.rawValue, name: self.txtSearch.text ?? "",withSearch: true)
        }
        else if selectedTab == WorkType.Draft.rawValue {
            hitWorkHoursApi(status:  WorkType.Draft.rawValue, name: self.txtSearch.text ?? "", withSearch: true)
        }
    }
    
    @IBAction func btnDonaAction(_ sender: UIBarButtonItem) {
        vwFilterContainer.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = getCurrentDateFromGMT()
        if selectedFromDate {
            if !fromDate.isEmpty {
                self.lblDateFrom.text = fromDate
            } else {
                fromDate = formatter.string(from: currentDate)
                self.lblDateFrom.text = fromDate
            }
        }
        else {
            if !toDate.isEmpty {
                self.lblDateTo.text = toDate
            } else {
                toDate = formatter.string(from: currentDate)
                self.lblDateTo.text = toDate
            }
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIBarButtonItem) {
        self.vwFilterContainer.isHidden = true
    }
    
    @IBAction func btnFromDateAction(_ sender: UIButton) {
        vwFilterContainer.isHidden = false
        selectedFromDate = true
    }
    
    
    @IBAction func btnToDateAction(_ sender: UIButton) {
        vwFilterContainer.isHidden = false
        selectedFromDate = false
    }
    
    
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if selectedFromDate {
            fromDate = formatter.string(for: sender.date) ?? ""
        }
        else {
            toDate = formatter.string(for: sender.date) ?? ""
        }
    }
    
    @IBAction func btnSelectFunctionAction(_ sender: UIButton) {
        
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SelectFunctionVC") as? SelectFunctionVC else { return}
   
        vc.callback = { (obj) in
          
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectTasksVC") as! SelectTasksVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let nvc = UINavigationController(rootViewController: vc) //Add navigation controller
        nvc.modalPresentationStyle = .overFullScreen
        nvc.navigationBar.isHidden = true
        
        self.navigationController?.present(nvc, animated: true)
    }
    @IBAction func cancelTripletexView(_ sender: Any) {
        tripletexVw.isHidden = true
    }
    @IBAction func okTripletexView(_ sender: Any) {
        
        self.approveWorkHoursAPI(id: selectedId, indePathId: selectedIndexPathId)
    }
}

extension WorkHoursVC:WorkHoursVCDelegate {
    func checkWorkHoursSegmentIndex(segmentIndex: Int) {
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member"{
            GlobleVariables.page = 0
            self.arrRows = []
            workHourtblView.reloadData()
            if segmentIndex == 0 {
                workHourEmployeeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.9492231011, green: 0.6871941686, blue: 0.371647954, alpha: 1)
    //            hitWorkHoursApi(status: WorkType.Active.rawValue)
                hitWorkHoursApi(status: WorkType.PendingMember.rawValue, name: self.txtSearch.text ?? "")
                selectedTab = WorkType.Pending.rawValue
            } else {
                workHourEmployeeSegment.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
                hitWorkHoursApi(status: WorkType.Approved.rawValue, name: self.txtSearch.text ?? "")
                selectedTab = WorkType.Approved.rawValue
            }
        } else {
            GlobleVariables.page = 0
            self.arrRows = []
            workHourtblView.reloadData()
            if segmentIndex == 0 {
                workProgressStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
                hitWorkHoursApi(status: WorkType.Draft.rawValue, name: self.txtSearch.text ?? "")
                selectedTab = WorkType.Draft.rawValue
            } else if segmentIndex == 1 {
                workProgressStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9492231011, green: 0.6871941686, blue: 0.371647954, alpha: 1)
                hitWorkHoursApi(status: WorkType.Pending.rawValue, name: self.txtSearch.text ?? "")
                selectedTab = WorkType.Pending.rawValue
            } else {
                workProgressStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
                hitWorkHoursApi(status: WorkType.Approved.rawValue, name: self.txtSearch.text ?? "")
                selectedTab = WorkType.Approved.rawValue
            }
        }
    }
}


//MARK: - TableView DataSource and Delegate Methods
extension WorkHoursVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 0
        if workHourEmployeeSegment.selectedSegmentIndex == 0 {
            count = self.arrRows?.count ?? 0
        } else {
            count = self.arrRows?.count ?? 0
        }
        
        if workProgressStatusSegmentControl.selectedSegmentIndex == 0 {
            count = self.arrRows?.count ?? 0
        } else if workHourEmployeeSegment.selectedSegmentIndex == 1 {
            count = self.arrRows?.count ?? 0
        } else {
            count = self.arrRows?.count ?? 0
        }
        
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noWorkHousAvailable.localizing()
            noDataLabel.textColor     = Constant.appColor
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            noDataLabel.lineBreakMode = .byWordWrapping
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            
        }else{
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.WorkHourTVC.rawValue, for: indexPath) as? WorkHourTVC
        else { return UITableViewCell() }
        cell.configUI(selectedTab: selectedTab)
        if (arrRows?.count ?? 0 > 0) {
            cell.setData(rowsData: (arrRows?[indexPath.row])!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard  let rowsData = arrRows?[indexPath.row] else {
            return
        }
        showActionSheet(id: "\(rowsData.id ?? 0)", taskid: "\(rowsData.task_id ?? 0)", indexPathId: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (arrRows?.count ?? 0) - 1 && isMoreWorkHoursData {
            GlobleVariables.page = GlobleVariables.page + 1
            if selectedTab == WorkType.Pending.rawValue {
                hitWorkHoursApi(status:  WorkType.Pending.rawValue, name: self.txtSearch.text ?? "")
            }
            else if selectedTab == WorkType.PendingMember.rawValue {
                hitWorkHoursApi(status:  WorkType.PendingMember.rawValue, name: self.txtSearch.text ?? "")
            }
            else if selectedTab == WorkType.Approved.rawValue {
                hitWorkHoursApi(status:  WorkType.Approved.rawValue, name: self.txtSearch.text ?? "")
            }
            else if selectedTab == WorkType.Draft.rawValue {
                hitWorkHoursApi(status:  WorkType.Draft.rawValue, name: self.txtSearch.text ?? "")
            }
        }
    }
}

extension WorkHoursVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hitWorkHoursApi(status: selectedTab, name: textField.text ?? "",withSearch: true)
        return true
    }
}


//MARK: Extension Api's
extension WorkHoursVC {
        
    func hitWorkHoursApi(status: String,name:String,withSearch isSearch: Bool = false) -> Void {
        self.isLoadingList = false
        if isSearch {
            self.arrRows?.removeAll()
            GlobleVariables.page = 0
        }
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"status\":\"\(status)\",\"fromDate\":\"\(fromDate)\",\"toDate\":\"\(toDate)\",\"name\":\"\(name)\"}"
        print(param)
        
        WorkHourVM.shared.workHourApi(parameters: param, isAuthorization: true) { [self] obj in
            print("obj.rows?.count is : ", obj.rows?.count)
            if obj.rows?.count ?? 0 > 0{
                self.isMoreWorkHoursData = true
            }else{
                self.isMoreWorkHoursData = false
            }
            for model in obj.rows ?? []{
                self.arrRows?.append(model)
            }
            self.workHourtblView.reloadData()
        }
        
    }
    
    func deleteWorkHoursAPI(id: String, indePathId : IndexPath) -> Void {
        self.isLoadingList = false
        let param = [String:Any]()
        print(param)
        WorkHourVM.shared.deleteWorkHoursAPI(parameters: param, id: id, isAuthorization: true) { [self] obj in
            
            print("Deleted data is : ", obj)
            arrRows?.remove(at: indePathId.row)
            self.workHourtblView.reloadData()
        }
    }
    
    func approveWorkHoursAPI(id: String, indePathId : IndexPath) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        param["status"] = "approved"
        if self.tripletexSwitch.isOn {
            param["isSyncWithTripletex"] = true
        }
        print(param)
        
        WorkHourVM.shared.approveWorkHoursAPI(parameters: param, id: id, isAuthorization: true) { [self] obj in
            print("Approved data is : ", obj)
            tripletexVw.isHidden = true
            arrRows?.remove(at: indePathId.row)
            self.workHourtblView.reloadData()
        }
    }
    
    func rejectWorkHoursAPI(id: String, indePathId : IndexPath) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        param["status"] = "rejected"
        print(param)
        WorkHourVM.shared.approveWorkHoursAPI(parameters: param, id: id, isAuthorization: true) { [self] obj in
            print("Rejected data is : ", obj)
            arrRows?.remove(at: indePathId.row)
            self.workHourtblView.reloadData()
        }
    }
    
    func resetApproveWorkHoursAPI(id: String, indePathId : IndexPath) -> Void {
        self.isLoadingList = false
        var param = [String:Any]()
        param["status"] = "reset"
        param["notes"] = ""
        print(param)
        WorkHourVM.shared.approveWorkHoursAPI(parameters: param, id: id, isAuthorization: true) { [self] obj in
            print("After Reset data is : ", obj)
            arrRows?.remove(at: indePathId.row)
            self.workHourtblView.reloadData()
        }
    }
    
    func validateWithTripletexAPI(taskId:String) -> Void {
        var param = [String:Any]()
        param["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0"
        param["task_id"] = taskId
        
        
        
        WorkHourVM.shared.validateWithTripletexAPI(parameters: param, isAuthorization: true) { [self]
            obj in
            print("obj.message ",obj.message)
            errorTripletexLbl.text = obj.message ?? ""
            if obj.message != "" {
                tripletexSwitch.isUserInteractionEnabled = false
            }else {
                tripletexSwitch.isUserInteractionEnabled = true
            }
        }
    }
}


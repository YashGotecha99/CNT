//
//  VacationAbsenceVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit
import SVProgressHUD

protocol VacationAbsenceVCDelegate: AnyObject {
    func checkVacationAbsenceSegmentIndex(segmentIndex: Int)
}

class VacationAbsenceVC: BaseViewController {

    @IBOutlet weak var vacationAbsenceTitleLbl: UILabel!
    @IBOutlet weak var vacationSegmentController: UISegmentedControl!
    @IBOutlet weak var vacationAbsenceTblVw: UITableView!
    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var vacationsFliterBtn: UIButton!
    @IBOutlet weak var allFiltetBtn: UIButton!
    @IBOutlet weak var absenceFliterBtn: UIButton!
    
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var vacationBtn: UIButton!
    @IBOutlet weak var absenceBtn: UIButton!
    @IBOutlet weak var requestCountView: UIView!
    
    @IBOutlet weak var allLbl: UILabel!
    @IBOutlet weak var vacationsLbl: UILabel!
    @IBOutlet weak var absenceLbl: UILabel!
    @IBOutlet weak var requestCount: UILabel!
    @IBOutlet weak var allLeaveTblVw: UITableView!
    @IBOutlet weak var allLeaveView: UIView!
    
    var vacationList : [VacationRows] = []
    var abseanceList : [AbsenceRows] = []
    var pendingRequestList : [AbsenceRows] = []
    var allLeaveList : [String] = []
    var modifiedAbsentTypes = [Absent_types]()

    var isMoreVacation : Bool = true
    var isMoreAbsence : Bool = true
    var isMorePendingRequest : Bool = true
    var isFilterOff : Bool = true
    
    var selectedModule = ""
    
    var isLoadingList : Bool = false
    @IBOutlet weak var addVacationAbsenceBtn: UIButton!
    var selectedSegmentIndex = 0
    
    var vacationsAbsenceYearlyData : Yearly?
    var employeePercent : String?
    
    var searchTask: DispatchWorkItem?
    @IBOutlet weak var vacationAbsenceFilterVw: UIView!
    @IBOutlet weak var allLeaveHeight: NSLayoutConstraint!
    var isVacationAbsenceFilterOff : Bool = true
    
    
    @IBOutlet weak var vacationAbsenceOkObj: UIButton!
    @IBOutlet weak var vacationAbsenceCancelObj: UIButton!
    var selectedLeaveIndex = 0
    @IBOutlet weak var datePickerVw: UIView!
    @IBOutlet weak var datePickerDoneObj: UIBarButtonItem!
    @IBOutlet weak var datePickerCancelObj: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var allLeavesLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    
    var selectedDate = ""
    var fromDate = ""
    var toDate = ""
    var filterAbsenceType = ""
    var filterAbsenceSearchName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
    }
    
    func setUpLocalization(){
        vacationAbsenceTitleLbl.text = LocalizationKey.vacationsAbsents.localizing()
        vacationSegmentController.setTitle(LocalizationKey.vacation.localizing(), forSegmentAt: 0)
        vacationSegmentController.setTitle(LocalizationKey.absence.localizing(), forSegmentAt: 1)
        txtsearch.placeholder = LocalizationKey.search.localizing()
        
        allLbl.text = LocalizationKey.all.localizing()
        vacationsLbl.text = LocalizationKey.vacation.localizing()
        absenceLbl.text = LocalizationKey.absence.localizing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        GlobleVariables.page = 0
//        vacationSegmentController.selectedSegmentIndex = selectedSegmentIndex
//        vacationsUsersData()
//        if vacationSegmentController.selectedSegmentIndex == 0 {
//            searchView.isHidden = true
//            vacationList.removeAll()
//            self.vacationListApi()
//        } else if vacationSegmentController.selectedSegmentIndex == 1 {
//            searchView.isHidden = true
//            abseanceList.removeAll()
//            self.absenceListApi()
//        }else {
//            searchView.isHidden = false
//            pendingRequestList.removeAll()
//            self.pendingRequestListApi(name: "")
//        }
    }
    
    func configUI() {
        filterView.isHidden = isFilterOff
        allLeaveView.isHidden = true
        let tempLeaveList = GlobleVariables.clientControlPanelConfiguration?.data?.extendedRules?.absent_types ?? []
        modifiedAbsentTypes.insert(Absent_types(code: "", name: "All Leaves"), at: 0)
        
        for type in tempLeaveList {
            modifiedAbsentTypes.append(Absent_types(code: type.code ?? "", name: (type.name ?? "") + " - Paid"))
            modifiedAbsentTypes.append(Absent_types(code: type.code ?? "", name: (type.name ?? "") + " - Unpaid"))
        }
        print("tempLeaveList is : ", modifiedAbsentTypes)
        if modifiedAbsentTypes.count > 7 {
            allLeaveHeight.constant = CGFloat((7 * 50) + 20)
        } else {
            allLeaveHeight.constant = CGFloat((modifiedAbsentTypes.count * 50) + 20)
        }

        /*
        allLeaveList.append("All Leaves")
        for obj in  tempLeaveList {
            
            allLeaveList.append((obj.name ?? "") + " - Paid")
            allLeaveList.append((obj.name ?? "") + " - Unpaid")
        }
        allLeaveHeight.constant = CGFloat((allLeaveList.count * 50) + 20)
        */
        vacationAbsenceFilterVw.isHidden = isVacationAbsenceFilterOff
        allBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        filterView.addGestureRecognizer(tap)
        
//        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapVacationAbsenceFilter(_:)))
//        tap1.delegate = self
//        vacationAbsenceFilterVw.addGestureRecognizer(tap1)
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        vacationSegmentController.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        vacationSegmentController.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        vacationAbsenceTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.VacationAbsenceTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.VacationAbsenceTVC.rawValue)
        
        vacationAbsenceTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.LeaveStatusTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.LeaveStatusTVC.rawValue)
        
        vacationAbsenceTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.PendingRequestTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.PendingRequestTVC.rawValue)
        allLeaveTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ChildListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue)
        
        setAddVactionAbsenceButton()
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            vacationSegmentController.insertSegment(withTitle: LocalizationKey.pending.localizing(), at: 2, animated: false)
            requestCountView.isHidden = false
            pendingRequestCountApi()
        } else {
            requestCountView.isHidden = true
        }
        vacationAbsenceTblVw.reloadData()
        
        GlobleVariables.page = 0
        vacationSegmentController.selectedSegmentIndex = selectedSegmentIndex
        vacationsUsersData()
        if vacationSegmentController.selectedSegmentIndex == 0 {
            searchView.isHidden = true
            vacationList.removeAll()
            self.vacationListApi()
        } else if vacationSegmentController.selectedSegmentIndex == 1 {
            searchView.isHidden = false
            abseanceList.removeAll()
            self.absenceListApi(name: filterAbsenceSearchName)
        }else {
            searchView.isHidden = false
            pendingRequestList.removeAll()
            self.pendingRequestListApi(name: "")
        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        filterView.isHidden = true
    }
    
    @objc func handleTapVacationAbsenceFilter(_ sender: UITapGestureRecognizer? = nil) {
        print("handleTapVacationAbsenceFilter")
        vacationAbsenceFilterVw.isHidden = true
    }
    
    @IBAction func fromDateClearBtnAction(_ sender: Any) {
        fromLbl.text = LocalizationKey.from.localizing().capitalized
        fromDate = ""
    }
    
    @IBAction func toDateClearBtnAction(_ sender: Any) {
        toLbl.text = LocalizationKey.to.localizing().capitalized
        toDate = ""
    }
    
    @IBAction func vacationAbsenceOkBtnAction(_ sender: Any) {
        isVacationAbsenceFilterOff = !isVacationAbsenceFilterOff
        vacationAbsenceFilterVw.isHidden = true
        self.abseanceList.removeAll()
        GlobleVariables.page = 0
        self.absenceListApi(name: filterAbsenceSearchName)
    }
    
    @IBAction func vacationAbsenceCancelBtnAction(_ sender: Any) {
        isVacationAbsenceFilterOff = !isVacationAbsenceFilterOff
        vacationAbsenceFilterVw.isHidden = true
    }
    
    @IBAction func datePickerCancelBtnAction(_ sender: Any) {
        datePickerVw.isHidden = true
    }
    
    @IBAction func datePickerDoneBtnAction(_ sender: Any) {
        chooseDate()
    }
    
    @IBAction func fromDateBtnAction(_ sender: Any) {
        selectedDate = "fromDate"
        datePickerVw.isHidden = false
    }
    
    @IBAction func toDateBtnAction(_ sender: Any) {
        selectedDate = "toDate"
        datePickerVw.isHidden = false
    }
    
    func chooseDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let chooseDate = dateFormatter.string(from: datePicker.date)
        
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        let serverDate = serverDateFormatter.string(from: datePicker.date)
        
        let cuurentDate = getCurrentDateFromGMT()
        
        if selectedDate == "fromDate" {
            if chooseDate > toLbl.text ?? dateFormatter.string(from: cuurentDate) {
                fromLbl.text = chooseDate
                toLbl.text = chooseDate
                fromDate = serverDate
                toDate = serverDate
            } else {
                fromLbl.text = chooseDate
                fromDate = serverDate
            }
        } else {
            if let date1 = dateFormatter.date(from: chooseDate),
               let date2 = dateFormatter.date(from: fromLbl.text ?? dateFormatter.string(from: cuurentDate)) {
                
                if date1 < date2 {
                    presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.fromDateMustBeLessThenToDate.localizing())
                } else {
                    toLbl.text = chooseDate
                    toDate = serverDate
                }
            } else {
                print("Invalid date format")
            }
        }
        datePickerVw.isHidden = true
    }
    
    func setAddVactionAbsenceButton() {
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
//            addVacationAbsenceBtn.isHidden = false
            if vacationSegmentController.selectedSegmentIndex == 0 {
                    addVacationAbsenceBtn.isHidden = false
               
            } else if vacationSegmentController.selectedSegmentIndex == 1 {
                    addVacationAbsenceBtn.isHidden = false
            } else {
                addVacationAbsenceBtn.isHidden = true
            }
        }
        else {
            if vacationSegmentController.selectedSegmentIndex == 0 {
                if GlobleVariables.bizTypeControlPanelConfiguration?.data?.allow_vacations  ?? false {
                    addVacationAbsenceBtn.isHidden = false
                }else {
                    addVacationAbsenceBtn.isHidden = true
                }
            } else if vacationSegmentController.selectedSegmentIndex == 1 {
                if GlobleVariables.bizTypeControlPanelConfiguration?.data?.allow_absents  ?? false {
                    addVacationAbsenceBtn.isHidden = false
                }else {
                    addVacationAbsenceBtn.isHidden = true
                }
            }
        }
    }
    @IBAction func allFiltetBtn(_ sender: Any) {
        allBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        absenceBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        vacationBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        isFilterOff = true
        filterView.isHidden = isFilterOff
        selectedModule = ""
        GlobleVariables.page = 0
        pendingRequestList.removeAll()
        self.pendingRequestListApi(name: "")
    }
    
    @IBAction func vacationsFliterBtn(_ sender: Any) {
        allBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        absenceBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        vacationBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        isFilterOff = true
        filterView.isHidden = isFilterOff
        selectedModule = "vacation"
        GlobleVariables.page = 0
        pendingRequestList.removeAll()
        self.vacationAbsenceTblVw.reloadData()
        self.pendingRequestListApi(name: "")
    }
    
    @IBAction func absenceFliterBtn(_ sender: Any) {
        allBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        absenceBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        vacationBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        isFilterOff = true
        filterView.isHidden = isFilterOff
        selectedModule = "absence"
        GlobleVariables.page = 0
        pendingRequestList.removeAll()
        self.vacationAbsenceTblVw.reloadData()
        self.pendingRequestListApi(name: "")
    }
    @IBAction func btnFilter(_ sender: Any) {
        if vacationSegmentController.selectedSegmentIndex == 1 {
            isVacationAbsenceFilterOff = !isVacationAbsenceFilterOff
            vacationAbsenceFilterVw.isHidden = isVacationAbsenceFilterOff
        } else {
            isFilterOff = !isFilterOff
            filterView.isHidden = isFilterOff
        }
    }
    @IBAction func ChangedSegment(_ sender: Any) {
        vacationAbsenceFilterVw.isHidden = true
        if vacationSegmentController.selectedSegmentIndex == 0 {
            searchView.isHidden = true
            isFilterOff = true
            filterView.isHidden = isFilterOff
            txtsearch.text = ""
            GlobleVariables.page = 0
            vacationList.removeAll()
            self.vacationListApi()
        } else if vacationSegmentController.selectedSegmentIndex == 1 {
            searchView.isHidden = false
            isFilterOff = true
            filterView.isHidden = isFilterOff
            GlobleVariables.page = 0
            txtsearch.text = ""
            abseanceList.removeAll()
            self.absenceListApi(name: filterAbsenceSearchName)
        } else {
            searchView.isHidden = false
            requestCountView.setNeedsLayout()
            requestCountView.layer.cornerRadius = requestCountView.frame.height/2
            requestCountView.layer.masksToBounds = true
            GlobleVariables.page = 0
            txtsearch.text = ""
            pendingRequestList.removeAll()
            self.pendingRequestListApi(name: "")
        }
        setAddVactionAbsenceButton()
        vacationAbsenceTblVw.reloadData()
    }
    
    @IBAction func addVacationBtnAction(_ sender: Any) {
        if vacationSegmentController.selectedSegmentIndex == 0 {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddVacationVC") as! AddVacationVC
//            guard let vacation = vacationsAbsenceYearlyData else {return }
            vc.vacationsAbsenceData = vacationsAbsenceYearlyData
            vc.employeePercent = employeePercent ?? ""
            vc.selectedVacationAbsenceSegmmentIndex = vacationSegmentController.selectedSegmentIndex
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else if vacationSegmentController.selectedSegmentIndex == 1 {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddAbsenceVC") as! AddAbsenceVC
//            guard let vacation = vacationsAbsenceYearlyData else {return }
            vc.vacationsAbsenceData = vacationsAbsenceYearlyData
            vc.employeePercent = employeePercent ?? ""
            vc.selectedVacationAbsenceSegmmentIndex = vacationSegmentController.selectedSegmentIndex
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func showAllLeaveTypeBtn(_ sender: Any) {
        allLeaveView.isHidden = !allLeaveView.isHidden
    }
    
    
    //MARK: Show Alert
    
    func showAlertAbsenceVacationDelete(title: String, message: String, id: Int, indePathId : IndexPath, fromData: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            print("fromData is : ", fromData)
            
            if fromData == "Vacation" {
                self.deleteVacation(id: id, indexPath: indePathId)
            } else {
                
                self.deleteAbsence(id: id, indexPath: indePathId)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension VacationAbsenceVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == allLeaveTblVw {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == allLeaveTblVw {
            return modifiedAbsentTypes.count
        }
        if section == 0 {
            if vacationSegmentController.selectedSegmentIndex == 2 {
                return 0
            }else {
                return 1
            }
        }
        else{
            if vacationSegmentController.selectedSegmentIndex == 0 {
                return vacationList.count
            } else if vacationSegmentController.selectedSegmentIndex == 1 {
                return abseanceList.count
            } else {
                return pendingRequestList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == allLeaveTblVw {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue, for: indexPath) as? ChildListTVC
            else { return UITableViewCell() }
            cell.childNameLbl.text = modifiedAbsentTypes[indexPath.row].name
            cell.childNameLbl.numberOfLines = 0
            
            if selectedLeaveIndex == indexPath.row {
                cell.selectChildBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            }
            else {
                cell.selectChildBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            }
            return cell
        }
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.VacationAbsenceTVC.rawValue, for: indexPath) as? VacationAbsenceTVC else { return UITableViewCell() }
            guard let vacation = vacationsAbsenceYearlyData else {return UITableViewCell()}
            cell.setCellUI(selectedSegmentIndex: vacationSegmentController.selectedSegmentIndex, vacationsAbsenceData: vacation, employeePercent: employeePercent ?? "")
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.LeaveStatusTVC.rawValue, for: indexPath) as? LeaveStatusTVC
        else { return UITableViewCell() }
        if vacationSegmentController.selectedSegmentIndex == 0 {
            let obj = vacationList[indexPath.row]
            cell.selectionStyle = .none
            cell.setValueForVacation(vacation: obj)
        }else if vacationSegmentController.selectedSegmentIndex == 1 {
            let obj = abseanceList[indexPath.row]
            cell.selectionStyle = .none
            cell.setValueForAbsence(abseance: obj)
        } else {
            guard let pendingRequestCell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.PendingRequestTVC.rawValue, for: indexPath) as? PendingRequestTVC
            else { return UITableViewCell() }
            let obj = pendingRequestList[indexPath.row]
            pendingRequestCell.setValueForPendingRequest(pendingRequest: obj, indexPath: indexPath)
            pendingRequestCell.delegate = self
            return pendingRequestCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == allLeaveTblVw {
            print("indexPath.row ",indexPath.row)
            selectedLeaveIndex = indexPath.row
            filterAbsenceType = ""
            let selectedAbsentType = modifiedAbsentTypes[indexPath.row]
            
            if selectedAbsentType.name!.contains("Paid") {
                filterAbsenceType = (selectedAbsentType.code ?? "") + ",paid"
                print("Selected leave is paid")
            } else if selectedAbsentType.name!.contains("Unpaid") {
                filterAbsenceType = (selectedAbsentType.code ?? "") + ",unpaid"
                print("Selected leave is unpaid")
            } 
            else {
                filterAbsenceType = (selectedAbsentType.code ?? "")
                print("Cannot determine if the leave is paid or unpaid")
            }
            
            allLeaveTblVw.reloadData()
            return
        }
        if vacationSegmentController.selectedSegmentIndex == 2 {
            let obj = pendingRequestList[indexPath.row]
            if obj.type == "vacation" {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddVacationVC") as! AddVacationVC
                vc.vacationsAbsenceData = vacationsAbsenceYearlyData
                vc.employeePercent = employeePercent ?? ""
                vc.selectedVacationAbsenceSegmmentIndex = vacationSegmentController.selectedSegmentIndex
                vc.isComingFrom = "Details"
                vc.vacationID = obj.id ?? 0
                vc.userID = obj.user_id ?? 0
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddAbsenceVC") as! AddAbsenceVC
                vc.vacationsAbsenceData = vacationsAbsenceYearlyData
                vc.employeePercent = employeePercent ?? ""
                vc.selectedVacationAbsenceSegmmentIndex = vacationSegmentController.selectedSegmentIndex
                vc.isComingFrom = "Details"
                vc.absenceID = obj.id ?? 0
                vc.userID = obj.user_id ?? 0
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } 
        else if  UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm" {
            if vacationSegmentController.selectedSegmentIndex == 0 {
                let obj = vacationList[indexPath.row]
                showActionSheet(indexPath: indexPath, fromData: "Vacation", absenceVacationID: obj.id ?? 0)
            } else {
                let obj = abseanceList[indexPath.row]
                showActionSheet(indexPath: indexPath, fromData: "Absence", absenceVacationID: obj.id ?? 0)
            }
        }
    }
    
    func showActionSheet(indexPath: IndexPath, fromData: String, absenceVacationID: Int) {
            
            let alert = UIAlertController(title: "", message: LocalizationKey.action.localizing(), preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: LocalizationKey.delete.localizing(), style: .destructive , handler:{ (UIAlertAction)in
                self.showAlertAbsenceVacationDelete(title: "", message: LocalizationKey.areYouSureToDeleteAnItem.localizing(), id: absenceVacationID, indePathId: indexPath, fromData: fromData)
            }))
            
            alert.addAction(UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
}

extension VacationAbsenceVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList  ){
            if vacationSegmentController.selectedSegmentIndex == 0 && isMoreVacation {
                self.isLoadingList = true
                GlobleVariables.page = GlobleVariables.page + 1
                vacationListApi()
            }else if vacationSegmentController.selectedSegmentIndex == 1 && isMoreAbsence {
                self.isLoadingList = true
                GlobleVariables.page = GlobleVariables.page + 1
                absenceListApi(name: filterAbsenceSearchName)
            }else if vacationSegmentController.selectedSegmentIndex == 2 && isMorePendingRequest{
                self.isLoadingList = true
                GlobleVariables.page = GlobleVariables.page + 1
                pendingRequestListApi(name: "")
            }
        }
    }
}

extension VacationAbsenceVC: VacationAbsenceVCDelegate {
    func checkVacationAbsenceSegmentIndex(segmentIndex: Int) {
        self.vacationList.removeAll()
        self.abseanceList.removeAll()
        pendingRequestList.removeAll()
        vacationAbsenceTblVw.reloadData()
        GlobleVariables.page = 0
        if segmentIndex == 0 {
            searchView.isHidden = true
//            vacationList.removeAll()
            self.vacationListApi()
        } else if segmentIndex == 1 {
            searchView.isHidden = false
//            abseanceList.removeAll()
            self.absenceListApi(name: filterAbsenceSearchName)
        }else {
            searchView.isHidden = false
//            pendingRequestList.removeAll()
            self.pendingRequestListApi(name: "")
        }
    }
}

extension VacationAbsenceVC : PendingRequestTVCProtocol {
    func acceptOrRejectRequest(status: String, vacationId: Int, absenceID: Int,indexPath:IndexPath) {
        if vacationId != 0 {
            if status == "approved" {
                let alert = UIAlertController(title: LocalizationKey.areYouSure.localizing(), message: LocalizationKey.doYouWantToApproveTheRequest.localizing(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
                    self.approveOrRejectVacationApi(id: "\(vacationId)", status: status,indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: LocalizationKey.areYouSure.localizing(), message: LocalizationKey.doYouWantToRejectTheRequest.localizing(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
                    self.approveOrRejectVacationApi(id: "\(vacationId)", status: status,indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if status == "approved" {
                let alert = UIAlertController(title: LocalizationKey.areYouSure.localizing(), message: LocalizationKey.doYouWantToApproveTheRequest.localizing(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
                    self.approveOrRejectAbsenceApi(id: "\(absenceID)", status: status, indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: LocalizationKey.areYouSure.localizing(), message: LocalizationKey.doYouWantToRejectTheRequest.localizing(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
                    self.approveOrRejectAbsenceApi(id: "\(absenceID)", status: status, indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension VacationAbsenceVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var searchText = txtsearch.text!
//        if let r = Range(range, in: searchText){
//            searchText.removeSubrange(r) // it will delete any deleted string.
//        }
        searchText.insert(contentsOf: string, at: searchText.index(searchText.startIndex, offsetBy: range.location)) // it will insert any text.
        print("searchText",searchText)
        filterAbsenceSearchName = searchText
            self.searchTask?.cancel()
            let task = DispatchWorkItem { [weak self] in
                if self?.vacationSegmentController.selectedSegmentIndex == 1 {
                    self?.abseanceList.removeAll()
                    GlobleVariables.page = 0
                    self?.absenceListApi(name: searchText)
                } else {
                    self?.pendingRequestList.removeAll()
                    GlobleVariables.page = 0
                    self?.pendingRequestListApi(name: searchText)
                }
            }
            self.searchTask = task
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
           return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


//MARK: APi Work in View controller
extension VacationAbsenceVC{
    private func vacationListApi(){
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        VacationAbsenceVM.shared.vacationList(parameters: param) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreVacation = true
            }else{
                self.isMoreVacation = false
            }
            for model in obj.rows ?? []{
                self.vacationList.append(model)
            }
            self.vacationAbsenceTblVw.reloadData()
        }
    }
    
    private func absenceListApi(name : String){
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        
        if (fromDate != "" && toDate != "") {
            param["filters"] = "{\"status\":\"\",\"name\":\"\(name)\",\"absence_type\":\"\(filterAbsenceType)\",\"fromDate\":\"\(fromDate)\",\"toDate\":\"\(toDate)\"}"
        } else if (fromDate != "" && toDate == "") {
            param["filters"] = "{\"status\":\"\",\"name\":\"\(name)\",\"absence_type\":\"\(filterAbsenceType)\",\"fromDate\":\"\(fromDate)\"}"
        } else if (fromDate == "" && toDate != "") {
            param["filters"] = "{\"status\":\"\",\"name\":\"\(name)\",\"absence_type\":\"\(filterAbsenceType)\",\"toDate\":\"\(toDate)\"}"
        } else {
            param["filters"] = "{\"status\":\"\",\"name\":\"\(name)\",\"absence_type\":\"\(filterAbsenceType)\"}"
        }

        print("absenceListApi is : ", param)
        
        
        VacationAbsenceVM.shared.absenceList(parameters: param) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreAbsence = true
            }else{
                self.isMoreAbsence = false
            }
            for model in obj.rows ?? []{
                self.abseanceList.append(model)
            }
            self.vacationAbsenceTblVw.reloadData()
        }
    }
    
    func vacationsUsersData() {
        var param = [String:Any]()
        
        AllUsersVM.shared.getVacationsUsersData(parameters: param, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in
            
            print(obj)
            employeePercent = obj.user?.employee_percent
            vacationsAbsenceYearlyData = (obj.user?.totals?.yearly)!
            self.vacationAbsenceTblVw.reloadData()
        }
    }
    
    private func pendingRequestCountApi(){
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"name\":\"\",\"module\":\"\"}"
        print("param is : ", param)
        
        VacationAbsenceVM.shared.pendingRequestList(parameters: param) { [self] obj in
            requestCount.text = obj.totalCount ?? 0 > 99 ? "99+" : "\(obj.totalCount ?? 0)"
            requestCountView.setNeedsLayout()
            requestCountView.layer.cornerRadius = requestCountView.frame.height/2
            requestCountView.layer.masksToBounds = true
            if requestCount.text == "0" {
                requestCountView.isHidden = true
            } else {
                requestCountView.isHidden = false
            }
        }
    }
    
    private func pendingRequestListApi(name : String){
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"name\":\"\(name)\",\"module\":\"\(selectedModule)\"}"
        print("param is : ", param)
        
        VacationAbsenceVM.shared.pendingRequestList(parameters: param) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMorePendingRequest = true
            }else{
                self.isMorePendingRequest = false
            }
            for model in obj.rows ?? []{
                self.pendingRequestList.append(model)
            }
//            requestCount.text = "\(obj.totalCount ?? 0)"
            requestCount.text = obj.totalCount ?? 0 > 99 ? "99+" : "\(obj.totalCount ?? 0)"
            if requestCount.text == "0" {
                requestCountView.isHidden = true
            } else {
                requestCountView.isHidden = false
            }
            self.vacationAbsenceTblVw.reloadData()
        }
    }
    
    func decreasePendingRequestCount() {
        var count = Int(requestCount.text ?? "1") ?? 1
        count = count - 1
        requestCount.text = count > 99 ? "99+" : "\(count)"
//        requestCount.text = "\(count)"
        if requestCount.text == "0" {
            requestCountView.isHidden = true
        } else {
            requestCountView.isHidden = false
        }
    }
    
    private func approveOrRejectVacationApi(id:String,status:String,indexPath:IndexPath){
        var param = [String:Any]()
        param["notes"] = status
        param["status"] = status
        VacationAbsenceVM.shared.approveOrRejectVacation(parameters: param, id: id) { [self] obj in
            if let index = pendingRequestList.firstIndex(where: {$0.id == Int(id)}) {
                if status == "approved" {
                    showAlert(message: LocalizationKey.vacationApprovedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        self.pendingRequestList.remove(at: index)
                        self.vacationAbsenceTblVw.deleteRows(at: [indexPath], with: .automatic)
                        self.decreasePendingRequestCount()
                    }
                } else {
                    showAlert(message: LocalizationKey.vacationRejectedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        self.pendingRequestList.remove(at: index)
                        self.vacationAbsenceTblVw.deleteRows(at: [indexPath], with: .automatic)
                        self.decreasePendingRequestCount()
                    }
                }
            }
        }
    }
    private func approveOrRejectAbsenceApi(id:String,status:String,indexPath:IndexPath){
        var param = [String:Any]()
        param["notes"] = status
        param["status"] = status
        VacationAbsenceVM.shared.approveOrRejectAbsence(parameters: param, id: id) { [self] obj in
            if let index = pendingRequestList.firstIndex(where: {$0.id == Int(id)}) {
                if status == "approved" {
                    showAlert(message: LocalizationKey.absenceApprovedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        self.pendingRequestList.remove(at: index)
                        self.vacationAbsenceTblVw.deleteRows(at: [indexPath], with: .automatic)
                        self.decreasePendingRequestCount()
                    }
                } else {
                    showAlert(message: LocalizationKey.absenceRejectedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        self.pendingRequestList.remove(at: index)
                        self.vacationAbsenceTblVw.deleteRows(at: [indexPath], with: .automatic)
                        self.decreasePendingRequestCount()
                    }
                }
            }
        }
    }
    
    private func deleteAbsence(id:Int, indexPath:IndexPath){
        var param = [String:Any]()
        VacationAbsenceVM.shared.deleteAbsence(parameters: param, id: id) { [self] obj in
            
            if let index = abseanceList.firstIndex(where: {$0.id == Int(id)}) {
                self.abseanceList.remove(at: index)
                self.vacationAbsenceTblVw.deleteRows(at: [indexPath], with: .automatic)
                self.vacationAbsenceTblVw.reloadData()
            }
        }
    }
    
    private func deleteVacation(id:Int, indexPath:IndexPath){
        var param = [String:Any]()
        VacationAbsenceVM.shared.deleteVacation(parameters: param, id: id) { [self] obj in
            
            if let index = vacationList.firstIndex(where: {$0.id == Int(id)}) {
                self.vacationList.remove(at: index)
                self.vacationAbsenceTblVw.deleteRows(at: [indexPath], with: .automatic)
                self.vacationAbsenceTblVw.reloadData()
            }
        }
    }
}

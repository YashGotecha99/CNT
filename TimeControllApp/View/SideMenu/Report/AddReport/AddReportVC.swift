//
//  AddReportVC.swift
//  TimeControllApp
//
//  Created by mukesh on 31/07/22.
//

import UIKit

class AddReportVC: BaseViewController {

    @IBOutlet weak var AddReportTitleLbl: UILabel!
    @IBOutlet weak var staticApprovedOnly: UILabel!
    @IBOutlet weak var staticShowWeekendHours: UILabel!
    @IBOutlet weak var staticShowByProjectName: UILabel!
    @IBOutlet weak var staticStartDate: UILabel!
    @IBOutlet weak var staticEndDate: UILabel!
    @IBOutlet weak var staticSelectProjectLbl: UILabel!
    
    @IBOutlet weak var approvedBtn: UIButton!
    @IBOutlet weak var showWeekendHoursBtn: UIButton!
    @IBOutlet weak var showByProjectBtn: UIButton!
    @IBOutlet weak var allMemberBtn: UIButton!
    @IBOutlet weak var startDateTxt: UITextField!
    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var endDateTxt: UITextField!
    @IBOutlet weak var endDateBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var selectedProjectView: UIView!
    @IBOutlet weak var selectedProjectLbl: UILabel!
    @IBOutlet weak var selectedProjectLocationLbl: UILabel!
    
    @IBOutlet weak var allMemberView: UIView!
    @IBOutlet weak var selectEmployeeView: UIView!
    @IBOutlet weak var selectedEmployeeView: UIView!
    @IBOutlet weak var selectedEmployeeLbl: UILabel!
    @IBOutlet weak var reportForAllEmpMessageView: UIView!
    @IBOutlet weak var staticReportForAllEmpLbl: UILabel!
    
    @IBOutlet weak var vwDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isApprovedOnly = false
    var isShowWeekendHours = false
    var isShowByProject = false
    var isAllMember = false
    
    var projectId = ""
    var projectName = "All"
    var employeeId = String()
    
    var selectedDate = ""
    
    var startDate = ""
    var endDate = ""
    @IBOutlet weak var staticSelectEmployeeLbl: UILabel!
    @IBOutlet weak var staticSelectedEmployeeLbl: UILabel!
    @IBOutlet weak var staticSelectedProjectLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        AddReportTitleLbl.text = LocalizationKey.employeePayrollReport.localizing()
        staticApprovedOnly.text = LocalizationKey.approvedOnly.localizing()
        staticShowWeekendHours.text = LocalizationKey.showWeekendHours.localizing()
        staticShowByProjectName.text = LocalizationKey.showByProjectName.localizing()
        staticStartDate.text = LocalizationKey.startDate.localizing()
        staticEndDate.text = LocalizationKey.endDate.localizing()
        staticSelectProjectLbl.text = LocalizationKey.all.localizing()
        staticSelectEmployeeLbl.text = LocalizationKey.selectEmployee.localizing()
        staticSelectedEmployeeLbl.text = LocalizationKey.selected.localizing()
        staticSelectedProjectLbl.text = LocalizationKey.selected.localizing()
        staticReportForAllEmpLbl.text = LocalizationKey.reportForAllEmployeesCanBeTooBigWeRecommendToSelectOneEmployeeAtATimeAndTry.localizing()
        applyBtn.setTitle(LocalizationKey.apply.localizing(), for: .normal)

        // Do any additional setup after loading the view.
    }
    
    func configUI(){
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            allMemberView.isHidden = true
            selectEmployeeView.isHidden = true
        } else {
            allMemberView.isHidden = false
            selectEmployeeView.isHidden = false
        }
        selectedProjectView.isHidden = true
        selectedEmployeeView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwDatePicker.addGestureRecognizer(tap)
        vwDatePicker.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        let formatDate = DateFormatter()
        formatDate.dateFormat = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format
        
        let startDateString = Date().startOfMonth
        let endDateString = Date()
        startDateTxt.text =  formatDate.string(from: startDateString)
        endDateTxt.text = formatDate.string(from: endDateString)
        
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        startDate = serverDateFormatter.string(from: Date().startOfMonth)
        endDate = serverDateFormatter.string(from: Date())

        isApprovedOnly = true
        approvedBtn.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    func chooseDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let chooseDate = dateFormatter.string(from: datePicker.date)
    
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        let serverDate = serverDateFormatter.string(from: datePicker.date)
        
        if selectedDate == "startDate" {
            if chooseDate > endDateTxt.text ?? dateFormatter.string(from: Date()) {
                startDateTxt.text = chooseDate
                endDateTxt.text = chooseDate
                startDate = serverDate
                endDate = serverDate
            } else {
                startDateTxt.text = chooseDate
                startDate = serverDate
            }
            
        } else {
            if chooseDate < startDateTxt.text ?? dateFormatter.string(from: Date()) {
                presentAlert(withTitle: "Error", message: LocalizationKey.fromDateMustBeLessThenToDate.localizing())
            } else {
                endDateTxt.text = chooseDate
                endDate = serverDate
                let fromDate = dateFormatter.date(from: startDateTxt.text ?? dateFormatter.string(from: Date()))
            }
        }
        vwDatePicker.isHidden = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        vwDatePicker.isHidden = true
    }
    
    @IBAction func btnApply(_ sender: Any) {
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            getReportApi()
        } else {
            if isAllMember {
                getReportApi()
            } else {
                if employeeId == ""  {
                    self.showAlert(message: LocalizationKey.pleaseSelectEmployee.localizing(), strtitle: LocalizationKey.alert.localizing())
                    return
                }
                getReportApi()
            }
        }
    }
    
    @IBAction func btnSelectEmployeeAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectEmplyeeVC") as! SelectEmplyeeVC
        vc.delegate = self
        vc.isComingFrom = "AddReportVC"
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnProjectNameAction(_ sender: UIButton) {
        
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectProjectVC") as! SelectProjectVC
        vc.mode = "no-acl"
        vc.module = "no-module"
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func approvedBtn(_ sender: Any) {
        if isApprovedOnly {
            isApprovedOnly = false
            approvedBtn.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            isApprovedOnly = true
            approvedBtn.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
    }
    @IBAction func showWeekendHoursBtn(_ sender: Any) {
        if isShowWeekendHours {
            isShowWeekendHours = false
            showWeekendHoursBtn.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            isShowWeekendHours = true
            showWeekendHoursBtn.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
    }
    @IBAction func showByProjectBtn(_ sender: Any) {
        if isShowByProject {
            isShowByProject = false
            showByProjectBtn.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            isShowByProject = true
            showByProjectBtn.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
    }
    @IBAction func allMemberBtn(_ sender: Any) {
        if isAllMember {
            isAllMember = false
            allMemberBtn.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            isAllMember = true
            allMemberBtn.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
    }
    @IBAction func startDateBtn(_ sender: Any) {
        selectedDate = "startDate"
        vwDatePicker.isHidden = false
    }
    @IBAction func endDateBtn(_ sender: Any) {
        selectedDate = "endDate"
        vwDatePicker.isHidden = false
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        chooseDate()
    }
    
    @IBAction func btnCancelAction(_ sender: UIBarButtonItem) {
        vwDatePicker.isHidden = true
    }
    
}

//MARK: Delegate
extension AddReportVC : SelectProjectProtocol,SelectEmployeeProtocol {
    
    func projectId(projectId: String, projectName: String) {
        selectedProjectView.isHidden = false
        selectedProjectLbl.text = "\(projectId) | \(projectName)"
        self.projectId = projectId
        self.projectName = projectName
    }
    
    func employeeId(empId: String, empName: String) {
        selectedEmployeeView.isHidden = false
        reportForAllEmpMessageView.isHidden = true
//        selectedEmployeeLbl.text = "\(empId) | \(empName)"
        selectedEmployeeLbl.text = empName
        self.employeeId = empId
    }
}

extension AddReportVC {
    
    func getReportApi() -> Void {
        var startOfWeekDate = Date().startOfWeek
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        let serverStartOfWeekDate = serverDateFormatter.string(from: startOfWeekDate)
        
        
        var param = [String:Any]()
        
        param["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        param["mode"] = "employee_project"
        param["mail"] = false
        param["all_members"] = isAllMember
        param["excel"] = false
        param["zirius"] = false
        param["users"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm" ? isAllMember ? "" : employeeId : UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        param["email"] = ""
        param["approved_only"] = isApprovedOnly
        param["project"] = projectId
        param["gps"] = nil
        param["consider_overtime"] = true
        param["projectname"] = projectName
        param["start"] = startDate
        param["end"] = endDate
        param["weekStart"] = serverStartOfWeekDate
        param["include_images"] = true
        param["include_extra"] = true
        param["include_extra_images"] = nil
        param["include_distance"] = nil
        param["include_travel_expenses"] = nil
        param["include_other_expenses"] = nil
        param["include_weekend_hours"] = isShowWeekendHours
        param["include_missing_hours"] = false
        param["is_project_mode"] = isShowByProject
        param["preview"] = true
        param["authorization"] = UserDefaults.standard.string(forKey: UserDefaultKeys.token)
        
        var strUrl = String()
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.sendReport as NSString)
        
        // Create URL components
        var urlComponents = URLComponents(string: strUrl)

        // Create an array to store the query items
        var queryItems = [URLQueryItem]()

        // Iterate over the parameters dictionary
        for (key, value) in param {
            // Create a query item with the parameter key and value
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            // Add the query item to the array
            queryItems.append(queryItem)
        }

        // Set the query items of the URL components
        urlComponents?.queryItems = queryItems

        // Get the updated URL string with the query parameters
        if let updatedUrlString = urlComponents?.url?.absoluteString {
            strUrl = updatedUrlString
        }
        print("strUrl",strUrl)
        
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ShowReportVC") as! ShowReportVC
        vc.strUrl = strUrl
        vc.getParamData = param
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

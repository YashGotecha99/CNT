//
//  addTasksVC.swift
//  TimeControllApp
//
//  Created by mukesh on 28/07/22.
//

import UIKit
import CoreLocation

protocol TasksVCDelegate: AnyObject {
    func checkSegmentIndex(segmentIndex: Int)
}

class AddTasksVC: BaseViewController, SelectProjectProtocol, TaskMapVCProtocol {
    
    @IBOutlet weak var addTaskTitleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var taskInfoLbl: UILabel!
    @IBOutlet weak var projectLbl: UILabel!
    @IBOutlet weak var taskNameLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var normalLbl: UILabel!
    @IBOutlet weak var urgentLbl: UILabel!
    @IBOutlet weak var criticalLbl: UILabel!
    @IBOutlet weak var taskInfo2Lbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var zipCodeLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var commentsLbl: UILabel!
    @IBOutlet weak var costAndExpenseLbl: UILabel!
    @IBOutlet weak var dailyLbl: UILabel!
    @IBOutlet weak var weeklyLbl: UILabel!
    @IBOutlet weak var monthlyLbl: UILabel!
    @IBOutlet weak var estimatedHoursLbl: UILabel!
    
    @IBOutlet weak var txtProjectName: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtLeaveNumber: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var txvDescription: UITextView!
    
    @IBOutlet weak var txtEstimatedHours: UITextField!
    
    @IBOutlet weak var btnNormal: UIButton!
    
    @IBOutlet weak var btnUrgent: UIButton!
    
    @IBOutlet weak var btnCritical: UIButton!
    
    @IBOutlet weak var btnMonthly: UIButton!
    
    @IBOutlet weak var btnWeekly: UIButton!
    
    @IBOutlet weak var btnDaily: UIButton!
    
    var lat = Double()
    var long = Double()
    
    var projectId = String()
    var estwork = "daily"
    var prority = "Normal"
    var currentCorrdinate = CLLocationCoordinate2D()
    var isComingFrom = String()
    var taskID = Int()
    
    @IBOutlet weak var criticalVv: UIView!
    @IBOutlet weak var normalStatusLbl: UILabel!
    @IBOutlet weak var urgentStatusLbl: UILabel!
    var selectedSegmmentIndex = Int()

    weak var delegate : TasksVCDelegate?
    @IBOutlet weak var autoLocateBtnObj: UIButton!
    
    var gpsData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isComingFrom == "StartHours" || isComingFrom == "AddTask") {
            criticalVv.isHidden = true
            normalStatusLbl.text = LocalizationKey.active.localizing()
            urgentStatusLbl.text = LocalizationKey.inactive.localizing()
            prority = "active"
            
            btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            
            btnDaily.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnWeekly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnMonthly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        } else if (isComingFrom == "TasksDetails") {
            criticalVv.isHidden = true
            normalStatusLbl.text = LocalizationKey.active.localizing()
            urgentStatusLbl.text = LocalizationKey.inactive.localizing()
            getTaskDetailsAPI(taskID: "\(taskID)")
        }
        else {
            criticalVv.isHidden = false
            normalStatusLbl.text = LocalizationKey.normal.localizing()
            urgentStatusLbl.text = LocalizationKey.urgent.localizing()
            prority = "Normal"
            
            btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            
            
            btnDaily.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnWeekly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnMonthly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        setUpLocalization()
        hitprojectsApi()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        addTaskTitleLbl.text = LocalizationKey.addTask.localizing()
        taskInfoLbl.text = LocalizationKey.taskInfo.localizing()
        projectLbl.text = LocalizationKey.project.localizing()
        txtProjectName.placeholder = LocalizationKey.selectProject.localizing()
        taskNameLbl.text = LocalizationKey.taskName.localizing()
        txtName.placeholder = LocalizationKey.enterTaskName.localizing()
        numberLbl.text = LocalizationKey.number.localizing()
        txtLeaveNumber.placeholder = LocalizationKey.leaveTheFieldToBeFilledAutomatically.localizing()
        taskInfo2Lbl.text = LocalizationKey.taskInfo.localizing()
        autoLocateBtnObj.setTitle(LocalizationKey.getCurrentLocation.localizing(), for: .normal)
        addressLbl.text = LocalizationKey.address.localizing()
        txtAddress.placeholder = LocalizationKey.enterAddress.localizing()
        zipCodeLbl.text = LocalizationKey.zipCode.localizing()
        txtZipCode.placeholder = LocalizationKey.postNumber.localizing()
        cityLbl.text = LocalizationKey.city.localizing()
        txtCity.placeholder = LocalizationKey.postPlace.localizing()
        commentsLbl.text = LocalizationKey.comments.localizing()
        costAndExpenseLbl.text = LocalizationKey.costAndExpenses.localizing()
        dailyLbl.text = LocalizationKey.daily.localizing()
        weeklyLbl.text = LocalizationKey.weekly.localizing()
        monthlyLbl.text = LocalizationKey.monthly.localizing()
        estimatedHoursLbl.text = LocalizationKey.estimatedHours.localizing()
        txtEstimatedHours.placeholder = LocalizationKey.enterEstimatedHours.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
    }
    
    func projectId(projectId: String, projectName: String) {
        self.txtProjectName.text = projectName
        self.projectId = projectId
    }
    

    //MARK: Button Actions
      @IBAction func btnBackAction(_ sender: UIButton) {
          delegate?.checkSegmentIndex(segmentIndex: selectedSegmmentIndex)
          self.navigationController?.popViewController(animated: true)
      }
    
    @IBAction func btnGpsAction(_ sender: UIButton) {
        let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "TaskMapVC") as! TaskMapVC
        vc.lat = String(currentCorrdinate.latitude)
        vc.long = String(currentCorrdinate.longitude)
        vc.isMapFrom = "AddTasks"
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
      
      
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if (txtName.text == "") {
            self.showAlert(message: LocalizationKey.enterTaskName.localizing(), strtitle: "")
        }
        else if (txtAddress.text == "") {
            self.showAlert(message: LocalizationKey.enterTheAddess.localizing(), strtitle: "")
        }
        else if (txtZipCode.text == "") {
            self.showAlert(message: LocalizationKey.enterTheZipcode.localizing(), strtitle: "")
        }
        else if (txtCity.text == "") {
            self.showAlert(message: LocalizationKey.enterTheCity.localizing(), strtitle: "")
        }
        else if (txvDescription.text == "") {
            self.showAlert(message: LocalizationKey.enterTheComment.localizing(), strtitle: "")
        }
//        else if (txtEstimatedHours.text == "") {
//            self.showAlert(message: LocalizationKey.enterTheEstimatedWorkHour.localizing(), strtitle: "")
//        }
        else {
            if (isComingFrom == "TasksDetails") {
                updateTaskAPI(taskID: "\(taskID)")
            } else if (isComingFrom == "AddTask") {
                addTaskApi()
            } else {
                addTaskApi()
            }
        }
    }
    
    
    @IBAction func btnSelectProjectAction(_ sender: UIButton) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectProjectVC") as! SelectProjectVC
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            vc.mode = "managers"
            vc.module = "no-module"
        } else {
            vc.mode = "members"
            vc.module = "no-module"
        }
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnNormalAction(_ sender: UIButton) {
        if (isComingFrom == "StartHours" || isComingFrom == "TasksDetails" || isComingFrom == "AddTask") {
            prority = "active"
            btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        else {
            prority = "Normal"
            btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
    }
    
    @IBAction func btnUrgentAction(_ sender: UIButton) {
        if (isComingFrom == "StartHours" || isComingFrom == "TasksDetails" || isComingFrom == "AddTask") {
            prority = "inactive"
            btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        else {
            prority = "Urgent"
            btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
    }
    
    @IBAction func btnCriticalAction(_ sender: UIButton) {
        prority = "Critical"
        btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnCritical.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
    }
    
    //MARK: estWork
    @IBAction func btnDailyAction(_ sender: UIButton) {
         estwork = "daily"
        btnDaily.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnWeekly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnMonthly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        
    }
    
    @IBAction func btnWeeklyAction(_ sender: UIButton) {
        estwork = "weekly"
        btnDaily.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnWeekly.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnMonthly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    
    @IBAction func btnMonthlyAction(_ sender: UIButton) {
        estwork = "monthly"
        btnDaily.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnWeekly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnMonthly.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
    }
    
    func getLatLong(lat: Double, long: Double, addressMap: String, postalCode: String, cityName: String) {
        self.lat = lat
        self.long = long
        txtZipCode.text = postalCode
        txtCity.text = cityName
        txtAddress.text = addressMap
        gpsData = "\(lat),\(long)"
    }
}

//MARK: UITextField Delegate

extension AddTasksVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if txtAddress.text?.count ?? 0 > 3 && txtZipCode.text?.count ?? 0 > 3 && txtCity.text?.count ?? 0 > 3 && txtAddress.text != "" && txtZipCode.text != "" && txtCity.text != "" {
            let address = (txtAddress.text ?? "") + "," + (txtZipCode.text ?? "") + "," + (txtCity.text ?? "")
            getGPSLocationFromAddress(address: address)
        }
        return true
    }
}


extension AddTasksVC {
    
    func getTaskDetailsAPI(taskID: String) {
        var param = [String:Any]()
        WorkHourVM.shared.workGetTaskApi(parameters: param, id: taskID, isAuthorization: true) { [self] obj in
            //            self.taskDetails = obj.task
            
            self.txtProjectName.text = obj.task?.project?.name
            self.txtName.text = obj.task?.name
            let taskNumber = obj.task?.task_number ?? 0
            self.txtLeaveNumber.text = String(format: "%d", taskNumber)
            self.txtAddress.text = obj.task?.address
            self.txtZipCode.text = obj.task?.post_number
            self.txtCity.text = obj.task?.post_place
            self.txvDescription.text = obj.task?.description
            let estHours = obj.task?.est_hours ?? 0
            self.txtEstimatedHours.text = String(format: "%d", estHours)
            
            if (obj.task?.status) == "active" {
                btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
                btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            } else {
                btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
                btnUrgent.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            }
            
            if (obj.task?.est_work == "Daily" || obj.task?.est_work == "daily") {
                btnDaily.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
                btnWeekly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
                btnMonthly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            } else if (obj.task?.est_work == "Weekly" || obj.task?.est_work == "weekly") {
                btnDaily.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
                btnWeekly.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
                btnMonthly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            } else {
                btnDaily.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
                btnWeekly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
                btnMonthly.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            }
            prority = obj.task?.status ?? "active"
            estwork = obj.task?.est_work ?? "daily"
            let projectID = obj.task?.project?.id
            self.projectId = String(format: "%d", projectID!)
        }
    }
    
    func getGPSLocationFromAddress(address : String) {
        var dataParam = [String:Any]()
        dataParam["address"] = address
        print(dataParam)
        
        AllUsersVM.shared.getGPSLocationAddress(parameters: dataParam, isAuthorization: true) { [self] obj in
            print(obj)
            gpsData = obj.result ?? ""
//            gpsLocationTxt.text = obj.result
        }
    }
    
    func addTaskApi() {
        
        var param = [String:Any]()
        var members = [[String:Any]]()
        var memberDetails = [String:Any]()
        memberDetails["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? ""
        members.append(memberDetails)
        
        var data = [String:Any]()
        
        data["require_hms"] =  true
        data["security_analyze"] = false
        data["addressCache"] = "\(self.txtAddress.text ?? ""), \(self.txtCity.text ?? ""), \(self.txtZipCode.text ?? "")"
        
        param["status"] = prority
        param["est_work"] = estwork
        param["est_hours"] = self.txtEstimatedHours.text
        //param["b_nr"] = self.txtnr.text
        //   param["g_nr"] = self.txtFr.text
        
//        param["members"] = members
        param["data"] = data
        
        //      param["assignee_id"] = 3
        param["name"] = self.txtName.text
        //  param["start_time"] = 480
        //     param["end_time"] = 1020
        //    param["scheduled_days"] = "0,1,2,3,4"
        param["project_id"] = self.projectId
        param["address"] = self.txtAddress.text
        param["post_place"] = self.txtCity.text
        
        param["gps_data"] = gpsData
        param["post_number"] = self.txtZipCode.text
        param["description"] = self.txvDescription.text
        param["assignee_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? ""
        //        param["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? ""
        
        print(param)
        WorkHourVM.shared.addTasksApi(parameters: param, isAuthorization: true) { [self] obj in
            
            print(obj.message)
            delegate?.checkSegmentIndex(segmentIndex: selectedSegmmentIndex)
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func hitprojectsApi() -> Void {
        
        var param = [String:Any]()
        WorkHourVM.shared.workprojectsApi(parameters: param, isAuthorization: true) { [self] obj in
            
            self.txtProjectName.text = obj.rows?.first?.name ?? ""
            
            self.projectId = "\(obj.rows?.first?.id ?? 0)"
            
        }
    }
    
    func updateTaskAPI(taskID: String) {
        
        var param = [String:Any]()
        
        param["status"] = prority
        param["est_work"] = estwork
        param["est_hours"] = self.txtEstimatedHours.text
        
        param["name"] = self.txtName.text
        param["project_id"] = self.projectId
        param["address"] = self.txtAddress.text
        param["post_place"] = self.txtCity.text
        
        param["gps_data"] = "\(lat),\(long)"
        param["post_number"] = self.txtZipCode.text
        param["description"] = self.txvDescription.text
//        param["assignee_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? ""
        param["task_number"] = self.txtLeaveNumber.text

        print(param)
        
        WorkHourVM.shared.updateTaskApi(parameters: param, id: taskID, isAuthorization: true) { [self] obj in
            
            showAlert(message: LocalizationKey.yourTaskUpdated.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.delegate?.checkSegmentIndex(segmentIndex: self.selectedSegmmentIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func addTaskAPI() {
        
        var param = [String:Any]()
        
        param["status"] = prority
        param["est_work"] = estwork
        param["est_hours"] = self.txtEstimatedHours.text
        
        param["name"] = self.txtName.text
        param["project_id"] = self.projectId
        param["address"] = self.txtAddress.text
        param["post_place"] = self.txtCity.text
        
        param["gps_data"] = "\(lat),\(long)"
        param["post_number"] = self.txtZipCode.text
        param["description"] = self.txvDescription.text
        param["assignee_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? ""
        param["task_number"] = self.txtLeaveNumber.text
        
        print(param)
        
        WorkHourVM.shared.addTaskApi(parameters: param, isAuthorization: true) { [self] obj in
            
            showAlert(message: LocalizationKey.yourTaskCreated.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                delegate?.checkSegmentIndex(segmentIndex: selectedSegmmentIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

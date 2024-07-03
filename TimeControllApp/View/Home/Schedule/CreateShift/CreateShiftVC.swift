//
//  CreateShiftVC.swift
//  TimeControllApp
//
//  Created by mukesh on 07/08/22.
//

import UIKit
import SVProgressHUD

class CreateShiftVC: BaseViewController {
    
    
    @IBOutlet weak var vwTimePicker: UIView!
    @IBOutlet weak var vwDatePicker: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var toDateTxtField: UITextField!
    @IBOutlet weak var fromDateTxtField: UITextField!
    @IBOutlet weak var startTimeTxtField: UITextField!
    @IBOutlet weak var endTimeTxtField: UITextField!
    @IBOutlet weak var btnAddBonus: UIButton!
    @IBOutlet weak var btnNotifyUser: UIButton!
    
    
    @IBOutlet weak var selectedProjectView: UIView!
    @IBOutlet weak var selectedTaskView: UIView!
    @IBOutlet weak var selectedEmployeeView: UIView!
    @IBOutlet weak var selectedGroupView: UIView!
    
    @IBOutlet weak var selectedProjectLbl: UILabel!
    @IBOutlet weak var selectedProjectLocationLbl: UILabel!
    @IBOutlet weak var selectedTaskLbl: UILabel!
    @IBOutlet weak var selectedTaskLocationLbl: UILabel!
    @IBOutlet weak var selectedEmployeeLbl: UILabel!
    @IBOutlet weak var selectedGroupLbl: UILabel!
    
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var messageImg: UIImageView!
    
    @IBOutlet weak var commentTV: UITextView!
    @IBOutlet weak var createShiftTitleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var staticDateLbl: UILabel!
    @IBOutlet weak var staticEndDateLbl: UILabel!
    @IBOutlet weak var staticSelectProject: UILabel!
    @IBOutlet weak var staticSelectTask: UILabel!
    @IBOutlet weak var staticSelectEmployeeLbl: UILabel!
    @IBOutlet weak var staticSelectGroup: UILabel!
    @IBOutlet weak var staticFromLbl: UILabel!
    @IBOutlet weak var staticToLbl: UILabel!
    @IBOutlet weak var staticCommentLbl: UILabel!
    @IBOutlet weak var staticAddBonusLbl: UILabel!
    @IBOutlet weak var staticNotifyUserLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var cancelTimeBtn: UIBarButtonItem!
    @IBOutlet weak var doneTimeBtn: UIBarButtonItem!
    
    
    var selectedDate = ""
    var selectedTime = ""
    var projectId = String()
    var employeeId = String()
    var taskId = String()
    var groupId = -1
    var isAddBonus = false
    var isNotifyUser = false
    
    var isSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        createShiftTitleLbl.text = LocalizationKey.createShift.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        cancelBtn.title = LocalizationKey.cancel.localizing()
        doneBtn.title = LocalizationKey.done.localizing()
        cancelTimeBtn.title = LocalizationKey.cancel.localizing()
        doneTimeBtn.title = LocalizationKey.done.localizing()
        
        staticDateLbl.text = LocalizationKey.date.localizing()
        staticEndDateLbl.text = LocalizationKey.endDate.localizing()
        fromDateTxtField.placeholder = LocalizationKey.selectDate.localizing()
        toDateTxtField.placeholder = LocalizationKey.endDate.localizing()
        staticSelectProject.text = LocalizationKey.selectProject.localizing()
        staticSelectTask.text = LocalizationKey.taskName.localizing()
        staticSelectEmployeeLbl.text = LocalizationKey.selectEmployee.localizing()
        
        staticFromLbl.text = LocalizationKey.from.localizing()
        staticToLbl.text = LocalizationKey.to.localizing()
        startTimeTxtField.placeholder = LocalizationKey.from.localizing()
        endTimeTxtField.text = LocalizationKey.to.localizing()
        staticCommentLbl.text = LocalizationKey.comment.localizing()
        staticAddBonusLbl.text = LocalizationKey.addBonus.localizing()
        staticNotifyUserLbl.text = LocalizationKey.notifyUser.localizing()
        
        messageLbl.text = LocalizationKey.thankYouForSwappingTradingTheShiftTheEmployeesHasBeenInformedPleaseWaitForTheAcceptance.localizing()
    }
    
    //MARK: Functions
    
    func configUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwDatePicker.addGestureRecognizer(tap)
        let timePicker = UITapGestureRecognizer(target: self, action: #selector(self.timePickerTap(_:)))
        vwTimePicker.addGestureRecognizer(timePicker)
        
        vwDatePicker.isHidden = true
        vwTimePicker.isHidden = true
        selectedProjectView.isHidden = true
        selectedTaskView.isHidden = true
        selectedEmployeeView.isHidden = true
        selectedGroupView.isHidden = true
        
        datePicker.minimumDate = Date()
    }
    
    func chooseDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let chooseDate = dateFormatter.string(from: datePicker.date)
        
        if selectedDate == "fromDate" {
            fromDateTxtField.text = chooseDate
        } else {
            toDateTxtField.text = chooseDate
        }
        vwDatePicker.isHidden = true
    }
    
    func chooseTime(){
        
        let fmt = DateFormatter()
        fmt.dateFormat = "H:mm"
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "H:mm" //"h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        
        if let selectPickerDate = formatter.string(for: timePicker.date) {
            
            print(selectPickerDate)
            
            if selectedTime == "startTime" {
                startTimeTxtField.text = selectPickerDate
            } else {
                endTimeTxtField.text = selectPickerDate
            }
        }
        vwTimePicker.isHidden = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        vwDatePicker.isHidden = true
    }
    
    
    @objc func timePickerTap(_ sender: UITapGestureRecognizer? = nil) {
        
        vwTimePicker.isHidden = true
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
    
    @IBAction func btnSelectEmployeeAction(_ sender: Any) {
        if self.projectId.isEmpty || self.projectId == "0" {
            return
        }
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectEmplyeeVC") as! SelectEmplyeeVC
        vc.delegate = self
        vc.projectId = projectId
        vc.isComingFrom = "CreateShiftVC"
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func btnTaskNameAction(_ sender: Any) {
        if self.projectId.isEmpty || self.projectId == "0" {
            return
        }
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectTasksVC") as! SelectTasksVC
        vc.delegate = self
        vc.projectId = projectId
        vc.isComingFrom = "CreateShiftVC"
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnGroupNameAction(_ sender: UIButton) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectGroupVC") as! SelectGroupVC
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
    
    @IBAction func startTimePickerBtnAction(_ sender: Any) {
        selectedTime = "startTime"
        vwTimePicker.isHidden = false
    }
    
    @IBAction func endTimePickerBtnAction(_ sender: Any) {
        selectedTime = "endTime"
        vwTimePicker.isHidden = false
    }
    @IBAction func doneBtnTimeAction(_ sender: Any) {
        chooseTime()
    }
    @IBAction func cancelBtnTimeAction(_ sender: Any) {
        vwTimePicker.isHidden = true
    }
    @IBAction func btnAddBonusAction(_ sender: Any) {
        if isAddBonus {
            isAddBonus = false
            btnAddBonus.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            isAddBonus = true
            btnAddBonus.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
    }
    @IBAction func btnNotifyUserAction(_ sender: Any) {
        if isNotifyUser {
            isNotifyUser = false
            btnNotifyUser.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            isNotifyUser = true
            btnNotifyUser.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
    }
    
    @IBAction func bottomCrossBtnAction(_ sender: Any) {
        self.bottomSheetView.isHidden = true
        if isSuccess {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func converTimeToMinutes (time:String) -> Int {
        let time = time
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        
        let date = formatter.date(from: time)
        let calendar = Calendar(identifier: .gregorian)

        var currentDateComponent = calendar.dateComponents([.hour, .minute], from: date!)
        let numberOfMinutes = (currentDateComponent.hour! * 60) + currentDateComponent.minute!
         
        return numberOfMinutes
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if (fromDateTxtField.text == "") {
            messageLbl.text = LocalizationKey.pleaseSelectStartDate.localizing()
            messageImg.image = UIImage(named: "reject")
            isSuccess = false
            self.bottomSheetView.isHidden = false
        }
//        else if (toDateTxtField.text == "") {
//            messageLbl.text = LocalizationKey.pleaseSelectEndDate.localizing()
//            messageImg.image = UIImage(named: "reject")
//            isSuccess = false
//            self.bottomSheetView.isHidden = false
//        }
        else if (self.projectId == "") {
            messageLbl.text = LocalizationKey.pleaseSelectProject.localizing()
            messageImg.image = UIImage(named: "reject")
            isSuccess = false
            self.bottomSheetView.isHidden = false
        }
        else if (self.taskId == "") {
            messageLbl.text = LocalizationKey.selectTask.localizing()
            messageImg.image = UIImage(named: "reject")
            isSuccess = false
            self.bottomSheetView.isHidden = false
        }
        else if (self.employeeId == "") {
            messageLbl.text = LocalizationKey.pleaseSelectEmployee2.localizing()
            messageImg.image = UIImage(named: "reject")
            isSuccess = false
            self.bottomSheetView.isHidden = false
        }
        else if (startTimeTxtField.text == "") {
            messageLbl.text = LocalizationKey.pleaseSelectStartTime.localizing()
            messageImg.image = UIImage(named: "reject")
            isSuccess = false
            self.bottomSheetView.isHidden = false
        }
        else if (endTimeTxtField.text == "") {
            messageLbl.text = LocalizationKey.pleaseSelectEndTime.localizing()
            messageImg.image = UIImage(named: "reject")
            isSuccess = false
            self.bottomSheetView.isHidden = false
        }
//        else if (commentTV.text == "") {
//            messageLbl.text = LocalizationKey.pleaseEnterComment.localizing()
//            messageImg.image = UIImage(named: "reject")
//            isSuccess = false
//            self.bottomSheetView.isHidden = false
//        }
        else {
            createShiftAPI()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: Delegate
extension CreateShiftVC : SelectProjectProtocol,SelectEmployeeProtocol,AddTaskProjectNameProtocol,SelectGroupProtocol {
    func employeeId(empId: String, empName: String) {
        selectedEmployeeView.isHidden = false
//        selectedEmployeeLbl.text = "\(empId) | \(empName)"
        selectedEmployeeLbl.text = empName
        self.employeeId = empId
    }
    
    func projectId(projectId: String, projectName: String) {
        selectedProjectView.isHidden = false
        selectedProjectLbl.text = "\(projectId) | \(projectName)"
        self.projectId = projectId
        
        selectedEmployeeView.isHidden = true
        selectedTaskView.isHidden = true
        self.employeeId = ""
        self.taskId = ""
    }
    
    func getTaskProjectName(projectId: String, taskId: String) {
        selectedTaskView.isHidden = false
        selectedTaskLbl.text = "\(taskId) | \(projectId)"
        self.taskId = taskId
    }
    
    func groupId(groupId: String, groupName: String) {
        selectedGroupView.isHidden = false
        selectedGroupLbl.text = "\(groupId) | \(groupName)"
        self.groupId = Int(groupId) ?? -1
    }
}

//MARK: APi Work in View controller
extension CreateShiftVC{
    
    func createShiftAPI() {
        SVProgressHUD.show()
        var param = [String:Any]()
        param["assignee_id"] = employeeId
        param["comment"] = commentTV.text
        var data = [String:Any]()
        data["addBonus"] = isAddBonus
        param["data"] = data
        
        param["do_notify"] = isNotifyUser
        param["end_date"] = toDateTxtField.text
        param["end_time"] = converTimeToMinutes(time: endTimeTxtField.text ?? "")
        param["for_date"] = fromDateTxtField.text
        param["project_id"] = projectId
        param["start_time"] = converTimeToMinutes(time: startTimeTxtField.text ?? "")
        param["status"] = "pending"
        param["task_id"] = taskId
        param["user_group"] = groupId
        
        print(param)
        
        ScheduleListVM.shared.createShiftAPI(parameters: param, isAuthorization: true) { [self] obj in
            print("Create swift : ", obj)
            messageLbl.text = LocalizationKey.scheduleCreatedSuccessfully.localizing()
            messageImg.image = UIImage(named: "accept")
            isSuccess = true
            self.bottomSheetView.isHidden = false
        }
    }
}

//
//  AddChecklistVC.swift
//  TimeControllApp
//
//  Created by mukesh on 31/07/22.
//

import UIKit

class AddChecklistVC: BaseViewController {

    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnWeek: UIButton!
    @IBOutlet weak var btnGap: UIButton!
    @IBOutlet weak var btnMonthly: UIButton!
    @IBOutlet weak var btnHalfYearly: UIButton!
    @IBOutlet weak var btnAnnually: UIButton!
    @IBOutlet weak var btnNone: UIButton!
    
    
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var gapView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var halfYearlyView: UIView!
    @IBOutlet weak var annuallyView: UIView!
    
    @IBOutlet weak var weekHeight: NSLayoutConstraint!
    @IBOutlet weak var gapHeight: NSLayoutConstraint!
    @IBOutlet weak var monthlyHeight: NSLayoutConstraint!
    @IBOutlet weak var halfYearlyHeight: NSLayoutConstraint!
    @IBOutlet weak var annuallyHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnSun: UIButton!
    @IBOutlet weak var btnMon: UIButton!
    @IBOutlet weak var btnTue: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    @IBOutlet weak var btnThu: UIButton!
    @IBOutlet weak var btnFri: UIButton!
    @IBOutlet weak var btnSat: UIButton!
    
    @IBOutlet weak var lblProjectName: UILabel!
    
    @IBOutlet weak var selectedProjectView: UIView!
    @IBOutlet weak var selectedChecklistView: UIView!
    @IBOutlet weak var selectedEmployeeView: UIView!
    
    @IBOutlet weak var selectedProjectLbl: UILabel!
    @IBOutlet weak var selectedProjectLocationLbl: UILabel!
    @IBOutlet weak var selectedChecklistLbl: UILabel!
    @IBOutlet weak var selectedChecklistLocationLbl: UILabel!
    @IBOutlet weak var selectedEmployeeLbl: UILabel!
    
    @IBOutlet weak var obligatorySwitch: UISwitch!
    @IBOutlet weak var sendEmailSwitch: UISwitch!
    @IBOutlet weak var allowCheckAllSwitch: UISwitch!
    
    @IBOutlet weak var gapBetweenTxt: UITextField!
    @IBOutlet weak var monthlyTxt: UITextField!
    @IBOutlet weak var halfYearlyTxt: UITextField!
    @IBOutlet weak var annuallyTxt: UITextField!
    
    @IBOutlet weak var checklistTitleLbl: UILabel!
    @IBOutlet weak var staticSelectProjectLbl: UILabel!
    @IBOutlet weak var staticSelectChecklistLbl: UILabel!
    @IBOutlet weak var staticSelectEmployeeLbl: UILabel!
    @IBOutlet weak var staticObligatoryLbl: UILabel!
    @IBOutlet weak var staticSendEmialLbl: UILabel!
    @IBOutlet weak var staticAllowCheckAllLbl: UILabel!
    @IBOutlet weak var staticScheduleLbl: UILabel!
    @IBOutlet weak var staticAllWorkingDaysLbl: UILabel!
    @IBOutlet weak var staticWeekDaysLbl: UILabel!
    @IBOutlet weak var staticSunLbl: UILabel!
    @IBOutlet weak var staticMonLbl: UILabel!
    @IBOutlet weak var staticTueLbl: UILabel!
    @IBOutlet weak var staticWedLbl: UILabel!
    @IBOutlet weak var staticThuLbl: UILabel!
    @IBOutlet weak var staticFriLbl: UILabel!
    @IBOutlet weak var staticSatLbl: UILabel!
    @IBOutlet weak var staticGapBetweenLbl: UILabel!
    @IBOutlet weak var staticMonthlyLbl: UILabel!
    @IBOutlet weak var staticHalfYearlyLbl: UILabel!
    @IBOutlet weak var staticAnnuallyLbl: UILabel!
    @IBOutlet weak var staticNoneLbl: UILabel!
    @IBOutlet weak var staticSelectedProjectStatusLbl: UILabel!
    @IBOutlet weak var staticSelectedChecklistStatusLbl: UILabel!
    @IBOutlet weak var staticSelectedEmployeeStatusLbl: UILabel!

    var btnALLTerritory = [UIButton]()
    
    var btnAllDays = [UIButton]()
    
    var projectId = String()
    var employeeId = String()
    var checklistId = String()
    
    var cornjobDuration = ""
    var cornjobType = "Everyday"
    
    var selectedChecklistSegmmentIndex = Int()
    weak var delegate : ChecklistVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        checklistTitleLbl.text = LocalizationKey.checklist.localizing()
        staticSelectProjectLbl.text = LocalizationKey.selectProject.localizing()
        staticSelectChecklistLbl.text = LocalizationKey.selectChecklist.localizing()
        staticSelectEmployeeLbl.text = LocalizationKey.selectEmployee.localizing()
        staticObligatoryLbl.text = LocalizationKey.obligatory.localizing()
        staticSendEmialLbl.text = LocalizationKey.sendEmail.localizing()
        staticAllowCheckAllLbl.text = LocalizationKey.allowCheckAll.localizing()
        staticScheduleLbl.text = LocalizationKey.schedule.localizing()
        staticAllWorkingDaysLbl.text = LocalizationKey.allWorkingDays.localizing()
        staticWeekDaysLbl.text = LocalizationKey.weekDays.localizing()
        staticGapBetweenLbl.text = LocalizationKey.gapBetweenDays.localizing()
        staticMonthlyLbl.text = LocalizationKey.monthly.localizing()
        staticHalfYearlyLbl.text = LocalizationKey.halfYearly.localizing()
        staticAnnuallyLbl.text = LocalizationKey.annually.localizing()
        staticNoneLbl.text = LocalizationKey.none.localizing()
        staticSelectedProjectStatusLbl.text = LocalizationKey.selected.localizing()
        staticSelectedChecklistStatusLbl.text = LocalizationKey.selected.localizing()
        staticSelectedEmployeeStatusLbl.text = LocalizationKey.selected.localizing()
    }
    
    func configUI() {
        btnAll.tag = 1
        btnWeek.tag = 2
        btnGap.tag = 3
        btnMonthly.tag = 4
        btnHalfYearly.tag = 5
        btnAnnually.tag = 6
        btnNone.tag = 7
        
        btnSun.tag = 11
        btnMon.tag = 12
        btnTue.tag = 13
        btnWed.tag = 14
        btnThu.tag = 15
        btnFri.tag = 16
        btnSat.tag = 17
        
        weekHeight.constant = 0
        gapHeight.constant = 0
        monthlyHeight.constant = 0
        halfYearlyHeight.constant = 0
        annuallyHeight.constant = 0
        
        btnALLTerritory = [btnAll,btnWeek,btnGap,btnMonthly,btnHalfYearly,btnAnnually,btnNone]
        btnAllDays = [btnSun,btnMon,btnTue,btnWed,btnThu,btnFri,btnSat]
        btnAll.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        
        selectedProjectView.isHidden = true
        selectedChecklistView.isHidden = true
        selectedEmployeeView.isHidden = true
        
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
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func btnSelectCheckListAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectChecklistVC") as! SelectChecklistVC
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func obligatorySwitch(_ sender: Any) {
    }
    @IBAction func sendEmailSwitch(_ sender: Any) {
    }
    @IBAction func allowCheckAllSwitch(_ sender: Any) {
    }
    @IBAction func btnDays(_ sender: UIButton) {
        for button in btnALLTerritory {
            if sender.tag == button.tag{
                button.isSelected = true;
                button.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            }else{
                button.isSelected = false;
                button.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            }
        }
        
        switch sender.tag
            {
                case 1:
            weekHeight.constant = 0
            gapHeight.constant = 0
            monthlyHeight.constant = 0
            halfYearlyHeight.constant = 0
            annuallyHeight.constant = 0
            
            cornjobType = "Everyday"
                    break
                case 2:
            weekHeight.constant = 56
            gapHeight.constant = 0
            monthlyHeight.constant = 0
            halfYearlyHeight.constant = 0
            annuallyHeight.constant = 0
            
            cornjobType = "Weekdays"
                    break
                case 3:
            weekHeight.constant = 0
            gapHeight.constant = 46
            monthlyHeight.constant = 0
            halfYearlyHeight.constant = 0
            annuallyHeight.constant = 0
            
            cornjobType = "Gap Between Days"
                    break
                case 4:
            weekHeight.constant = 0
            gapHeight.constant = 0
            monthlyHeight.constant = 46
            halfYearlyHeight.constant = 0
            annuallyHeight.constant = 0

            cornjobType = "Monthly"
                    break
                case 5:
            weekHeight.constant = 0
            gapHeight.constant = 0
            monthlyHeight.constant = 0
            halfYearlyHeight.constant = 46
            annuallyHeight.constant = 0

            cornjobType = "Half Yearly"
                    break
                case 6:
            weekHeight.constant = 0
            gapHeight.constant = 0
            monthlyHeight.constant = 0
            halfYearlyHeight.constant = 0
            annuallyHeight.constant = 46

            cornjobType = "Annually"
                    break
                case 7:
            weekHeight.constant = 0
            gapHeight.constant = 0
            monthlyHeight.constant = 0
            halfYearlyHeight.constant = 0
            annuallyHeight.constant = 0

            cornjobType = "None"
                    break
                default: print("Other...")
            }
        
        for button in btnAllDays {
            button.isSelected = false;
            button.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        }
        cornjobDuration = ""
        gapBetweenTxt.text = ""
        monthlyTxt.text = ""
        halfYearlyTxt.text = ""
        annuallyTxt.text = ""
    }
    
    @IBAction func btnWeekDaysCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            sender.isSelected = true
            sender.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
//        for button in btnAllDays {
//            if sender.tag == button.tag{
//                button.isSelected = true;
//                button.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
//            }else{
//                button.isSelected = false;
//                button.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
//            }
//        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if projectId == "" || checklistId == "" || employeeId == "" {
            showAlert(message: LocalizationKey.selectProjectChecklistAndEmployee.localizing(), strtitle: LocalizationKey.alert.localizing())
            return
        }
        switch cornjobType {
        case "Everyday":
            addCheckList()
        case "Weekdays":
            var isSelected = false
            for button in btnAllDays {
                if button.isSelected {
                    isSelected = true
                }
            }
            if isSelected {
                addCheckList()
            } else {
                showAlert(message: LocalizationKey.pleaseSelectAtLeastOneDayOfWeek.localizing(), strtitle: "")
            }
        case "Gap Between Days":
            if gapBetweenTxt.text != "" {
                addCheckList()
            } else {
                showAlert(message: LocalizationKey.pleaseEnterValue.localizing(), strtitle: "")
            }
        case "Monthly":
            if monthlyTxt.text != "" {
                addCheckList()
            } else {
                showAlert(message: LocalizationKey.pleaseEnterValue.localizing(), strtitle: "")
            }
        case "Half Yearly":
            if halfYearlyTxt.text != "" {
                addCheckList()
            } else {
                showAlert(message: LocalizationKey.pleaseEnterValue.localizing(), strtitle: "")
            }
        case "Annually":
            if annuallyTxt.text != "" {
                addCheckList()
            } else {
                showAlert(message: LocalizationKey.pleaseEnterValue.localizing(), strtitle: "")
            }
        case "None":
            addCheckList()
        default:
            break
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

    
    @IBAction func btnBackAddAction(_ sender: Any) {
        delegate?.checkChecklistSegmentIndex(segmentIndex: selectedChecklistSegmmentIndex)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: Delegate
extension AddChecklistVC : SelectProjectProtocol,SelectEmployeeProtocol,SelectChecklistProtocol {
    func checkListId(checklistId: String, checklistName: String) {
        selectedChecklistView.isHidden = false
        selectedChecklistLbl.text = "\(checklistId) | \(checklistName)"
        self.checklistId = checklistId
    }
    
    func employeeId(empId: String, empName: String) {
        selectedEmployeeView.isHidden = false
        selectedEmployeeLbl.text = "\(empId) | \(empName)"
        self.employeeId = empId
    }
    
    func projectId(projectId: String, projectName: String) {
        selectedProjectView.isHidden = false
        selectedProjectLbl.text = "\(projectId) | \(projectName)"
        self.projectId = projectId
    }
}

//MARK: Extension Api's
extension AddChecklistVC {
    private func addCheckList(){
        var param = [String:Any]()
        
        param["allow_check_all"] = allowCheckAllSwitch.isOn
        param["isSendEmail"] = sendEmailSwitch.isOn
        param["isobligatory"] = obligatorySwitch.isOn
        param["checklist_templates_id"] = checklistId
        param["project_id"] = projectId
        param["user_id"] = employeeId
        param["cornjob_type"] = cornjobType
        
        switch cornjobType {
        case "Everyday":
            cornjobDuration = ""
        case "Weekdays":
            for button in btnAllDays {
                if button.isSelected{
                    switch button.tag {
                    case 11:
                        cornjobDuration = cornjobDuration == "" ? "Sun" : cornjobDuration + ",Sun"
                        break
                    case 12:
                        cornjobDuration = cornjobDuration == "" ? "Mon" : cornjobDuration + ",Mon"
                        break
                    case 13:
                        cornjobDuration = cornjobDuration == "" ? "Tue" : cornjobDuration + ",Tue"
                        break
                    case 14:
                        cornjobDuration = cornjobDuration == "" ? "Wed" : cornjobDuration + ",Wed"
                        break
                    case 15:
                        cornjobDuration = cornjobDuration == "" ? "Thu" : cornjobDuration + ",Thu"
                        break
                    case 16:
                        cornjobDuration = cornjobDuration == "" ? "Fri" : cornjobDuration + ",Fri"
                        break
                    case 17:
                        cornjobDuration = cornjobDuration == "" ? "Sat" : cornjobDuration + ",Sat"
                        break
                        
                    default:
                        cornjobDuration = ""
                    }
                }
            }
        case "Gap Between Days":
            cornjobDuration = gapBetweenTxt.text ?? ""
        case "Monthly":
            cornjobDuration = monthlyTxt.text ?? ""
        case "Half Yearly":
            cornjobDuration = halfYearlyTxt.text ?? ""
        case "Annually":
            cornjobDuration = annuallyTxt.text ?? ""
        case "None":
            cornjobDuration = ""
        default:
            cornjobDuration = ""
        }
        param["cornjob_duration"] = cornjobDuration
        print(param)
        
        CheckListVM.shared.addCheckList(parameters: param){ [self] obj in
            showAlert(message: obj.message ?? "", strtitle: LocalizationKey.success.localizing()) {_ in
                delegate?.checkChecklistSegmentIndex(segmentIndex: selectedChecklistSegmmentIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

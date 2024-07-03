//
//  SelectEmplyeeVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit

protocol SelectEmployeeProtocol {
    
    func employeeId(empId: String, empName: String)
}

class SelectEmplyeeVC: BaseViewController {
    
    @IBOutlet weak var selectEmplyeeTitleLbl: UILabel!

    @IBOutlet weak var employeeListTblVw: UITableView!
    
    var arrRows : [UserListByProjectModel] = []
    
    var members : [Rooms]?
        
    var selectedIndex = -1
    
    var delegate : SelectEmployeeProtocol?
    
    var isMoreUser : Bool = true
    var isLoadingList : Bool = false
    
    var projectId = ""
    var isComingFrom = ""
    @IBOutlet weak var btnObjApply: UIButton!
    @IBOutlet weak var deviationStackview: UIStackView!
    @IBOutlet weak var btnObjAssign: UIButton!
    @IBOutlet weak var btnObjUnAssign: UIButton!
    @IBOutlet weak var btnObjReAssign: UIButton!
    @IBOutlet weak var addBtnObj: UIButton!
    
    var assigneeId = String()
    var lastAssigneeId = String()
    var deviationId = Int()
    @IBOutlet weak var txtSearch: UITextField!
    var filteredDataArrRows : [UserListByProjectModel]?
    var filteredDataMembers : [Rooms]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        selectEmplyeeTitleLbl.text = LocalizationKey.selectEmployee.localizing()
        addBtnObj.setTitle(LocalizationKey.add.localizing(), for: .normal)
        btnObjApply.setTitle(LocalizationKey.apply.localizing(), for: .normal)
        btnObjAssign.setTitle(LocalizationKey.assign.localizing(), for: .normal)
        btnObjReAssign.setTitle(LocalizationKey.reassign.localizing(), for: .normal)
        btnObjUnAssign.setTitle(LocalizationKey.unassign.localizing(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrRows.removeAll()
        GlobleVariables.page = 0
        hitGetAllUsersApi(projectId: projectId)
    }
    
    func configUI() {
        employeeListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.EmployeeListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EmployeeListTVC.rawValue)
        employeeListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue)
        
        if isComingFrom == "DeviationDetails" {
            btnObjApply.isHidden = true
            deviationStackview.isHidden = false
        } else {
            btnObjApply.isHidden = false
            deviationStackview.isHidden = true
        }
        
        employeeListTblVw.reloadData()
    }
    
    @IBAction func addEmployeeBtnAction(_ sender: Any) {
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    @IBAction func btnApplyAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)

        if selectedIndex != -1 {
            if projectId == "" {
                let empolyeeData = filteredDataMembers?[selectedIndex]
                delegate?.employeeId(empId: "\(empolyeeData?.id ?? 0)" ,empName: "\(empolyeeData?.fullname ?? "")")
            } else {
                let empolyeeData = filteredDataArrRows?[selectedIndex]
                delegate?.employeeId(empId: "\(empolyeeData?.id ?? 0)" ,empName: "\(empolyeeData?.fullname ?? "")")
            }
        }
    }
    
    @IBAction func btnAssignAction(_ sender: Any) {
        if selectedIndex != -1 {
            let empolyeeData = filteredDataArrRows?.first(where: { "\($0.id ?? 0)" == assigneeId })
            assignEmployee(assignId: "\(empolyeeData?.id ?? 0)", deviationId: deviationId)
//            delegate?.employeeId(empId: "\(empolyeeData.id ?? 0)" ,empName: "\(empolyeeData.fullname ?? "")")
        }
    }
    
    @IBAction func btnUnAssignAction(_ sender: Any) {
        unAssignEmployee(assignId: assigneeId, deviationId: deviationId)
//        btnObjAssign.isHidden = false
//        btnObjUnAssign.isHidden = true
//        btnObjReAssign.isHidden = true
//        selectedIndex = -1
//        assigneeId = "-1"
//        self.employeeListTblVw.reloadData()
    }
    
    @IBAction func btnReAssignAction(_ sender: Any) {
        if selectedIndex != -1 {
            let empolyeeData = filteredDataArrRows?.first(where: { "\($0.id ?? 0)" == assigneeId })
            reAssignEmployee(assignId: "\(empolyeeData?.id ?? 0)", deviationId: deviationId)
//            delegate?.employeeId(empId: "\(empolyeeData.id ?? 0)" ,empName: "\(empolyeeData.fullname ?? "")")
        }
    }
}
    


//MARK: - TableView DataSource and Delegate Methods
extension SelectEmplyeeVC: UITableViewDataSource, UITableViewDelegate {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if projectId == "" {
            return filteredDataMembers?.count ?? 0
        }
        return filteredDataArrRows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if (isComingFrom == "CreateShiftVC" || isComingFrom == "DeviationDetails" || isComingFrom == "AddReportVC") {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, for: indexPath) as? EmployeeListShiftTVC
            else { return UITableViewCell() }
            cell.selectedEmplyeeRadioBtn.isHidden = false
            cell.selectedEmplyeeRadioBtn.isUserInteractionEnabled = false
        
            if (isComingFrom == "DeviationDetails") {
                guard let arrRows = filteredDataArrRows?[indexPath.row] else { return UITableViewCell() }
                if assigneeId == "\(arrRows.id ?? 0)" {
                    cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
                }
                else {
                    cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
                }
            } else {
                if selectedIndex == indexPath.row {
                    cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
                }
                else {
                    cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
                }
            }
            if projectId == "" {
                guard let member = filteredDataMembers?[indexPath.row] else { return UITableViewCell() }
                cell.setData(room: member)
            } else {
                guard let arrRows = filteredDataArrRows?[indexPath.row] else { return UITableViewCell() }
                cell.setData(rowsData: arrRows)
            }
            return cell
//        }
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EmployeeListTVC.rawValue, for: indexPath) as? EmployeeListTVC
//        else { return UITableViewCell() }
//        cell.selectedEmplyeeRadioBtn.isHidden = false
//        cell.selectedEmplyeeRadioBtn.isUserInteractionEnabled = false
//        cell.userNumberLbl.isHidden = true
//        cell.userNumberImage.isHidden = true
//        if selectedIndex == indexPath.row {
//            cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
//        }
//        else {
//            cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
//        }
//        cell.setData(rowsData: arrRows[indexPath.row])
//        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isComingFrom == "DeviationDetails") {
            if lastAssigneeId != "0" {
                selectedIndex = indexPath.row
                assigneeId = "\(filteredDataArrRows?[indexPath.row].id ?? 0)"
                if lastAssigneeId == assigneeId {
                    btnObjReAssign.isHidden = true
                    btnObjAssign.isHidden = true
                    btnObjUnAssign.isHidden = false
                } else {
                    btnObjReAssign.isHidden = false
                    btnObjAssign.isHidden = true
                    btnObjUnAssign.isHidden = true
                }
                self.employeeListTblVw.reloadData()
            } else {
                selectedIndex = indexPath.row
                assigneeId = "\(filteredDataArrRows?[indexPath.row].id ?? 0)"
                btnObjReAssign.isHidden = true
                btnObjAssign.isHidden = false
                btnObjUnAssign.isHidden = true
                self.employeeListTblVw.reloadData()
            }
        } else {
            selectedIndex = indexPath.row
            employeeListTblVw.reloadData()
        }
    }
}

extension SelectEmplyeeVC : UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if currentText.isEmpty {
            hitGetAllUsersApi(projectId: projectId)
        } else {
            if projectId == "" {
                filteredDataMembers = members?.filter { members in
                    guard let name = members.name else { return false }
                    return name.lowercased().contains(currentText.lowercased())
                }
            } else {
                filteredDataArrRows = arrRows.filter { arrEmployeeData in
                    guard let nameData = arrEmployeeData.fullname else { return false }
                    return nameData.lowercased().contains(currentText.lowercased())
                }
            }
        }
        employeeListTblVw.reloadData()
        return true
    }
}

extension SelectEmplyeeVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList && isMoreUser && projectId == ""  ){
            self.isLoadingList = true
            GlobleVariables.page = GlobleVariables.page + 1
            hitGetAllUsersApi(projectId: projectId)
        }
    }
}

//MARK: All User List Api's

extension SelectEmplyeeVC {
        
    func hitGetAllUsersApi(projectId : String) -> Void {
        
        if projectId == "" {
            var param = [String:Any]()
            
            param["name"] = ""
            param["mode"] = "both"
            
            ChatVM.shared.getMembers(parameters: param, isAuthorization: true) { [self] obj in
                
               // self.arrProjects = obj
                
                self.members = obj
                self.filteredDataMembers = self.members
                self.employeeListTblVw.reloadData()
            }
        }else {
            AllUsersVM.shared.getUsersByProjectApi(id: projectId, isAuthorization: true) { [self] obj in
//                for model in obj ?? []{
//                    self.arrRows.append(model)
//                }
                print(obj)
                self.arrRows = obj
                self.filteredDataArrRows = self.arrRows
                if (isComingFrom == "DeviationDetails") {
                    if lastAssigneeId != "0" {
                        if lastAssigneeId == assigneeId {
                            btnObjAssign.isHidden = true
                            btnObjReAssign.isHidden = true
                            btnObjUnAssign.isHidden = false
                        } else {
                            btnObjAssign.isHidden = true
                            btnObjReAssign.isHidden = false
                            btnObjUnAssign.isHidden = true
                        }
                    } else {
                        btnObjAssign.isHidden = false
                        btnObjReAssign.isHidden = true
                        btnObjUnAssign.isHidden = true
                    }
                }
                self.employeeListTblVw.reloadData()
            }
        }
    }
    
    func assignEmployee(assignId:String, deviationId: Int){
        var param = [String:Any]()
        param["assigned_id"] = assignId
        print(param)
        
        DeviationsVM.shared.assignMember(parameters: param, id: deviationId, isAuthorization: true) { [self] obj in
            self.dismiss(animated: true)
            let empolyeeData = filteredDataArrRows?.first(where: { "\($0.id ?? 0)" == assigneeId })
            delegate?.employeeId(empId: "\(empolyeeData?.id ?? 0)" ,empName: "\(empolyeeData?.fullname ?? "")")
        }
    }
    
    func unAssignEmployee(assignId:String, deviationId: Int){
        var param = [String:Any]()
        param["assigned_id"] = assignId
        print(param)
        
        DeviationsVM.shared.unAssignMember(parameters: param, id: deviationId, isAuthorization: true) { [self] obj in
            self.dismiss(animated: true)
            delegate?.employeeId(empId: "" ,empName: "")
        }
    }
    
    func reAssignEmployee(assignId:String, deviationId: Int){
        var param = [String:Any]()
        param["assigned_id"] = assignId
        print(param)
        
        DeviationsVM.shared.reAssignMember(parameters: param, id: deviationId, isAuthorization: true) { [self] obj in
            
            print("Obj is : ", obj)
            self.dismiss(animated: true)
            let empolyeeData = filteredDataArrRows?.first(where: { "\($0.id ?? 0)" == assigneeId })
            delegate?.employeeId(empId: "\(empolyeeData?.id ?? 0)" ,empName: "\(empolyeeData?.fullname ?? "")")
        }
    }
}

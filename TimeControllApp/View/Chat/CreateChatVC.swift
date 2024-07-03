//
//  CreateChatVC.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 12/04/23.
//

import UIKit

class CreateChatVC: BaseViewController {
    
    @IBOutlet weak var createChatTitleLbl: UILabel!
    @IBOutlet weak var memberListtblView: UITableView!
    @IBOutlet weak var createBtn: UIButton!
    
    var selectedRows : [IndexPath] = []
    
    var members : [Rooms]?
    var iscomingFrom = ""
    var swapId = Int()
    var swapEmployees : [Availableusers]?
    var selectedSwapEmployees : [Availableusers]?
    var delegate =  SwapDetailsVC()

    @IBOutlet weak var staticEmployeeMessageLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        createChatTitleLbl.text = LocalizationKey.selectMemberS.localizing()
        staticEmployeeMessageLbl.text = LocalizationKey.employeesavailablefortradingashift.localizing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if iscomingFrom == "swap-swift" {
            self.staticEmployeeMessageLbl.isHidden = false
            createBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
            getSwapSwiftEmployeeApi(selectedSwapId: swapId)
        } else {
            self.staticEmployeeMessageLbl.isHidden = true
            createBtn.setTitle(LocalizationKey.create.localizing(), for: .normal)
            getMembersApi()
        }
    }
    
    func configUI() {
        memberListtblView.register(UINib.init(nibName: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue)
    }
    
    @IBAction func btnCreateChat(_ sender: Any) {
        if iscomingFrom == "swap-swift" {
            print("selectedRows is : ", selectedRows)
            var selectedData = [Availableusers]()
            for i in selectedRows {
                guard  let selectSwapEmployee = swapEmployees?[i.row] else {
                    return
                }
                print("selectSwapEmployee is : ", selectSwapEmployee)
                selectedData.append(selectSwapEmployee)
            }
            print("self.selectedSwapEmployees is : ", selectedData)
            delegate.selectedSwapEmployeesArray = selectedData
            if selectedData.count > 0 {
                delegate.employeeTblVw.isHidden = false
                delegate.contentViewHeight.constant = CGFloat(470 + (60*(selectedData.count )))
            }
            delegate.employeeTblVw.reloadData()
            self.navigationController?.popViewController(animated: true)
        } else {
            if selectedRows.count < 2 {
                self.showAlert(message: LocalizationKey.pleaseSelectAtLeastTwoMember.localizing(), strtitle: LocalizationKey.alert.localizing())
                return
            }
            createRoomApi()
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

//MARK: - TableView DataSource and Delegate Methods
extension CreateChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if iscomingFrom == "swap-swift" {
            return swapEmployees?.count ?? 0
        } else {
            return members?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, for: indexPath) as? EmployeeListShiftTVC
        else { return UITableViewCell() }
        cell.selectedEmplyeeRadioBtn.isHidden = false
        cell.selectedEmplyeeRadioBtn.isUserInteractionEnabled = false
        if self.selectedRows.contains(indexPath) {
            cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
        else {
            cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        }
        if iscomingFrom == "swap-swift" {
            guard  let swapEmployee = swapEmployees?[indexPath.row] else {
                return cell
            }
            cell.setSwapData(availableUser: swapEmployee)
        } else {
            guard  let member = members?[indexPath.row] else {
                return cell
            }
            cell.setData(room: member)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, for: indexPath) as? EmployeeListShiftTVC
        else { return  }
        if self.selectedRows.contains(indexPath) {
            self.selectedRows.remove(at: self.selectedRows.firstIndex(of: indexPath)!)
            cell.selectedEmplyeeRadioBtn.setImage(UIImage(named:"UnselectTickSquare"), for: .normal)
        } else {
            self.selectedRows.append(indexPath)
            cell.selectedEmplyeeRadioBtn.setImage(UIImage(named:"SelectedTickSquare"), for: .normal)
        }
        memberListtblView.reloadData()
    }
}


//MARK: Extension Api's
extension CreateChatVC {
    
    func getMembersApi(name: String = "") -> Void {
        
        var param = [String:Any]()
        
        param["name"] = name
        param["mode"] = "both"
        
        ChatVM.shared.getMembers(parameters: param, isAuthorization: true) { [self] obj in
            
           // self.arrProjects = obj
            
            self.members = obj
            
            self.memberListtblView.reloadData()
        }
    }
    
    func getSwapSwiftEmployeeApi(selectedSwapId: Int) -> Void {
        var param = [String:Any]()
        
        ChatVM.shared.getSwapSwiftEmployeesList(parameters: param, id: selectedSwapId, isAuthorization: true) { [self] obj in

            self.swapEmployees = obj.availableusers
            if obj.availableusers?.count ?? 0 < 1 {
                staticEmployeeMessageLbl.isHidden = true
            } else {
                staticEmployeeMessageLbl.isHidden = false
            }
            self.memberListtblView.reloadData()
        }
    }
    
    func createRoomApi() -> Void {
        
        var param = [String:Any]()
        
        var roomMembers = ""
        for i in selectedRows {
            guard  let member = members?[i.row] else {
                return
            }
            if roomMembers == "" {
                roomMembers = "\(member.id ?? 0)"
            } else {
                roomMembers = "\(roomMembers),\(member.id ?? 0)"
            }
        }
        param["roomMembers"] = roomMembers
        param["client_id"] = Int(UserDefaults.standard.string(forKey: UserDefaultKeys.clientId) ?? "0")
        param["user_id"] = Int(UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
        
        ChatVM.shared.createPrivateRooms(parameters: param, isAuthorization: true) { [self] obj in
            
           // self.arrProjects = obj
            
            self.showAlert(message: LocalizationKey.privateRoomCreatedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.navigationController?.popViewController(animated: true)
            }
            self.memberListtblView.reloadData()
        }
    }
}


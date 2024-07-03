//
//  SelectGroupVC.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 19/03/24.
//

import UIKit

protocol SelectGroupProtocol {
    
    func groupId(groupId: String, groupName: String)
}

class SelectGroupVC: UIViewController {
    
    @IBOutlet weak var selectGroupTitleLbl: UILabel!
    
    @IBOutlet weak var groupListtblView: UITableView!
    

    @IBOutlet weak var applyBtn: UIButton!
    
    
    //Group List
    var userGroups = GlobleVariables.clientControlPanelConfiguration?.data?.extendedRules?.user_groups ?? []
    
    var filteredUserGroups : [User_groups] = []

    var selectedIndex = -1
    
    var delegate : SelectGroupProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        hitGroupsApi()
    }
    
    //MARK: Functions
    func setUpLocalization(){
//        selectGroupTitleLbl.text = LocalizationKey.selectProject.localizing()
        applyBtn.setTitle(LocalizationKey.apply.localizing(), for: .normal)
    }
    
    func configUI() {
        groupListtblView.register(UINib.init(nibName: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue)
    }
    
    //MARK: Button Actions

    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func btnApplyAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)

        if selectedIndex != -1 {
            let obj = userGroups[selectedIndex]
            
            delegate?.groupId(groupId: "\(obj.code ?? 0)", groupName: obj.name ?? "")
        } else {
            showAlert(message: LocalizationKey.pleaseSelectProject.localizing(), strtitle: LocalizationKey.alert.localizing())
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
extension SelectGroupVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return filteredUserGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, for: indexPath) as? EmployeeListShiftTVC
        else { return UITableViewCell() }
        let obj = userGroups[indexPath.row]
        cell.userNameLbl.text = "\(obj.code ?? 0) | \(obj.name ?? "")"
        
        cell.userImage.isHidden = true
        cell.userNameLeading.constant = -20
        
        if selectedIndex == indexPath.row {
            cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        }
        else {
            cell.selectedEmplyeeRadioBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        selectedIndex = indexPath.row

        groupListtblView.reloadData()
        
    }
}
//MARK: Extension Api's
extension SelectGroupVC {
    func hitGroupsApi() -> Void {
        
        WorkHourVM.shared.getGroupsData(isAuthorization: true) { [self] obj in
            print(obj)
            guard let groupsString = obj.user?.groups
            else {return}
            
            print(userGroups.count)
            let groupsArray = groupsString.components(separatedBy: ",")
            
            filteredUserGroups = userGroups.filter { group in
                if let groupCode = group.code, let groupsString = obj.user?.groups {
                    let groupsArray = groupsString.components(separatedBy: ",")
                    return groupsArray.contains(String(groupCode))
                }
                return false
            }
            
            groupListtblView.reloadData()
        }
    }
}

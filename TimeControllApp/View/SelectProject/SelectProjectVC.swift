//
//  SelectProjectVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit

protocol SelectProjectProtocol {
    
    func projectId(projectId: String, projectName: String)
}

class SelectProjectVC: BaseViewController {
    
    @IBOutlet weak var selectProjectTitleLbl: UILabel!

//    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var projectListtblView: UITableView!
    
    @IBOutlet var vwFooter: UIView!

    @IBOutlet weak var txtsearch: UITextField!
    @IBOutlet weak var applyBtn: UIButton!
    
    var arrProjects : [projectsModel]?
    
//    var arrRows : [TaskRows]?
    var arrRows : [projectsModel] = []
    var filteredData : [projectsModel] = []

    var selectedIndex = -1
    
    var delegate : SelectProjectProtocol?
    var members : [Rooms]?
    var mode = ""
    var module = ""

    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
    }
    
    func setUpLocalization(){
        selectProjectTitleLbl.text = LocalizationKey.selectProject.localizing()
        applyBtn.setTitle(LocalizationKey.apply.localizing(), for: .normal)
        txtsearch.placeholder = LocalizationKey.search.localizing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        hitprojectsApi()
    }
    
    
    //MARK: Functions
    func configUI() {
      //  projectListtblView.tableFooterView = vwFooter
        
        projectListtblView.register(UINib.init(nibName: TABLE_VIEW_CELL.ProjectListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ProjectListTVC.rawValue)
      //  projectListtblView.reloadData()
    }
    
    //MARK: Button Actions
    @IBAction func addProjectBtnAction(_ sender: Any) {
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func btnApplyAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)

        if selectedIndex != -1 {
//            guard  let projectData = arrRows[selectedIndex] else {
//                return
//            }
//            delegate?.projectId(projectId: "\(projectData.id ?? 0)", projectName: projectData.name ?? "")
            delegate?.projectId(projectId: "\(filteredData[selectedIndex].id ?? 0)", projectName: filteredData[selectedIndex].fullname ?? "")
        } else {
            showAlert(message: LocalizationKey.pleaseSelectProject.localizing(), strtitle: LocalizationKey.alert.localizing())
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension SelectProjectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ProjectListTVC.rawValue, for: indexPath) as? ProjectListTVC
        else { return UITableViewCell() }
      
    
//        guard  let projectData = arrRows[indexPath.row] else {
//            return cell
//        }

//        cell.setData(data: projectData)
        cell.setProjectData(data: filteredData[indexPath.row])
        
        if selectedIndex == indexPath.row {
            cell.btnSelect.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        }
        else {
            cell.btnSelect.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        selectedIndex = indexPath.row

        projectListtblView.reloadData()
        
    }
}


extension SelectProjectVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*
        let searchText = txtsearch.text! + string
        print(searchText)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.arrRows.removeAll()
            
            self.hitprojectsApi(name: searchText)
            
        }
        return true
         */
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if currentText.isEmpty {
            filteredData = arrRows
        } else {
            filteredData = arrRows.filter { projects in
                guard let fullname = projects.fullname else { return false }
                return fullname.lowercased().contains(currentText.lowercased())
            }
        }
        projectListtblView.reloadData()
       return true
    }
}


//MARK: Extension Api's
extension SelectProjectVC {
    /*
    func hitprojectsApi(name: String = "") -> Void {
        
        var param = [String:Any]()

   // https://tidogkontroll.no/api/tasks?filters={"project":"","name":""}
        param = ["pagesize":"100","filters":"{\"name\":\"\(name)\"}"]
//    https://tidogkontroll.no/api/projects?pagesize=10&page=0&sort=[]&filters={"status":"","name":""}
        
        WorkHourVM.shared.workprojectsApi(parameters: param, isAuthorization: true) { [self] obj in
            
           // self.arrProjects = obj
            
            self.arrRows = obj.rows
            
            projectListtblView.reloadData()
        }
    }
    */
    
    
    func hitprojectsApi(name: String = "") -> Void {
        
        var param = [String:Any]()

//        param = ["mode":"managers","name": name, "module": "no-module"]
        param = ["mode":mode,"name": name, "module": module]
        print("Param is : ", param)
        
//
//    https://norsktimeregister.no/api/projects/lookup_projects?name=&mode=managers&module=no-module
        WorkHourVM.shared.workLookUpprojectsApi(parameters: param, isAuthorization: true) { [self] obj in
            
            print("Project Data is : ", obj)
            
            for i in 0..<obj.count {
//                let arrAssignProjects = obj[i].assigned_users.components(separatedBy: ",")
                guard  let assignUserData = obj[i].assigned_users else {
                    return
                }
//
//                let arrAssignProjects = splitArray(array: assignUserData, chunkSize: assignUserData.count)
//                print("arrAssignProjects is : ", arrAssignProjects)
                
                for j in 0..<assignUserData.count {
                    print("assignUserData[j] is : ", assignUserData[j])
                    print("UserDefaults.standard.integer(forKey: UserDefaultKeys.userId) is : ", UserDefaults.standard.integer(forKey: UserDefaultKeys.userId))
                    print("assignUserData[j] == UserDefaults.standard.integer(forKey: UserDefaultKeys.userId) is : ", assignUserData[j] == UserDefaults.standard.integer(forKey: UserDefaultKeys.userId))
                 
                    if (assignUserData[j] == UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)) {
                        print("obj[i]", obj[i])
                        self.arrRows.append(obj[i])
                        print("self.arrRows? is : ", self.arrRows)
//                        return
                    }
                }
            }
            
//            self.arrRows = obj
            filteredData = self.arrRows
            print("self.arrRows?.count",self.arrRows.count)
            self.projectListtblView.reloadData()
        }
    }
    
    func splitArray<T>(array: [T], chunkSize: Int) -> [[T]] {
        return stride(from: 0, to: array.count, by: chunkSize).map {
            Array(array[$0..<min($0 + chunkSize, array.count)])
        }
    }
}

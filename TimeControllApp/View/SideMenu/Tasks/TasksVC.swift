//
//  TasksVC.swift
//  TimeControllApp
//
//  Created by mukesh on 27/07/22.
//

import UIKit

enum TasksType:String {
    case All = ""
    case Active = "active"
    case Today = "TODAY"
}

class TasksVC: UIViewController {
    
    @IBOutlet weak var tasksTitleLbl: UILabel!
    @IBOutlet weak var tasksSegmentController: UISegmentedControl!
    @IBOutlet weak var tasksTblVw: UITableView!
    
    var isLoadingList : Bool = false
    var isMoreTasksData : Bool = true

    var arrTasksData : [TasksScreenData]? = []
    private var segmentControlIndex = 0
    var selectedTab = String()
    @IBOutlet weak var txtSearch: UITextField!
    var isSearch : Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        tasksTitleLbl.text = LocalizationKey.tasks.localizing()
        tasksSegmentController.setTitle(LocalizationKey.all.localizing(), forSegmentAt: 0)
        tasksSegmentController.setTitle(LocalizationKey.active.localizing(), forSegmentAt: 1)
        tasksSegmentController.setTitle(LocalizationKey.today.localizing(), forSegmentAt: 2)
        txtSearch.placeholder = LocalizationKey.search.localizing()
    }
    
    func configUI() {
        txtSearch.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked))
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        tasksSegmentController.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        tasksSegmentController.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        tasksTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.TasksTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.TasksTVC.rawValue)
        
        tasksSegmentController.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        tasksSegmentController.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        tasksSegmentController.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)

        isSearch = false
        getTasksAPI(status: TasksType.All.rawValue)
//        tasksTblVw.reloadData()
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        self.textFieldShouldReturn(txtSearch)
    }

    @IBAction func addTasksBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddTasksVC") as! AddTasksVC
        vc.isComingFrom = "AddTask"
        vc.selectedSegmmentIndex = segmentControlIndex
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        segmentControlIndex = sender.selectedSegmentIndex
        GlobleVariables.page = 0
        txtSearch.text = ""
        self.arrTasksData = []
        tasksTblVw.reloadData()
        if sender.selectedSegmentIndex == 0 {
            getTasksAPI(status: TasksType.All.rawValue)
            selectedTab = TasksType.All.rawValue
        } else if sender.selectedSegmentIndex == 1 {
            getTasksAPI(status: TasksType.Active.rawValue)
            selectedTab = TasksType.Active.rawValue
        } else {
            getTasksAPI(status: TasksType.Today.rawValue)
            selectedTab = TasksType.Today.rawValue
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension TasksVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("arrTasksData?.count ",arrTasksData?.count)
        return arrTasksData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.TasksTVC.rawValue, for: indexPath) as? TasksTVC
        else { return UITableViewCell() }
        print("arrTasksData?.count ",arrTasksData?.count)
        guard let row = arrTasksData?[indexPath.row] else { return UITableViewCell() }
        cell.setData(rowsData: row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddTasksVC") as! AddTasksVC
        vc.isComingFrom = "TasksDetails"
        vc.taskID = arrTasksData?[indexPath.row].id ?? 0
        vc.selectedSegmmentIndex = segmentControlIndex
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (arrTasksData?.count ?? 0) - 1 && isMoreTasksData {
            GlobleVariables.page = GlobleVariables.page + 1
            if selectedTab == TasksType.All.rawValue {
                getTasksAPI(status:  TasksType.All.rawValue,searchName: self.txtSearch.text ?? "")
            }
            else if selectedTab == TasksType.Active.rawValue {
                getTasksAPI(status:  TasksType.Active.rawValue,searchName: self.txtSearch.text ?? "")
            } else {
                getTasksAPI(status:  TasksType.Today.rawValue,searchName: self.txtSearch.text ?? "")
            }
        }
    }
}

extension TasksVC:TasksVCDelegate {
    func checkSegmentIndex(segmentIndex: Int) {
        self.arrTasksData?.removeAll()
        tasksTblVw.reloadData()
        GlobleVariables.page = 0
        if segmentIndex == 0 {
            getTasksAPI(status: TasksType.All.rawValue)
        }
        else if segmentIndex == 1 {
            getTasksAPI(status: TasksType.Active.rawValue)
        }
        else {
            getTasksAPI(status: TasksType.Today.rawValue)
        }
    }
}

extension TasksVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getTasksAPI(status: selectedTab, searchName: textField.text ?? "",withSearch: true)
        return true
    }
}

//MARK: Extension Api's
extension TasksVC {

    func getTasksAPI(status: String,searchName name:String = "",withSearch isSearch: Bool = false) -> Void {
        self.isLoadingList = false
        if isSearch {
            self.arrTasksData?.removeAll()
            GlobleVariables.page = 0
        }
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"status\":\"\(status)\",\"name\":\"\(name)\",\"project\":null}"
        param["sort"] = "[{\"id\":\"updated_at\",\"desc\":\"true\"}]"

        print(param)
        
        TasksVM.shared.getTasksData(parameters: param, isAuthorization: true) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreTasksData = true
            }else{
                self.isMoreTasksData = false
            }
            for model in obj.rows ?? []{
                self.arrTasksData?.append(model)
            }
            self.tasksTblVw.reloadData()
        }
    }
}

//
//  ChecklistVC.swift
//  TimeControllApp
//
//  Created by mukesh on 14/07/22.
//

import UIKit

class ChecklistVC: BaseViewController {

    @IBOutlet weak var checklistStatusSegmentControl: UISegmentedControl!
    @IBOutlet weak var checklisttblVw: UITableView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var viewDetailsView: UIView!
    @IBOutlet weak var approveView: UIView!
    @IBOutlet weak var deleteView: UIView!
    
    @IBOutlet weak var checklistTitleLbl: UILabel!
    @IBOutlet weak var viewDetailsLbl: UILabel!
    @IBOutlet weak var approveLbl: UILabel!
    @IBOutlet weak var deleteTitleLbl: UILabel!
    
    var newCheckList : [ChecklistsRows] = []
    var underWorkCheckList : [ChecklistsRows] = []
    var doneCheckList : [ChecklistsRows] = []
    
    var isMoreChecklist : Bool = true
    
    var isLoadingList : Bool = false
    
    var selectedIndex = 0
    
    private var segmentControlIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        self.segmentControlIndex = 0
        self.checklistStatusSegmentControl.selectedSegmentIndex = 0
        GlobleVariables.page = 0
        self.checklistStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
        self.checkListApi(status: "New")
        self.newCheckList.removeAll()
        
        self.isMoreChecklist = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        GlobleVariables.page = 0
//
//        if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
//            newCheckList.removeAll()
//            checkListApi(status: "New")
//        } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
//            underWorkCheckList.removeAll()
//            checkListApi(status: "Under work")
//        } else {
//            doneCheckList.removeAll()
//            checkListApi(status: "Done")
//        }
    }
    
    func setUpLocalization(){
        checklistTitleLbl.text = LocalizationKey.checklist.localizing()
        checklistStatusSegmentControl.setTitle(LocalizationKey.new.localizing(), forSegmentAt: 0)
        checklistStatusSegmentControl.setTitle(LocalizationKey.underWork.localizing(), forSegmentAt: 1)
        checklistStatusSegmentControl.setTitle(LocalizationKey.done.localizing(), forSegmentAt: 2)
        viewDetailsLbl.text = LocalizationKey.viewDetails.localizing()
        approveLbl.text = LocalizationKey.approve.localizing()
        deleteTitleLbl.text = LocalizationKey.delete.localizing()
    }

    func configUI() {
        popUpView.isHidden = true
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            approveView.isHidden = true
            deleteView.isHidden = true
        }
        
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        checklistStatusSegmentControl.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        checklistStatusSegmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        checklistStatusSegmentControl.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        checklisttblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ChecklistTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ChecklistTVC.rawValue)
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        segmentControlIndex = sender.selectedSegmentIndex
        GlobleVariables.page = 0
        if sender.selectedSegmentIndex == 0 {
            checklistStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            checkListApi(status: "New")
            newCheckList.removeAll()
            
            approveView.isHidden = false
            deleteView.isHidden = false
        } else if sender.selectedSegmentIndex == 1 {
            checklistStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            checkListApi(status: "Under work")
            underWorkCheckList.removeAll()
            
            approveView.isHidden = false
            deleteView.isHidden = false
        } else {
            checklistStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            checkListApi(status: "Done")
            doneCheckList.removeAll()
            
            approveView.isHidden = true
            deleteView.isHidden = true
        }
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            approveView.isHidden = true
            deleteView.isHidden = true
        }
        isMoreChecklist = true
        checklisttblVw.reloadData()
    }
    
    @IBAction func ViewDetailsBtnAction(_ sender: Any) {
        popUpView.isHidden = true
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "EquipmentChecklistVC") as! EquipmentChecklistVC
        if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
            let checklist = newCheckList[selectedIndex]
            vc.selectedCheckList = checklist
        } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
            let checklist = underWorkCheckList[selectedIndex]
            vc.selectedCheckList = checklist
        } else {
            let checklist = doneCheckList[selectedIndex]
            vc.selectedCheckList = checklist
        }
        vc.selectedChecklistSegmmentIndex = segmentControlIndex
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ApproveBtn(_ sender: Any) {
        popUpView.isHidden = true
        if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
            let checklist = newCheckList[selectedIndex]
            self.checkListApprove(id: checklist.id ?? 0)
        } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
            let checklist = underWorkCheckList[selectedIndex]
            self.checkListApprove(id: checklist.id ?? 0)
        } else {
            let checklist = doneCheckList[selectedIndex]
            self.checkListApprove(id: checklist.id ?? 0)
        }
    }
    @IBAction func DeleteBtn(_ sender: Any) {
        popUpView.isHidden = true
        if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
            let checklist = newCheckList[selectedIndex]
            self.checkListDelete(id: checklist.id ?? 0)
        } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
            let checklist = underWorkCheckList[selectedIndex]
            self.checkListDelete(id: checklist.id ?? 0)
        } else {
            let checklist = doneCheckList[selectedIndex]
            self.checkListDelete(id: checklist.id ?? 0)
        }
    }
    @IBAction func crossBtn(_ sender: Any) {
        popUpView.isHidden = true
    }
    
    @IBAction func addChecklistBtnAction(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "AddChecklistVC") as! AddChecklistVC
        vc.selectedChecklistSegmmentIndex = segmentControlIndex
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension ChecklistVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 0
        if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
            count = newCheckList.count
        } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
            count = underWorkCheckList.count
        } else {
            count = doneCheckList.count
        }
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noCheckListAvailable.localizing()
            noDataLabel.textColor     = Constant.appColor
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            noDataLabel.lineBreakMode = .byWordWrapping
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            
        }else{
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
            return newCheckList.count
        } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
            return underWorkCheckList.count
        } else {
            return doneCheckList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ChecklistTVC.rawValue, for: indexPath) as? ChecklistTVC
        else { return UITableViewCell() }
        if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
            let checklist = newCheckList[indexPath.row]
            cell.configUI(index: segmentControlIndex, checklist: checklist)
        } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
            let checklist = underWorkCheckList[indexPath.row]
            cell.configUI(index: segmentControlIndex, checklist: checklist)
        } else {
            let checklist = doneCheckList[indexPath.row]
            cell.configUI(index: segmentControlIndex, checklist: checklist)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        popUpView.isHidden = false
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
//            approveView.isHidden = true
//            deleteView.isHidden = true
            var checklist : ChecklistsRows?
            if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
                checklist = newCheckList[indexPath.row]
                approveView.isHidden = true
                deleteView.isHidden = false
            } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
                checklist = underWorkCheckList[indexPath.row]
                approveView.isHidden = true
                deleteView.isHidden = false
            } else {
                checklist = doneCheckList[indexPath.row]
                if checklist?.status?.uppercased() == "DONE" {
                    approveView.isHidden = true
                    deleteView.isHidden = false
                } else {
                    approveView.isHidden = true
                    deleteView.isHidden = false
                }
            }
        } else {
            var checklist : ChecklistsRows?
            if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
                checklist = newCheckList[indexPath.row]
                approveView.isHidden = true
                deleteView.isHidden = false
            } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
                checklist = underWorkCheckList[indexPath.row]
                approveView.isHidden = true
                deleteView.isHidden = false
            } else {
                checklist = doneCheckList[indexPath.row]
                if checklist?.status?.uppercased() == "DONE" {
                    approveView.isHidden = false
                    deleteView.isHidden = false
                } else {
                    approveView.isHidden = true
                    deleteView.isHidden = false
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ChecklistVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList && isMoreChecklist ){
            if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
                self.isLoadingList = true
                GlobleVariables.page = GlobleVariables.page + 1
                checkListApi(status: "New")
            } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
                self.isLoadingList = true
                GlobleVariables.page = GlobleVariables.page + 1
                checkListApi(status: "Under work")
            } else {
                self.isLoadingList = true
                GlobleVariables.page = GlobleVariables.page + 1
                checkListApi(status: "Done")
            }
        }
    }
}

//MARK: APi Work in View controller
extension ChecklistVC{
    private func checkListApi(status : String){
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"status\":\"\(status)\"}"
        param["sort"] = "[{\"id\":\"updated_at\",\"desc\":\"true\"}]"
        
        CheckListVM.shared.checkList(parameters: param) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreChecklist = true
            }else{
                self.isMoreChecklist = false
            }
            for model in obj.rows ?? []{
                if checklistStatusSegmentControl.selectedSegmentIndex == 0 {
                    self.newCheckList.append(model)
                } else if checklistStatusSegmentControl.selectedSegmentIndex == 1 {
                    self.underWorkCheckList.append(model)
                } else {
                    self.doneCheckList.append(model)
                }
            }
            self.isLoadingList = false
            self.checklisttblVw.reloadData()
        }
    }
    
    private func checkListApprove(id:Int){
        var param = [String:Any]()
        
        param["id"] = id
        param["status_note"] = "Done"
        print(param)
        
        CheckListVM.shared.checkListApprove(parameters: param){ [self] obj in
            print(obj.checklist)
            segmentedControlValueChanged(checklistStatusSegmentControl)
        }
    }
    
    private func checkListDelete(id:Int){
        CheckListVM.shared.checkListDelete(id: id){ [self] obj in
            print(obj.checklist)
            segmentedControlValueChanged(checklistStatusSegmentControl)
        }
    }
}


extension ChecklistVC:ChecklistVCDelegate {
    func checkChecklistSegmentIndex(segmentIndex: Int) {
        self.newCheckList.removeAll()
        self.underWorkCheckList.removeAll()
        self.doneCheckList.removeAll()
        checklisttblVw.reloadData()
        GlobleVariables.page = 0
        if segmentIndex == 0 {
            checklistStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            checkListApi(status: "New")
            
            approveView.isHidden = false
            deleteView.isHidden = false
        }
        else if segmentIndex == 1 {
            checklistStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            checkListApi(status: "Under work")
            
            approveView.isHidden = false
            deleteView.isHidden = false
        }
        else {
            checklistStatusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            checkListApi(status: "Done")
            doneCheckList.removeAll()
            
            approveView.isHidden = true
            deleteView.isHidden = true
        }
    }
}

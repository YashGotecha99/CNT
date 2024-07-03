//
//  PendingRequestVC.swift
//  TimeControllApp
//
//  Created by mukesh on 26/07/22.
//

import UIKit

class PendingRequestVC: BaseViewController {

    @IBOutlet weak var pendingRequestTitleLbl: UILabel!
    @IBOutlet weak var pendingReqTblVw: UITableView!
    @IBOutlet weak var pendingRequestSegment: UISegmentedControl!
    @IBOutlet weak var txtsearch: UITextField!
    
    var vacationList : [VacationRows] = []
    var abseanceList : [AbsenceRows] = []
    
    var isMoreVacation : Bool = true
    var isMoreAbsence : Bool = true
    
    var isLoadingList : Bool = false
    
    var searchTask: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        pendingRequestTitleLbl.text = LocalizationKey.pendingRequests.localizing()
        txtsearch.placeholder = LocalizationKey.search.localizing()
        pendingRequestSegment.setTitle(LocalizationKey.vacation.localizing(), forSegmentAt: 0)
        pendingRequestSegment.setTitle(LocalizationKey.absence.localizing(), forSegmentAt: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GlobleVariables.page = 0
        
        if pendingRequestSegment.selectedSegmentIndex == 0 {
            vacationList.removeAll()
            txtsearch.text = ""
            self.vacationListApi(name: "")
        } else {
            abseanceList.removeAll()
            txtsearch.text = ""
            self.absenceListApi(name: "")
        }
    }
    
    func configUI() {
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        pendingRequestSegment.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        pendingRequestSegment.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        pendingReqTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.PendingRequestTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.PendingRequestTVC.rawValue)
        pendingReqTblVw.reloadData()
    }
    
    @IBAction func ChangedSegment(_ sender: Any) {
        if pendingRequestSegment.selectedSegmentIndex == 0 {
            GlobleVariables.page = 0
            vacationList.removeAll()
            txtsearch.text = ""
            self.vacationListApi(name: "")
        } else {
            GlobleVariables.page = 0
            abseanceList.removeAll()
            txtsearch.text = ""
            self.absenceListApi(name: "")
        }
        pendingReqTblVw.reloadData()
    }

}

//MARK: - TableView DataSource and Delegate Methods
extension PendingRequestVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pendingRequestSegment.selectedSegmentIndex == 0 {
            return vacationList.count
        } else {
            return abseanceList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.PendingRequestTVC.rawValue, for: indexPath) as? PendingRequestTVC
        else { return UITableViewCell() }
        if pendingRequestSegment.selectedSegmentIndex == 0 {
            let obj = vacationList[indexPath.row]
            cell.setValueForVacation(vacation: obj,indexPath: indexPath)
        }else {
            let obj = abseanceList[indexPath.row]
            cell.setValueForAbsence(abseance: obj,indexPath: indexPath)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension PendingRequestVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var searchText = txtsearch.text!
        if let r = Range(range, in: searchText){
            searchText.removeSubrange(r) // it will delete any deleted string.
        }
        searchText.insert(contentsOf: string, at: searchText.index(searchText.startIndex, offsetBy: range.location)) // it will insert any text.
        print("searchText",searchText)

            if self.pendingRequestSegment.selectedSegmentIndex == 0 {
                self.searchTask?.cancel()
                let task = DispatchWorkItem { [weak self] in
                    self?.vacationList.removeAll()
                    GlobleVariables.page = 0
                    self?.vacationListApi(name: searchText)
                }
                self.searchTask = task
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
            } else {
                self.searchTask?.cancel()
                let task = DispatchWorkItem { [weak self] in
                    self?.abseanceList.removeAll()
                    GlobleVariables.page = 0
                    self?.absenceListApi(name: searchText)
                }
                self.searchTask = task
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
            }
           return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension PendingRequestVC : PendingRequestTVCProtocol {
    func acceptOrRejectRequest(status: String, vacationId: Int, absenceID: Int,indexPath:IndexPath) {
        if pendingRequestSegment.selectedSegmentIndex == 0 {
            if status == "approved" {
                let alert = UIAlertController(title: LocalizationKey.areYouSure.localizing(), message: LocalizationKey.doYouWantToApproveTheRequest.localizing(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
                    self.approveOrRejectVacationApi(id: "\(vacationId)", status: status,indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: LocalizationKey.areYouSure.localizing(), message: LocalizationKey.doYouWantToRejectTheRequest.localizing(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
                    self.approveOrRejectVacationApi(id: "\(vacationId)", status: status,indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if status == "approved" {
                let alert = UIAlertController(title: LocalizationKey.areYouSure.localizing(), message: LocalizationKey.doYouWantToApproveTheRequest.localizing(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
                    self.approveOrRejectAbsenceApi(id: "\(absenceID)", status: status, indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: LocalizationKey.areYouSure.localizing(), message: LocalizationKey.doYouWantToRejectTheRequest.localizing(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
                    self.approveOrRejectAbsenceApi(id: "\(absenceID)", status: status, indexPath: indexPath)
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension PendingRequestVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList  ){
            if pendingRequestSegment.selectedSegmentIndex == 0 && isMoreVacation {
                self.isLoadingList = true
                GlobleVariables.page = GlobleVariables.page + 1
                vacationListApi(name: txtsearch.text ?? "")
            }else if isMoreAbsence {
                self.isLoadingList = true
                GlobleVariables.page = GlobleVariables.page + 1
                absenceListApi(name: txtsearch.text ?? "")
            }
        }
    }
}

//MARK: APi Work in View controller
extension PendingRequestVC{
    private func vacationListApi(name : String){
       self.isLoadingList = false
       var param = [String:Any]()
       param = Helper.urlParameterForPagination()
       param["filters"] = "{\"name\":\"\(name)\"}"
       VacationAbsenceVM.shared.vacationList(parameters: param) { [self] obj in
           if obj.rows?.count ?? 0 > 0{
               self.isMoreVacation = true
           }else{
               self.isMoreVacation = false
           }
           for model in obj.rows ?? []{
               self.vacationList.append(model)
           }
           self.pendingReqTblVw.reloadData()
       }
   }
    
    private func absenceListApi(name : String){
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"name\":\"\(name)\"}"
        VacationAbsenceVM.shared.absenceList(parameters: param) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreAbsence = true
            }else{
                self.isMoreAbsence = false
            }
            for model in obj.rows ?? []{
                self.abseanceList.append(model)
            }
            self.pendingReqTblVw.reloadData()
        }
    }
    
    private func approveOrRejectVacationApi(id:String,status:String,indexPath:IndexPath){
        var param = [String:Any]()
        param["notes"] = status
        param["status"] = status
        VacationAbsenceVM.shared.approveOrRejectVacation(parameters: param, id: id) { [self] obj in
            if let index = vacationList.firstIndex(where: {$0.id == Int(id)}) {
                if status == "approved" {
                    showAlert(message: LocalizationKey.vacationApprovedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        self.vacationList[index].status = status
                        self.pendingReqTblVw.reloadRows(at: [indexPath], with: .automatic)
                    }
                } else {
                    showAlert(message: LocalizationKey.vacationRejectedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        self.vacationList[index].status = status
                        self.pendingReqTblVw.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }}
    }
    private func approveOrRejectAbsenceApi(id:String,status:String,indexPath:IndexPath){
        var param = [String:Any]()
        param["notes"] = status
        param["status"] = status
        VacationAbsenceVM.shared.approveOrRejectAbsence(parameters: param, id: id) { [self] obj in
            if let index = abseanceList.firstIndex(where: {$0.id == Int(id)}) {
                if status == "approved" {
                    showAlert(message: LocalizationKey.absenceApprovedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        self.abseanceList[index].status = status
                        self.pendingReqTblVw.reloadRows(at: [indexPath], with: .automatic)
                    }
                } else {
                    showAlert(message: LocalizationKey.absenceRejectedSuccessfully.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        self.abseanceList[index].status = status
                        self.pendingReqTblVw.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }}
    }
}

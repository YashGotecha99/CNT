//
//  AvailabilityListVC.swift
//  TimeControllApp
//
//  Created by yash on 19/01/23.
//

import UIKit
import SVProgressHUD

class AvailabilityListVC: BaseViewController {
    
    @IBOutlet weak var availabilityTblVw: UITableView!
    
    @IBOutlet weak var availabilitySearchTxt: UITextField!
    
    var isMoreData : Bool = true
    var isLoadingList : Bool = false
    var searchTask: DispatchWorkItem?

    var arrAllAvailabilityData : [AvailabilityList] = []
    @IBOutlet weak var availabilityPopUpView: UIView!
    @IBOutlet weak var availabilityOnlyDetailsPopUpView: UIView!
    
    var selectedIndexPath : IndexPath = []
    
    //MARK: Localizations
    @IBOutlet weak var staticAvailabilityLbl: UILabel!
    @IBOutlet weak var staticViewDetailsLbl: UILabel!
    @IBOutlet weak var staticApproveLbl: UILabel!
    @IBOutlet weak var staticRejectLbl: UILabel!
    @IBOutlet weak var staticOnlyViewDetailsLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        // Do any additional setup after loading the view.
    }
    func setUpLocalization() {
        staticAvailabilityLbl.text = LocalizationKey.checkAvailability.localizing()
        staticViewDetailsLbl.text = LocalizationKey.viewDetails.localizing()
        staticApproveLbl.text = LocalizationKey.approve.localizing()
        staticRejectLbl.text = LocalizationKey.reject.localizing()
        staticOnlyViewDetailsLbl.text = LocalizationKey.viewDetails.localizing()
    }
    func configUI() {
        self.availabilityTblVw.separatorColor = UIColor.clear
        availabilityTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.AvailabilityListPMTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AvailabilityListPMTVC.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configUI()
        availabilityPopUpView.isHidden = true
        availabilityOnlyDetailsPopUpView.isHidden = true
        self.arrAllAvailabilityData.removeAll()
        GlobleVariables.page = 0
        getAvailabityListData(filterData: availabilitySearchTxt.text ?? "")
    }

    @IBAction func createAvailabilityBtn(_ sender: Any) {
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "CreateAvailabilityVC") as! CreateAvailabilityVC
        vc.availabilityID = 0
        vc.isComingFrom = "PMCreate"
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    
    @IBAction func btnClickedOnlyDetails(_ sender: Any) {
        availabilityOnlyDetailsPopUpView.isHidden = true
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "CreateAvailabilityVC") as! CreateAvailabilityVC
        vc.availabilityID = arrAllAvailabilityData[selectedIndexPath.row].id ?? 0
        vc.isComingFrom = "PMDetails"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func closeOnlyDetails(_ sender: Any) {
        availabilityOnlyDetailsPopUpView.isHidden = true
    }
    
    @IBAction func btnClickedViewDetails(_ sender: Any) {
        availabilityPopUpView.isHidden = true
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "CreateAvailabilityVC") as! CreateAvailabilityVC
        vc.availabilityID = arrAllAvailabilityData[selectedIndexPath.row].id ?? 0
        vc.isComingFrom = "PMDetails"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnClickedApprove(_ sender: Any) {
        availabilityPopUpView.isHidden = true
        approveRejectAvailabilityById(status: "approved", availabilityID: arrAllAvailabilityData[selectedIndexPath.row].id ?? 0)
    }
    
    @IBAction func btnClickedReject(_ sender: Any) {
        availabilityPopUpView.isHidden = true
        approveRejectAvailabilityById(status: "rejected", availabilityID: arrAllAvailabilityData[selectedIndexPath.row].id ?? 0)
    }
    
    @IBAction func btnClickedClosePopUpView(_ sender: Any) {
        availabilityPopUpView.isHidden = true
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension AvailabilityListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        let count = arrAllAvailabilityData.count
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noAvailability.localizing()
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
        return arrAllAvailabilityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AvailabilityListPMTVC.rawValue, for: indexPath) as? AvailabilityListPMTVC else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.setData(availabilityData: arrAllAvailabilityData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        let userIDAPI =  "\(arrAllAvailabilityData[indexPath.row].user_id ?? 0)"

        if (userID != userIDAPI && arrAllAvailabilityData[indexPath.row].status == "pending") {
            availabilityPopUpView.isHidden = false
        } else {
            availabilityOnlyDetailsPopUpView.isHidden = false
        }
    }
}

extension AvailabilityListVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchText = availabilitySearchTxt.text!
        if let r = Range(range, in: searchText){
            searchText.removeSubrange(r) // it will delete any deleted string.
        }
        searchText.insert(contentsOf: string, at: searchText.index(searchText.startIndex, offsetBy: range.location)) // it will insert any text.
        print("searchText",searchText)
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.arrAllAvailabilityData.removeAll()
            GlobleVariables.page = 0
            self?.getAvailabityListData(filterData: searchText)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: task)
        return true
    }
}

extension AvailabilityListVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height / 2
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList && isMoreData  ){
            self.isLoadingList = true
            GlobleVariables.page = GlobleVariables.page + 1
            getAvailabityListData(filterData: availabilitySearchTxt.text ?? "")
        }
    }
}

//MARK: APi Work in View controller
extension AvailabilityListVC{
    
    func getAvailabityListData(filterData: String) -> Void {
        SVProgressHUD.show()
        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        param["filters"] = "{\"name\":\"\(filterData)\"}"
        print(param)
        
        AvailabilityVM.shared.getAllAvailabilityData(parameters: param, isAuthorization: true) { [self] obj in
            if obj.rows?.count ?? 0 > 0{
                self.isMoreData = true
            }else{
                self.isMoreData = false
            }
            for model in obj.rows ?? []{
                self.arrAllAvailabilityData.append(model)
            }
            self.availabilityTblVw.reloadData()
        }
    }
    
    func approveRejectAvailabilityById(status: String, availabilityID: Int) -> Void {
        SVProgressHUD.show()
        var param = [String:Any]()
        param["status"] = status
        print("Approve and Reject param is : ", param)
        
        AvailabilityVM.shared.approvedRejectAvailabilityByID(parameters: param, availabilityID: availabilityID, isAuthorization: true) { [self] obj in
            print("Approved is : ", obj)
            var message = ""
            if (status == "approved") {
                message = LocalizationKey.availabilityRequestAccepted.localizing()
            } else {
                message = LocalizationKey.availabilityRequestRejected.localizing()
            }
            showAlert(message: message, strtitle: LocalizationKey.success.localizing()) {_ in
                if let index = self.arrAllAvailabilityData.firstIndex(where: {$0.id == availabilityID}) {
                    self.arrAllAvailabilityData[index].status = status
                    self.availabilityTblVw.reloadRows(at: [self.selectedIndexPath], with: .automatic)
                }}
        }
    }
}

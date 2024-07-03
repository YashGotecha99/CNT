//
//  NotificationVC.swift
//  TimeControllApp
//
//  Created by mukesh on 23/07/22.
//

import UIKit
import SVProgressHUD

class NotificationVC: BaseViewController {

    @IBOutlet weak var notificationTblVw: UITableView!
//    var notificationData : [NotificationScreenModel]? = []
    var notificationData : [Notifications]? = []
    var filteredData : [Notifications]?

    var isLoadingList : Bool = false
    var isMoreNotificationData : Bool = true
    @IBOutlet weak var notificationTitleLbl: UILabel!
    @IBOutlet weak var clearBtnObj: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    
    var selectedWorkHoursSegmmentIndex = Int()
    weak var delegate : WorkHoursVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpLocalization()
        configUI()
    }
    
    func setUpLocalization(){
        notificationTitleLbl.text = LocalizationKey.notifications.localizing()
        clearBtnObj.setTitle(LocalizationKey.clear.localizing(), for: .normal)
        txtSearch.placeholder = LocalizationKey.search.localizing()
    }
    
    func configUI() {
        notificationTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ShiftRequestTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ShiftRequestTVC.rawValue)
        
        notificationTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.NotificationTypeTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.NotificationTypeTVC.rawValue)
        GlobleVariables.page = 0
        self.notificationData?.removeAll()
        self.filteredData?.removeAll()
        getNotificationListAPI()
//        notificationTblVw.reloadData()
    }
    
    @IBAction func btnClearAction(_ sender: Any) {
        clearNotificationAPI()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.checkWorkHoursDetails)
        delegate?.checkWorkHoursSegmentIndex(segmentIndex: selectedWorkHoursSegmmentIndex)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
//        return 6
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ShiftRequestTVC.rawValue, for: indexPath) as? ShiftRequestTVC
            else { return UITableViewCell() }
          
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.NotificationTypeTVC.rawValue, for: indexPath) as? NotificationTypeTVC
        else { return UITableViewCell() }
        if indexPath.row % 2 == 0 {
            cell.backgroundVw.backgroundColor = #colorLiteral(red: 1, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        } else {
            cell.backgroundVw.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9411764706, blue: 0.9960784314, alpha: 1)
        }
        return cell
        */
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.NotificationTypeTVC.rawValue, for: indexPath) as? NotificationTypeTVC
        else { return UITableViewCell() }
        
        if (filteredData?.count ?? 0 > 0) {
            cell.setData(rowsData: (filteredData?[indexPath.row])!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        readNotificationAPI(notificationID: filteredData?[indexPath.row].id ?? 0)
        
        if filteredData?[indexPath.row].data?.context?.source == "schedule" {
            if filteredData?[indexPath.row].data?.context?.subsource == "availability" {
                let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "AvailabilityListVC") as! AvailabilityListVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else if filteredData?[indexPath.row].data?.context?.subsource == "swap_history" {
                if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesVC") as! SwapTradesVC
                    vc.isNotificationForMySwap = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
                    vc.isNotificationForMySwap = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else if filteredData?[indexPath.row].data?.context?.subsource == "new_swaps" {
                if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesVC") as! SwapTradesVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else if filteredData?[indexPath.row].data?.context?.subsource == "grab_shift" {
                if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
                    let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "UpToGrabsListVC") as! UpToGrabsListVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ScheduleListVC") as! ScheduleListVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ScheduleListVC") as! ScheduleListVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if filteredData?[indexPath.row].data?.context?.source == "chat" {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.roomId = filteredData?[indexPath.row].data?.context?.room ?? 0
            vc.selectedSegmentStr = "0"
            vc.selectedSegmentStr = "Project"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if filteredData?[indexPath.row].data?.context?.source == "privatechat" {
            if ((filteredData?[indexPath.row].data?.context?.isChatRoomDeleted) != nil) {

            } else {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                vc.roomId = filteredData?[indexPath.row].data?.context?.room ?? 0
                vc.selectedSegmentStr = "0"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if filteredData?[indexPath.row].data?.context?.source == "timelogs" {
            if filteredData?[indexPath.row].data?.context?.id != 0 || filteredData?[indexPath.row].data?.context?.id != nil {
                let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "AddWorkDocumentVC") as! AddWorkDocumentVC
                vc.comingFrom = "workHourDetail"
                let timelogsID = filteredData?[indexPath.row].data?.context?.id
//                vc.id = timelogsID ?? ""
                vc.id = "\(filteredData?[indexPath.row].data?.context?.id ?? 0)"
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.tabBarController?.selectedIndex = 1
            }
        } else if filteredData?[indexPath.row].data?.context?.source == "vacations" {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VacationAbsenceVC") as! VacationAbsenceVC
            if filteredData?[indexPath.row].data?.context?.subsource == "pending" {
                vc.selectedSegmentIndex = 2
            } else {
                vc.selectedSegmentIndex = 0
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if filteredData?[indexPath.row].data?.context?.source == "absences" {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VacationAbsenceVC") as! VacationAbsenceVC
//            vc.selectedSegmentIndex = 1
            if filteredData?[indexPath.row].data?.context?.subsource == "pending" {
                vc.selectedSegmentIndex = 2
            } else {
                vc.selectedSegmentIndex = 1
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if filteredData?[indexPath.row].data?.context?.source == "shifts" {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ScheduleListVC") as! ScheduleListVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if filteredData?[indexPath.row].data?.context?.source == "deviation" {
            if filteredData?[indexPath.row].data?.context?.id != 0 || filteredData?[indexPath.row].data?.context?.id != nil {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DeviationDetailVC") as! DeviationDetailVC
                vc.selectedSegmmentIndex = 0
//                vc.delegate = self
//                vc.selectedDeviationsID = Int(notificationData?[indexPath.row].data?.context?.id ?? "0") ?? 0
                vc.selectedDeviationsID = filteredData?[indexPath.row].data?.context?.id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DeviationVC") as! DeviationVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (filteredData?.count ?? 0) - 1 && isMoreNotificationData {
            GlobleVariables.page = GlobleVariables.page + 1
            getNotificationListAPI()
        }
    }
    
}
extension NotificationVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if currentText.isEmpty {
            filteredData = notificationData
        } else {
            filteredData = notificationData?.filter { notification in
                guard let name = notification.data?.context?.source else { return false }
                    return name.lowercased().contains(currentText.lowercased())
            }
        }
        notificationTblVw.reloadData()
       return true
    }
}

extension NotificationVC {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let screenSize: CGRect = UIScreen.main.bounds
//        let screenHeight = screenSize.height / 2
//
//        if (((scrollView.contentOffset.y + scrollView.frame.size.height + screenHeight) > scrollView.contentSize.height ) && !isLoadingList && isMoreNotificationData  ) {
//            self.isLoadingList = true
//            GlobleVariables.page = GlobleVariables.page + 1
//            getNotificationListAPI()
//        }
//    }
}

//MARK: APi Work in View controller
extension NotificationVC {
    func getNotificationListAPI() {
//        SVProgressHUD.show()
//        let param = [String:Any]()
//
//        WorkHourVM.shared.notificationListAPI(parameters: param){ [self] obj in
//            notificationData = obj
//            self.notificationTblVw.reloadData()
//        }
        

        self.isLoadingList = false
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        print(param)
        
        WorkHourVM.shared.notificationListAPI(parameters: param, isAuthorization: true) { [self] obj in
            
            if obj.notifications?.count ?? 0 > 0{
                self.isMoreNotificationData = true
            }else{
                self.isMoreNotificationData = false
            }
            for model in obj.notifications ?? []{
                self.notificationData?.append(model)
            }
            filteredData = notificationData
            self.notificationTblVw.reloadData()
        }
    }
    
    func clearNotificationAPI() {
        SVProgressHUD.show()
        let param = [String:Any]()
        
        WorkHourVM.shared.clearNotificationAPI(parameters: param, isAuthorization: true) { [self] obj in
            self.notificationData = []
            self.filteredData = []
            self.notificationTblVw.reloadData()
        }
    }
    
    func readNotificationAPI(notificationID: Int) {
        SVProgressHUD.show()
        var param = [String:Any]()
        param["notification_id"] = notificationID
        
        WorkHourVM.shared.updateNotificationReadStatus(parameters: param, isAuthorization: true) { [self] obj in
            
            print("Update read notification data : ", obj)
            
        }
    }
}

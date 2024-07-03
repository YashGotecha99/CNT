//
//  SwapDetailsVC.swift
//  TimeControllApp
//
//  Created by yash on 09/01/23.
//

import UIKit
import FSCalendar

class SwapDetailsVC: BaseViewController {
    
    @IBOutlet weak var employeeTblVw: UITableView!
    
    @IBOutlet weak var calenderMainVw: UIView!
    @IBOutlet weak var calenderVwHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var calenderVw: FSCalendar!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var shiftTitleLbl: UILabel!
    
    @IBOutlet weak var bottomSheetMainView: UIView!
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var swapDetailsTitleLbl: UILabel!
    @IBOutlet weak var selectAShiftToLbl: UILabel!
    @IBOutlet weak var staticSelectDateLbl: UILabel!
    @IBOutlet weak var staticEndDateLbl: UILabel!
    @IBOutlet weak var selectEmployeeLbl: UILabel!
    @IBOutlet weak var thankYouForSwappingLbl: UILabel!
    @IBOutlet weak var sendRequestBtnObj: UIButton!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    var shift : FormattedData?
    
    var selectedShiftArray : [ShiftsOfUser] = []
    @IBOutlet weak var staticReasonForSwapLbl: UILabel!
    @IBOutlet weak var tvReason: UITextView!
    @IBOutlet weak var btnObjSwapSwift: UIButton!
    @IBOutlet weak var btnObjTradeSwift: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var isTradeSwift = Bool()
    var selectedSwapEmployeesArray : [Availableusers]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        isTradeSwift = true
        swapDetailsTitleLbl.text = LocalizationKey.schedule.localizing()
        shiftTitleLbl.text = LocalizationKey.swappingOrTradingYourShiftOnMondayDec199050PM.localizing() + "\(logTime(time: shift?.start_time ?? 0)) - \(logTime(time: shift?.end_time ?? 0))"
        selectAShiftToLbl.text = LocalizationKey.selectAShiftToSwapOrTradeWith.localizing()
        staticSelectDateLbl.text = LocalizationKey.selectDate.localizing()
        staticEndDateLbl.text = LocalizationKey.endDate.localizing()
        dateTxt.placeholder = LocalizationKey.selectDate.localizing()
        selectEmployeeLbl.text = LocalizationKey.selectEmployee.localizing()
        sendRequestBtnObj.setTitle(LocalizationKey.sendRequest.localizing(), for: .normal)
        thankYouForSwappingLbl.text = LocalizationKey.thankYouForSwappingTradingTheShiftTheEmployeesHasBeenInformedPleaseWaitForTheAcceptance.localizing()
    }
    
    func configUI() {
        
        shiftTitleLbl.text = LocalizationKey.swappingOrTradingYourShiftOn.localizing() + " \(shift?.for_date?.convertAllFormater(formated: "EEEE") ?? ""),\n" + "\(shift?.for_date?.convertAllFormater(formated: "LLL") ?? "") " + "\(shift?.for_date?.convertAllFormater(formated: "dd") ?? "") @ " + "\(logTime(time: shift?.start_time ?? 0)) - \(logTime(time: shift?.end_time ?? 0))"
        //"Monday, Dec 19 @ 9:00AM - 5:00PM"
        
        dateTxt.text =  shift?.for_date ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        calenderVw.select(dateFormatter.date(from: shift?.for_date ?? dateFormatter.string(from: Date())))
        
        sheetView.layer.cornerRadius = 39
        sheetView.layer.masksToBounds = true
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        bottomSheetMainView.addGestureRecognizer(tap)
        bottomSheetMainView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapScroll(_:)))
        tapGesture.cancelsTouchesInView = false // Allow touches to propagate to subviews
        scrollView.addGestureRecognizer(tapGesture)
        
        calenderMainVw.clipsToBounds = true
        calenderMainVw.layer.cornerRadius = 20
        calenderMainVw.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        calenderMainVw.isHidden = true
        
        calenderVw.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9490196078, blue: 0.9725490196, alpha: 1)
        calenderVw.appearance.selectionColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
        calenderVw.appearance.subtitleSelectionColor = .white
        calenderVw.appearance.headerTitleColor = UIColor.black
        calenderVw.appearance.headerTitleFont = UIFont.init(name: "SFProText-Medium", size: 16)
        
        calenderVw.appearance.weekdayTextColor = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.5962744473)
        calenderVw.appearance.weekdayFont = UIFont.init(name: "SFProText-Medium", size: 13)
        
        calenderVw.appearance.titleDefaultColor = .black
//        calenderVw.appearance.todayColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
        calenderVw.appearance.todaySelectionColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
        calenderVw.allowsMultipleSelection = false
        self.calenderVw.scope = .month
        self.calenderVw.firstWeekday = 2
        
        calenderVw.dataSource = self
        calenderVw.delegate = self
        
        
        self.employeeTblVw.isHidden = true
        self.employeeTblVw.separatorColor = UIColor.clear
        employeeTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SwapEmployeeTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SwapEmployeeTVC.rawValue)
        
        employeeTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.calenderMainVw {
            calenderMainVw.isHidden = true
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
    }
    
    @objc func handleTapScroll(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: scrollView)
        
        // Check if the tap location is outside the popup view
        if !calenderMainVw.frame.contains(tapLocation) {
            // Hide the popup view
            calenderMainVw.isHidden = true
        }
    }
    
    @IBAction func crossBtn(_ sender: Any) {
        bottomSheetMainView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectEmployeeBtn(_ sender: Any) {
        if isTradeSwift {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapEmployeeListVC") as! SwapEmployeeListVC
            vc.for_date = dateTxt.text ?? ""
            vc.tradeshift = "\(shift?.id ?? 0)"
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "CreateChatVC") as! CreateChatVC
            vc.iscomingFrom = "swap-swift"
            vc.swapId = shift?.id ?? 0
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func selectDateBtn(_ sender: Any) {
        calenderMainVw.isHidden = false
    }
    @IBAction func sendRequestBtn(_ sender: Any) {
        if isTradeSwift {
            if selectedShiftArray.count < 1 {
                self.showAlert(message: LocalizationKey.pleaseSelectEmployee.localizing(), strtitle: "")
                return
            }
            self.sendTradeRequest()
        } else {
            if selectedSwapEmployeesArray?.count ?? 0 < 1 {
                self.showAlert(message: LocalizationKey.pleaseSelectEmployee.localizing(), strtitle: "")
                return
            }
            self.sendSwiftRequest()
        }
    }
    
    @IBAction func btnClickedTradeSwift(_ sender: Any) {
        isTradeSwift = true
        btnObjTradeSwift.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnObjSwapSwift.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        self.selectedSwapEmployeesArray = []
        employeeTblVw.isHidden = true
        contentViewHeight.constant = CGFloat(470)
        employeeTblVw.reloadData()
        
    }
    
    @IBAction func btnClickedSwapSwift(_ sender: Any) {
        isTradeSwift = false
        btnObjTradeSwift.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnObjSwapSwift.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        self.selectedShiftArray = []
        employeeTblVw.isHidden = true
        contentViewHeight.constant = CGFloat(470)
        employeeTblVw.reloadData()
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension SwapDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 1
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noEmployeeAvailable.localizing()
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
        if isTradeSwift {
            return selectedShiftArray.count
        } else {
            return selectedSwapEmployeesArray?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isTradeSwift {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SwapEmployeeTVC.rawValue, for: indexPath) as? SwapEmployeeTVC else { return UITableViewCell() }
            let obj = selectedShiftArray[indexPath.row]
            cell.setCellValue(shiftsOfUser: obj)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EmployeeListShiftTVC.rawValue, for: indexPath) as? EmployeeListShiftTVC
        else { return UITableViewCell() }
        cell.selectedEmplyeeRadioBtn.isHidden = true
        cell.selectedEmplyeeRadioBtn.isUserInteractionEnabled = false
        guard  let swapEmployee = selectedSwapEmployeesArray?[indexPath.row] else {
            return cell
        }
        cell.setSwapData(availableUser: swapEmployee)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isTradeSwift {
            return 230.0
        }else {
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension SwapDetailsVC :FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fday = formatter.string(from: date)
        dateTxt.text = fday
        calenderMainVw.isHidden = true
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

extension SwapDetailsVC{
    private func sendTradeRequest(){
        var param = [String:Any]()
        param["fromShiftId"] = shift?.id
        param["fromUserID"] = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)
        param["shiftDate"] = shift?.for_date
        param["swap_type"] = "trade-shift"
        
        var shiftArray = [[String:Any]]()
        for i in 0..<selectedShiftArray.count{
            var shift = [String:Any]()
            shift["shiftID"] = selectedShiftArray[i].shift_id
            shift["userID"] = selectedShiftArray[i].id
            shift["for_date"] = selectedShiftArray[i].for_date
            shiftArray.append(shift)
        }
        param["swapShiftDetails"] = shiftArray
        
        print("param",param)
        
        ScheduleListVM.shared.sendRequestForTrade(parameters: param){ [self] obj in
            self.bottomSheetMainView.isHidden = false
        }
    }
    
    private func sendSwiftRequest(){
        var param = [String:Any]()
        
//        send swap request for sending grab request as well
//        post
//        /api/schedule/send_swap_request
//        payload-
//        fromUser: 237 (which user is send sick leave)
//        shiftId: 605 ( the shift of the sick user)
//        swap_type: "sick-leave"  (type of swap)
//        users: [33, 104, 34, 228, 39] (here member will choose member who he want to give the shift)
                         
        var selectedUsers = [Int]()
        for i in 0..<(self.selectedSwapEmployeesArray?.count ?? 0) {
            selectedUsers.append(self.selectedSwapEmployeesArray?[i].id ?? 0)
        }

        print("selectedUsers is : ", selectedUsers)
        
        param["fromUser"] = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)
        param["shiftId"] = shift?.id
        param["swap_type"] = "swap-shift"
        param["users"] = selectedUsers
        
        print("param",param)
        
        
        ScheduleListVM.shared.sendRequestForSwapSwift(parameters: param){ [self] obj in
            self.bottomSheetMainView.isHidden = false
        }
    }
}

//
//  ScheduleListVC.swift
//  TimeControllApp
//
//  Created by mukesh on 07/08/22.
//

import UIKit
import FSCalendar
import SVProgressHUD
class ScheduleListVC: BaseViewController {

    @IBOutlet weak var scheduleSegmentControl: UISegmentedControl!
    @IBOutlet weak var scheduleMemberSegmentControl: UISegmentedControl!
    @IBOutlet weak var scheduleSegmentHeight: NSLayoutConstraint!
    @IBOutlet weak var scheduleMemberSegmentHeight: NSLayoutConstraint!
    @IBOutlet weak var scheduleListTblVw: UITableView!
    @IBOutlet weak var calenderMainVw: UIView!
    @IBOutlet weak var calenderVwHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var calenderVw: FSCalendar!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpViewForPM: UIView!
    
    @IBOutlet weak var checkAvailabilityPMCountLbl: UILabel!
    
    @IBOutlet weak var shiftRequestsPMCountLbl: UILabel!
    
    @IBOutlet weak var scheduleTitleLbl: UILabel!
    @IBOutlet weak var upForGrabsLbl: UILabel!
    @IBOutlet weak var updateAvailabiltyLbl: UILabel!
    @IBOutlet weak var swapTradesLbl: UILabel!
    @IBOutlet weak var copyWeekLbl: UILabel!
    @IBOutlet weak var shiftRequestLbl: UILabel!
    @IBOutlet weak var checkAvailabilityLbl: UILabel!
    @IBOutlet weak var successfullyCopiedWithLbl: UILabel!
    @IBOutlet weak var upForGrabsCount: UILabel!
    @IBOutlet weak var updateAvailabiltyCount: UILabel!
    @IBOutlet weak var swapTradeCount: UILabel!
    
    
    var currentDate = Date()
    
    var datesArray: [FormattedShifts] = []
    
    var isMember = false
    
    @IBOutlet weak var btnCreateSchedule: UIButton!
    
    public var scheduleListViewModel = ScheduleListViewModel()
    
    private var segmentControlIndex = 0

    var arrScheduleApprovedData: [Shifts] = []
    var arrSchedulePendingData: [Shifts] = []

    var startDateStr = ""
    var endDateStr = ""
    
    @IBOutlet weak var bottomSheet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        scheduleTitleLbl.text = LocalizationKey.schedule.localizing()
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            scheduleSegmentControl.setTitle(LocalizationKey.myShift.localizing(), forSegmentAt: 0)
            scheduleSegmentControl.setTitle(LocalizationKey.colleagueShift.localizing(), forSegmentAt: 1)
        } else {
            scheduleSegmentControl.setTitle(LocalizationKey.schedule.localizing(), forSegmentAt: 0)
            scheduleSegmentControl.setTitle(LocalizationKey.pending.localizing(), forSegmentAt: 1)
        }
        upForGrabsLbl.text = LocalizationKey.upForGrabs.localizing()
        updateAvailabiltyLbl.text = LocalizationKey.updateAvailabilty.localizing()
        swapTradesLbl.text = LocalizationKey.swapTrades.localizing()
        
        copyWeekLbl.text = LocalizationKey.copyWeek.localizing()
        shiftRequestLbl.text = LocalizationKey.shiftRequests.localizing()
        checkAvailabilityLbl.text = LocalizationKey.checkAvailability.localizing()
        
        successfullyCopiedWithLbl.text = LocalizationKey.successfullyCopiedWithCurrentWeekToNextWeek.localizing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bottomSheet.isHidden = true
        callAPI()
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            btnCreateSchedule.isHidden = false
        }
        else {
            btnCreateSchedule.isHidden = true
        }
        
    }
    
    @IBAction func crossBtnAction(_ sender: Any) {
        popUpView.isHidden = true
    }
    
    @IBAction func UpToGrabsBtn(_ sender: Any) {
        popUpView.isHidden = true
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "UpToGrabsListVC") as! UpToGrabsListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func SwapTradesBtn(_ sender: Any) {
        popUpView.isHidden = true
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesVC") as! SwapTradesVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func UpdateAvailabityBtn(_ sender: Any) {
        popUpView.isHidden = true
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "AvailabilityListMemebrVC") as! AvailabilityListMemebrVC
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "AvailabilityListVC") as! AvailabilityListVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func crossPMBtnClicked(_ sender: Any) {
        popUpViewForPM.isHidden = true
        popUpView.isHidden = true
    }
    
    @IBAction func copyWeekBtnClicked(_ sender: Any) {
        popUpViewForPM.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDate = Date()
        var dateComponent = DateComponents()
        
        var monday = currentDate
        var mondayDay = dateFormatter.string(from: monday)
        while (mondayDay != "Monday") {
            dateComponent.day = -1
            monday = Calendar.current.date(byAdding: dateComponent, to: monday)!
            mondayDay = dateFormatter.string(from: monday)
        }
        print("Monday is", monday)
        
        var sunday = currentDate
        var sundayDay = dateFormatter.string(from: sunday)
        while (sundayDay != "Sunday") {
            dateComponent.day = 1
            sunday = Calendar.current.date(byAdding: dateComponent, to: sunday)!
            sundayDay = dateFormatter.string(from: sunday)
        }
        print("Sunday is", sunday)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let finalMonday = dateFormatter1.string(from: monday)
        let finalSunday = dateFormatter1.string(from: sunday)

        self.copyWeekAPI(monday: finalMonday, sunday: finalSunday)
    }
    
    @IBAction func shiftRequestsBtnClicked(_ sender: Any) {
        popUpViewForPM.isHidden = true
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func checkAvailabilityBtnClicked(_ sender: Any) {
        popUpViewForPM.isHidden = true
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "AvailabilityListVC") as! AvailabilityListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                self.calenderVw.scope = .month
                calenderVwHeightConstr.constant = 360.0
            case .left:
                print("Swiped left")
            case .up:
                self.calenderVw.scope = .week
                calenderVwHeightConstr.constant = 160.0
            default:
                break
            }
        }
    }
    
    func configUI() {
        
        popUpView.isHidden = true
        popUpViewForPM.isHidden = true

        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            isMember = true
            scheduleSegmentControl.isHidden = false
            scheduleSegmentHeight.constant = 38
        } else {
            isMember = false
            scheduleSegmentControl.isHidden = false
            scheduleSegmentHeight.constant = 38
        }
        
//        scheduleSegmentControl.isHidden = false
//        scheduleSegmentControl.setTitle(LocalizationKey.myShift.localizing(), forSegmentAt: 0)
//        scheduleSegmentControl.setTitle(LocalizationKey.colleagueShift.localizing(), forSegmentAt: 1)
//        scheduleSegmentHeight.constant = 38

        
        calenderMainVw.clipsToBounds = true
        calenderMainVw.layer.cornerRadius = 20
        calenderMainVw.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
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
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeRight.direction = .up
            self.calenderMainVw.addGestureRecognizer(swipeRight)

            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeDown.direction = .down
            self.calenderMainVw.addGestureRecognizer(swipeDown)
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        scheduleSegmentControl.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        scheduleSegmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        self.scheduleListTblVw.separatorColor = UIColor.clear
        scheduleListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ScheduleListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ScheduleListTVC.rawValue)
        scheduleListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ScheduleListMemberTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ScheduleListMemberTVC.rawValue)
        scheduleListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ScheduleListMemberColleagueTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ScheduleListMemberColleagueTVC.rawValue)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [self] in
            let temp = UISwipeGestureRecognizer()
            temp.direction = .up
            self.respondToSwipeGesture(gesture: temp)
        })
        
        scheduleListTblVw.reloadData()
        
        scheduleSegmentControl.addTarget(self, action: "segmentedControlValueChanged:", for: UIControl.Event.valueChanged)

    }
    
    func callAPI(){
        getAllShiftCountAPI()
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let date = Calendar.current.date(byAdding: .day, value: 10, to: Date()) {
                //print(Date().allDates(till: date))
                let startResult = formatter.string(from: Date())
                let endResult = formatter.string(from: date)
                self.scheduleList(startDate: startResult, endDate: endResult)
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: Date())
            startDateStr = result
            endDateStr = result
            self.scheduleFilterApi(startDate: result, endDate: result)
        }
    }
    
    @IBAction func createShiftBtnAction(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CreateShiftVC") as! CreateShiftVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func moreBtnAction(_ sender: Any) {
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MoreScheduleVC") as! MoreScheduleVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            popUpView.isHidden = false
        }
        else {
            popUpViewForPM.isHidden = false
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            segmentControlIndex = sender.selectedSegmentIndex
            if segmentControlIndex == 0 {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                if let date = Calendar.current.date(byAdding: .day, value: 10, to: Date()) {
                    //print(Date().allDates(till: date))
                    let startResult = formatter.string(from: Date())
                    let endResult = formatter.string(from: date)
                    self.scheduleList(startDate: startResult, endDate: endResult)
                }
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                if let date = Calendar.current.date(byAdding: .day, value: 10, to: Date()) {
                    //print(Date().allDates(till: date))
                    let startResult = formatter.string(from: Date())
                    let endResult = formatter.string(from: date)
                    self.scheduleList(startDate: startResult, endDate: endResult)
                }
            }
        } else {
            segmentControlIndex = sender.selectedSegmentIndex
            self.scheduleFilterApi(startDate: startDateStr, endDate: endDateStr)
        }
    }
    
    @IBAction func closeBottomSheet(_ sender: Any) {
        bottomSheet.isHidden = true
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension ScheduleListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

//        var count = scheduleListViewModel.scheduleListModel?.shifts?.count ?? 0
        var count = 0
        if segmentControlIndex == 0 {
            count = arrScheduleApprovedData.count
        }
        else {
            count = arrSchedulePendingData.count
        }

        if count < 1 && !isMember{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noScheduleAvailable.localizing()
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
        if isMember {
            if segmentControlIndex == 0 {
                return datesArray.count
            }
            else {
                return datesArray.count
            }
        } else {
            if segmentControlIndex == 0 {
                return arrScheduleApprovedData.count
            }
            else {
                return arrSchedulePendingData.count
            }
//            return scheduleListViewModel.scheduleListModel?.shifts?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isMember {
            if segmentControlIndex == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ScheduleListMemberTVC.rawValue, for: indexPath) as? ScheduleListMemberTVC else { return UITableViewCell() }
                
                let obj = datesArray[indexPath.row]
                cell.setCellValue(formattedShifts: obj)
                cell.delegate = self
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ScheduleListMemberColleagueTVC.rawValue, for: indexPath) as? ScheduleListMemberColleagueTVC else { return UITableViewCell() }
            
            let obj = datesArray[indexPath.row]
            cell.setCellValue(formattedShifts: obj)
            cell.delegate = self
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ScheduleListTVC.rawValue, for: indexPath) as? ScheduleListTVC else { return UITableViewCell() }
//            let shift = scheduleListViewModel.scheduleListModel?.shifts?[indexPath.row]
//
//            cell.assigneeNameLbl.text = shift?.assignee_name
//            cell.projectNameLbl.text = shift?.project_name
//            cell.shiftTimeLbl.text = "\(logTime(time: shift?.start_time ?? 0)) - \(logTime(time: shift?.end_time ?? 0))"

            if segmentControlIndex == 0 {
                let shift = arrScheduleApprovedData[indexPath.row]
                
                cell.userImgWidthConstraints.constant = 40
                cell.assigneeNameLbl.text = shift.assignee_name
                cell.projectNameLbl.text = shift.project_name
                cell.shiftTimeLbl.text = "\(logTime(time: shift.start_time ?? 0)) - \(logTime(time: shift.end_time ?? 0))"
               
                let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
                let url = URL(string: strUrl + "/\(shift.user_image ?? "")")
                cell.userImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                cell.userImg.contentMode = .scaleAspectFill
            }
            else {
                let shift = arrSchedulePendingData[indexPath.row]
                
                cell.userImgWidthConstraints.constant = 0
                
                cell.assigneeNameLbl.text = shift.project_name
                cell.projectNameLbl.text = shift.project_name
                cell.shiftTimeLbl.text = "\(logTime(time: shift.start_time ?? 0)) - \(logTime(time: shift.end_time ?? 0))"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isMember {
            return
        } else {
            print("datesArray is : ", datesArray)
//            print("datesArray[indexPath.row] is : ", datesArray[indexPath.row])
//            print("[indexPath.row] is : ", indexPath.row)

            if datesArray.count > 0 {
                let obj = datesArray[indexPath.row]
                print(obj.data)
                
                if obj.data?.count ?? 0 > 0 {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let currentDate = dateFormatter.string(from: Date())
                    
                    guard let timeZone = TimeZone(identifier: "GMT") else {
                        // Handle the case where timeZone is nil (invalid identifier)
                        // You can log an error, return a default value, or handle it in an appropriate way
                        return // Example default value, adjust as needed
                    }
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.timeZone = timeZone
                    dateFormatter1.dateFormat = "HH:mm"
                    let currentDate1 = dateFormatter1.string(from: Date())
                    print("getCurrentTime: \(currentDate1)")
                    
                    let currentDateSplit = currentDate1.components(separatedBy: ":")
                    let currentHours: String = currentDateSplit[0]
                    let currentMinute: String = currentDateSplit[1]
                    
                    //       return (Int(currentHours) + (GlobleVariables.timezoneGMT ?? 0)) * 60 + Int(currentMinute)
                    
                    let currentHoursInt = Int(currentHours) ?? 0
                    let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
                    let currentMinuteInt = Int(currentMinute) ?? 0
                    
                    let totalMinutes = (currentHoursInt + timezoneOffset) * 60 + currentMinuteInt
                    
                    if obj.data?[0].for_date ?? "" < currentDate {
                        
                        if segmentControlIndex == 0 {
                            presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.youCanNotSwapPastDate.localizing())
                        } else {
                            if isMember && obj.data?.count ?? 0 > 1{
                                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchduleDayListVC") as! SchduleDayListVC
                                vc.formattedShifts = obj
                                vc.isComingFrom = false
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    } else {
                        if segmentControlIndex == 0 {
                            
                            if isMember && obj.data?.count ?? 0 > 1{
                                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchduleDayListVC") as! SchduleDayListVC
                                vc.formattedShifts = obj
                                vc.isComingFrom = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else if isMember && obj.data?.count ?? 0 == 1 {
                                if ((obj.data?[0].for_date ?? "" < currentDate) && (obj.data?[0].end_time ?? 0 < Int(totalMinutes))) {
                                    presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.youCanNotSwapPastDate.localizing())
                                } else if ((obj.data?[0].for_date ?? "" == currentDate) && (obj.data?[0].end_time ?? 0 < Int(totalMinutes))) {
                                    presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.youCanNotSwapPastDate.localizing())
                                } else {
                                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapDetailsVC") as! SwapDetailsVC
                                    vc.shift = obj.data?[0]
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                        else {
                            if isMember && obj.data?.count ?? 0 > 1{
                                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchduleDayListVC") as! SchduleDayListVC
                                vc.formattedShifts = obj
                                vc.isComingFrom = false
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

/*
 
 
 {
     
     let obj = datesArray[indexPath.row]
     print(obj.data)
     
     if obj.data?.count ?? 0 > 0 {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let currentDate = dateFormatter.string(from: Date())
         
         guard let timeZone = TimeZone(identifier: "GMT") else {
             // Handle the case where timeZone is nil (invalid identifier)
             // You can log an error, return a default value, or handle it in an appropriate way
             return // Example default value, adjust as needed
         }
         let dateFormatter1 = DateFormatter()
         dateFormatter1.timeZone = timeZone
         dateFormatter1.dateFormat = "HH:mm"
         let currentDate1 = dateFormatter1.string(from: Date())
         print("getCurrentTime: \(currentDate1)")
         
         let currentDateSplit = currentDate1.components(separatedBy: ":")
         let currentHours: String = currentDateSplit[0]
         let currentMinute: String = currentDateSplit[1]
         
 //       return (Int(currentHours) + (GlobleVariables.timezoneGMT ?? 0)) * 60 + Int(currentMinute)
         
         let currentHoursInt = Int(currentHours) ?? 0
         let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
         let currentMinuteInt = Int(currentMinute) ?? 0

         let totalMinutes = (currentHoursInt + timezoneOffset) * 60 + currentMinuteInt
         print("totalMinutes: \(totalMinutes)")

         if obj.data?[0].end_time ?? 0 < Int(totalMinutes) ?? 0 {
             
             if segmentControlIndex == 0 {
                 if isMember && obj.data?.count ?? 0 > 1{
                     let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchduleDayListVC") as! SchduleDayListVC
                     vc.formattedShifts = obj
                     vc.isComingFrom = true
                     self.navigationController?.pushViewController(vc, animated: true)
                 } else if isMember && obj.data?.count ?? 0 == 1 {
                     presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.youCanNotSwapPastDate.localizing())
                 }
             } else {
                 if isMember && obj.data?.count ?? 0 > 1{
                     let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchduleDayListVC") as! SchduleDayListVC
                     vc.formattedShifts = obj
                     vc.isComingFrom = false
                     self.navigationController?.pushViewController(vc, animated: true)
                 }
             }
             
         } else {
             if segmentControlIndex == 0 {
                 
                 if isMember && obj.data?.count ?? 0 > 1{
                     let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchduleDayListVC") as! SchduleDayListVC
                     vc.formattedShifts = obj
                     vc.isComingFrom = true
                     self.navigationController?.pushViewController(vc, animated: true)
                 } else if isMember && obj.data?.count ?? 0 == 1 {
                     let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapDetailsVC") as! SwapDetailsVC
                     vc.shift = obj.data?[0]
                     self.navigationController?.pushViewController(vc, animated: true)
                 }
             }
             else {
                 if isMember && obj.data?.count ?? 0 > 1{
                     let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchduleDayListVC") as! SchduleDayListVC
                     vc.formattedShifts = obj
                     vc.isComingFrom = false
                     self.navigationController?.pushViewController(vc, animated: true)
                 }
             }
         }
     }
 }
 */



extension ScheduleListVC :FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        var deSelctedWeek = currentDate.daysOfWeek
//        deSelctedWeek.forEach { (d) in
//            self.calenderVw.deselect(d)
//        }
//
//        var selectedWeek = date.daysOfWeek
//        selectedWeek.forEach { (d) in
//            self.calenderVw.select(d, scrollToDate: true)
//        }
//        currentDate = date
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let d = Calendar.current.date(byAdding: .day, value: 10, to: date) {
                //print(Date().allDates(till: date))
                let startResult = formatter.string(from: date)
                let endResult = formatter.string(from: d)
                self.scheduleList(startDate: startResult, endDate: endResult)
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let fday = formatter.string(from: date)
            let lday = formatter.string(from: date)
            startDateStr = formatter.string(from: date)
            endDateStr = formatter.string(from: date)
            scheduleListViewModel = ScheduleListViewModel()
            self.scheduleFilterApi(startDate: fday, endDate: lday)
        }
    }
    
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date()
//    }
}

//MARK: APi Work in View controller
extension ScheduleListVC{
//   private func scheduleApi(startDate:String,endDate:String){
//       SVProgressHUD.show()
//       scheduleListViewModel.schedule(startDate:startDate,endDate: endDate){ (message) in
//        SVProgressHUD.dismiss()
//           if message == "Successfully" {
//               displayToast(message)
//               self.scheduleListTblVw.reloadData()
//           } else {
//               displayToast(message)
//          }
//       }
//   }
    
    private func scheduleFilterApi(startDate:String,endDate:String){
        SVProgressHUD.show()
        var param = [String:Any]()
        param["start"] = startDate
        param["end"] = endDate
        
        print(param)
        ScheduleListVM.shared.scheduleFilterList(parameters: param){ [self] obj in
            arrScheduleApprovedData = []
            arrSchedulePendingData = []
            
            for i in 0..<(obj.shifts?.count ?? 0) {
                if (segmentControlIndex == 0 && obj.shifts?[i].status == "assigned") {
                    arrScheduleApprovedData.append((obj.shifts?[i])!)
                }
                else if (segmentControlIndex == 1 && obj.shifts?[i].status == "pending"){
                    arrSchedulePendingData.append((obj.shifts?[i])!)
                }
            }
            self.scheduleListTblVw.reloadData()
        }
    }
    
    private func scheduleList(startDate:String,endDate:String){
        datesArray.removeAll()
        var param = [String:Any]()
        param["userType"] = "Member"
        param["userId"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        param["start"] = startDate
        param["end"] = endDate
        param["mobile"] = "true"
        
        if segmentControlIndex == 0 {
            param["filterByRole"] = "false"
        } else {
            param["filterByRole"] = "true"
        }
        
        print(param)
        
        ScheduleListVM.shared.scheduleList(parameters: param){ [self] obj in
            datesArray = obj.formattedShifts ?? []
            self.scheduleListTblVw.reloadData()
        }
    }
    
    func copyWeekAPI(monday: String, sunday: String) {
        SVProgressHUD.show()
        var param = [String:Any]()
        param["start"] = monday
        param["end"] = sunday
        
        ScheduleListVM.shared.copyWeekAPI(parameters: param, isAuthorization: true) { [self] obj in
            print("Copy data is : ", obj)
            bottomSheet.isHidden = false
        }
    }
    func getAllShiftCountAPI() {
        var param = [String:Any]()
        
        ScheduleListVM.shared.getAllShiftCount(parameters: param, isAuthorization: true) { [self] obj in
            self.upForGrabsCount.text = "\(obj.grabCount ?? 0)"
            self.updateAvailabiltyCount.text = "\(obj.availabilityCount ?? 0)"
            self.swapTradeCount.text = "\(obj.swapTradeCount ?? 0)"
            self.shiftRequestsPMCountLbl.text = "\(obj.shiftCount ?? 0)"
            self.checkAvailabilityPMCountLbl.text = "\(obj.availabilityCount ?? 0)"
        }
    }
}

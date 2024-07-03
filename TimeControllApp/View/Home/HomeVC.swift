//
//  HomeVC.swift
//  TimeControllApp
//
//  Created by mukesh on 02/07/22.
//

import UIKit
import SVProgressHUD
import GoogleMaps
import GooglePlaces

enum AnomalyTrackerReasonsEnum:String {
    case offSiteClockIn = "offSiteClockIn"
    case offSiteClockOut = "offSiteClockOut"
    case earlyClockIn = "earlyClockIn"
    case earlyClockOut = "earlyClockOut"
    case lateClockIn = "lateClockIn"
    case lateClockOut = "lateClockOut"
    
}

class HomeVC: BaseViewController,CLLocationManagerDelegate, NotificationDelegate {
    
    @IBOutlet weak var homeTitleLbl: UILabel!
    @IBOutlet weak var hometblView: UITableView!
    @IBOutlet weak var documenttblVw: UITableView!
    @IBOutlet weak var obligatoryDocumentLbl: UILabel!
    @IBOutlet weak var readNowBtn: UIButton!
    @IBOutlet weak var readLaterBtn: UIButton!
    @IBOutlet weak var obligatoryDocumentPopupView: UIView!
    @IBOutlet weak var notificationCountView: UIView!
    @IBOutlet weak var notificationCountLbl: UILabel!
    @IBOutlet weak var reasontblView: UITableView!
    @IBOutlet weak var reasonPopupView: UIView!
    @IBOutlet weak var selectAReasonLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    var documentData : [DocumentRows]? = []
    var reasonArray : [ClockInOutReasons]? = []
    var reasonsType = String()
    var selectedScheduleData : [newScheduleModel] = []
    var isEarlyForStartWork = Bool()
    var isLateForStartWork = Bool()
    
    
    public var homeModel = HomeViewModel()
    var locationManager = CLLocationManager()
    
    var currentTimelogData : CurrentTimelog?
    var counter = 0
    var timer = Timer()
    var isPaused = false
    var controlPanleConfiguration : ClientModel?
    var currentScheduleData : [newScheduleModel] = []
    var currentTimeInMinutesData = Int()
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var locationString = String()
    var selectedReasonIndex = -1

    var isAdjustActualTime = false

    @IBOutlet weak var lblSelectAnomaliesReason: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.notificationDelegate = self
        sendFCMTokenAndDeviceID()
        configUI()
        if UserDefaults.standard.object(forKey: UserDefaultKeys.notificationData) != nil {
            self.didReceiveNotification(with: UserDefaults.standard.object(forKey: UserDefaultKeys.notificationData) as! [AnyHashable : Any])
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(apiCallCompleted), name: .apiCallCompleted, object: nil)
        // Do any additional setup after loading the view.
    }
    
    // Function to handle the notification and reload data
    @objc func apiCallCompleted() {
        print("apiCallCompleted")
        self.dashboardApi()
        self.getControlPanelConfigurationRules()
    }
    
    func setUpLocalization(){
        homeTitleLbl.text = LocalizationKey.dashboard.localizing()
        obligatoryDocumentLbl.text = LocalizationKey.obligatoryDocuments.localizing()
        readNowBtn.setTitle(LocalizationKey.readNow.localizing(), for: .normal)
        readLaterBtn.setTitle(LocalizationKey.readLater.localizing(), for: .normal)
        lblSelectAnomaliesReason.text = LocalizationKey.pleaseSelectASuitableComment.localizing()
//        hometblView.reloadData()
        cancelBtn.setTitle(LocalizationKey.cancel.localizing(), for: .normal)
        okBtn.setTitle(LocalizationKey.ok.localizing(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SocketIoManager.establishConnection()
        setUpLocalization()
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        DispatchQueue.global(qos: .background).async {
            self.timer.invalidate()
            self.dashboardApi()
//            self.checkCurrentDraftOrSkip()
//            self.callingDashboardAPI()
            self.getControlPanelConfigurationRules()
        }
    }
    
    func didReceiveNotification(with userInfo: [AnyHashable: Any]) {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.notificationData)
        print("userInfo is : ", userInfo)
        if userInfo["source"] as! String == "chat" {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.roomId = Int(userInfo["room"] as! String) ?? 0
            vc.selectedSegmentStr = "0"
            vc.selectedSegmentStr = "Project"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if userInfo["source"] as! String == "privatechat" {
            if (userInfo["isChatRoomDeleted"] != nil) {

            } else {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                vc.roomId = Int(userInfo["room"] as! String) ?? 0
                vc.selectedSegmentStr = "0"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if userInfo["source"] as! String == "timelogs" {
            if userInfo["id"] as! String != "" {
                let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "AddWorkDocumentVC") as! AddWorkDocumentVC
                vc.comingFrom = "workHourDetail"
                vc.id = userInfo["id"] as! String
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                self.tabBarController?.selectedIndex = 1
            }
        } else if userInfo["source"] as! String == "schedule" {
            if userInfo["subsource"] as! String == "availability" {
                let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "AvailabilityListVC") as! AvailabilityListVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if userInfo["subsource"] as! String == "swap_history" {
                if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesVC") as! SwapTradesVC
                    vc.isNotificationForMySwap = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
                    vc.isNotificationForMySwap = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if userInfo["subsource"] as! String == "new_swaps" {
                if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesVC") as! SwapTradesVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if userInfo["subsource"] as! String == "grab_shift" {
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
                print("pranjal pansuriya is open to work...!!")
            }
        } else if userInfo["source"] as! String == "vacations" {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VacationAbsenceVC") as! VacationAbsenceVC
            if userInfo["subsource"] as! String == "pending" {
                vc.selectedSegmentIndex = 2
            } else {
                vc.selectedSegmentIndex = 0
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if userInfo["source"] as! String == "absences" {
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VacationAbsenceVC") as! VacationAbsenceVC
            if userInfo["subsource"] as! String == "pending" {
                vc.selectedSegmentIndex = 2
            } else {
                vc.selectedSegmentIndex = 1
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if userInfo["source"] as! String == "shifts" {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ScheduleListVC") as! ScheduleListVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if userInfo["source"] as! String == "deviation" {
            if userInfo["id"] as! String != "" {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DeviationDetailVC") as! DeviationDetailVC
                vc.selectedSegmmentIndex = 0
//                vc.delegate = self
                vc.selectedDeviationsID = Int(userInfo["id"] as! String) ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DeviationVC") as! DeviationVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func callAPI() {
        guard let url = URL(string: "https://webhook.site/6cbf92b0-c864-4a93-b35a-e675a4f75476") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data: \(dataString)")
            }
        }
        
        task.resume()
    }

    
    func configUI() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        obligatoryDocumentPopupView.isHidden = true
        reasonPopupView.isHidden = true
        
        notificationCountView.setNeedsLayout()
        notificationCountView.layer.cornerRadius = notificationCountView.frame.height/2
        notificationCountView.layer.masksToBounds = true
        self.notificationCountView.isHidden = true

        hometblView.register(UINib.init(nibName: TABLE_VIEW_CELL.StartWorkTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.StartWorkTVC.rawValue)
        
        hometblView.register(UINib.init(nibName: TABLE_VIEW_CELL.ReportTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ReportTVC.rawValue)
        reasontblView.register(UINib.init(nibName: TABLE_VIEW_CELL.ChildListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue)
        
//        hometblView.reloadData()
        
        documenttblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ObligatoryDocumentTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ObligatoryDocumentTVC.rawValue)
        
        if GlobleVariables.isObligatoryDocuments {
            getDocumentListAPI()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
    }
    
    func timerCalling() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "HH"
        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL)
        
        let currentTimeInMinutes = getExactCurrentTimeInMinutes()
        
        if currentTimelogData?.anomaly?.start?.is_early ?? false && currentTimelogData?.data?.anomalyTrackerReason?.startReason?.autoAdjust ?? false && currentTimeInMinutes < currentTimelogData?.from ?? 0 {
            isAdjustActualTime = false
            hometblView.reloadData()
        } else {
            isAdjustActualTime = true
            let hoursToMinute = ((Int(dateFormatter.string(from: date)) ?? 0) + (GlobleVariables.timezoneGMT ?? 0)) * 60

    //        let hoursToMinute = base_url == "https://tidogkontroll.no/api/" ? ((Int(dateFormatter.string(from: date)) ?? 0) + 2) * 60 : ((Int(dateFormatter.string(from: date)) ?? 0) - 4) * 60

            dateFormatter.dateFormat = "mm"
//            var totalMinutes = (hoursToMinute + (Int(dateFormatter.string(from: Date())) ?? 0)) - (currentTimelogData?.from ?? 0) - (currentTimelogData?.breakTime ?? 0)
            var totalMinutes = currentTimeInMinutes - (currentTimelogData?.from ?? 0) - (currentTimelogData?.breakTime ?? 0)

            print("totalMinutes is : ", totalMinutes)

            if totalMinutes < 0 {
                totalMinutes += (24 * 60)
            }
            counter = totalMinutes * 60
            if (!isPaused) {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func timerAction() {
        counter += 1
        hometblView.reloadData()
    }
    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        // return formated string
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    @objc func pauseBtnClicked(_ sender: UIButton) {
        if isPaused{
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            isPaused = false
            takeBreakResumeWorkHourAPI(id: currentTimelogData?.id ?? 0, status: "stop")
        } else {
            self.timer.invalidate()
            isPaused = true
            takeBreakResumeWorkHourAPI(id: currentTimelogData?.id ?? 0, status: "start")
        }
        hometblView.reloadData()
    }
    @IBAction func cancelReasonBtn(_ sender: Any) {
        self.hometblView.reloadData()
        reasonPopupView.isHidden = true
    }
    @IBAction func okReasonBtn(_ sender: Any) {
        if selectedReasonIndex < 0 {
            let alert = UIAlertController(title: "", message: LocalizationKey.pleaseProvideReason.localizing(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizationKey.ok.localizing(), style: .default, handler: { action in
                // start work
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            switch reasonsType {
            case AnomalyTrackerReasonsEnum.offSiteClockIn.rawValue:
                self.hitStartWorkHoursApi(scheduleData: selectedScheduleData, isGpsEnable: true, isEarly: isEarlyForStartWork, isOffsite: true,isLate: isLateForStartWork, comment: reasonArray?[selectedReasonIndex].reason ?? "")
                reasonPopupView.isHidden = true
                
            case AnomalyTrackerReasonsEnum.offSiteClockOut.rawValue:
                print("socket connected")
                
            case AnomalyTrackerReasonsEnum.earlyClockIn.rawValue:
                self.hitStartWorkHoursApi(scheduleData: selectedScheduleData, isGpsEnable: true, isEarly: isEarlyForStartWork, isOffsite: false,isLate: isLateForStartWork, comment: reasonArray?[selectedReasonIndex].reason ?? "")
                reasonPopupView.isHidden = true
                print("socket connected")
                
            case AnomalyTrackerReasonsEnum.earlyClockOut.rawValue:
                print("socket connected")
                
            case AnomalyTrackerReasonsEnum.lateClockIn.rawValue:
                self.hitStartWorkHoursApi(scheduleData: selectedScheduleData, isGpsEnable: true, isEarly: isEarlyForStartWork, isOffsite: false,isLate: isLateForStartWork, comment: reasonArray?[selectedReasonIndex].reason ?? "")
                reasonPopupView.isHidden = true
                
            case AnomalyTrackerReasonsEnum.lateClockOut.rawValue:
                print("socket connected")
                
            default:
                print("socket connected")
            }
        }
    }
    
    @IBAction func btnActionSeeAllWorkHours(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func readNowBtn(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
        obligatoryDocumentPopupView.isHidden = true
    }
    @IBAction func readLater(_ sender: Any) {
        obligatoryDocumentPopupView.isHidden = true
    }
    
    @objc func finishBtnAction(_ sender: UIButton) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FinishWorkVC") as! FinishWorkVC
        vc.currentTimelogData = currentTimelogData
        vc.isFrom = "home"
        vc.dashboardScheduleData = homeModel.dashboardScheduleData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Schedule start work button action

    @objc func scheduleStartWorkBtnClicked(_ sender: UIButton) {
        print("startScheduleWork is : ")
        sender.isEnabled = false
        self.startScheduleWork()
    }
    
    func getExactCurrentTimeInMinutes() -> Int {
//        let timeZone = TimeZone(identifier: "GMT")!
        guard let timeZone = TimeZone(identifier: "GMT") else {
            // Handle the case where timeZone is nil (invalid identifier)
            // You can log an error, return a default value, or handle it in an appropriate way
            return 0  // Example default value, adjust as needed
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        let currentDate1 = dateFormatter.string(from: Date())
        print("getCurrentTime: \(currentDate1)")
        
        let currentDateSplit = currentDate1.components(separatedBy: ":")
        let currentHours: String = currentDateSplit[0]
        let currentMinute: String = currentDateSplit[1]
        
//       return (Int(currentHours) + (GlobleVariables.timezoneGMT ?? 0)) * 60 + Int(currentMinute)
        
        let currentHoursInt = Int(currentHours) ?? 0
        let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
        let currentMinuteInt = Int(currentMinute) ?? 0

        var totalMinutes = 0
        if currentHoursInt + timezoneOffset < 0 {
            totalMinutes = (currentHoursInt + timezoneOffset + 24) * 60 + currentMinuteInt
        } else if currentHoursInt + timezoneOffset > 23 {
            totalMinutes = (currentHoursInt + timezoneOffset - 24) * 60 + currentMinuteInt
        }
        else {
            totalMinutes = (currentHoursInt + timezoneOffset) * 60 + currentMinuteInt
        }

        return totalMinutes

    }
    
    
    //MARK: Get the current time in minutes
    
    func getCurrentDateFromGMTHome() -> String {
        let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
        let serverTimeZone = "\(timezoneOffset)"
        var timezoneOffsetData = ""
        if serverTimeZone.contains("-") {
            timezoneOffsetData = serverTimeZone
        } else {
            timezoneOffsetData = "+\(serverTimeZone)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT\(timezoneOffsetData)")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateInGMT = dateFormatter.string(from: Date())
        return currentDateInGMT
    }
    
    func getPreviousDateFromGMTHome(currentDate :  String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = currentDate
        guard let dateCurrent = dateFormatter.date(from: dateString) else { return "" }
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = -1

        guard let newDate = calendar.date(byAdding: dateComponents, to: dateCurrent) else { return "" }
        let previousDate = dateFormatter.string(from: newDate)
        print("previousDate is : ", previousDate)
        return previousDate
    }
    
    func getCurrentTimeInMinutes() {
        currentScheduleData.removeAll()
//        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
//        let formattedDate = formatter.string(from: currentDate)
        
//        guard let currentDate = getCurrentDateFromGMTHome() else { return }
//        let formattedDate = formatter.string(from: currentDate)
        let formattedDate = getCurrentDateFromGMTHome()
        let previousDate = getPreviousDateFromGMTHome(currentDate: formattedDate)

//        print("currentDate home is : ", currentDate)
        print("formattedDate home is : ", formattedDate)

        let currentTime = Date()
        let calendar = Calendar.current
        let currentTimeWithoutDate = calendar.dateComponents([.hour, .minute], from: currentTime)
//        let currentTimeInMinutes = (currentTimeWithoutDate.hour! * 60) + currentTimeWithoutDate.minute!
//        currentTimeInMinutesData = currentTimeInMinutes
        
//        let timeZone = TimeZone(identifier: "GMT")!
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = timeZone
//        dateFormatter.dateFormat = "HH:mm"
//        let currentDate1 = dateFormatter.string(from: Date())
//        print("getCurrentTime: \(currentDate1)")
//        
//        let currentDateSplit = currentDate1.components(separatedBy: ":")
//        let currentHours: String = currentDateSplit[0]
//        let currentMinute: String = currentDateSplit[1]
        
        let currentTimeInMinutes = getExactCurrentTimeInMinutes()
        currentTimeInMinutesData = currentTimeInMinutes
        
        print("currentTimeInMinutes is : ", currentTimeInMinutes)
        
        var scheduleToday: [newScheduleModel] = []
        for i in 0..<homeModel.dashboardScheduleData.count {
            if homeModel.dashboardScheduleData[i].for_date == formattedDate {
                scheduleToday.append(homeModel.dashboardScheduleData[i])
            } else if homeModel.dashboardScheduleData[i].is_multiday ?? false && homeModel.dashboardScheduleData[i].for_date == previousDate {
                scheduleToday.append(homeModel.dashboardScheduleData[i])
            }
        }
        
        if scheduleToday.count == 1 {
            if currentTimeInMinutes >= (scheduleToday[0].start_time ?? 0) - 30 && currentTimeInMinutes <= (scheduleToday[0].end_time ?? 0) - 30 {
                // Show the view for schedule
                currentScheduleData = scheduleToday
            } 
//            else if currentTimeInMinutes >= (scheduleToday[0].start_time ?? 0) - 30 && (scheduleToday[0].start_time ?? 0) - 30 >= (scheduleToday[0].end_time ?? 0) - 30 {
//                currentScheduleData = scheduleToday
//            }
            else if (scheduleToday[0].is_multiday ?? false && scheduleToday[0].for_date != formattedDate && currentTimeInMinutes < (scheduleToday[0].end_time ?? 0)) {
                currentScheduleData = scheduleToday
            } else if (scheduleToday[0].is_multiday ?? false && scheduleToday[0].for_date == formattedDate && (currentTimeInMinutes >= (scheduleToday[0].start_time ?? 0) - 30)) {
                currentScheduleData = scheduleToday
            }
            
//            hometblView.reloadData()
        } else if scheduleToday.count > 1 {
            var currentSchedule: [newScheduleModel] = []
            for i in 0..<scheduleToday.count {
                if currentTimeInMinutes >= (scheduleToday[i].start_time ?? 0) - 30 && currentTimeInMinutes <= (scheduleToday[i].end_time ?? 0) - 30 {
                    currentSchedule.append(scheduleToday[i])
                    break
                } 
//                else if currentTimeInMinutes >= (scheduleToday[i].start_time ?? 0) - 30 && (scheduleToday[i].start_time ?? 0) - 30 >= (scheduleToday[i].end_time ?? 0) - 30 {
//                    currentSchedule.append(scheduleToday[i])
//                    break
//                }
                
                else if (scheduleToday[i].is_multiday ?? false && scheduleToday[i].for_date != formattedDate && currentTimeInMinutes < (scheduleToday[i].end_time ?? 0)) {
                    currentSchedule.append(scheduleToday[i])
                    break
                } else if (scheduleToday[i].is_multiday ?? false && scheduleToday[i].for_date == formattedDate && (currentTimeInMinutes >= (scheduleToday[i].start_time ?? 0) - 30)) {
                    currentSchedule.append(scheduleToday[i])
                    break
                }
            }
            
            if ((currentSchedule.count) != 0)  {
                // Show the view for schedule
                currentScheduleData = currentSchedule
            }
            
//            hometblView.reloadData()
        } else if (scheduleToday.count == 0) {
            currentScheduleData = []
        }
        print("currentScheduleData is : ", currentScheduleData)
        hometblView.reloadData()
    }

    
    //MARK: Check GPS Obligatory

    func isGPSObligatory() -> Bool {
//        return controlPanleConfiguration?.data?.loginRules?.autoTimelogs == "gps" && controlPanleConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
        return controlPanleConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
    }
    
    //MARK: Check Anomaly

    private func checkAnomaly() -> Bool {
        print("controlPanleConfiguration?.data?.loginRules?.autoTimelogs is : ", controlPanleConfiguration?.data?.loginRules?.autoTimelogs)
        print("controlPanleConfiguration?.data?.basicRules?.workinghourGPSObligatory is : ", controlPanleConfiguration?.data?.basicRules?.workinghourGPSObligatory)
        return controlPanleConfiguration?.data?.loginRules?.autoTimelogs != "autoschedule" && controlPanleConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
    }
    
    //MARK: Check GPS Location

    func checkLocationEnable() -> Bool {
        /*
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    return true
                @unknown default:
//                    break
                    return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
        */
        if CLLocationManager.locationServicesEnabled() {
            let locationManager = CLLocationManager()
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                print("authorizedAlways")
                return true
            case .denied, .restricted:
                print("denied")
                return false
            case .notDetermined:
                print("notDetermined")
//                locationManager.requestWhenInUseAuthorization()
                return false
            @unknown default:
                // Handle future cases
                print("default")
                return false
            }
        } else {
            // Location services are not enabled
            print("Location services are not enabled")
            return false
        }
    }
    
    //MARK: Start schedule work

    /*
    func startScheduleWork() {
        if isGPSObligatory() {
            let currentLat = self.latitude
            let currentLon = self.longitude
            let targetLocation = currentScheduleData[0].gps_data?.split(separator: ",")
            let targetLat = Double(targetLocation?[0] ?? "")
            let targetLon = Double(targetLocation?[1] ?? "")
            let distance = distanceBetween(currentLatitude: currentLat, currentLongitude: currentLon, targetLatitude: targetLat ?? 0.0, targetLongitude: targetLon ?? 0.0)
            print("distance ", distance)
            
            if let allowedDistance = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.gpsAllowedDistance, allowedDistance != 0 {
                if distance <= Double(allowedDistance) {
                    // The current location is within the allowed distance from the target location
                    self.lookForBufferTime(schedule: currentScheduleData, currentTimeInMinutes: currentTimeInMinutesData)
                } else {
                    // The current location is outside the allowed distance from the target location
                    self.showAlert(message: "You're out of range, please try again when you are within the range of the site.", strtitle: "")
                }
            } else {
                if distance <= 100 {
                    // The current location is within a 100-meter radius of the target location
                    self.lookForBufferTime(schedule: currentScheduleData, currentTimeInMinutes: currentTimeInMinutesData)
                } else {
                    // The current location is outside the 100-meter radius from the target location
                    self.showAlert(message: "You're out of range, please try again when you are within the range of the site.", strtitle: "")
                }
            }
        }
        else {
            // Do normal start work without checking location and directly send available details to start work api
            // start work
//            self.startWork(schedule: schedule, location: location, true)
            self.hitStartWorkHoursApi(scheduleData: currentScheduleData, isGpsEnable: true)
        }
    }
     */
    
    func startScheduleWork() {
        if checkLocationEnable() {
            if checkAnomaly() {
                let currentLat = self.latitude
                let currentLon = self.longitude
                let targetLocation = currentScheduleData[0].gps_data?.split(separator: ",")
                let targetLat = Double(targetLocation?[0] ?? "")
                let targetLon = Double(targetLocation?[1] ?? "")
                let distance = distanceBetween(currentLatitude: currentLat, currentLongitude: currentLon, targetLatitude: targetLat ?? 0.0, targetLongitude: targetLon ?? 0.0)
                print("distance is :", distance)
                
                if let allowedDistance = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.gpsAllowedDistance, allowedDistance != 0 {
                    if distance <= Double(allowedDistance) {
                        // The current location is within the allowed distance
                        self.lookForBufferTime(schedule: currentScheduleData, currentTimeInMinutes: getExactCurrentTimeInMinutes(), onSite: true)
                    } else {
                        // The current location is not within the allowed distance
                        self.lookForBufferTime(schedule: currentScheduleData, currentTimeInMinutes: getExactCurrentTimeInMinutes(), onSite: false)
                    }
                } else {
    //                self.hitStartWorkHoursApi(scheduleData: currentScheduleData, isGpsEnable: true)
                    self.hitStartWorkHoursApi(scheduleData: currentScheduleData, isGpsEnable: true, isEarly: false, isOffsite: false,isLate: false, comment: "")
                }
            }
            else {
                // Do normal start work without checking location and directly send available details to start work api
                // start work
                //            self.startWork(schedule: schedule, location: location, true)
                print("Check anomalies not enable is : ")
                self.hitStartWorkHoursApi(scheduleData: currentScheduleData, isGpsEnable: true, isEarly: false, isOffsite: false,isLate: false, comment: "")
            }
        } else {
            if isGPSObligatory() {
                let alert = UIAlertController(title: LocalizationKey.allowLocationAccess.localizing(), message: LocalizationKey.yourEmployerHasMadeGPSUsageMandatoryPleaseTurnOnYourGPS.localizing(), preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: LocalizationKey.settings.localizing(), style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.ok.localizing(), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.hitStartWorkHoursApi(scheduleData: currentScheduleData, isGpsEnable: true, isEarly: false, isOffsite: false,isLate: false, comment: "")
            }
        }
    }
    
    //MARK: Get the distance
    
    func distanceBetween(currentLatitude: Double, currentLongitude: Double, targetLatitude: Double, targetLongitude: Double) -> Double {
        let manager = CLLocationManager() //location manager for user's current location
        let destinationCoordinates = CLLocation(latitude: targetLatitude, longitude: targetLongitude) //coordinates for destinastion
        // let destinationCoordinates = CLLocation(latitude: (30.7046), longitude: (76.7179)) //coordinates for destinastion
        let selfCoordinates = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        //   let selfCoordinates = CLLocation(latitude: (30.7377), longitude: (76.6792)) //user's location
        return selfCoordinates.distance(from: destinationCoordinates) //return distance in **meters**
    }

    //MARK: Check the Buffer time

    /*
    func lookForBufferTime(schedule: [newScheduleModel], currentTimeInMinutes: Int) {
        guard let startBuffer = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.startBufferTimeForClockIn, let endBuffer = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.endBufferTimeForClockOut else { return }
        
        //Here user is between start time & buffer time
        if currentTimeInMinutes >= (schedule[0].start_time ?? 0) - startBuffer && currentTimeInMinutes <= (schedule[0].start_time ?? 0) + startBuffer {
            //start work
//            startWork(schedule: schedule, location: location, isEarlyClockIn: true)
            self.hitStartWorkHoursApi(scheduleData: schedule, isGpsEnable: true)
            return
        }
        
        //This will execute when user tries to login before scheduled time - buffer time
        if currentTimeInMinutes < schedule[0].start_time ?? 0 - startBuffer {
            //Show dialog to user
            //Your scheduled time is 7pm - 10pm
            //Do you want to start earlier today? YES OR NO ?
            
            let title = "Your scheduled time is \(logTime(time: schedule[0].start_time ?? 0))-\(logTime(time: schedule[0].end_time ?? 0))"
            let message = "Do you want to start earlier today?"
            self.showAlert(title: title, message: message, schedule: schedule)
            return
        }
        
        //Here user is late for their shift
        if currentTimeInMinutes > schedule[0].start_time ?? 0 && currentTimeInMinutes <= schedule[0].end_time ?? 0 {
            //Show dialog to user
            //Late Shift?
            //You are running late today Your PM will be informed. Yes or No?
            let title = "Late Shift?"
            let message = "You are running late today Your PM will be informed."
            self.showAlert(title: title, message: message, schedule: schedule)
            return
        }
    }
    */
    
    func lookForBufferTime(schedule: [newScheduleModel], currentTimeInMinutes: Int, onSite: Bool) {
        let startBuffer = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.startBufferTimeForClockIn ?? 0
        
        //Here user is between start time & buffer time
        
        if currentTimeInMinutes >= (schedule[0].start_time ?? 0) - startBuffer && currentTimeInMinutes <= (schedule[0].start_time ?? 0) + startBuffer {
            //start work
            self.isEarlyForStartWork = false
            self.isLateForStartWork = false
            if onSite {
                self.hitStartWorkHoursApi(scheduleData: schedule, isGpsEnable: true, isEarly: false, isOffsite: false, isLate: false, comment: "")
                return
            } else {
                let title = LocalizationKey.helloTimeAndControlNoticedThatYouHaventArrivedAtTheSiteYet.localizing()
                let message = LocalizationKey.helloTimeAndControlNoticedThatYouHaventArrivedAtTheSiteEither.localizing() + "\n\n" + LocalizationKey.wouldYouStillLikeToClockInForYourShift.localizing()
                let heading = LocalizationKey.WhyDoYouWantToStartFromThisLocation.localizing()
                self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.offSiteClockIn
                self.reasonsType = AnomalyTrackerReasonsEnum.offSiteClockIn.rawValue
                self.selectedScheduleData = schedule
                self.reasontblView.reloadData()
                self.showAlert(title: "", message: message, schedule: schedule, heading: heading, isEarly: false, isOffsite: true)
                return
            }
        }
        
        // This will execute when the user tries to login before the scheduled time - buffer time
        
        if currentTimeInMinutes < schedule[0].start_time ?? 0 - startBuffer {
            //Show dialog to user
            //Your scheduled time is 7pm - 10pm
            //Do you want to start earlier today? YES OR NO ?
            self.isEarlyForStartWork = true
            self.isLateForStartWork = false
            if onSite {
                let title = "\(LocalizationKey.yourScheduledTimeIs.localizing()) \(logTime(time: schedule[0].start_time ?? 0))-\(logTime(time: schedule[0].end_time ?? 0))"
                let message = "\(LocalizationKey.yourScheduledTimeIs.localizing()) \(logTime(time: schedule[0].start_time ?? 0))-\(logTime(time: schedule[0].end_time ?? 0))\n\n" + LocalizationKey.doYouWantToStartEarlierToday.localizing()
                let heading = LocalizationKey.whyDoYouWantToStartEarlierToday.localizing()
                self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.earlyClockIn
                self.reasonsType = AnomalyTrackerReasonsEnum.earlyClockIn.rawValue
                self.selectedScheduleData = schedule
                self.reasontblView.reloadData()
                self.showAlert(title: "", message: message, schedule: schedule, heading: heading, isEarly: true, isOffsite: false)
                return
            } else {
                let title = LocalizationKey.heyYouStillHaveSomeTimeLeftBeforeScheduling.localizing()
                let message = LocalizationKey.heyYouStillHaveSomeTimeLeftBeforeTheScheduledTime.localizing() + "\n\n" + LocalizationKey.andYouHaventArrivedAtTheSiteEitherWouldYouLikeToStart.localizing()
                let heading = LocalizationKey.whyDoYouWantToStartEarlierFromOffSite.localizing()
                self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.offSiteClockIn
                self.reasonsType = AnomalyTrackerReasonsEnum.offSiteClockIn.rawValue
                self.selectedScheduleData = schedule
                self.reasontblView.reloadData()
                self.showAlert(title: "", message: message, schedule: schedule, heading: heading, isEarly: true, isOffsite: true)
                return
            }
        }
        
        //Here user is late for their shift
        
        if currentTimeInMinutes > (schedule[0].start_time ?? 0) + startBuffer  && currentTimeInMinutes <= schedule[0].end_time ?? 0 {
            //Show dialog to user
            //Late Shift?
            //You are running late today Your PM will be informed. Yes or No?
            self.isEarlyForStartWork = false
            self.isLateForStartWork = true
            if onSite {
                let title = LocalizationKey.lateShift.localizing()
                let message = LocalizationKey.heyYouAreRunningLateTodayPleasebBeAwareOfThisNextTime.localizing()
//                self.showAlert(title: title, message: message, schedule: schedule, heading: "")
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
                    // start work
//                    self.hitStartWorkHoursApi(scheduleData: schedule, isGpsEnable: true, isEarly: false, isOffsite: true, comment: "")
                    self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.lateClockIn
                    self.reasonsType = AnomalyTrackerReasonsEnum.lateClockIn.rawValue
                    self.selectedScheduleData = schedule
                    self.reasontblView.reloadData()
                    self.reasonPopupView.isHidden = false
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel, handler: { action in
                    self.hometblView.reloadData()
                }))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                let title = LocalizationKey.youAreRunningLateTodayYourPMWillBeInformed.localizing() + "\n"
                let message = LocalizationKey.lateAndOutsideOfWorkLocation.localizing() + "\n" +  LocalizationKey.wouldYouLikeToStart.localizing()
                let heading = LocalizationKey.WhyDoYouWantToStartFromThisLocation.localizing()
                self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.offSiteClockIn
                self.reasonsType = AnomalyTrackerReasonsEnum.offSiteClockIn.rawValue
                self.selectedScheduleData = schedule
                self.reasontblView.reloadData()
                self.showAlert(title: "", message: message, schedule: schedule, heading: heading, isEarly: false, isOffsite: true)
                return
            }
        }
    }
    
    //MARK: Open the alert view
    /*
    func showAlert(title: String, message: String, schedule: [newScheduleModel]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            // start work
            self.hitStartWorkHoursApi(scheduleData: schedule, isGpsEnable: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    */
    
    func showAlert(title: String, message: String, schedule: [newScheduleModel], heading: String, isEarly: Bool, isOffsite: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            // start work
            if self.checkControlPanelAnomalies() {
                let heading = heading //"Why do you want to start from this location?"
//                self.showCustomDialogForReason(heading: heading, schedule: schedule, isEarly: isEarly, isOffsite: isOffsite)
                self.reasonPopupView.isHidden = false
            } else {
                self.hitStartWorkHoursApi(scheduleData: schedule, isGpsEnable: true, isEarly: false, isOffsite: false, isLate: false, comment: "")
            }
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel, handler: { action in
            self.hometblView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Check control panel anomalies
    
    private func checkControlPanelAnomalies() -> Bool {
        return GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.trackAnomalies ?? false
    }
    
    //MARK: Open the reason dialog

//    private func showCustomDialogForReason( heading: String, schedule: [newScheduleModel], isEarly: Bool, isOffsite: Bool ) {
//        let alert = UIAlertController(title: heading, message: nil, preferredStyle: .alert)
//        
//        alert.addTextField { (textField) in
//            textField.placeholder = LocalizationKey.reason.localizing()
//        }
//        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
//            
//            guard let reason = alert.textFields?[0].text else {
//                // Validation message for comment
////                self.showAlert(message: "Please provide a reason", strtitle: "")
//                return
//            }
//
//            print("reason is : ", reason)
//            
//            if (reason == "") {
//                self.showAlert(message: LocalizationKey.pleaseProvideReason.localizing(), strtitle: "")
////                return
//            } else {
//                self.hitStartWorkHoursApi(scheduleData: schedule, isGpsEnable: true, isEarly: isEarly, isOffsite: isOffsite, comment: reason)
//            }
//        }))
//        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
}

//MARK: - TableView DataSource and Delegate Methods
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == documenttblVw {
            return 1
        }else if tableView == reasontblView {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == documenttblVw {
            return documentData?.count ?? 0
        }else if tableView == reasontblView {
            return reasonArray?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == documenttblVw {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ObligatoryDocumentTVC.rawValue, for: indexPath) as? ObligatoryDocumentTVC
            else { return UITableViewCell() }
            
            guard let document = documentData?[indexPath.row] else { return UITableViewCell() }
            
            cell.setCellValue(document: document)
            return cell
        }else if tableView == reasontblView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue, for: indexPath) as? ChildListTVC
            else { return UITableViewCell() }
            cell.childNameLbl.text = reasonArray?[indexPath.row].reason
            cell.childNameLbl.numberOfLines = 0
            
            if selectedReasonIndex == indexPath.row {
                cell.selectChildBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            }
            else {
                cell.selectChildBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            }
            return cell
        } else {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.StartWorkTVC.rawValue, for: indexPath) as? StartWorkTVC else { return UITableViewCell() }
                cell.delegate = self
                
                cell.userImage.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.userImageId) ?? ""), placeholderImage: UIImage(named: "userImage"), options: .highPriority, completed: nil)
                cell.userImage.contentMode = .scaleAspectFill

                if (currentTimelogData != nil) {
                    cell.startWorkVw.isHidden = true
                    cell.workingHoursVw.isHidden = false
                    cell.scheduleStartWorkVw.isHidden = true
                    cell.runningTimerLbl.text = isAdjustActualTime ? timeString(time: TimeInterval(counter)) : "00:00:00"
                    cell.startTimeLbl.text = LocalizationKey.stratTime.localizing() + " " + logTime(time: currentTimelogData?.from ?? 0)
                    if isPaused {
                        cell.pauseLbl.text = LocalizationKey.play.localizing()
                        cell.pauseResumeImg.image = UIImage(named: "starticon")
                    }
                    else {
                        cell.pauseLbl.text = LocalizationKey.pause.localizing()
                        cell.pauseResumeImg.image = UIImage(named: "pauseicon")
                    }
                    cell.projectNameLbl.text = currentTimelogData?.task_name
                    cell.currentTimelogData = currentTimelogData
                } else if ((currentScheduleData.count) != 0) {
                    cell.startWorkVw.isHidden = true
                    cell.workingHoursVw.isHidden = true
                    cell.scheduleStartWorkVw.isHidden = false
                    cell.scheduleTime.text = "\(logTime(time: currentScheduleData[0].start_time ?? 0)) - \(logTime(time: currentScheduleData[0].end_time ?? 0))"
                    cell.scheduleTaskName.text = currentScheduleData[0].task_name
                    cell.scheduleStartWorkBtn.isEnabled = true
                    cell.scheduleStartWorkBtn.addTarget(self, action: #selector(self.scheduleStartWorkBtnClicked), for: .touchUpInside)
                }
                else {
                    cell.startWorkVw.isHidden = false
                    cell.workingHoursVw.isHidden = true
                    cell.scheduleStartWorkVw.isHidden = true
                }
                cell.pauseBtn.addTarget(self, action: #selector(self.pauseBtnClicked), for: .touchUpInside)
                cell.btnFinish.addTarget(self, action: #selector(self.finishBtnAction), for: .touchUpInside)
                cell.setupLocalizationData()
                let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
                let url = URL(string: strUrl + "/\(GlobleVariables.clientControlPanelConfiguration?.image ?? "")")
                cell.logoImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                cell.clientNameLbl.text = GlobleVariables.clientControlPanelConfiguration?.name
                
                if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.hideBreakButton ?? false {
                    cell.pauseVw.isHidden = true
                } else {
                    cell.pauseVw.isHidden = false
                }
                
                return cell
            } else if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ReportTVC.rawValue, for: indexPath) as? ReportTVC else { return UITableViewCell() }
                if homeModel.newSchedule == 0 {
                    cell.scheduleCountLbl.isHidden = true
                    cell.scheduleNotifyVw.isHidden = true
                } else {
                    cell.scheduleCountLbl.isHidden = false
                    cell.scheduleNotifyVw.isHidden = false
                    cell.scheduleCountLbl.text = "\(homeModel.newSchedule)"
                }
                
                if homeModel.newDeviation == 0 {
                    cell.deviationCountLbl.isHidden = true
                    cell.deviationNotifyVw.isHidden = true
                } else {
                    cell.deviationCountLbl.isHidden = false
                    cell.deviationNotifyVw.isHidden = false
                    cell.deviationCountLbl.text = "\(homeModel.newSchedule)"
                }
                cell.delegate = self
                cell.setupLocalizationData()
                                
                if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.showAbsenceAndVacationInMobile != nil && GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.showAbsenceAndVacationInMobile ==  false {
                    cell.vacationAndAbsentVw.isHidden = true
                } else {
                    cell.vacationAndAbsentVw.isHidden = false
                }
                return cell
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.WorkLogTVC.rawValue, for: indexPath) as? WorkLogTVC
            else { return UITableViewCell() }
            cell.lastThreeWorkLog = homeModel.lastWorkLog
            cell.allWorkLogtblView.reloadData()
            cell.setupLocalizationData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == documenttblVw {
            self.tabBarController?.selectedIndex = 3
            obligatoryDocumentPopupView.isHidden = true
        }else if tableView == reasontblView {
            selectedReasonIndex = indexPath.row
            reasontblView.reloadData()
        }
    }
}

//MARK: APi Work in View controller
extension HomeVC{
    private func dashboardApi(){
        SVProgressHUD.show()
        homeModel.dashboard(){ (errorMsg,loginMessage) in
            SVProgressHUD.dismiss()
            if errorMsg == true {
                self.hometblView.reloadData()
            } else {
                displayToast(loginMessage)
            }
            print("Schedule is :", self.homeModel.dashboardScheduleData)
            GlobleVariables.notificationCount = self.homeModel.notificationCountData
            self.notificationCountLbl.text = self.homeModel.notificationCountData > 99 ? "99+" : "\(self.homeModel.notificationCountData)"
            if GlobleVariables.notificationCount > 0 {
                self.notificationCountView.isHidden = false
            }else {
                self.notificationCountView.isHidden = true
            }
            self.checkCurrentDraftOrSkip()
        }
    }
    
    func checkCurrentDraftOrSkip() {
        SVProgressHUD.show()
        let param = [String:Any]()
        
        WorkHourVM.shared.currentDraftOrSkipApi(parameters: param, isAuthorization: true) { [self] obj in
            
            currentTimelogData = obj.timelog
            if (currentTimelogData != nil) {
                if (currentTimelogData?.tracker_status == "break") {
                    isPaused = true
                    timerCalling()
                }
                else {
                    isPaused = false
                    timerCalling()
                }
                hometblView.reloadData()
            } else {
                self.getCurrentTimeInMinutes()
            }
        }
    }
    
    func takeBreakResumeWorkHourAPI(id: Int, status : String) {
        SVProgressHUD.show()
        let param = [String:Any]()
        
        WorkHourVM.shared.breakResumeWorkHoursAPI(parameters: param, id: id, status: status, isAuthorization: true) { [self] obj in

            print("Break work hour : ", obj)
            
        }
    }
    
    func getControlPanelConfigurationRules() {
        SVProgressHUD.show()
        let param = [String:Any]()
        
        WorkHourVM.shared.getControlPanelConfiguration(parameters: param, isAuthorization: true) { [self] obj in
            controlPanleConfiguration = obj.client
            
            //MARK: Change the date formate from configuration

            if (obj.client?.data?.dateTimeRules?.short_date_format == "DD.MM.YYYY") {
                controlPanleConfiguration?.data?.dateTimeRules?.short_date_format = "dd.MM.YYYY"
            } else if (obj.client?.data?.dateTimeRules?.short_date_format == "DD-MM-YYYY") {
                controlPanleConfiguration?.data?.dateTimeRules?.short_date_format = "dd-MM-YYYY"
            } else if (obj.client?.data?.dateTimeRules?.short_date_format == "DD/MM/YYYY") {
                controlPanleConfiguration?.data?.dateTimeRules?.short_date_format = "dd/MM/YYYY"
            }
            
            if (obj.client?.data?.dateTimeRules?.time_format == "hh:mm") {
                controlPanleConfiguration?.data?.dateTimeRules?.time_format = "HH:mm"
            }
            
            GlobleVariables.clientControlPanelConfiguration = controlPanleConfiguration
            GlobleVariables.bizTypeControlPanelConfiguration = obj.biztype
            GlobleVariables.integrationDetailsControlPanelConfiguration = obj.integration_details
            GlobleVariables.timezoneGMT = obj.timezoneGMT
            print("GlobleVariables.integration_details is : ", obj.integration_details)
            hometblView.reloadData()
        }
    }
    /*
    func hitStartWorkHoursApi(scheduleData: [newScheduleModel], isGpsEnable: Bool) {
        var param = [String:Any]()
        var startGps = [String:Any]()
        
        var coords = [String:Any]()
        let timestamp = Date().timeIntervalSince1970

        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:latitude, longitude: longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    { [self](placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                self.locationString = addressString
                
                coords["altitude"] = 0
                coords["altitudeAccuracy"] = 0
                coords["latitude"] = self.latitude
                coords["accuracy"] =  41
                coords["longitude"] = self.longitude
                coords["heading"] = 0
                coords["speed"] = 0

                startGps["coords"] = coords
                startGps["timestamp"] = timestamp
                startGps["locationString"] = self.locationString
                startGps["decision"] =  "off-bounds"
                startGps["is_ok"] = false
                startGps["diff"] = false

                param["task_id"] = scheduleData[0].task_id
                param["startGps"] = startGps
                param["location_string"] = self.locationString
                param["tracker_status"] = "started"

                print(param)
                WorkHourVM.shared.startWorkHoursApi(parameters: param, isAuthorization: true) { [self] obj in
                    self.checkCurrentDraftOrSkip()
                }
            }
        })
    }
     */
    
    func hitStartWorkHoursApi(scheduleData: [newScheduleModel], isGpsEnable: Bool, isEarly: Bool, isOffsite: Bool,isLate:Bool, comment: String) {
        var param = [String:Any]()
        var startGps = [String:Any]()
        
        var coords = [String:Any]()
        let timestamp = Date().timeIntervalSince1970

        var start = [String:Any]()
        var end = [String:Any]()
        var anamoly = [String:Any]()
        var anomalyTrackerReason = [String:Any]()
        var shiftData = [String:Any]()
        var deviceDetails = [String:Any]()

        let currentTime = Date()
        let calendar = Calendar.current
        let currentTimeWithoutDate = calendar.dateComponents([.hour, .minute], from: currentTime)
        let TimeInMinutes = (currentTimeWithoutDate.hour! * 60) + currentTimeWithoutDate.minute!

        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:latitude, longitude: longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    { [self](placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                self.locationString = addressString
                
                coords["altitude"] = 0
                coords["altitudeAccuracy"] = 0
                coords["latitude"] = self.latitude
                coords["accuracy"] =  41
                coords["longitude"] = self.longitude
                coords["heading"] = 0
                coords["speed"] = 0

                startGps["coords"] = coords
                startGps["timestamp"] = timestamp
                startGps["locationString"] = self.locationString
                startGps["decision"] =  "off-bounds"
                startGps["is_ok"] = false
                startGps["diff"] = false

                start["is_early"] = isEarly
                start["is_offsite"] = isOffsite
                start["is_late"] = isLate
                start["comment"] = comment

                end["is_early"] = false
                end["is_offsite"] = false
                end["is_late"] = false
                end["comment"] = ""

                anamoly["start"] = start
                anamoly["end"] = end
                
                if selectedReasonIndex > -1 {
                    anomalyTrackerReason["reason"] = reasonArray?[selectedReasonIndex].reason ?? ""
                    anomalyTrackerReason["value"] = reasonArray?[selectedReasonIndex].value ?? ""
                    anomalyTrackerReason["code"] = reasonArray?[selectedReasonIndex].code ?? ""
                    anomalyTrackerReason["sendNotification"] = reasonArray?[selectedReasonIndex].sendNotification ?? false
                    anomalyTrackerReason["autoAdjust"] = reasonArray?[selectedReasonIndex].autoAdjust ?? false
//                    anomalyTrackerReason["actualTime"] = TimeInMinutes
                    
                    param["anomalyTrackerReason"] = anomalyTrackerReason
                }
                
                param["task_id"] = scheduleData[0].task_id
                param["startGps"] = startGps
                param["location_string"] = self.locationString
                param["tracker_status"] = "started"
                param["anomaly"] = anamoly
                
                shiftData["shiftId"] = scheduleData[0].id
                
                shiftData["autoClockIn"] = false
                shiftData["autoClockOut"] = false
                
                deviceDetails["device"] = "iOS"
                deviceDetails["deviceModel"] = UIDevice.current.model
                deviceDetails["osVersion"] = UIDevice.current.systemVersion
                deviceDetails["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                deviceDetails["buildNumber"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                shiftData["deviceDetails"] = deviceDetails

                param["data"] = shiftData
                
                print(param)
                
                WorkHourVM.shared.startWorkHoursApi(parameters: param, isAuthorization: true) { [self] obj in
                    self.checkCurrentDraftOrSkip()
                }
            }
        })
    }
    
    func sendFCMTokenAndDeviceID() {
        var param = [String:Any]()
        
        param["device_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.deviceID)
        param["device_token"] = UserDefaults.standard.string(forKey: UserDefaultKeys.fcmToken)
        param["is_login"] = true
        
        print("FCM Token Param is : ", param)
        
        WorkHourVM.shared.sendFcmTokenAndDeviceIDApi(parameters: param, isAuthorization: true) { [self] obj in
            
           
        }
    }
    
    func getDocumentListAPI() {
        var param = [String:Any]()
        param = Helper.urlParameterForPagination()
        print(param)
        DocumentVM.shared.obligatedDocumentListAPI(parameters: param, isAuthorization: true) { [self] obj in
            self.documentData = obj.rows
            if obj.rows?.count ?? 0 > 0 {
                GlobleVariables.isObligatoryDocuments = false
                obligatoryDocumentPopupView.isHidden = false
                self.documenttblVw.reloadData()
            }
        }
    }
}

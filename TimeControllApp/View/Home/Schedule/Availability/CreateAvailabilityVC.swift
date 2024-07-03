//
//  CreateAvailabilityVC.swift
//  TimeControllApp
//
//  Created by yash on 19/01/23.
//

import UIKit
import SVProgressHUD

class CreateAvailabilityVC: BaseViewController {
    
    @IBOutlet weak var availabilityTblVw: UITableView!

    var availabilityID = Int()
    var isComingFrom = ""
    
    var availabilityDetailsData : Availability_request?
    @IBOutlet weak var timePicker: UIView!
    
    var selectedTime = Int()
    var fromTime = Int()
    var fromTimeSelectedIndex : IndexPath = []
    var selectedTimeBack : String = ""
    @IBOutlet weak var btnApply: UIButton!
    
    @IBOutlet weak var availabilityTblVwBottomConstraints: NSLayoutConstraint!
    
    //MARK: Localizations

    @IBOutlet weak var availabilityTitleLbl: UILabel!
    @IBOutlet weak var cancelBtnObj: UIBarButtonItem!
    @IBOutlet weak var doneBtnObj: UIBarButtonItem!
    
    struct StaticAvailableData : Codable {
        let availability_request: Availability_request
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        
        if isComingFrom == "PMDetails" {
            getAvailabilityByID(availabilityID: availabilityID)
        } else {
            getCreateAvailabilityDataFromJSON()
//            if let url = Bundle.main.url(forResource: "availability", withExtension: "json") {
//                do {
//                    let data = try Data(contentsOf: url)
//                    let decoder = JSONDecoder()
//                    let jsonData = try decoder.decode(StaticAvailableData.self, from: data)
//                    availabilityDetailsData = jsonData.availability_request
//
//                } catch {
//                    print("error:\(error)")
//                }
//            }
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "EEEE"
//            let currentDate = Date()
//            var dateComponent = DateComponents()
//
//            var monday = currentDate
//            var mondayDay = dateFormatter.string(from: monday)
//            while (mondayDay != "Monday") {
//                dateComponent.day = -1
//                monday = Calendar.current.date(byAdding: dateComponent, to: monday)!
//                mondayDay = dateFormatter.string(from: monday)
//            }
//            print("Monday is", monday)
//
//            var sunday = currentDate
//            var sundayDay = dateFormatter.string(from: sunday)
//            while (sundayDay != "Sunday") {
//                dateComponent.day = 1
//                sunday = Calendar.current.date(byAdding: dateComponent, to: sunday)!
//                sundayDay = dateFormatter.string(from: sunday)
//            }
//            print("Sunday is", sunday)
//
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.dateFormat = "yyyy-MM-dd"
//            let finalMonday = dateFormatter1.string(from: monday)
//            let finalSunday = dateFormatter1.string(from: sunday)
//
//            availabilityDetailsData?.request_type = "weekly"
//            availabilityDetailsData?.client_id = UserDefaults.standard.integer(forKey: UserDefaultKeys.clientId)
//            availabilityDetailsData?.user_id = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)
//            availabilityDetailsData?.from_date = "\(finalMonday)"
//            availabilityDetailsData?.to_date = "\(finalSunday)"
        }
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        availabilityTitleLbl.text = LocalizationKey.availability.localizing()
        cancelBtnObj.title = LocalizationKey.cancel.localizing()
        doneBtnObj.title = LocalizationKey.done.localizing()
        btnApply.setTitle(LocalizationKey.apply.localizing(), for: .normal)
    }
    
    func configUI() {
        self.availabilityTblVw.separatorColor = UIColor.clear
        availabilityTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.AvailabilityTypeTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AvailabilityTypeTVC.rawValue)
        availabilityTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.AvailabilityCalendarTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AvailabilityCalendarTVC.rawValue)
        availabilityTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.AvailabilityDayTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.AvailabilityDayTVC.rawValue)
        timeToMinutes()
    }

    
    @IBAction func btnClickedApply(_ sender: Any) {
        
        for index in 0..<(self.availabilityDetailsData?.availability?.count ?? 0) {
            
            if (self.availabilityDetailsData?.availability?[index].isAllDay == false && (self.availabilityDetailsData?.availability?[index].from == nil || self.availabilityDetailsData?.availability?[index].to == nil)) {
                
                if index == 0 {
                    if (self.availabilityDetailsData?.availability?[index].from == nil) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterFromTimeInMonday.localizing())
                    } else {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterToTimeInMonday.localizing())
                    }
                    return
                }  else if index == 1 {
                    if (self.availabilityDetailsData?.availability?[index].from == nil) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterFromTimeInTuesday.localizing())
                    } else {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterToTimeInTuesday.localizing())
                    }
                    return
                } else if index == 2 {
                    if (self.availabilityDetailsData?.availability?[index].from == nil) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterFromTimeInWednesday.localizing())
                    } else {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterToTimeInWednesday.localizing())
                    }
                    return
                } else if index == 3 {
                    if (self.availabilityDetailsData?.availability?[index].from == nil) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterFromTimeInThursday.localizing())
                    } else {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterToTimeInThursday.localizing())
                    }
                    return
                } else if index == 4 {
                    if (self.availabilityDetailsData?.availability?[index].from == nil) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterFromTimeInFriday.localizing())
                    } else {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterToTimeInFriday.localizing())
                    }
                    return
                } else if index == 5 {
                    if (self.availabilityDetailsData?.availability?[index].from == nil) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterFromTimeInSaturday.localizing())
                    } else {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterToTimeInSaturday.localizing())
                    }
                    return
                } else if index == 6 {
                    if (self.availabilityDetailsData?.availability?[index].from == nil) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterFromTimeInSunday.localizing())
                    } else {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.pleaseEnterToTimeInSunday.localizing())
                    }
                    return
                }
            }
        }
        
        if isComingFrom == "PMDetails" {
            upadateAvailabilityByID(availabilityID: availabilityID)
        } else {
            createAvailability()
        }
    }
    
    @objc func openFromTimePicker(sender: UIButton){
        let index = sender.tag
        timePicker.isHidden = false
    }
    
    @IBAction func btnDoneTimeAction(_ sender: UIBarButtonItem) {
        for index in 0..<(availabilityDetailsData?.availability?.count ?? 0) {
            if (index == fromTimeSelectedIndex.row - 2) {
                if (selectedTimeBack == "fromTime") {
                    if (availabilityDetailsData?.availability?[index].to != nil && selectedTime > availabilityDetailsData?.availability?[index].to ?? 0) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.fromTimeShouldBeLesserThanToTime.localizing())
                    } else {
                        availabilityDetailsData?.availability?[index].from = selectedTime
                    }
                } else {
                    if (availabilityDetailsData?.availability?[index].from != nil && selectedTime < availabilityDetailsData?.availability?[index].from ?? 0) {
                        presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.toTimeShouldBeBiggerThanFromTime.localizing())
                    } else {
                        availabilityDetailsData?.availability?[index].to = selectedTime
                    }
                }
            }
        }
//        self.fromTime = selectedTime
        self.availabilityTblVw.reloadData()
//        availabilityTblVw.reloadSections(IndexSet(integer: 0), with: .none)
        timePicker.isHidden = true
    }
    
    @IBAction func btnCancelTimeAction(_ sender: UIBarButtonItem) {
        timePicker.isHidden = true
    }
    
    @IBAction func timePickerValueChange(_ sender: UIDatePicker) {
        let cDate = Date()
        let hoursDate = DateFormatter()
        hoursDate.dateFormat = "H"
        let hours = Int(hoursDate.string(for: sender.date) ?? "") ?? 0
        
        let minutesDate = DateFormatter()
        minutesDate.dateFormat = "mm"
        let minutes = Int(minutesDate.string(for: sender.date) ?? "") ?? 0
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "H:mm" //"h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        
        selectedTime = hours * 60 + minutes
    }
    
    func timeToMinutes () {
        let cDate = Date()
        let hoursDate = DateFormatter()
        hoursDate.dateFormat = "H"
        let hours = Int(hoursDate.string(for: cDate) ?? "") ?? 0
        
        let minutesDate = DateFormatter()
        minutesDate.dateFormat = "mm"
        let minutes = Int(minutesDate.string(for: cDate) ?? "") ?? 0
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "H:mm" //"h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        
        selectedTime = hours * 60 + minutes
        
    }

}
//MARK: - TableView DataSource and Delegate Methods
extension CreateAvailabilityVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 1
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
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AvailabilityTypeTVC.rawValue, for: indexPath) as? AvailabilityTypeTVC else { return UITableViewCell() }
            
            if isComingFrom == "PMDetails" {
                if self.availabilityDetailsData != nil {
                    cell.setData(availabilityData: self.availabilityDetailsData!)
                }
            }
            else {
                guard  let availabilityData = self.availabilityDetailsData else {
                    return cell
                }
                cell.setData(availabilityData: availabilityData)
            }
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AvailabilityCalendarTVC.rawValue, for: indexPath) as? AvailabilityCalendarTVC else { return UITableViewCell() }
            
            if isComingFrom == "PMDetails" {
                if self.availabilityDetailsData != nil {
                    cell.setCalendarValue(availabilityData: self.availabilityDetailsData!)
                }
            }
            else {
                guard  let availabilityData = self.availabilityDetailsData else {
                    return cell
                }
                cell.setCalendarValue(availabilityData: availabilityData)
            }
            cell.delegate = self
            return cell
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AvailabilityDayTVC.rawValue, for: indexPath) as? AvailabilityDayTVC else { return UITableViewCell() }
            
            if isComingFrom == "PMDetails" {
                if self.availabilityDetailsData != nil {
                    cell.setCellValue(indexPath: indexPath, availabilityData: self.availabilityDetailsData?.availability ?? [], selectedFromTime: fromTime, allAvailabilityData: self.availabilityDetailsData!)
    //                if (fromTime != 0) {
    //                    cell.txtFromDate.text = "\(fromTime)"
    //
    //                } else {
    //                    cell.txtFromDate.text = logTime(time: self.availabilityDetailsData?.availability?[indexPath.row].from ?? 0)
    //                }
                }
            }
            else {
                guard  let availabilityData = self.availabilityDetailsData else {
                    return cell
                }
                cell.setCellValue(indexPath: indexPath, availabilityData: self.availabilityDetailsData?.availability ?? [], selectedFromTime: fromTime, allAvailabilityData: availabilityData)
            }
//            cell.btnFromDate.tag = indexPath.row
//            cell.btnFromDate.addTarget(self, action: #selector(openFromTimePicker(sender:)), for: .touchUpInside)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CreateAvailabilityVC:AvailabilityDayTVCDelegate {
    func onBtnAllDay(indexPath: IndexPath, isAllDay : Bool) {
        self.availabilityTblVw.beginUpdates()
//        print(indexPath.row ?? 0)
        self.availabilityDetailsData?.availability?[indexPath.row - 2].isAllDay = isAllDay
        self.availabilityTblVw.endUpdates()
    }
    
    func onFromTimeClicked(indexPathFromTime: IndexPath, selectedTextFrom: String) {
        fromTimeSelectedIndex = indexPathFromTime
        selectedTimeBack = selectedTextFrom
        timePicker.isHidden = false
    }
    
    func onToTimeClicked(indexPathToTime: IndexPath, selectedTextTo: String) {
        fromTimeSelectedIndex = indexPathToTime
        selectedTimeBack = selectedTextTo
        timePicker.isHidden = false
    }
    
    func onSelectedCommentText(commentIndexPath: IndexPath, comment : String) {
        for index in 0..<(availabilityDetailsData?.availability?.count ?? 0) {
            if (index == commentIndexPath.row - 2) {
                availabilityDetailsData?.availability?[index].comment = comment
            }
        }
    }
    
    func onAvailable(availableIndexPath: IndexPath, availableData : String) {
        for index in 0..<(availabilityDetailsData?.availability?.count ?? 0) {
            if (index == availableIndexPath.row - 2) {
                availabilityDetailsData?.availability?[index].availability_type = availableData
            }
        }
    }
}

extension CreateAvailabilityVC:AvailabilityTypeTVCDelegate {
    
    func onRequestType(requestTypeData: String) {
        availabilityDetailsData?.request_type = requestTypeData
    }
}

extension CreateAvailabilityVC:AvailabilityCalendarTVCDelegate {
    
    func didChangeDate(fromDate: String, toDate: String) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        print(formatter.string(for: sender.date))
//        selectedDate = formatter.string(for: sender.date) ?? ""
        self.availabilityDetailsData?.from_date = fromDate
        self.availabilityDetailsData?.to_date = toDate
    }
}


//MARK: APi Work in View controller
extension CreateAvailabilityVC{

    func getAvailabilityByID(availabilityID: Int) -> Void {
        SVProgressHUD.show()
        let param = [String:Any]()
        print(param)
        
        AvailabilityVM.shared.getAvailabilityByID(parameters: param, id: availabilityID, isAuthorization: true) { [self] obj in
                        
            self.availabilityDetailsData = obj.availability_request
            for index in 0..<(self.availabilityDetailsData?.availability?.count ?? 0) {
                if (self.availabilityDetailsData?.availability?[index].from != nil || self.availabilityDetailsData?.availability?[index].to != nil) {
                    self.availabilityDetailsData?.availability?[index].isAllDay = false
                } else {
                    self.availabilityDetailsData?.availability?[index].isAllDay = true
                }
            }
            
            let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
            let userIDAPI =  "\(availabilityDetailsData?.user_id ?? 0)"
            
            if userID == userIDAPI {
                if availabilityDetailsData?.status == "pending" {
                    btnApply.isHidden = false
                    availabilityTblVwBottomConstraints.constant = 80
                }
                else {
                    btnApply.isHidden = true
                    availabilityTblVwBottomConstraints.constant = 20
                }
            }
            else {
                btnApply.isHidden = true
                availabilityTblVwBottomConstraints.constant = 20
            }
            self.availabilityTblVw.reloadData()
        }
    }
    
//    func getCreateAvailabilityDataFromJSON() {
//        if let url = Bundle.main.url(forResource: "availability", withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                let jsonData = try decoder.decode(StaticAvailableData.self, from: data)
//                availabilityDetailsData = jsonData.availability_request
//                
//            } catch {
//                print("error:\(error)")
//            }
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        let currentDate = Date()
//        var dateComponent = DateComponents()
//        
//        var monday = currentDate
//        var mondayDay = dateFormatter.string(from: monday)
//        while (mondayDay != "Monday") {
//            dateComponent.day = -1
//            monday = Calendar.current.date(byAdding: dateComponent, to: monday)!
//            mondayDay = dateFormatter.string(from: monday)
//        }
//        print("Monday is", monday)
//        
//        var sunday = currentDate
//        var sundayDay = dateFormatter.string(from: sunday)
//        while (sundayDay != "Sunday") {
//            dateComponent.day = 1
//            sunday = Calendar.current.date(byAdding: dateComponent, to: sunday)!
//            sundayDay = dateFormatter.string(from: sunday)
//        }
//        print("Sunday is", sunday)
//        
//        let dateFormatter1 = DateFormatter()
//        dateFormatter1.dateFormat = "yyyy-MM-dd"
//        let finalMonday = dateFormatter1.string(from: monday)
//        let finalSunday = dateFormatter1.string(from: sunday)
//        
//        availabilityDetailsData?.request_type = "weekly"
//        availabilityDetailsData?.client_id = UserDefaults.standard.integer(forKey: UserDefaultKeys.clientId)
//        availabilityDetailsData?.user_id = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)
//        availabilityDetailsData?.from_date = "\(finalMonday)"
//        availabilityDetailsData?.to_date = "\(finalSunday)"
//        
//        availabilityTblVwBottomConstraints.constant = 80
//    }
    
    func getCreateAvailabilityDataFromJSON() {
        DispatchQueue.global(qos: .background).async {
            if let url = Bundle.main.url(forResource: "availability", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(StaticAvailableData.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.availabilityDetailsData = jsonData.availability_request
                        self.handleDates()
                        self.configureAvailabilityData()
                    }
                } catch {
                    print("Error decoding JSON:", error)
                }
            }
        }
    }

    func handleDates() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        let currentDate = Date()
//        var dateComponent = DateComponents()
        
        
        guard let timeZone = TimeZone(identifier: "GMT") else {
            // Handle the case where timeZone is nil (invalid identifier)
            // You can log an error, return a default value, or handle it in an appropriate way
            return // Example default value, adjust as needed
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
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
        
//        while (mondayDay != "Monday") {
//            dateComponent.day = -1
//            if let newMonday = Calendar.current.date(byAdding: dateComponent, to: monday) {
//                monday = newMonday
//                mondayDay = dateFormatter.string(from: monday)
//            } else {
//                // Handling the case where date(byAdding:to:) returns nil
//                // You can set a default value here, for example, setting it to the start of the week.
//                monday = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) ?? Date()
//                mondayDay = dateFormatter.string(from: monday)
//                break // Exit the loop as fallback default value is set
//            }
//        }
        
        var sunday = currentDate
        var sundayDay = dateFormatter.string(from: sunday)
        while (sundayDay != "Sunday") {
            dateComponent.day = 1
            sunday = Calendar.current.date(byAdding: dateComponent, to: sunday)!
            sundayDay = dateFormatter.string(from: sunday)
        }
        
//        while (sundayDay != "Sunday") {
//            dateComponent.day = 1
//            if let newSunday = Calendar.current.date(byAdding: dateComponent, to: sunday) {
//                sunday = newSunday
//                sundayDay = dateFormatter.string(from: sunday)
//            } else {
//                // Handling the case where date(byAdding:to:) returns nil
//                // You can set a default value here, for example, setting it to the end of the week.
//                sunday = Calendar.current.date(bySetting: .weekday, value: 7, of: currentDate) ?? Date()
//                sundayDay = dateFormatter.string(from: sunday)
//                break // Exit the loop as fallback default value is set
//            }
//        }
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.timeZone = timeZone
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let finalMonday = dateFormatter1.string(from: monday)
        let finalSunday = dateFormatter1.string(from: sunday)
        
        availabilityDetailsData?.request_type = "weekly"
        availabilityDetailsData?.client_id = UserDefaults.standard.integer(forKey: UserDefaultKeys.clientId)
        availabilityDetailsData?.user_id = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)
        availabilityDetailsData?.from_date = finalMonday
        availabilityDetailsData?.to_date = finalSunday
    }

    func configureAvailabilityData() {
        DispatchQueue.main.async {
            // Update UI or perform any other tasks related to availability data
            self.availabilityTblVwBottomConstraints.constant = 80
            self.availabilityTblVw.reloadData()
        }
    }

    
    func upadateAvailabilityByID(availabilityID: Int) -> Void {
        SVProgressHUD.show()
        var param = [String:Any]()
        var availabilityData = [[String:Any]]()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromDateString = dateFormatter.date(from: availabilityDetailsData?.from_date ?? "")
        
        let selectedWeek = fromDateString?.daysOfWeek
        var weekDateArray = [String]()
        selectedWeek?.forEach { (dateOfWeek) in
            print("Date is : ", dateOfWeek)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            weekDateArray.append(dateFormatter.string(from: dateOfWeek))
        }
        print("weekDateArray is : ", weekDateArray)
        
        for index in 0..<(self.availabilityDetailsData?.availability?.count ?? 0) {
            var availabilityOnce = [String:Any]()
            availabilityOnce["availability_type"] = availabilityDetailsData?.availability?[index].availability_type
            availabilityOnce["comment"] = availabilityDetailsData?.availability?[index].comment
            availabilityOnce["to"] = availabilityDetailsData?.availability?[index].to
            availabilityOnce["from"] = availabilityDetailsData?.availability?[index].from
//            availabilityOnce["for_date"] = availabilityDetailsData?.availability?[index].for_date
            availabilityOnce["for_date"] = weekDateArray.count == 0 ? availabilityDetailsData?.availability?[index].for_date : weekDateArray[index]
            availabilityData.append(availabilityOnce)
        }
    
        param["availability"] = availabilityData
        param["client_id"] = self.availabilityDetailsData?.client_id
        param["from_date"] = self.availabilityDetailsData?.from_date
        param["request_type"] = self.availabilityDetailsData?.request_type
        param["to_date"] = self.availabilityDetailsData?.to_date
        param["user_id"] = self.availabilityDetailsData?.user_id
        
        print("Update param is : ", param)
        
        AvailabilityVM.shared.updateAvailabilityByID(parameters: param, id: availabilityID, isAuthorization: true) { [self] obj in
            showAlert(message: LocalizationKey.availabilityUpdated.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func createAvailability() -> Void {
        SVProgressHUD.show()
        var param = [String:Any]()
        var availabilityData = [[String:Any]]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromDateString = dateFormatter.date(from: availabilityDetailsData?.from_date ?? "")
        
        let selectedWeek = fromDateString?.daysOfWeek
        var weekDateArray = [String]()
        selectedWeek?.forEach { (dateOfWeek) in
            print("Date is : ", dateOfWeek)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            weekDateArray.append(dateFormatter.string(from: dateOfWeek))
        }
        print("weekDateArray is : ", weekDateArray)
        
        for index in 0..<(self.availabilityDetailsData?.availability?.count ?? 0) {
            var availabilityOnce = [String:Any]()
            availabilityOnce["availability_type"] = availabilityDetailsData?.availability?[index].availability_type
            availabilityOnce["comment"] = availabilityDetailsData?.availability?[index].comment
            availabilityOnce["to"] = availabilityDetailsData?.availability?[index].to
            availabilityOnce["from"] = availabilityDetailsData?.availability?[index].from
//            availabilityOnce["for_date"] = availabilityDetailsData?.availability?[index].for_date
            availabilityOnce["for_date"] = weekDateArray[index]
            availabilityData.append(availabilityOnce)
        }
    
        param["availability"] = availabilityData
        param["client_id"] = self.availabilityDetailsData?.client_id
        param["from_date"] = self.availabilityDetailsData?.from_date
        param["request_type"] = self.availabilityDetailsData?.request_type
        param["to_date"] = self.availabilityDetailsData?.to_date
        param["user_id"] = self.availabilityDetailsData?.user_id
        
        print("Create param is : ", param)
        
        AvailabilityVM.shared.createAvailability(parameters: param, isAuthorization: true) { [self] obj in
            showAlert(message: LocalizationKey.availabilityCreated.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getAllDaysOfTheCurrentWeek() -> [Date] {
        var dates: [Date] = []
        guard let dateInterval = Calendar.current.dateInterval(of: .weekOfYear,
                                                               for: Date()) else {
            return dates
        }
        
        Calendar.current.enumerateDates(startingAfter: dateInterval.start,
                                        matching: DateComponents(hour:0),
                                        matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else {
                return
            }
            if date <= dateInterval.end {
                dates.append(date)
            } else {
                stop = true
            }
        }
        
        return dates
    }
    
    
    func weekDates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        
        print("All Dates : ", dates)
        return dates
    }
}

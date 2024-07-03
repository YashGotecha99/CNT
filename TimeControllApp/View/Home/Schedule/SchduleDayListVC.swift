//
//  SchduleDayListVC.swift
//  TimeControllApp
//
//  Created by yash on 09/01/23.
//

import UIKit

class SchduleDayListVC: BaseViewController {
    
    @IBOutlet weak var scheduleListTblVw: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var scheduleDayListTitleLbl: UILabel!
    
    var formattedShifts : FormattedShifts?
    
    var shiftArray: [FormattedData] = []

    var isComingFrom = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        scheduleDayListTitleLbl.text = LocalizationKey.schedule.localizing()
    }
    
    func configUI() {
        self.scheduleListTblVw.separatorColor = UIColor.clear
        scheduleListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SchedueDayListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SchedueDayListTVC.rawValue)
        scheduleListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ScheduleListMemberColleagueTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ScheduleListMemberColleagueTVC.rawValue)
        
        shiftArray = formattedShifts?.data ?? []
        
        //MARK: Change the date formate from configuration
//        dateLbl.text = formattedShifts?.for_date?.convertAllFormater(formated: "dd.MM.yyyy")
        dateLbl.text = formattedShifts?.for_date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        
        dayLbl.text = formattedShifts?.for_date?.convertAllFormater(formated: "EEEE")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: - TableView DataSource and Delegate Methods
extension SchduleDayListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 1
        if count < 1 {
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
        return shiftArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isComingFrom {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SchedueDayListTVC.rawValue, for: indexPath) as? SchedueDayListTVC else { return UITableViewCell() }
            
            let obj = shiftArray[indexPath.row]
            cell.setCellValue(shift: obj)
            cell.delegate = self
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ScheduleListMemberColleagueTVC.rawValue, for: indexPath) as? ScheduleListMemberColleagueTVC else { return UITableViewCell() }
        
        let obj = shiftArray[indexPath.row]
        cell.setCellValueFrom(shift: obj)
//        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isComingFrom {
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
            
            let obj = shiftArray[indexPath.row]
            
            print("obj is : ", obj)
            
            if ((obj.for_date ?? "" < currentDate) && (obj.end_time ?? 0 < Int(totalMinutes))) {
                presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.youCanNotSwapPastDate.localizing())
            } else if ((obj.for_date ?? "" == currentDate) && (obj.end_time ?? 0 < Int(totalMinutes))) {
                presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.youCanNotSwapPastDate.localizing())
            } else {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapDetailsVC") as! SwapDetailsVC
                vc.shift = obj
                self.navigationController?.pushViewController(vc, animated: true)
            }
//            if obj.end_time ?? 0 < Int(totalMinutes) {
//                presentAlert(withTitle: LocalizationKey.error.localizing(), message: LocalizationKey.youCanNotSwapPastDate.localizing())
//            } else {
//                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapDetailsVC") as! SwapDetailsVC
//                vc.shift = obj
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
    
}

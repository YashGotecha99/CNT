//
//  AvailabilityCalendarTVC.swift
//  TimeControllApp
//
//  Created by yash on 20/01/23.
//

import UIKit
import FSCalendar

protocol AvailabilityCalendarTVCDelegate: class {
    func didChangeDate(fromDate: String, toDate: String)
}

class AvailabilityCalendarTVC: UITableViewCell {
    
    @IBOutlet weak var calenderMainVw: UIView!
    @IBOutlet weak var calenderVw: FSCalendar!
    
    weak var delegate : AvailabilityCalendarTVCDelegate?

    var currentDate = Date()
    
    //MARK: Localizations
    @IBOutlet weak var staticSelectWeekLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        staticSelectWeekLbl.text = LocalizationKey.selectWeek.localizing()
        configUI()
    }
    
    func configUI() {
        
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
        calenderVw.allowsMultipleSelection = true
        
        calenderVw.dataSource = self
        calenderVw.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCalendarValue(availabilityData: Availability_request) -> Void {
        
        let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        let userIDAPI =  "\(availabilityData.user_id ?? 0)"
        
        if userID == userIDAPI {
            if availabilityData.status == "pending" {
                calenderVw.isUserInteractionEnabled = true
            }
            else {
                calenderVw.isUserInteractionEnabled = false
            }
        }
        else {
            calenderVw.isUserInteractionEnabled = false
        }
        
        let splitFromdate = availabilityData.to_date?.split(separator: "T")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromDate = dateFormatter.date(from: String(splitFromdate?[0] ?? ""))
        
        let deSelctedWeek = currentDate.daysOfWeek
        deSelctedWeek.forEach { (d) in
            self.calenderVw.deselect(d)
        }

        let selectedWeek = fromDate?.daysOfWeek
        selectedWeek?.forEach { (d) in
            self.calenderVw.select(d, scrollToDate: true)
        }
        currentDate = fromDate ?? Date()
    }
    
}
extension AvailabilityCalendarTVC :FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        var dateComponent = DateComponents()
        
        var monday = date
        var mondayDay = dateFormatter.string(from: monday)
        while (mondayDay != "Monday") {
            dateComponent.day = -1
            monday = Calendar.current.date(byAdding: dateComponent, to: monday)!
            mondayDay = dateFormatter.string(from: monday)
        }
        print("Monday is", monday)
        
        var sunday = date
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
        
        let deSelctedWeek = currentDate.daysOfWeek
        deSelctedWeek.forEach { (d) in
            self.calenderVw.deselect(d)
        }
        
        let selectedWeek = date.daysOfWeek
        delegate?.didChangeDate(fromDate: finalMonday, toDate: finalSunday)
        selectedWeek.forEach { (d) in
            self.calenderVw.select(d, scrollToDate: true)
        }
        currentDate = date
    }
}

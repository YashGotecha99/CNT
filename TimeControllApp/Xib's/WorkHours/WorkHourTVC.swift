//
//  WorkHourTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 04/07/22.
//

import UIKit
import CoreLocation

class WorkHourTVC: UITableViewCell {

    @IBOutlet weak var stackVwWidth: NSLayoutConstraint!
    @IBOutlet weak var breakHourDividerVw: UIView!
    @IBOutlet weak var breakDividerVw: UIView!
    @IBOutlet weak var totalHoursStackVw: UIStackView!
    @IBOutlet weak var workHourTitleLbl: UILabel!
    @IBOutlet weak var statusBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var locationBackgroundVw: UIView!
    @IBOutlet weak var backgroundColorVw: UIView!
    @IBOutlet weak var locImg: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblprojectName: UILabel!
    @IBOutlet weak var lblFromToTime: UILabel!
    
    @IBOutlet weak var lblOvertime: UILabel!
    
//    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var lblBreak: UILabel!
    
    @IBOutlet weak var lblTotalHrs: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var stackMiles: UIStackView!
    
    //MARK: Localizations
    @IBOutlet weak var staticTimeLbl: UILabel!
//    @IBOutlet weak var staticMilesLbl: UILabel!
    @IBOutlet weak var staticBreakLbl: UILabel!
    @IBOutlet weak var staticTotalHoursLbl: UILabel!
    
    @IBOutlet weak var breakVw: UIStackView!
    @IBOutlet weak var imgTripletex: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        locImg.image = UIImage(named: "Location")
        staticTimeLbl.text = LocalizationKey.time.localizing()
//        staticMilesLbl.text = LocalizationKey.miles.localizing()
        staticBreakLbl.text = LocalizationKey.breakData.localizing()
        staticTotalHoursLbl.text = LocalizationKey.totalHrs.localizing()
        self.selectionStyle = .none
    }

    func configUI(selectedTab : String) {
        
        switch selectedTab {
        case WorkType.Draft.rawValue:
            workHourTitleLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            backgroundColorVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            locationBackgroundVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 0.1032631803)
            statusBtnWidth.constant = 57.0
            statusBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            statusBtn.setTitle(LocalizationKey.draft.localizing(), for: .normal)
            totalHoursStackVw.isHidden = true
            breakDividerVw.isHidden = true
            breakHourDividerVw.isHidden = true
            imgTripletex.isHidden = true
          //  stackVwWidth.constant = 213.0
        case WorkType.Pending.rawValue:
            workHourTitleLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            backgroundColorVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            locationBackgroundVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 0.1025457058)
            statusBtnWidth.constant = 75.0
            statusBtn.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            statusBtn.setTitle(LocalizationKey.pending.localizing(), for: .normal)
            totalHoursStackVw.isHidden = false
            breakDividerVw.isHidden = false
            breakHourDividerVw.isHidden = false
            imgTripletex.isHidden = true
          //  stackVwWidth.constant = 286.0
        case WorkType.Approved.rawValue:
            workHourTitleLbl.textColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            backgroundColorVw.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            locationBackgroundVw.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 0.1024925595)
            statusBtnWidth.constant = 75.0
            statusBtn.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            statusBtn.setTitle(LocalizationKey.approved.localizing(), for: .normal)
            totalHoursStackVw.isHidden = false
            breakDividerVw.isHidden = false
            breakHourDividerVw.isHidden = false
          //  stackVwWidth.constant = 286.0
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }

    func minutesToHoursAndMinutesDecimal(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        var minutesCal = (((minutes % 60) * 100)) / 60
//        if minutesCal.
//        var stringWithLeadingZero = String()
//        if (String(minutesCal).count == 1) {
//            stringWithLeadingZero = String(format: "%02d", minutesCal)
//            minutesCal = Int(stringWithLeadingZero) ?? 0
//        }
//        print("stringWithLeadingZero is : ", minutesCal)
        
        return (minutes / 60, (((minutes % 60) * 100)) / 60)
    }

    
    func setData(rowsData: Rows) -> Void {
        
        if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.hideBreakButton ?? false {
            breakVw.isHidden = true
        } else {
            breakVw.isHidden = false
        }
        
        if rowsData.status == "draft" {
            workHourTitleLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            backgroundColorVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            locationBackgroundVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 0.1032631803)
            statusBtnWidth.constant = 57.0
            statusBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            statusBtn.setTitle(LocalizationKey.draft.localizing(), for: .normal)
            totalHoursStackVw.isHidden = true
            breakDividerVw.isHidden = true
            breakHourDividerVw.isHidden = true
        }
        
        if rowsData.status == "rejected" {
            statusBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            statusBtn.setTitle(LocalizationKey.rejected.localizing(), for: .normal)
        }
        
        if rowsData.status == "approved" || rowsData.status == "complete" {
            
            if rowsData.int_id != nil {
                imgTripletex.isHidden = false
            } else {
                imgTripletex.isHidden = true
            }
        }
        
        workHourTitleLbl.text = rowsData.task_name ?? ""
        lblprojectName.text = rowsData.project_name ?? ""
        
        let from = minutesToHoursAndMinutes(rowsData.from ?? 0)
        
        let to = minutesToHoursAndMinutes(rowsData.to ?? 0)
        
//        lblFromToTime.text = "\(from.hours):\(from.leftMinutes) - \(to.hours):\(to.leftMinutes)"
        
        let overtime = minutesToHoursAndMinutes(rowsData.total_hours_overtime ?? 0)
//        lblOvertime.text = "\(overtime.hours):\(overtime.leftMinutes)"
        
        //MARK: Change the time formate from configuration
//        lblOvertime.text = "\(from.hours):\(from.leftMinutes) - \(to.hours):\(to.leftMinutes)"
        lblOvertime.text = "\(logTime(time: rowsData.from ?? 0)) - \(logTime(time: rowsData.to ?? 0))"
        lblOvertime.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            
        
        let totalHours = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.total_time_format == "decimal" ? minutesToHoursAndMinutesDecimal(rowsData.total_hours_normal ?? 0) : minutesToHoursAndMinutes(rowsData.total_hours_normal ?? 0)

        //        lblTotalHrs.text = "\(totalHours.hours):\(totalHours.leftMinutes)"
        lblTotalHrs.text = "\(convertValueInDecimal(totalTime: totalHours.hours)):\(convertValueInDecimal(totalTime: totalHours.leftMinutes))"

        let breakData = minutesToHoursAndMinutes(rowsData.break ?? 0)
        lblBreak.text = "\(breakData.hours):\(breakData.leftMinutes)"
        
//        let miles = minutesToHoursAndMinutes(Int(rowsData.data?.distance ?? 0.0))
//        lblMiles.text = "\(miles.hours):\(miles.leftMinutes)"
//        if ((rowsData.data?.distance) != nil) {
//            lblMiles.text = "\(rowsData.data?.distance ?? 0)"
//        } else {
//            lblMiles.text = "0"
//        }
        /*
        if let dis = rowsData.data?.distance as? String {
            lblMiles.text = dis
        } else if let dis = rowsData.data?.distance as? Float {
            lblMiles.text = "\(dis)"
        }
         */
        
        
        if ((rowsData.gps_data?.start?.coords?.latitude) != nil) && ((rowsData.gps_data?.start?.coords?.longitude) != nil) {
            let ceo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude:rowsData.gps_data?.start?.coords?.latitude ?? 0.0, longitude: rowsData.gps_data?.start?.coords?.longitude ?? 0.0)
            
            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        {(placemarks, error) in
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
                    self.lblLocation.text = "\(addressString)"
                }
            })
        } else {
            lblLocation.text = LocalizationKey.locationGPSTurnedOff.localizing()
        }
                
//        lblLocation.text = "Location: \(rowsData.location_string ?? "GPS Turned Off")"
        //MARK: Change the date formate from configuration
//        lblDate.text =  rowsData.for_date?.convertStringDate() //convertStringDate(date: rowsData.for_date ?? "")
        lblDate.text =  rowsData.for_date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "") //convertStringDate(date: rowsData.for_date ?? "")
        
        let userID = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)
        
        if userID == rowsData.user_id {
            lblFromToTime.text = LocalizationKey.you.localizing()
        } else {
            lblFromToTime.text = (rowsData.first_name ?? "") + " " + (rowsData.last_name ?? "")
        }
    }
    
    func convertValueInDecimal (totalTime: Int) -> String {
        if (String(totalTime).count == 1) {
            return String(format: "%02d", totalTime)
        } else{
            return "\(totalTime)"
        }
    }
}

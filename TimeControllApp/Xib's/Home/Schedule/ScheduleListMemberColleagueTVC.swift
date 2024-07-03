//
//  ScheduleListMemberColleagueTVC.swift
//  TimeControllApp
//
//  Created by yash on 09/01/23.
//

import UIKit

class ScheduleListMemberColleagueTVC: UITableViewCell {

    @IBOutlet weak var scheduleListView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var projectLbl: UILabel!
    @IBOutlet weak var noShiftLbl: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
//    @IBOutlet weak var swapView: UIView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var dateVw: UIView!
    @IBOutlet weak var dateVwWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeMoreShiftsLbl: UILabel!
    var delegate = ScheduleListVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValue(formattedShifts:FormattedShifts){
        noShiftLbl.text = LocalizationKey.noShift.localizing()
        
        dateLbl.text = formattedShifts.for_date?.convertAllFormater(formated: "d")
        dayLbl.text = formattedShifts.for_date?.convertAllFormater(formated: "E")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: formattedShifts.for_date ?? "")
        if formattedShifts.data?.count ?? 0 > 0 {
            timeLbl.isHidden = false
            projectLbl.isHidden = false
            noShiftLbl.isHidden = true
            usernameLbl.isHidden = false
            seeMoreShiftsLbl.isHidden = true
            if formattedShifts.data?.count ?? 0 > 1 {
                arrowImg.isHidden = false
//                swapView.isHidden = true

                timeLbl.isHidden = true
                projectLbl.isHidden = true
                usernameLbl.isHidden = true
                seeMoreShiftsLbl.isHidden = false
                seeMoreShiftsLbl.text = "\(formattedShifts.data?.count ?? 0) \(LocalizationKey.shiftsClickToSeeMore.localizing())"
            } else {
                arrowImg.isHidden = true
//                swapView.isHidden = true
                
                timeLbl.isHidden = false
                projectLbl.isHidden = false
                usernameLbl.isHidden = false
                seeMoreShiftsLbl.isHidden = true
            }
            
            scheduleListView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9411764706, blue: 0.9960784314, alpha: 1)
            
            guard let firstShift = formattedShifts.data?[0] else {return}
            timeLbl.text = "\(delegate.logTime(time: firstShift.start_time ?? 0)) - \(delegate.logTime(time: firstShift.end_time ?? 0))"
            projectLbl.text = firstShift.task_name ?? ""
            usernameLbl.text = firstShift.assignee_name ?? ""
        } else {
            timeLbl.isHidden = true
            projectLbl.isHidden = true
            noShiftLbl.isHidden = false
            arrowImg.isHidden = true
            usernameLbl.isHidden = true
            seeMoreShiftsLbl.isHidden = true
            scheduleListView.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 0.1)
//            swapView.isHidden = true
        }
    }
    
    
    func setCellValueFrom(shift:FormattedData){
        arrowImg.isHidden = true
        dateVw.isHidden = true
        dateVwWidthConstraint.constant = 0
        projectLbl.text = shift.project_name
        usernameLbl.text = shift.assignee_name ?? ""
        timeLbl.text = "\(delegate.logTime(time: shift.start_time ?? 0)) - \(delegate.logTime(time: shift.end_time ?? 0))"
    }
}

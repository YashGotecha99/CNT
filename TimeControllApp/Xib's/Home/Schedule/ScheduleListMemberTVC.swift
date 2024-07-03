//
//  ScheduleListMemberTVC.swift
//  TimeControllApp
//
//  Created by yash on 09/01/23.
//

import UIKit

class ScheduleListMemberTVC: UITableViewCell {

    @IBOutlet weak var scheduleListView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var projectLbl: UILabel!
    @IBOutlet weak var noShiftLbl: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var swapView: UIView!
    
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
            if formattedShifts.data?.count ?? 0 > 1 {
                arrowImg.isHidden = false
                swapView.isHidden = true
            } else {
                arrowImg.isHidden = true
                swapView.isHidden = false
            }
            
            scheduleListView.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9411764706, blue: 0.9960784314, alpha: 1)
            
            guard let firstShift = formattedShifts.data?[0] else {return}
            timeLbl.text = "\(delegate.logTime(time: firstShift.start_time ?? 0)) - \(delegate.logTime(time: firstShift.end_time ?? 0))"
            projectLbl.text = firstShift.task_name ?? ""
            
        } else {
            timeLbl.isHidden = true
            projectLbl.isHidden = true
            noShiftLbl.isHidden = false
            arrowImg.isHidden = true
            
            scheduleListView.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 0.1)
            swapView.isHidden = true
        }
    }
    
}

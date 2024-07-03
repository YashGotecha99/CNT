//
//  MemberShiftTVC.swift
//  TimeControllApp
//
//  Created by yash on 09/03/23.
//

import UIKit

class MemberShiftTVC: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var taskNameLbl: UILabel!
    @IBOutlet weak var checkboxImg: UIImageView!
    
    var delegate = SwapEmployeeListVC()
    
    var selectedShift : ShiftsOfUser?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    func setCellValue(shift:ShiftsOfUser){
        selectedShift = shift
        projectNameLbl.text = "\(shift.project_id ?? 0) | \(shift.project_name ?? "")"
        taskNameLbl.text = "\(shift.task_id ?? 0) | \(shift.task_name ?? "")"
        locationLbl.text = shift.task_location
        timeLbl.text = "\(delegate.logTime(time: shift.start_time ?? 0)) - \(delegate.logTime(time: shift.end_time ?? 0))"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

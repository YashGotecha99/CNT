//
//  SchedueDayListTVC.swift
//  TimeControllApp
//
//  Created by yash on 09/01/23.
//

import UIKit

class SchedueDayListTVC: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    
    var delegate = SchduleDayListVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValue(shift:FormattedData){
        projectNameLbl.text = shift.project_name
        timeLbl.text = "\(delegate.logTime(time: shift.start_time ?? 0)) - \(delegate.logTime(time: shift.end_time ?? 0))"
    }
    
}

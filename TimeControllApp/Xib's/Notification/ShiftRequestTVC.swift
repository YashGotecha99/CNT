//
//  ShiftRequestTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 23/07/22.
//

import UIKit

class ShiftRequestTVC: UITableViewCell {

    @IBOutlet weak var acceptShiftBtn: UIButton!
    @IBOutlet weak var rejectShiftBtn: UIButton!
    @IBOutlet weak var shiftReqDeslbl: UILabel!
    @IBOutlet weak var shiftRequestDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

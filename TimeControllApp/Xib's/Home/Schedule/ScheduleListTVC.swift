//
//  ScheduleListTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 07/08/22.
//

import UIKit

class ScheduleListTVC: UITableViewCell {

    @IBOutlet weak var scheduleStatusLbl: UILabel!
    @IBOutlet weak var assigneeNameLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var shiftTimeLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userImgWidthConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

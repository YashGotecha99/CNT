//
//  NotificationTypeTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 23/07/22.
//

import UIKit

class NotificationTypeTVC: UITableViewCell {

    @IBOutlet weak var notificationDesLbl: UILabel!
    @IBOutlet weak var notificationDateLbl: UILabel!
    @IBOutlet weak var notificationTypeLbl: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundVw.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        backgroundVw.layer.shadowOpacity = 0.5
        backgroundVw.layer.shadowOffset = .zero
        backgroundVw.layer.shadowRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(rowsData: Notifications) -> Void {
        if rowsData.is_unread ?? false {
            backgroundVw.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9411764706, blue: 0.9960784314, alpha: 1)
//            backgroundVw.backgroundColor = UIColor
            //            cell.acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
        } else {
            backgroundVw.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        }
        
        notificationTypeLbl.text = rowsData.data?.context?.source
        notificationDesLbl.text = rowsData.message
        notificationDateLbl.text =  rowsData.created_at?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
    }
}

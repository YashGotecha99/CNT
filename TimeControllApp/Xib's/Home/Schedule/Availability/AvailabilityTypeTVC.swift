//
//  AvailabilityTypeTVC.swift
//  TimeControllApp
//
//  Created by yash on 20/01/23.
//

import UIKit

protocol AvailabilityTypeTVCDelegate: class {
    func onRequestType(requestTypeData: String)
}

class AvailabilityTypeTVC: UITableViewCell {

    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var btnRepeating: UIButton!
    
    weak var delegate : AvailabilityTypeTVCDelegate?

    var isWeekly = true
    
    //MARK: Localizations
    @IBOutlet weak var availabilityTypeLbl: UILabel!
    @IBOutlet weak var weeklyLbl: UILabel!
    @IBOutlet weak var repeatingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        availabilityTypeLbl.text = LocalizationKey.availabilityType.localizing()
        weeklyLbl.text = LocalizationKey.weekly.localizing()
        repeatingLbl.text = LocalizationKey.repeating.localizing()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnRepeating(_ sender: Any) {
        isWeekly = false
        btnRepeating.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnWeekly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        delegate?.onRequestType(requestTypeData: "repeating")
    }
    @IBAction func btnWeekly(_ sender: Any) {
        isWeekly = true
        btnWeekly.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnRepeating.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        delegate?.onRequestType(requestTypeData: "weekly")
    }
    
    func setData(availabilityData: Availability_request) -> Void {
    
        let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        let userIDAPI =  "\(availabilityData.user_id ?? 0)"
        
        if userID == userIDAPI {
            if availabilityData.status == "pending" {
                btnWeekly.isUserInteractionEnabled = true
                btnRepeating.isUserInteractionEnabled = true
            }
            else {
                btnWeekly.isUserInteractionEnabled = false
                btnRepeating.isUserInteractionEnabled = false
            }
        }
        else {
            btnWeekly.isUserInteractionEnabled = false
            btnRepeating.isUserInteractionEnabled = false
        }
        
        if availabilityData.request_type == "weekly" {
            isWeekly = true
            btnWeekly.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnRepeating.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        } else {
            isWeekly = false
            btnRepeating.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnWeekly.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
    }
}

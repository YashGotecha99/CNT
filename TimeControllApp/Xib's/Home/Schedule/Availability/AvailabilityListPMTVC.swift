//
//  AvailabilityListTVC.swift
//  TimeControllApp
//
//  Created by yash on 19/01/23.
//

import UIKit

class AvailabilityListPMTVC: UITableViewCell {
    
    @IBOutlet weak var availabilityImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var approvedVw: UIView!
    @IBOutlet weak var approvedLbl: UILabel!
    @IBOutlet weak var weekendVw: UIView!
    @IBOutlet weak var weekendLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fromDateLbl.text = LocalizationKey.from.localizing()
        toDateLbl.text = LocalizationKey.to.localizing()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(availabilityData: AvailabilityList) -> Void {
        nameLbl.text = (availabilityData.first_name ?? "") + " " + (availabilityData.last_name ?? "")
        let splitFromdate = availabilityData.from_date?.split(separator: "T")
        let splitTodate = availabilityData.to_date?.split(separator: "T")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fromDate = dateFormatter.date(from: String(splitFromdate?[0] ?? ""))
        let toDate = dateFormatter.date(from: String(splitTodate?[0] ?? ""))
        dateFormatter.dateFormat = "MM.dd.yyyy"
        let fromDateFinal = dateFormatter.string(from: fromDate ?? Date())
        let toDateFinal = dateFormatter.string(from: toDate ?? Date())

        fromDateLbl.text = "\(LocalizationKey.from.localizing()): " + fromDateFinal
        toDateLbl.text = "\(LocalizationKey.to.localizing()): " + toDateFinal
        
        if (availabilityData.status == "pending") {
            approvedVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            approvedLbl.text = LocalizationKey.pending.localizing()
        } else if (availabilityData.status == "rejected") {
            approvedVw.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            approvedLbl.text = LocalizationKey.rejected.localizing()
        } else {
            approvedVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            approvedLbl.text = LocalizationKey.approved.localizing()
        }
        
        if (availabilityData.request_type == "weekly") {
            weekendLbl.text = LocalizationKey.weekly.localizing()
        } else {
            weekendLbl.text = LocalizationKey.repeating.localizing()
        }
        
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(availabilityData.image ?? "")")
        availabilityImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        
//        approvedLbl.text = availabilityData.status?.capitalizingFirstLetter()
//        weekendLbl.text = availabilityData.request_type?.capitalizingFirstLetter()
    }

}

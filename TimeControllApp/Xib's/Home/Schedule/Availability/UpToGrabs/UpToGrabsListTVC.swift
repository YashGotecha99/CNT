//
//  UpToGrabsListTVC.swift
//  TimeControllApp
//
//  Created by yash on 30/01/23.
//

import UIKit

protocol UpToGrabButtonClickedTVCDelegate: AnyObject {
    func onGrabBtnClicked(cell: UpToGrabsListTVC)
}


class UpToGrabsListTVC: UITableViewCell {

    @IBOutlet weak var grabDateLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var occupationLbl: UILabel!
    @IBOutlet weak var grabTimeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var grabBtn: UIButton!
    
    var selectedUpToGrab : RequestShift?
    
    var delegate = UpToGrabsListVC()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func grabButtonClicked(_ sender: Any) {
        delegate.onGrabBtnClicked(cell: self)
    }
    
    func setCellValue(requestShift:RequestShift,selectedSegmentIndex:Int){
        selectedUpToGrab = requestShift
        occupationLbl.text = requestShift.project_name
        addressLbl.text = requestShift.task_name
        locationLbl.text = (requestShift.task_address ?? "") + "," + (requestShift.task_post_place ?? "") + "," + (requestShift.task_post_number ?? "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let grabDate = dateFormatter.date(from: requestShift.shift_date ?? "")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEE"
        let dayName = dateFormatter1.string(from: grabDate ?? Date())
        grabTimeLbl.text = "\(dayName), \(delegate.logTime(time: requestShift.start_time ?? 0)) - \(delegate.logTime(time: requestShift.end_time ?? 0))"
//        locationLbl.text = requestShift.
        if (requestShift.is_accepted ?? false) {
            if (requestShift.is_approved ?? false) {
                grabBtn.setTitle(LocalizationKey.approved.localizing(), for: .normal)
                grabBtn.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.7027264031)
            } else if (requestShift.is_rejected ?? false) {
                grabBtn.setTitle(LocalizationKey.rejected.localizing(), for: .normal)
                grabBtn.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.6950201956)
            } else {
                grabBtn.setTitle(LocalizationKey.awaiting.localizing(), for: .normal)
                grabBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
        else {
            grabBtn.setTitle(LocalizationKey.grab.localizing(), for: .normal)
            grabBtn.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
        }
        if (requestShift.is_accepted ?? false) {
            grabBtn.isUserInteractionEnabled = false
        }
        else {
            grabBtn.isUserInteractionEnabled = true
        }
    }
}

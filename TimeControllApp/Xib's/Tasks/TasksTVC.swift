//
//  TasksTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 27/07/22.
//

import UIKit

class TasksTVC: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(rowsData: TasksScreenData) -> Void {
        lblName.text = rowsData.name
        lblTime.text = "\(logTime(time: rowsData.start_time ?? 0)) - \(logTime(time: rowsData.end_time ?? 0))"
        lblProjectName.text = rowsData.project_name
//        lblLocation.text = "Location: \(rowsData.data?.addressCache ?? "Missing")"
        var address = ""
        if rowsData.address != "" {
            address = rowsData.address ?? ""
        }
        
        if rowsData.post_number != "" {
            address = "\(address), \(rowsData.post_number ?? "")"
        }
        
        if rowsData.post_place != "" {
            address = "\(address), \(rowsData.post_place ?? "")"
        }
        
        if address == "" {
            address = LocalizationKey.missing.localizing()
        }
        
        lblLocation.text = address

//        lblLocation.text = "\(LocalizationKey.location.localizing()) \(rowsData.data?.addressCache ?? "\(LocalizationKey.missing.localizing())")"
//        lblLocation.text = ((rowsData.data?.addressCache) != nil) ? "Location: \(rowsData.data?.addressCache)" : "Location: Missing"
    }
}

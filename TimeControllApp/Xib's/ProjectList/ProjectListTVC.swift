//
//  ProjectListTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 31/07/22.
//

import UIKit

class ProjectListTVC: UITableViewCell {

    @IBOutlet weak var lblProjectTitle: UILabel!
    @IBOutlet weak var lblLocationName: UILabel!
    
    @IBOutlet weak var btnSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: TaskRows) -> Void {
        
        self.lblProjectTitle.text = "\(data.id ?? 1) | \(data.name ?? "")"
        self.lblLocationName.text = LocalizationKey.location.localizing() + " " + LocalizationKey.missing.localizing()
        
    }
    
    func setData(data: ChecklistsRows) -> Void {
        
        self.lblProjectTitle.text = "\(data.id ?? 1) | \(data.name ?? "")"
        self.lblLocationName.text = LocalizationKey.location.localizing() + " " + LocalizationKey.missing.localizing()
        
    }
    func setData(data: Rooms) -> Void {
        
        self.lblProjectTitle.text = "\(data.id ?? 1) | \(data.name ?? "")"
        self.lblLocationName.text = LocalizationKey.location.localizing() + " " + LocalizationKey.missing.localizing()
        
    }
    
    func setProjectData(data: projectsModel) -> Void {
        
        self.lblProjectTitle.text = "\(data.id ?? 1) | \(data.fullname ?? "")"
        self.lblLocationName.text = LocalizationKey.location.localizing() + " " + LocalizationKey.missing.localizing()
        
    }
    
}

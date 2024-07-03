//
//  ChecklistTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 14/07/22.
//

import UIKit

class ChecklistTVC: UITableViewCell {

    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusBackgroundVw: UIView!
    @IBOutlet weak var titleCheckListLbl: UILabel!
    @IBOutlet weak var elementNameLbl: UILabel!
    @IBOutlet weak var obligatoryLbl: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var createdByLbl: UILabel!
    @IBOutlet weak var doneDateLbl: UILabel!
    @IBOutlet weak var assignedToLbl: UILabel!
    
    //MARK: Localizations
    @IBOutlet weak var staticStartDateLbl: UILabel!
    @IBOutlet weak var staticDoneDateLbl: UILabel!
    @IBOutlet weak var staticCreatedByLbl: UILabel!
    @IBOutlet weak var staticAssignesToLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configUI(index:Int,checklist:ChecklistsRows) {
        staticStartDateLbl.text = LocalizationKey.startDate.localizing()
        staticDoneDateLbl.text = LocalizationKey.doneDate.localizing()
        staticCreatedByLbl.text = LocalizationKey.createdBy.localizing()
        staticAssignesToLbl.text = LocalizationKey.assignedTo.localizing()

        if index == 0 {
            titleCheckListLbl.textColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            backgroundVw.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            statusBackgroundVw.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            
        } else if index == 1 {
            titleCheckListLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            backgroundVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            statusBackgroundVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
        } else {
            titleCheckListLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            backgroundVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            statusBackgroundVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
        }
        if checklist.isobligatory ?? false {
            obligatoryLbl.isHidden = false
        } else {
            obligatoryLbl.isHidden = true
        }
        statusLbl.text = "\(LocalizationKey.status.localizing()) : \(checklist.status ?? "")"
        titleCheckListLbl.text = "\(checklist.id ?? 0) | \(checklist.name ?? "")"
        elementNameLbl.text = "\(checklist.element_data?.first?.id ?? 0) | \(checklist.element_data?.first?.name ?? "")"
        
        //MARK: Change the date formate from configuration
//        startDateLbl.text = (checklist.created_at != nil) ? checklist.created_at?.convertAllFormater(formated: "dd.MM.yyyy") : ""
        startDateLbl.text = (checklist.created_at != nil) ? checklist.created_at?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "") : ""
        
        createdByLbl.text = "\(checklist.created_by_first_name ?? "") \(checklist.created_by_last_name ?? "")"
        assignedToLbl.text = "\(checklist.first_name ?? "") \(checklist.last_name ?? "")"
        
        //MARK: Change the date formate from configuration
//        doneDateLbl.text = (checklist.updated_at != nil) ? checklist.updated_at?.convertAllFormater(formated: "dd.MM.yyyy") : ""
        doneDateLbl.text = (checklist.updated_at != nil) ? checklist.updated_at?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "") : ""
    }
    
}

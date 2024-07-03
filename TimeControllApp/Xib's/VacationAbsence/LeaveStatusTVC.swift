//
//  LeaveStatusTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit

class LeaveStatusTVC: UITableViewCell {

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var daysBtn: UIButton!
    @IBOutlet weak var approvedLbl: UILabel!
    @IBOutlet weak var backGroundColorVw: UIView!
    @IBOutlet weak var fromDataLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValueForVacation(vacation:VacationRows){
        //MARK: Change the date formate from configuration
//        fromDataLbl.text = vacation.from
        fromDataLbl.text = vacation.from?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")

//        toDateLbl.text = vacation.to
        toDateLbl.text = vacation.to?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")

        daysBtn.setTitle("\(vacation.total_days ?? 0) \(LocalizationKey.days.localizing())", for: .normal)
        
        let userID = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)
        
        if userID == vacation.user_id {
            nameLbl.text = LocalizationKey.you.localizing()
        } else {
            nameLbl.text = "\(vacation.first_name ?? "") \(vacation.last_name ?? "")"
        }
        
        if vacation.status == "approved"{
            approvedLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            approvedLbl.text = LocalizationKey.approved.localizing()
            backGroundColorVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            daysBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            
        }else if vacation.status == "rejected" {
            approvedLbl.textColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            approvedLbl.text = LocalizationKey.rejected.localizing()
            backGroundColorVw.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            daysBtn.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
        } else  {
            approvedLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            approvedLbl.text = LocalizationKey.pending.localizing()
            backGroundColorVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            daysBtn.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
        }
        if vacation.vacation_type?.lowercased() == LocalizationKey.paid.localizing().lowercased() || vacation.vacation_type?.lowercased() == LocalizationKey.normal.localizing().lowercased() {
            statusLbl.text = LocalizationKey.paid.localizing()
        } else {
            statusLbl.text = LocalizationKey.unPaid.localizing()
        }
    }
    
    func setValueForAbsence(abseance:AbsenceRows){
        //MARK: Change the date formate from configuration
//        fromDataLbl.text = abseance.from
//        toDateLbl.text = abseance.to
        
        fromDataLbl.text = abseance.from?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        toDateLbl.text = abseance.to?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        
        daysBtn.setTitle("\(abseance.total_days ?? 0) \(LocalizationKey.days.localizing())", for: .normal)
        
        let userID = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId)

        if userID == abseance.user_id {
            nameLbl.text = LocalizationKey.you.localizing()
        } else {
            nameLbl.text = "\(abseance.first_name ?? "") \(abseance.last_name ?? "")"
        }
        
        if abseance.status == "approved"{
            approvedLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            approvedLbl.text = LocalizationKey.approved.localizing()
            backGroundColorVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            daysBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            statusLbl.text = LocalizationKey.paid.localizing()
            
        }else if abseance.status == "rejected" {
            approvedLbl.textColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            approvedLbl.text = LocalizationKey.rejected.localizing()
            backGroundColorVw.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            daysBtn.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            statusLbl.text = LocalizationKey.unPaid.localizing()
        } else  {
            approvedLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            approvedLbl.text = LocalizationKey.pending.localizing()
            backGroundColorVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            daysBtn.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            statusLbl.text = LocalizationKey.unPaid.localizing()
        }
        if abseance.absence_type?.lowercased() == "doctor"{
            statusLbl.text = LocalizationKey.medicalLeave.localizing()
        } else if abseance.absence_type?.lowercased() == "child"  {
            statusLbl.text = LocalizationKey.parentalLeave.localizing()
        } else {
            statusLbl.text = LocalizationKey.sickLeave.localizing()
        }
    }
    
}

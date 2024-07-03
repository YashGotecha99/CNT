//
//  VacationAbsenceTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit

class VacationAbsenceTVC: UITableViewCell {

    @IBOutlet weak var ParentalLeavesView: UIView!
    @IBOutlet weak var TotalVacationsLbl: UILabel!
    @IBOutlet weak var TotalVacationsValueLbl: UILabel!
    @IBOutlet weak var RegisteredVacationsLbl: UILabel!
    @IBOutlet weak var RegisteredVacationsValueLbl: UILabel!
    @IBOutlet weak var RestVacationsLbl: UILabel!
    
    @IBOutlet weak var RestVacationsValueLbl: UILabel!
    @IBOutlet weak var ParentalLeavesLbl: UILabel!
    @IBOutlet weak var ParentalLeavesValueLbl: UILabel!
    
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var employedSinceLbl: UILabel!
    @IBOutlet weak var staticYearLbl: UILabel!
    @IBOutlet weak var staticEmployedSinceLbl: UILabel!
    
    @IBOutlet weak var sickLeaveCycleVw: UIView!
    @IBOutlet weak var staticSickLeaveCycleLbl: UILabel!
    @IBOutlet weak var sickLeaveCycleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLocalization()
        yearLbl.text = getDateFormattedString(date: Date(), dateFormat: "yyyy")
//        employedSinceLbl.text = getDateFormattedString(date: Date(), dateFormat: "yyyy")
    }

    func setUpLocalization(){
        staticYearLbl.text = LocalizationKey.year.localizing()
        staticEmployedSinceLbl.text = LocalizationKey.employedSince.localizing()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellUI(selectedSegmentIndex:Int, vacationsAbsenceData : Yearly, employeePercent : String){
        if selectedSegmentIndex == 0 {
            sickLeaveCycleVw.isHidden = true
            
            staticEmployedSinceLbl.text = LocalizationKey.employement.localizing()
            employedSinceLbl.text = employeePercent + "%"

            TotalVacationsLbl.text = LocalizationKey.totalVacations.localizing()
            TotalVacationsValueLbl.text = "\(vacationsAbsenceData.vacationsTotal ?? 0)"
            
            RegisteredVacationsLbl.text = LocalizationKey.restVacations.localizing()
            RegisteredVacationsValueLbl.text = "\(vacationsAbsenceData.vacationsLeft ?? 0)"
            
            RestVacationsLbl.text = LocalizationKey.registerdVacations.localizing()
            RestVacationsValueLbl.text = "\(vacationsAbsenceData.vacationDays ?? 0)"
            
            ParentalLeavesView.isHidden = true
        } else {
            if vacationsAbsenceData.userSickLeaveCycle?.cycleStartDate != nil {
                sickLeaveCycleVw.isHidden = false
                sickLeaveCycleLbl.text = "\(vacationsAbsenceData.userSickLeaveCycle?.cycleStartDate ?? "")\n\(vacationsAbsenceData.userSickLeaveCycle?.cycleEndDate ?? "")"
            } else {
                sickLeaveCycleVw.isHidden = true
            }
            
            staticEmployedSinceLbl.text = LocalizationKey.employement.localizing()
            employedSinceLbl.text = employeePercent + "%"
            
            TotalVacationsLbl.text = LocalizationKey.totalLeaves.localizing()
            let totalLeaves = (vacationsAbsenceData.childDays ?? 0) + (vacationsAbsenceData.clearancesLeft ?? 0)
            TotalVacationsValueLbl.text = "\(totalLeaves)"
            
            RegisteredVacationsLbl.text = LocalizationKey.utilizedLeaves.localizing()
            let utilizedLeaves = (vacationsAbsenceData.selfClearances ?? 0) + (vacationsAbsenceData.doctorClearances ?? 0)
            RegisteredVacationsValueLbl.text = "\(utilizedLeaves)"
            
            RestVacationsLbl.text = LocalizationKey.sickLeaves.localizing()
            RestVacationsValueLbl.text = "\(vacationsAbsenceData.selfClearances ?? 0) / \(vacationsAbsenceData.clearancesLeft ?? 0)"
            
            ParentalLeavesView.isHidden = false
            ParentalLeavesLbl.text = LocalizationKey.parentalLeaves.localizing()
            ParentalLeavesValueLbl.text = "\(vacationsAbsenceData.doctorClearances ?? 0) / \(vacationsAbsenceData.childDays ?? 0)"
        }
    }
    
}

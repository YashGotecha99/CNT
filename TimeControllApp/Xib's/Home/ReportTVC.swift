//
//  ReportTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 03/07/22.
//

import UIKit

class ReportTVC: UITableViewCell {

    @IBOutlet weak var scheduleNotifyVw: UIView!
    @IBOutlet weak var deviationNotifyVw: UIView!
    
    @IBOutlet weak var scheduleCountLbl: UILabel!
    @IBOutlet weak var deviationCountLbl: UILabel!
    @IBOutlet weak var payrollReportLbl: UILabel!
    @IBOutlet weak var scheduleLbl: UILabel!
    @IBOutlet weak var deviationsLbl: UILabel!
    @IBOutlet weak var checklistLbl: UILabel!
    @IBOutlet weak var myTaskLbl: UILabel!
    @IBOutlet weak var vacationAbsentsLbl: UILabel!
    @IBOutlet weak var vacationAndAbsentVw: UIView!
    
    var delegate = HomeVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deviationNotifyVw.clipsToBounds = true
        deviationNotifyVw.layer.cornerRadius = 15
        deviationNotifyVw.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        
        scheduleNotifyVw.clipsToBounds = true
        scheduleNotifyVw.layer.cornerRadius = 15
        scheduleNotifyVw.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        
        
    }
    
    func setupLocalizationData() {
        payrollReportLbl.text = LocalizationKey.payrollReport.localizing()
        scheduleLbl.text = LocalizationKey.schedule.localizing()
        deviationsLbl.text = LocalizationKey.deviations.localizing()
        checklistLbl.text = LocalizationKey.checklist.localizing()
        myTaskLbl.text = LocalizationKey.myTasks.localizing()
        vacationAbsentsLbl.text = LocalizationKey.vacationsAbsents.localizing()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checklistBtnAction(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ChecklistVC") as! ChecklistVC
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deviationBtnAction(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "DeviationVC") as! DeviationVC
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func scheduleBtnAction(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ScheduleListVC") as! ScheduleListVC
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func payrollReportBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddReportVC") as! AddReportVC
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func myTasksBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "TasksVC") as! TasksVC
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func vacationAbsenceBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VacationAbsenceVC") as! VacationAbsenceVC
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
}

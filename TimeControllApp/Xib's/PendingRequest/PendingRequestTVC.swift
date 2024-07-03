//
//  PendingRequestTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 26/07/22.
//

import UIKit

protocol PendingRequestTVCProtocol {
    
    func acceptOrRejectRequest(status: String,vacationId: Int,absenceID: Int,indexPath:IndexPath)
}

class PendingRequestTVC: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var requestType: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var totalDaysLbl: UILabel!
    @IBOutlet weak var requestDateLbl: UILabel!
    @IBOutlet weak var typeOfLeaveLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var staticFromDateLbl: UILabel!
    @IBOutlet weak var staticToDateLbl: UILabel!
    @IBOutlet weak var staticTotalDaysLbl: UILabel!
    @IBOutlet weak var staticRequestDateLbl: UILabel!
    @IBOutlet weak var staticTypeOfLeaveLbl: UILabel!
    @IBOutlet weak var staticStatusLbl: UILabel!
    

    var selectedVacationId = 0
    var selectedAbsenceId = 0
    
    var delegate : PendingRequestTVCProtocol?
    
    var selectedIndexPath = IndexPath()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        staticFromDateLbl.text = LocalizationKey.fromDate.localizing()
        staticToDateLbl.text = LocalizationKey.toDate.localizing()
        totalDaysLbl.text = LocalizationKey.totalDays.localizing()
        staticRequestDateLbl.text = LocalizationKey.requestDate.localizing()
        staticTypeOfLeaveLbl.text = LocalizationKey.type.localizing()
        staticStatusLbl.text = LocalizationKey.typeOfLeave.localizing()
        rejectBtn.setTitle(LocalizationKey.reject.localizing(), for: .normal)
        acceptBtn.setTitle(LocalizationKey.approve.localizing(), for: .normal)
        
        self.selectionStyle = .none

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func rejectBtn(_ sender: Any) {
        delegate?.acceptOrRejectRequest(status: "rejected",vacationId: selectedVacationId,absenceID: selectedAbsenceId,indexPath: selectedIndexPath)
    }
    @IBAction func acceptBtn(_ sender: Any) {
        delegate?.acceptOrRejectRequest(status: "approved",vacationId: selectedVacationId,absenceID: selectedAbsenceId,indexPath: selectedIndexPath)
    }
    
    func setValueForVacation(vacation:VacationRows,indexPath:IndexPath){
        selectedIndexPath = indexPath
        selectedVacationId = vacation.id ?? 0
        fromDateLbl.text = vacation.from
        toDateLbl.text = vacation.to
        totalDaysLbl.text = "\(vacation.total_days ?? 0)"
//        requestDateLbl.text = vacation.created_at
        requestDateLbl.text = vacation.created_at?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        nameLbl.text = "\(vacation.first_name ?? "") \(vacation.last_name ?? "")"
        
        if vacation.status == "approved"{
            acceptBtn.alpha = 0.4
            rejectBtn.alpha = 1.0
            acceptBtn.isUserInteractionEnabled = false
            rejectBtn.isUserInteractionEnabled = true
            acceptBtn.setTitleColor(UIColor.black, for: .normal)
            rejectBtn.setTitleColor(UIColor.white, for: .normal)
            statusLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            statusLbl.text = LocalizationKey.approved.localizing()
            
        }else if vacation.status == "rejected" {
            rejectBtn.alpha = 0.4
            acceptBtn.alpha = 1.0
            rejectBtn.setTitleColor(UIColor.black, for: .normal)
            acceptBtn.setTitleColor(UIColor.white, for: .normal)
            acceptBtn.isUserInteractionEnabled = true
            rejectBtn.isUserInteractionEnabled = false
            statusLbl.textColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            statusLbl.text = LocalizationKey.rejected.localizing()
        } else  {
            rejectBtn.alpha = 1.0
            acceptBtn.alpha = 1.0
            acceptBtn.setTitleColor(UIColor.white, for: .normal)
            rejectBtn.setTitleColor(UIColor.white, for: .normal)
            acceptBtn.isUserInteractionEnabled = true
            rejectBtn.isUserInteractionEnabled = true
            statusLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            statusLbl.text = LocalizationKey.pending.localizing()
        }
        if vacation.vacation_type?.lowercased() == "paid" || vacation.vacation_type?.lowercased() == "normal" {
            typeOfLeaveLbl.text = LocalizationKey.paidVacation.localizing()
        } else {
            typeOfLeaveLbl.text = LocalizationKey.unpaidVacation.localizing()
        }
    }
    
    func setValueForAbsence(abseance:AbsenceRows,indexPath:IndexPath){
        selectedIndexPath = indexPath
        selectedAbsenceId = abseance.id ?? 0
        fromDateLbl.text = abseance.from
        toDateLbl.text = abseance.to
        totalDaysLbl.text = "\(abseance.total_days ?? 0)"
        requestDateLbl.text = abseance.created_at
        nameLbl.text = "\(abseance.first_name ?? "") \(abseance.last_name ?? "")"
        
        if abseance.status == "approved"{
            acceptBtn.isUserInteractionEnabled = false
            rejectBtn.isUserInteractionEnabled = true
            statusLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            statusLbl.text = LocalizationKey.approved.localizing()
        }else if abseance.status == "rejected" {
            acceptBtn.isUserInteractionEnabled = true
            rejectBtn.isUserInteractionEnabled = false
            statusLbl.textColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            statusLbl.text = LocalizationKey.rejected.localizing()
        } else  {
            acceptBtn.isUserInteractionEnabled = true
            rejectBtn.isUserInteractionEnabled = true
            statusLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            statusLbl.text = LocalizationKey.pending.localizing()
        }
        if abseance.absence_type?.lowercased() == "doctor"{
            typeOfLeaveLbl.text = LocalizationKey.medicalLeave.localizing()
        } else if abseance.absence_type?.lowercased() == "child"  {
            typeOfLeaveLbl.text = LocalizationKey.parentalLeave.localizing()
        } else {
            typeOfLeaveLbl.text = LocalizationKey.sickLeave.localizing()
        }
    }
    
    func setValueForPendingRequest(pendingRequest:AbsenceRows,indexPath:IndexPath){
        selectedIndexPath = indexPath
        fromDateLbl.text = pendingRequest.from_date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        toDateLbl.text = pendingRequest.to_date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        requestDateLbl.text = pendingRequest.requested_date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        totalDaysLbl.text = "\(pendingRequest.total_days ?? 0)"
        nameLbl.text = "\(pendingRequest.first_name ?? "") \(pendingRequest.last_name ?? "")"
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let urlAttachment = URL(string: strUrl + "/\(pendingRequest.user_image ?? "")")
        userImage.sd_setImage(with: urlAttachment , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        userImage.contentMode = .scaleAspectFill
        
        if pendingRequest.type ?? "" == "vacation" {
            requestType.text = LocalizationKey.vacation.localizing()
            requestType.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            
            selectedVacationId = pendingRequest.id ?? 0
            selectedAbsenceId = 0
            
            staticStatusLbl.isHidden = true
            statusLbl.isHidden = true
            
            if pendingRequest.status == "approved"{
                acceptBtn.alpha = 0.4
                rejectBtn.alpha = 1.0
                acceptBtn.isUserInteractionEnabled = false
                rejectBtn.isUserInteractionEnabled = true
                acceptBtn.setTitleColor(UIColor.black, for: .normal)
                rejectBtn.setTitleColor(UIColor.white, for: .normal)
                statusLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
                statusLbl.text = LocalizationKey.approved.localizing()
                
            }else if pendingRequest.status == "rejected" {
                rejectBtn.alpha = 0.4
                acceptBtn.alpha = 1.0
                rejectBtn.setTitleColor(UIColor.black, for: .normal)
                acceptBtn.setTitleColor(UIColor.white, for: .normal)
                acceptBtn.isUserInteractionEnabled = true
                rejectBtn.isUserInteractionEnabled = false
                statusLbl.textColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
                statusLbl.text = LocalizationKey.rejected.localizing()
            } else  {
                rejectBtn.alpha = 1.0
                acceptBtn.alpha = 1.0
                acceptBtn.setTitleColor(UIColor.white, for: .normal)
                rejectBtn.setTitleColor(UIColor.white, for: .normal)
                acceptBtn.isUserInteractionEnabled = true
                rejectBtn.isUserInteractionEnabled = true
                statusLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
                statusLbl.text = LocalizationKey.pending.localizing()
            }
            if pendingRequest.leave_type?.lowercased() == "paid" || pendingRequest.leave_type?.lowercased() == "normal" {
                typeOfLeaveLbl.text = LocalizationKey.paid.localizing()
            } else {
                typeOfLeaveLbl.text = LocalizationKey.unPaid.localizing()
            }
        } else {
            requestType.text = LocalizationKey.absence.localizing()
            requestType.textColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            
            selectedAbsenceId = pendingRequest.id ?? 0
            selectedVacationId = 0
            
            staticStatusLbl.isHidden = false
            statusLbl.isHidden = false
            
            
            if pendingRequest.status == "approved"{
                acceptBtn.isUserInteractionEnabled = false
                rejectBtn.isUserInteractionEnabled = true
                statusLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
                statusLbl.text = LocalizationKey.approved.localizing()
            }else if pendingRequest.status == "rejected" {
                acceptBtn.isUserInteractionEnabled = true
                rejectBtn.isUserInteractionEnabled = false
                statusLbl.textColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
                statusLbl.text = LocalizationKey.rejected.localizing()
            } else  {
                acceptBtn.isUserInteractionEnabled = true
                rejectBtn.isUserInteractionEnabled = true
                statusLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
                statusLbl.text = LocalizationKey.pending.localizing()
            }
            
            if pendingRequest.absence_type?.lowercased() == "doctor"{
                statusLbl.text = LocalizationKey.medicalLeave.localizing()
            } else if pendingRequest.absence_type?.lowercased() == "child"  {
                statusLbl.text = LocalizationKey.parentalLeave.localizing()
            } else {
                statusLbl.text = LocalizationKey.sickLeave.localizing()
            }
            
            if pendingRequest.leave_type?.lowercased() == "paid" || pendingRequest.leave_type?.lowercased() == "normal" {
                typeOfLeaveLbl.text = LocalizationKey.paid.localizing()
            } else {
                typeOfLeaveLbl.text = LocalizationKey.unPaid.localizing()
            }
        }
        
        if (UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0") == "\(pendingRequest.user_id ?? 0)" {
            acceptBtn.isUserInteractionEnabled = false
            rejectBtn.isUserInteractionEnabled = false
            acceptBtn.alpha = 0.4
            rejectBtn.alpha = 0.4
        } else {
            acceptBtn.isUserInteractionEnabled = true
            rejectBtn.isUserInteractionEnabled = true
            acceptBtn.alpha = 1
            rejectBtn.alpha = 1
        }
    }
    
}

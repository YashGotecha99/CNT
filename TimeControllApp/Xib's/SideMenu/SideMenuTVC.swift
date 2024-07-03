//
//  SideMenuTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 13/07/22.
//

import UIKit

class SideMenuTVC: UITableViewCell {

    @IBOutlet weak var titleNameLbl: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    
    var delegate = SideMenuVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func selectedIndexPath(indexPath:Int){
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            if indexPath == 0 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AllUsersVC") as! AllUsersVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 1 {
//                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ShiftRequestVC") as! ShiftRequestVC
//                delegate.navigationController?.pushViewController(vc, animated: true)
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 2 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "TasksVC") as! TasksVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 3 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VacationAbsenceVC") as! VacationAbsenceVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } 
//            else if indexPath == 4 {
//                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "PendingRequestVC") as! PendingRequestVC
//                delegate.navigationController?.pushViewController(vc, animated: true)
//            } 
            else if indexPath == 4 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 5 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 6 {
//                sendFCMTokenAndDeviceID()
                showAlert()
            }
        } else {
            if indexPath == 0 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "TasksVC") as! TasksVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 1 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "VacationAbsenceVC") as! VacationAbsenceVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 2 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 3 {
                let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
                delegate.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath == 4 {
//                sendFCMTokenAndDeviceID()
                showAlert()
            }
        }
    }
    
    func sendFCMTokenAndDeviceID() {
        var param = [String:Any]()
        
        param["device_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.deviceID)
        param["device_token"] = UserDefaults.standard.string(forKey: UserDefaultKeys.fcmToken)
        param["is_login"] = false
        
        print("FCM Token Param is : ", param)
        
        WorkHourVM.shared.sendFcmTokenAndDeviceIDApi(parameters: param, isAuthorization: true) { [self] obj in
            UserDefaults.standard.removeObject(forKey: UserDefaultKeys.token)
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            delegate.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: LocalizationKey.areYouSureYouWantToLogout.localizing(), message: LocalizationKey.logout.localizing() + "?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            // start work
            self.sendFCMTokenAndDeviceID()
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        delegate.present(alert, animated: true, completion: nil)
    }
    
}

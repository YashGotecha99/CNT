//
//  SettingVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit

class SettingVC: BaseViewController {

    @IBOutlet weak var settingTitleLbl: UILabel!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var termsAndConditionLbl: UILabel!
    @IBOutlet weak var privacyPoliciesLbl: UILabel!
    @IBOutlet weak var changePasswordLbl: UILabel!
    @IBOutlet weak var logoutLbl: UILabel!
    @IBOutlet weak var areYouSureLbl: UILabel!
    @IBOutlet weak var logoutPopupLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    
    @IBOutlet weak var logOutVw: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        logOutVw.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        settingTitleLbl.text = LocalizationKey.settings.localizing()
        notificationLbl.text = LocalizationKey.notifications.localizing()
        termsAndConditionLbl.text = LocalizationKey.termsCondition.localizing()
        privacyPoliciesLbl.text = LocalizationKey.privacyPolicies.localizing()
        changePasswordLbl.text = LocalizationKey.changePassword.localizing()
        logoutLbl.text = LocalizationKey.logout.localizing()
        areYouSureLbl.text = LocalizationKey.areYouSureYouWantToLogout.localizing()
        logoutPopupLbl.text = LocalizationKey.logout.localizing() + "?"
        cancelBtn.setTitle(LocalizationKey.cancel.localizing(), for: .normal)
        yesBtn.setTitle(LocalizationKey.yes.localizing(), for: .normal)
    }
    

    @IBAction func changePasswordBtnAction(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        logOutVw.isHidden = false
    }
    
    @IBAction func logoutCancelBtnAction(_ sender: Any) {
        logOutVw.isHidden = true
    }
    
    @IBAction func logoutYesBtnAction(_ sender: Any) {
        logOutVw.isHidden = true
        sendFCMTokenAndDeviceID()
    }
    
    @IBAction func notificationsBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func termsAndConditionsBtnAction(_ sender: Any) {
//        if let url = URL(string: "https://tidogkontroll.no/terms"), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//        }
        if let url = URL(string: "https://timeandcontrol.com/terms"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyPolicyBtnAction(_ sender: Any) {
//        if let url = URL(string: "https://tidogkontroll.no/privacy"), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//        }
        
        if let url = URL(string: "https://timeandcontrol.com/privacy"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
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
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

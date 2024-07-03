//
//  ChangePasswordVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit
import SVProgressHUD
class ChangePasswordVC: BaseViewController {

    @IBOutlet weak var newPasswordTxtField: UITextField!
    @IBOutlet weak var confirmNewPasswordTxtField: UITextField!
    @IBOutlet weak var currentPasswordTxtField: UITextField!
    @IBOutlet weak var currentPasswordVwHeight: NSLayoutConstraint!
    @IBOutlet weak var changePasswordTitleLbl: UILabel!
    @IBOutlet weak var staticCurrentPasswordLbl: UILabel!
    @IBOutlet weak var staticNewPasswordLbl: UILabel!
    @IBOutlet weak var staticConfirmNewPasswordLbl: UILabel!
    @IBOutlet weak var changePasswordBtn: UIButton!
    
    @IBOutlet weak var newPasswordEyeImg: UIImageView!
    @IBOutlet weak var confirmNewPasswordEyeImg: UIImageView!
    public var comingFrom = ""
    public var emailAddress = String()
    public var changePasswordModel = ChangePasswordViewModel()
    
    var isNewPasswordEyeOpen = false
    var isConfirmNewPasswordEyeOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        changePasswordTitleLbl.text = LocalizationKey.changePassword.localizing()
        staticCurrentPasswordLbl.text = LocalizationKey.currentPassword.localizing()
        staticNewPasswordLbl.text = LocalizationKey.newPassword.localizing()
        staticConfirmNewPasswordLbl.text = LocalizationKey.confirmNewPassword.localizing()
        currentPasswordTxtField.placeholder = LocalizationKey.currentPassword.localizing()
        newPasswordTxtField.placeholder = LocalizationKey.newPassword.localizing()
        confirmNewPasswordTxtField.placeholder = LocalizationKey.confirmNewPassword.localizing()
        changePasswordBtn.setTitle(LocalizationKey.changePassword.localizing(), for: .normal)
    }
    func configUI(){
        if comingFrom == "ResetPasswordScreen" {
            currentPasswordVwHeight.constant = 0.0
        } else {
            currentPasswordVwHeight.constant = 67.0
        }
    }
    @IBAction func newPasswordEyeBtn(_ sender: Any) {
        if isNewPasswordEyeOpen {
            newPasswordTxtField.isSecureTextEntry = true
            newPasswordEyeImg.image = UIImage(named: "ic_Eye_Close")
            isNewPasswordEyeOpen = false
        }else {
            newPasswordTxtField.isSecureTextEntry = false
            newPasswordEyeImg.image = UIImage(named: "ic_Eye_Open")
            isNewPasswordEyeOpen = true
        }
    }
    @IBAction func confirmNewPasswordEyeBtn(_ sender: Any) {
        if isConfirmNewPasswordEyeOpen {
            confirmNewPasswordTxtField.isSecureTextEntry = true
            confirmNewPasswordEyeImg.image = UIImage(named: "ic_Eye_Close")
            isConfirmNewPasswordEyeOpen = false
        }else {
            confirmNewPasswordTxtField.isSecureTextEntry = false
            confirmNewPasswordEyeImg.image = UIImage(named: "ic_Eye_Open")
            isConfirmNewPasswordEyeOpen = true
        }
    }
    
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        if comingFrom == "ResetPasswordScreen" {
            apiChangePassword()
        } else {
            if (currentPasswordTxtField.text == "") {
                self.showAlert(message: LocalizationKey.enterCurrentPassword.localizing(), strtitle: "")
            }
            else if (newPasswordTxtField.text == "") {
                self.showAlert(message: LocalizationKey.enterNewPassword.localizing(), strtitle: "")
            }
            else if (newPasswordTxtField.text != confirmNewPasswordTxtField.text) {
                self.showAlert(message: LocalizationKey.newPasswordShoudbesameasConfirmNewPassword.localizing(), strtitle: "")
            } else {
                hitProfileSave()
            }
        }
    }
    

}

//MARK: APi Work in View controller
extension ChangePasswordVC {
   private func apiChangePassword(){
       SVProgressHUD.show()
       changePasswordModel.changePassword(email: emailAddress, password: newPasswordTxtField.text ?? ""){ (successMsg,loginMessage) in
        SVProgressHUD.dismiss()
           if successMsg == true {
               self.showAlert(message: loginMessage, strtitle: "")
               
               let alert = UIAlertController(title: "", message: loginMessage, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: LocalizationKey.ok.localizing(), style: .default, handler: { action in
                   UserDefaults.standard.removeObject(forKey: UserDefaultKeys.token)
                   let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                   self.navigationController?.pushViewController(vc, animated: true)
               }))
               self.present(alert, animated: true, completion: nil)
           } else {
               self.showAlert(message: loginMessage, strtitle: "")
//               displayToast(loginMessage)
          }
       }
   }
    
    func hitProfileSave() -> Void {
        var param = [String:Any]()
        
        param["old_password"] = currentPasswordTxtField.text?.trimTrailingWhitespace()
        param["password"] = newPasswordTxtField.text?.trimTrailingWhitespace()
        AllUsersVM.shared.saveUserProfileDetailsApi(parameters: param, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in

            print(obj)
            UserDefaults.standard.removeObject(forKey: UserDefaultKeys.token)
            let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
//            self.navigationController?.popViewController(animated: true)
        }
    }
}

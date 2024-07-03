//
//  ForgotPasswordVC.swift
//  TimeControllApp
//
//  Created by Abhishek on 02/07/22.
//

import UIKit
import SVProgressHUD
class ForgotPasswordVC: BaseViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var forgotPasswordTitleLbl: UILabel!
    @IBOutlet weak var remindPasswordLbl: UILabel!
    @IBOutlet weak var thisWillSendLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    
    public var forgotPasswordModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        forgotPasswordTitleLbl.text = LocalizationKey.forgotPassword.localizing()
        remindPasswordLbl.text = LocalizationKey.remindPassword.localizing()
        thisWillSendLbl.text = LocalizationKey.thisWillSendYouAnEmailWithResettedPasswordPleasceCheckInSpamFolderForTheEmail.localizing()
        emailLbl.text = LocalizationKey.enterYourEmail.localizing()
        resetBtn.setTitle(LocalizationKey.reset.localizing(), for: .normal)
        emailTxtField.placeholder = LocalizationKey.email.localizing()
    }

    
    @IBAction override func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetBtnAction(_ sender: Any) {
        guard emailTxtField.text! != "" else{
            Toast.show(message: LocalizationKey.pleaseEnterEmail.localizing(), controller: self)
            return
        }
        guard emailTxtField.text!.isValidEmail(emailTxtField.text!) == true else{
            Toast.show(message: LocalizationKey.pleaseEnterValidEmail.localizing(), controller: self)
            return
        }
        apiForgotPassword()
    }
}

//MARK: APi Work in View controller
extension ForgotPasswordVC {
   private func apiForgotPassword(){
       SVProgressHUD.show()
       forgotPasswordModel.forgotPassword(email: emailTxtField.text ?? ""){ (errorMsg,loginMessage, apiStatusCode) in
           SVProgressHUD.dismiss()
           if apiStatusCode == 403 {
               Toast.show(message: loginMessage, controller: self)
           } else {
               if errorMsg == true {
                   let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                   vc.emailAddress = self.emailTxtField.text ?? ""
                   self.navigationController?.pushViewController(vc, animated: true)
               } else {
                   self.showAlert(message: loginMessage, strtitle: "")
                   //               displayToast(loginMessage)
               }
           }
       }
   }
}

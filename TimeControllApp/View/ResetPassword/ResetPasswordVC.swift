//
//  ResetPasswordVC.swift
//  TimeControllApp
//
//  Created by mukesh on 17/07/22.
//

import UIKit
import SVProgressHUD

class ResetPasswordVC: BaseViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var forgotPasswordTitleLbl: UILabel!
    @IBOutlet weak var oneTimePasswordLbl: UILabel!
    @IBOutlet weak var weHaveSentLbl: UILabel!
    @IBOutlet weak var verifyYourLbl: UILabel!

    @IBOutlet weak var fourthTxtField: UITextField!
    @IBOutlet weak var thirdTxtField: UITextField!
    @IBOutlet weak var secondTxtField: UITextField!
    @IBOutlet weak var firstTxtField: UITextField!
    
    @IBOutlet weak var verifyBtn: UIButton!
    
    public var emailAddress = String()
    public var resetPasswordModel = ResetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        firstTxtField.delegate = self
        secondTxtField.delegate = self
        thirdTxtField.delegate = self
        fourthTxtField.delegate = self
        
        firstTxtField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTxtField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTxtField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fourthTxtField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        forgotPasswordTitleLbl.text = LocalizationKey.forgotPassword.localizing()
        oneTimePasswordLbl.text = LocalizationKey.oneTimePassword.localizing()
        weHaveSentLbl.text = LocalizationKey.weHaveSentYouAOneTimePasswordAtYourRegisteredPhoneNumber.localizing()
        verifyYourLbl.text = LocalizationKey.verifyYourPhoneNumber.localizing()
        verifyBtn.setTitle(LocalizationKey.verify.localizing(), for: .normal)
    }
    
    @IBAction func verifyOTPBtnAction(_ sender: Any) {
        var otp = String()
        otp.append(firstTxtField.text ?? "")
        otp.append(secondTxtField.text ?? "")
        otp.append(thirdTxtField.text ?? "")
        otp.append(fourthTxtField.text ?? "")
        apiVerifyOTP(otp:otp)
    }
    

    @objc func textFieldDidChange(textField: UITextField){
            let text = textField.text
            if  text?.count == 1 {
                switch textField{
                case firstTxtField:
                    secondTxtField.becomeFirstResponder()
                case secondTxtField:
                    thirdTxtField.becomeFirstResponder()
                case thirdTxtField:
                    fourthTxtField.becomeFirstResponder()
                case fourthTxtField:
                    fourthTxtField.resignFirstResponder()
                default:
                    break
                }
            }
            if  text?.count == 0 {
                switch textField{
                case firstTxtField:
                    firstTxtField.becomeFirstResponder()
                case secondTxtField:
                    firstTxtField.becomeFirstResponder()
                case thirdTxtField:
                    secondTxtField.becomeFirstResponder()
                case fourthTxtField:
                    thirdTxtField.becomeFirstResponder()
                default:
                    break
                }
            }
            else{

            }
        }
    
}

//MARK: APi Work in View controller
extension ResetPasswordVC {
    private func apiVerifyOTP(otp:String){
       SVProgressHUD.show()
        resetPasswordModel.resetPassword(email: emailAddress, otp: otp){ (errorMsg,loginMessage, apiStatusCode) in
            SVProgressHUD.dismiss()
            if apiStatusCode == 403 {
                Toast.show(message: loginMessage, controller: self)
            } else {
                if errorMsg == true {
                    let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                    vc.comingFrom = "ResetPasswordScreen"
                    vc.emailAddress = self.emailAddress
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showAlert(message: loginMessage, strtitle: "")
                    //               displayToast(loginMessage)
                }
            }
        }
   }
}

//
//  PersonalInfoVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit
import SVProgressHUD

class PersonalInfoVC: BaseViewController {

    @IBOutlet weak var personalInfoTitleLbl: UILabel!
    @IBOutlet weak var staticFirstNameLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var staticLastNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var staticEmailLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var staticPhoneNumberLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var staticUsernameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var editPtofileBtn: UIButton!
    @IBOutlet weak var dofTxt: UITextField!
    @IBOutlet weak var staticDobLbl: UILabel!
    @IBOutlet weak var staticBankAccountLbl: UITextField!
    @IBOutlet weak var banckAccountLbl: UILabel!
    
    
    @IBOutlet weak var vwDatePicker: UIView!
    var selectedDate = "Date"
    var finalDate = ""

    var userProfileData : UserDetails?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hitGetUsersDetailsApi(id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
    }
    
    func setUpLocalization() {
        personalInfoTitleLbl.text = LocalizationKey.personalInfo.localizing()
        staticFirstNameLbl.text = LocalizationKey.firstName.localizing()
        staticLastNameLbl.text = LocalizationKey.lastName.localizing()
        staticEmailLbl.text = LocalizationKey.email.localizing()
        staticPhoneNumberLbl.text = LocalizationKey.phoneNumber.localizing()
        staticUsernameLbl.text = LocalizationKey.username.localizing()
        staticDobLbl.text = LocalizationKey.dateOfBirth.localizing()
        editPtofileBtn.setTitle(LocalizationKey.editProfile.localizing(), for: .normal)
        staticBankAccountLbl.text = LocalizationKey.bankAccount.localizing()
    }

    @IBAction func editProfileBtnAction(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.userProfileData = self.userProfileData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dobBtnAction(_ sender: Any) {
        vwDatePicker.isHidden = false
    }
    
    @IBAction func cancelDatePickerBtnAction(_ sender: Any) {
        vwDatePicker.isHidden = true
    }
    
    @IBAction func doneDatePickerBtnAction(_ sender: Any) {
        vwDatePicker.isHidden = true
        finalDate = selectedDate
    }
    
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(for: sender.date) ?? ""
    }
}

//MARK: APi Work in View controller
extension PersonalInfoVC{
    
    func hitGetUsersDetailsApi(id: String) -> Void {
        var param = [String:Any]()
        AllUsersVM.shared.getUsersDetailsApi(parameters: param, id: id, isAuthorization: true) { [self] obj,responseData  in
            userProfileData = obj.user!
            self.firstNameLbl.text = obj.user?.first_name ?? ""
            self.lastNameLbl.text = obj.user?.last_name ?? ""
            self.emailLbl.text = obj.user?.email ?? ""
            self.phoneNumberLbl.text = obj.user?.phone ?? ""
            self.usernameLbl.text = obj.user?.username ?? ""
            self.dofTxt.text = obj.user?.birthday ?? ""
            self.banckAccountLbl.text = obj.user?.bank_account_number ?? ""
        }
    }
}

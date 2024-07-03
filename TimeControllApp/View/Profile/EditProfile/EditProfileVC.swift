//
//  EditProfileVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit
import CountryPickerView

class EditProfileVC: BaseViewController {
    
    @IBOutlet weak var countryCodeLbl: UILabel!
    
    @IBOutlet weak var editProfileTitleLbl: UILabel!
    @IBOutlet weak var staticFirstNameLbl: UILabel!
    @IBOutlet weak var staticLastNameLbl: UILabel!
    @IBOutlet weak var staticEmailLbl: UILabel!
    @IBOutlet weak var staticPhoneNumberLbl: UILabel!
    @IBOutlet weak var staticUsernameLbl: UILabel!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var saveChangesBtn: UIButton!
    @IBOutlet weak var dobTxt: UITextField!
    @IBOutlet weak var staticDateOfBirthLbl: UILabel!
    @IBOutlet weak var bankAccLbl: UILabel!
    @IBOutlet weak var bankAccountTxt: UITextField!
    
    let countryPicker = CountryPickerView()
    var userProfileData : UserDetails?
    
    @IBOutlet weak var vwDatePicker: UIView!
    var selectedDate = "Date"
    var finalDate = ""
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        editProfileTitleLbl.text = LocalizationKey.editProfile.localizing()
        staticFirstNameLbl.text = LocalizationKey.firstName.localizing()
        staticLastNameLbl.text = LocalizationKey.lastName.localizing()
        staticEmailLbl.text = LocalizationKey.email.localizing()
        staticPhoneNumberLbl.text = LocalizationKey.phoneNumber.localizing()
        staticUsernameLbl.text = LocalizationKey.username.localizing()
        staticDateOfBirthLbl.text = LocalizationKey.dateOfBirth.localizing()
        saveChangesBtn.setTitle(LocalizationKey.saveChanges.localizing(), for: .normal)
        bankAccLbl.text = LocalizationKey.bankAccount.localizing()
        
        firstNameTxt.placeholder = LocalizationKey.enterFirstName.localizing()
        lastNameTxt.placeholder = LocalizationKey.enterLastName.localizing()
        phoneNumberTxt.placeholder = LocalizationKey.enterPhoneNumber.localizing()
        usernameTxt.placeholder = LocalizationKey.enterUsername.localizing()
    }
    
    func configUI(){
        let currentDate = getCurrentDateFromGMT()
        datePicker.maximumDate = currentDate
        countryPicker.delegate = self
        firstNameTxt.text = userProfileData?.first_name
        lastNameTxt.text = userProfileData?.last_name
        emailTxt.text = userProfileData?.email
        phoneNumberTxt.text = userProfileData?.phone
        usernameTxt.text = userProfileData?.username
        dobTxt.text = userProfileData?.birthday
        bankAccountTxt.text = userProfileData?.bank_account_number ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(for: currentDate) ?? ""
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.dismiss.localizing(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func countryPickerBtnAction(_ sender: Any) {
        countryPicker.showCountriesList(from: self)
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
        dobTxt.text = finalDate
    }
    
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(for: sender.date) ?? ""
    }
    
    @IBAction func saveChangesBtn(_ sender: Any) {
        if (firstNameTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterFirstName.localizing(), strtitle: "")
        }
        else if (lastNameTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterLastName.localizing(), strtitle: "")
        }
        else if (emailTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterEmail.localizing(), strtitle: "")
        }
        else if (phoneNumberTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterPhoneNumber.localizing(), strtitle: "")
        }
        else if (usernameTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterUsername.localizing(), strtitle: "")
        }
        else if (dobTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterDateOfBirth.localizing(), strtitle: "")
        }
        else if (bankAccountTxt.text != "" && (bankAccountTxt.text?.count ?? 12 < 11)){
            self.showAlert(message: "Invalid Bank Account", strtitle: "")
        }
        else {
            hitProfileSave()
        }
    }
    
}

extension EditProfileVC: CountryPickerViewDelegate,CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        countryCodeLbl.text = "\(country.phoneCode)"
//        let title = "Selected Country"
//        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
//        showAlert(title: title, message: message)
    }
}


//MARK: APi Work in View controller
extension EditProfileVC{
    
    func hitProfileSave() -> Void {
        var dataParam = [String:Any]()

        dataParam["first_name"] = self.firstNameTxt.text ?? ""
        dataParam["last_name"] = self.lastNameTxt.text ?? ""
        dataParam["phone"] = self.phoneNumberTxt.text ?? ""
        dataParam["username"] = self.usernameTxt.text ?? ""
        dataParam["birthday"] = self.dobTxt.text ?? ""
        dataParam["bank_account_number"] = self.bankAccountTxt.text ?? ""
        
        print(dataParam)
        AllUsersVM.shared.saveUserProfileDetailsApi(parameters: dataParam, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in
            
            print(obj)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

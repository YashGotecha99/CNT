//
//  AddKidsVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit

class AddKidsVC: BaseViewController {

    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var datePickerVw: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var addKidsTitleLbl: UILabel!
    @IBOutlet weak var staticFirstNameLbl: UILabel!
    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var staticLastNameLbl: UILabel!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var staticDateOfBirthLbl: UILabel!
    @IBOutlet weak var staticHaveChronicDiseaseLbl: UILabel!
    @IBOutlet weak var staticConfirmedExtra: UILabel!
    
    @IBOutlet weak var diseaseYesBtn: UIButton!
    @IBOutlet weak var diseaseNoBtn: UIButton!
    @IBOutlet weak var caretakeYesBtn: UIButton!
    @IBOutlet weak var caretakeNoBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var yesDiseaseLbl: UILabel!
    @IBOutlet weak var noDiseaseLbl: UILabel!
    @IBOutlet weak var yesCaretakeLbl: UILabel!
    @IBOutlet weak var noCaretakeLbl: UILabel!
    @IBOutlet weak var doneBtnObj: UIButton!
    
    var isDisease = false
    var isCaretake = false
    
    var kidsData : [Kids] = []
    
    var selectedDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
    }
    
    func setUpLocalization() {
        addKidsTitleLbl.text = LocalizationKey.addKid.localizing()
        staticFirstNameLbl.text = LocalizationKey.firstName.localizing()
        staticLastNameLbl.text = LocalizationKey.lastName.localizing()
        staticDateOfBirthLbl.text = LocalizationKey.dateOfBirth.localizing()
        staticHaveChronicDiseaseLbl.text = LocalizationKey.haveChronicDisease.localizing()
        staticConfirmedExtra.text = LocalizationKey.confirmedExtraCaretakeDays.localizing()
        yesDiseaseLbl.text = LocalizationKey.yes.localizing()
        noDiseaseLbl.text = LocalizationKey.no.localizing()
        yesCaretakeLbl.text = LocalizationKey.yes.localizing()
        noCaretakeLbl.text = LocalizationKey.no.localizing()
        firstNameTxt.placeholder = LocalizationKey.enterFirstName.localizing()
        lastNameTxt.placeholder = LocalizationKey.enterLastName.localizing()
        dateTxtField.placeholder = LocalizationKey.enterDateOfBirth.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        doneBtnObj.setTitle(LocalizationKey.done.localizing(), for: .normal)
    }
    
    func configUI(){
        datePickerVw.isHidden = true
    }
    
    func chooseDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(from: datePicker.date)
        let currentDate = getCurrentDateFromGMT()
        
        if datePicker.date < currentDate && ((selectedDate.calcAge(birthday: selectedDate, fromFormet: "yyyy-MM-dd")) < 18) {
            dateTxtField.text = selectedDate
            datePickerVw.isHidden = true
        } else {
            self.showAlert(message:LocalizationKey.ageShouldBeLessThen18OrInValidDate.localizing(), strtitle:"")
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if (firstNameTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterFirstName.localizing(), strtitle: "")
        }
        else if (lastNameTxt.text == "") {
            self.showAlert(message:LocalizationKey.enterLastName.localizing(), strtitle: "")
        }
        else if (dateTxtField.text == "") {
            self.showAlert(message: LocalizationKey.enterDateOfBirth.localizing(), strtitle: "")
        }else {
            kidsData.append(Kids( key: "0", name: "\(firstNameTxt.text ?? "") \(lastNameTxt.text ?? "")", date: selectedDate, chronicDisease: isDisease ? "yes" : "no", chronicPermission: isCaretake ? "yes" : "no"))
            hitProfileSave()
        }
    }
    @IBAction func chooseDatebtnAction(_ sender: Any){
        datePickerVw.isHidden = false
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        chooseDate()
    }
    
    @IBAction func diseaseYesBtnAction(_ sender: Any) {
        isDisease = true
        diseaseYesBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        diseaseNoBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    
    @IBAction func diseaseNoBtnAction(_ sender: Any) {
        isDisease = false
        diseaseYesBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        diseaseNoBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
    }
    
    @IBAction func caretakeYesBtnAction(_ sender: Any) {
        isCaretake = true
        caretakeYesBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        caretakeNoBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    
    @IBAction func caretakeNoBtnAction(_ sender: Any) {
        isCaretake = false
        caretakeYesBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        caretakeNoBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
    }
    
    func convertKidToDictionary(kid: Kids) -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["key"] = kid.key
        dictionary["name"] = kid.name
        dictionary["date"] = kid.date
        dictionary["chronic_disease"] = kid.chronic_disease
        dictionary["chronic_permission"] = kid.chronic_permission
        return dictionary
    }

}

//MARK: APi Work in View controller
extension AddKidsVC{
    
    func hitProfileSave() -> Void {
        var dataParam = [String:Any]()
        var kidParam = [String:Any]()
        
        kidParam["kids"] = kidsData.map(convertKidToDictionary)
        dataParam["data"] = kidParam
        print(dataParam)
        AllUsersVM.shared.saveUserProfileDetailsApi(parameters: dataParam, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in

            print(obj)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

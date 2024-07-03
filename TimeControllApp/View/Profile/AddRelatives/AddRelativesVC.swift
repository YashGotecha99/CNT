//
//  AddRelativesVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit
import CountryPickerView

class AddRelativesVC: BaseViewController {

    
    @IBOutlet weak var addRelativessTitleLbl: UILabel!
    @IBOutlet weak var staticFirstNameLbl: UILabel!
    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var staticLastNameLbl: UILabel!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var staticPhoneNumberLbl: UILabel!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var nominesData : [Nomines] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        addRelativessTitleLbl.text = LocalizationKey.addRelative.localizing()
        staticFirstNameLbl.text = LocalizationKey.firstName.localizing()
        staticLastNameLbl.text = LocalizationKey.lastName.localizing()
        staticPhoneNumberLbl.text = LocalizationKey.phoneNumber.localizing()
        firstNameTxt.placeholder = LocalizationKey.enterFirstName.localizing()
        lastNameTxt.placeholder = LocalizationKey.enterLastName.localizing()
        phoneNumberTxt.placeholder = LocalizationKey.enterPhoneNumber.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        if (firstNameTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterFirstName.localizing(), strtitle: "")
        }
        else if (lastNameTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterLastName.localizing(), strtitle: "")
        }
        else if (phoneNumberTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterPhoneNumber.localizing(), strtitle: "")
        }else {
            nominesData.append(Nomines(key: "0", name: "\(firstNameTxt.text ?? "") \(lastNameTxt.text ?? "")", contactNumber: phoneNumberTxt.text ?? ""))
            hitProfileSave()
        }
    }
    
    func convertKidToDictionary(nomines: Nomines) -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["key"] = nomines.key
        dictionary["name"] = nomines.name
        dictionary["contactNumber"] = nomines.contactNumber
        return dictionary
    }

}

//MARK: APi Work in View controller
extension AddRelativesVC{
    
    func hitProfileSave() -> Void {
        var dataParam = [String:Any]()
        var nominesParam = [String:Any]()
        
        nominesParam["nomines"] = nominesData.map(convertKidToDictionary)
        dataParam["data"] = nominesParam
        print(dataParam)
        AllUsersVM.shared.saveUserProfileDetailsApi(parameters: dataParam, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in

            print(obj)
            self.navigationController?.popViewController(animated: true)
        }
    }
}


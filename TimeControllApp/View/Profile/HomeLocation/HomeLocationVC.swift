//
//  HomeLocationVC.swift
//  TimeControllApp
//
//  Created by prashant on 24/05/23.
//

import UIKit

class HomeLocationVC: BaseViewController {

    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var postNumberTxt: UITextField!
    @IBOutlet weak var postPlaceTxt: UITextField!
    @IBOutlet weak var gpsLocationTxt: UITextField!
    @IBOutlet weak var homeLocationTitleLbl: UILabel!
    @IBOutlet weak var staticAddressLbl: UILabel!
    @IBOutlet weak var staticPostNumberLbl: UILabel!
    @IBOutlet weak var staticPostPlaceLbl: UILabel!
    @IBOutlet weak var staticGpsLocationLbl: UILabel!
    @IBOutlet weak var staticIncludeMileLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    
    let homeAddress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        getHomelocationSave()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        homeLocationTitleLbl.text = LocalizationKey.homeLocation.localizing()
        staticAddressLbl.text = LocalizationKey.address.localizing()
        staticPostNumberLbl.text = LocalizationKey.postNumber.localizing()
        staticPostPlaceLbl.text = LocalizationKey.postPlace.localizing()
        staticGpsLocationLbl.text = LocalizationKey.gPSLocation.localizing()
        staticIncludeMileLbl.text = LocalizationKey.includeMileAllowanceFromHomeAddress.localizing()
        addressTxt.placeholder = LocalizationKey.address.localizing()
        postNumberTxt.placeholder = LocalizationKey.postNumber.localizing()
        postPlaceTxt.placeholder = LocalizationKey.postPlace.localizing()
        gpsLocationTxt.placeholder = LocalizationKey.gPSLocation.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
    }
    
    @IBAction override func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if (addressTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterAddress.localizing(), strtitle: "")
        }
        else if (postNumberTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterThePostNumber.localizing(), strtitle: "")
        }
        else if (postPlaceTxt.text == "") {
            self.showAlert(message: LocalizationKey.enterThePostPlace.localizing(), strtitle: "")
        }else {
            hitHomelocationSave()
        }
    }
}

//MARK: UITextField Delegate

extension HomeLocationVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if addressTxt.text?.count ?? 0 > 3 && postNumberTxt.text?.count ?? 0 > 3 && postPlaceTxt.text != "" && postNumberTxt.text != "" && postPlaceTxt.text != "" {
            let address = (addressTxt.text ?? "") + "," + (postNumberTxt.text ?? "") + "," + (postPlaceTxt.text ?? "")
            getGPSLocationFromAddress(address: address)
        } else {
            gpsLocationTxt.text = ""
        }
        return true
    }
}

//MARK: APi Work in View controller
extension HomeLocationVC{
    
    func getHomelocationSave() -> Void {
        var dataParam = [String:Any]()
        print(dataParam)
        
        AllUsersVM.shared.getHomeLocationApi(parameters: dataParam, isAuthorization: true) { [self] obj in
            
            if obj.user?.address != nil {
                addressTxt.text = obj.user?.address
            }
            if obj.user?.post_number != nil {
                postNumberTxt.text = obj.user?.post_number
            }
            if obj.user?.post_place != nil {
                postPlaceTxt.text = obj.user?.post_place
            }
            if obj.user?.gps_data != nil {
                gpsLocationTxt.text = obj.user?.gps_data
            }
            
        }
    }
    
    func hitHomelocationSave() -> Void {
        var dataParam = [String:Any]()
        dataParam["address"] = addressTxt.text
        dataParam["post_number"] = postNumberTxt.text
        dataParam["post_place"] = postPlaceTxt.text
        dataParam["gps_data"] = gpsLocationTxt.text
        dataParam["home_payment_enabled"] = homeAddress

        print(dataParam)
        
        AllUsersVM.shared.saveHomeLocationApi(parameters: dataParam, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in

            print(obj)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getGPSLocationFromAddress(address : String) {
        var dataParam = [String:Any]()
        dataParam["address"] = address
        print(dataParam)
        
        
        AllUsersVM.shared.getGPSLocationAddress(parameters: dataParam, isAuthorization: true) { [self] obj in
            
            print(obj)
            gpsLocationTxt.text = obj.result
        }
    }
}


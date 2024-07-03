//
//  ViewController.swift
//  TimeControllApp
//
//  Created by Abhishek on 01/07/22.
//

import UIKit
import SVProgressHUD
import CoreLocation

class LoginVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var pleaseLoginLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var changeRegionBtnObj: UIButton!
    @IBOutlet weak var selectRegionVw: UIView!
    @IBOutlet weak var changeRegionTblVw: UITableView!
    
    var loginModel = LoginViewModel()
    var locationManager = CLLocationManager()
    var regionList : [ReligionData]?
    var selectedIndex = -1
    var previousSelectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLocalization()
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
       
        if let url = Bundle.main.url(forResource: "regionList", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                regionList = try decoder.decode([ReligionData].self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
        
        changeRegionTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SelectRegion.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SelectRegion.rawValue)
//        UserDefaults.standard.setValue("https://norsktimeregister.no/api/", forKey: UserDefaultKeys.serverChangeURL)
        UserDefaults.standard.setValue("https://tidogkontroll.no/api/", forKey: UserDefaultKeys.serverChangeURL)
        changeRegionTblVw.reloadData()
    }
    
    func setUpLocalization() {
        loginLbl.text = LocalizationKey.login.localizing()
        pleaseLoginLbl.text = LocalizationKey.pleaseLoginToContinue.localizing()
        emailLbl.text = LocalizationKey.emailUsername.localizing()
        emailTxtField.placeholder = LocalizationKey.enterYourEmail.localizing()
        passwordLbl.text = LocalizationKey.password.localizing()
        passwordTxtField.placeholder = LocalizationKey.enterYourPassword.localizing()
        forgotPasswordBtn.setTitle(LocalizationKey.forgotPasswords.localizing(), for: .normal)
        loginBtn.setTitle(LocalizationKey.login.localizing(), for: .normal)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    //MARK: Get the updated location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        counter = 0
        let location: CLLocation = locations.last!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        self.getAddressFromLatLong(latitude : location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func getAddressFromLatLong(latitude : Double, longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var countryCode : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks
            
            if pm?.count ?? 0 > 0 {
                let pm = placemarks?[0]
                
                if pm?.isoCountryCode != nil {
                    countryCode = pm?.isoCountryCode ?? ""
                }
                print("Country Code is : ", countryCode)
//                GlobleVariables.countryCodeFromLocation = countryCode
                GlobleVariables.dynamicBaseUrl = countryCode == "US" ? "https://timeandcontrol.com/api/" : "https://norsktimeregister.no/api/"
//                UserDefaults.standard.setValue(countryCode == "US" ? "https://timeandcontrol.com/api/" : "https://norsktimeregister.no/api/", forKey: UserDefaultKeys.serverChangeURL)
                UserDefaults.standard.setValue(countryCode == "US" ? "https://timeandcontrol.com/api/" : "https://tidogkontroll.no/api/", forKey: UserDefaultKeys.serverChangeURL)
                
                for i in 0..<(self.regionList?.count ?? 0) {
                    if self.regionList?[i].code == countryCode {
                        self.selectedIndex = i
                        self.previousSelectedIndex = i
                        self.changeRegionBtnObj.setTitle("\(LocalizationKey.location.localizing()) " + (self.regionList?[i].country ?? ""), for: .normal)
                        break
                    }
                }
                if self.selectedIndex == -1 {
                    self.selectedIndex = 0
                    self.previousSelectedIndex = 0
                    self.changeRegionBtnObj.setTitle("\(LocalizationKey.location.localizing()) " + (self.regionList?[self.selectedIndex].country ?? ""), for: .normal)
                }
                self.locationManager.stopUpdatingLocation()
                self.changeRegionTblVw.reloadData()
            }
        })
    }
    
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.push(viewController: vc)
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
//        fatalError()
        guard emailTxtField.text! != "" else{
            Toast.show(message: LocalizationKey.pleaseEnterEmail.localizing(), controller: self)
            return
        }
        
//        guard emailTxtField.text!.isValidEmail(emailTxtField.text!) == true else{
//            Toast.show(message: "Please enter valid email", controller: self)
//            return
//        }
        
        guard passwordTxtField.text! != "" else {
            Toast.show(message: LocalizationKey.pleaseEnterPassword.localizing(), controller: self)
            return
        }
        apiLoginUser()
    }
    
    @IBAction func changeRegionBtnAction(_ sender: Any) {
        selectRegionVw.isHidden = false
        changeRegionTblVw.reloadData()
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.selectedIndex = self.previousSelectedIndex
        selectRegionVw.isHidden = true
    }
    
    @IBAction func selectBtnAction(_ sender: Any) {
        selectRegionVw.isHidden = true
        self.previousSelectedIndex = selectedIndex
        changeRegionBtnObj.setTitle("\(LocalizationKey.location.localizing()) " + (regionList?[selectedIndex].country ?? ""), for: .normal)
        GlobleVariables.dynamicBaseUrl = self.regionList?[self.selectedIndex].code == "US" ? "https://timeandcontrol.com/api/" : "https://norsktimeregister.no/api/"
//        UserDefaults.standard.setValue(self.regionList?[self.selectedIndex].code == "US" ? "https://timeandcontrol.com/api/" : "https://norsktimeregister.no/api/", forKey: UserDefaultKeys.serverChangeURL)
        UserDefaults.standard.setValue(self.regionList?[self.selectedIndex].code == "US" ? "https://timeandcontrol.com/api/" : " https://tidogkontroll.no/api/", forKey: UserDefaultKeys.serverChangeURL)
    }
}

extension LoginVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension LoginVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regionList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SelectRegion.rawValue, for: indexPath) as? SelectRegion
        else { return UITableViewCell() }
                
        cell.regionNameLbl.text = regionList?[indexPath.row].country
//        cell.setCellValue(document: document)
        if selectedIndex == indexPath.row {
            cell.btnSelect.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        }
        else {
            cell.btnSelect.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        changeRegionTblVw.reloadData()
    }
}

//MARK: APi Work in View controller
extension LoginVC {
    
   private func apiLoginUser(){
       
       SVProgressHUD.show()
       loginModel.userLogin(email: emailTxtField.text ?? "", password: passwordTxtField.text ?? "") { (errorMsg,loginMessage, apiStatusCode) in
           SVProgressHUD.dismiss()
           if apiStatusCode == 403 {
               Toast.show(message: loginMessage, controller: self)
           } else {
               if errorMsg == true {
                   let scene = UIApplication.shared.connectedScenes.first
                   if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                       sd.userLoadConfig()
                   }
                   
                   let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "GPSInfoVC") as! GPSInfoVC
                   self.navigationController?.push(viewController: vc)
               } else {
                   Toast.show(message: loginMessage, controller: self)
                   //               displayToast(loginMessage)
               }
           }
       }
   }
}

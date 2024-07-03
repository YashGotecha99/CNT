//
//  ChangeLanguageVC.swift
//  TimeControllApp
//
//  Created by mukesh on 24/07/22.
//

import UIKit
import SVProgressHUD

class ChangeLanguageVC: BaseViewController {

    @IBOutlet weak var changeLanguageTitleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var changeLanguageTableVw: UITableView!
    
    private var changeLanguageModel = ChangeLanguageViewModel()
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        changeLanguageTableVw.reloadData()
        let lang = UserDefaults.standard.string(forKey: UserDefaultKeys.selectedLanguageCode) ?? "en"
        selectedIndex = changeLanguageModel.Languages.firstIndex(where: { $0.languageCode == lang }) ?? 0
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        changeLanguageTitleLbl.text = LocalizationKey.changeLanguage.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        callLanguageAPI(languageCode: changeLanguageModel.Languages[selectedIndex].languageCode, languageName: changeLanguageModel.Languages[selectedIndex].languageName)
    }
}

//MARK: - TableView DataSource and Delegate Methods

extension ChangeLanguageVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return changeLanguageModel.Languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = changeLanguageTableVw.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ChangeLanguageTVC.rawValue, for: indexPath) as? ChangeLanguageTVC
        else { return UITableViewCell() }
        cell.languageLbl.text = changeLanguageModel.Languages[indexPath.row].languageName
        if selectedIndex == indexPath.row {
            cell.selectedRadioImg.image = UIImage(named: "selectRadioIcon")
        } else {
            cell.selectedRadioImg.image = UIImage(named: "deselectRadioIcon")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //phangeLanguageModel.Languages[indexPath.row].selectedLanguage.filter { $0.contains(false) })
//        changeLanguageModel.Languages[indexPath.row].selectedLanguage = true
        selectedIndex = indexPath.row
        changeLanguageTableVw.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: APi Work in View controller
extension ChangeLanguageVC{
    
    func callLanguageAPI(languageCode: String, languageName: String) {
        SVProgressHUD.show()
        var param = [String:Any]()
        var setLanguageCode = ""
        if (languageName == "English") {
            setLanguageCode = "en"
        } else if (languageName == "Polish") {
            setLanguageCode = "pl"
        } else if (languageName == "Lithuanian") {
            setLanguageCode = "lt"
        } else if (languageName == "Greek") {
            setLanguageCode = "el"
        } else if (languageName == "Norwegian") {
            setLanguageCode = "no"
        } else if (languageName == "Russian") {
            setLanguageCode = "ru"
        } else if (languageName == "Spanish") {
            setLanguageCode = "es"
        } else {
            setLanguageCode = "se"
        }
        
        param["lang"] = setLanguageCode
        
        print("Language param is : ", param)
        
        ScheduleListVM.shared.setLanguageAPI(parameters: param, isAuthorization: true) { [self] obj in
            print("Language data is : ", obj)
            UserDefaults.standard.setValue(changeLanguageModel.Languages[selectedIndex].languageCode, forKey: UserDefaultKeys.selectedLanguageCode)
            
            guard let rootVC = STORYBOARD.MAIN.instantiateViewController(identifier: "TabbarVC") as? TabbarVC else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            self.view.window?.rootViewController = rootNC
        }
    }
}

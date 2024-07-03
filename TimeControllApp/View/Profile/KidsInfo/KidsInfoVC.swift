//
//  KidsInfoVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit

class KidsInfoVC: BaseViewController {

    @IBOutlet weak var kidstblVw: UITableView!
    @IBOutlet weak var kidsTitleLbl: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var ifYouWantToLbl: UILabel!
    
    var kidsData : [Kids] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hitGetUsersDetailsApi(id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
    }
    
    func setUpLocalization() {
        kidsTitleLbl.text = LocalizationKey.kidsInfo.localizing()
        ifYouWantToLbl.text = LocalizationKey.ifYouWantToAddTheKidsPleaseClickOnTheAboveAddButtonToAddThem.localizing()
    }
    func configUI() {
        noDataView.isHidden = true
       
        kidstblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.KidsTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.KidsTVC.rawValue)
        
    }
    
    @IBAction func addKidsInfoBtnAction(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AddKidsVC") as! AddKidsVC
        vc.kidsData = self.kidsData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension KidsInfoVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kidsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.KidsTVC.rawValue, for: indexPath) as? KidsTVC
        else { return UITableViewCell() }
        cell.setValueForCell(kid: kidsData[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func convertKidToDictionary(kid: Kids) -> [String: Any] {
        var dictionary = [String: Any]()
//        dictionary["key"] = kid.key
        dictionary["name"] = kid.name
        dictionary["date"] = kid.date
        dictionary["chronic_disease"] = kid.chronic_disease
        dictionary["chronic_permission"] = kid.chronic_permission
        return dictionary
    }
    
}
extension KidsInfoVC:KidsTVCTVCProtocol{
    func removeChild(index: Int) {
        let alert = UIAlertController(title: "", message: LocalizationKey.areYouSureYouWantTo.localizing(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            self.hitProfileSave(index: index)
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: APi Work in View controller
extension KidsInfoVC{
    
    func hitProfileSave(index:Int) -> Void {
        var removedKidData = kidsData
        removedKidData.remove(at: index)
        var dataParam = [String:Any]()
        var kidParam = [String:Any]()
        
        kidParam["kids"] = removedKidData.map(convertKidToDictionary)
        dataParam["data"] = kidParam
        print(dataParam)
        AllUsersVM.shared.saveUserProfileDetailsApi(parameters: dataParam, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in

            kidsData = removedKidData
            
            if kidsData.count < 1 {
                noDataView.isHidden = false
            } else {
                noDataView.isHidden = true
            }
            kidstblVw.reloadData()
        }
    }
    
    func hitGetUsersDetailsApi(id: String) -> Void {
        var param = [String:Any]()
        AllUsersVM.shared.getUsersDetailsApi(parameters: param, id: id, isAuthorization: true) { [self] obj,responseData  in
            kidsData = obj.user?.data?.kids ?? []
            if kidsData.count < 1 {
                noDataView.isHidden = false
            } else {
                noDataView.isHidden = true
            }
            kidstblVw.reloadData()
        }
    }
}

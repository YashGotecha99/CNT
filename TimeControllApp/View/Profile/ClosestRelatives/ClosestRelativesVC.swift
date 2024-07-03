//
//  ClosestRelativesVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit

class ClosestRelativesVC: BaseViewController {
    
    @IBOutlet weak var closestRelativestblVw: UITableView!
    @IBOutlet weak var closestRelativesTitleLbl: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var ifYouWantToLbl: UILabel!
    
    var nominesData : [Nomines] = []

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
        closestRelativesTitleLbl.text = LocalizationKey.closestRelative.localizing()
        ifYouWantToLbl.text = LocalizationKey.ifYouWantToAddTheClosestRelativePleaseClickOnTheAboveAddButtonToAddThem.localizing()
    }
    
    func configUI() {
        noDataView.isHidden = true
        
        closestRelativestblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.KidsTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.KidsTVC.rawValue)
        
    }
    

    @IBAction func closestRelativeBtnAction(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AddRelativesVC") as! AddRelativesVC
        vc.nominesData = nominesData
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension ClosestRelativesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nominesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.KidsTVC.rawValue, for: indexPath) as? KidsTVC
        else { return UITableViewCell() }
        cell.setValueForCell(nomines: nominesData[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func convertKidToDictionary(nomines: Nomines) -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["name"] = nomines.name
        dictionary["contactNumber"] = nomines.contactNumber
        return dictionary
    }
    
}

extension ClosestRelativesVC:KidsTVCTVCProtocol{
    func removeChild(index: Int) {
        let alert = UIAlertController(title: "", message: LocalizationKey.areYouSureYouWantToDeleteRelative.localizing(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            self.hitProfileSave(index: index)
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: APi Work in View controller
extension ClosestRelativesVC{
    
    func hitProfileSave(index:Int) -> Void {
        var removedNominesData = nominesData
        removedNominesData.remove(at: index)
        var dataParam = [String:Any]()
        var nominesParam = [String:Any]()
        
        nominesParam["nomines"] = removedNominesData.map(convertKidToDictionary)
        dataParam["data"] = nominesParam
        AllUsersVM.shared.saveUserProfileDetailsApi(parameters: dataParam, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in
            print(obj)
            nominesData = removedNominesData
            if nominesData.count < 1 {
                noDataView.isHidden = false
            } else {
                noDataView.isHidden = true
            }
            closestRelativestblVw.reloadData()
        }
    }
    
    func hitGetUsersDetailsApi(id: String) -> Void {
        var param = [String:Any]()
        AllUsersVM.shared.getUsersDetailsApi(parameters: param, id: id, isAuthorization: true) { [self] obj,responseData  in
            nominesData = obj.user?.data?.nomines ?? []
            if nominesData.count < 1 {
                noDataView.isHidden = false
            } else {
                noDataView.isHidden = true
            }
            closestRelativestblVw.reloadData()
        }
    }
}

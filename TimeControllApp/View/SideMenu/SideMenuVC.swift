//
//  SideMenuVC.swift
//  TimeControllApp
//
//  Created by mukesh on 12/07/22.
//

import UIKit

class SideMenuVC: UIViewController {

    @IBOutlet weak var sideMenutblVw: UITableView!
    
    @IBOutlet weak var allRightLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    
    private var sideMenuModel = SideMenuViewModel()
    private var sideMenuMemberModel = SideMenuModel()

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fullNameLbl.text = UserDefaults.standard.string(forKey: UserDefaultKeys.userFullname)
        userNameLbl.text = UserDefaults.standard.string(forKey: UserDefaultKeys.userName)
        userImg.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.userImageId) ?? ""), placeholderImage: UIImage(named: "userImage"), options: .highPriority, completed: nil)
        userImg.contentMode = .scaleAspectFill
        
        let versionName = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

        versionLbl.text = LocalizationKey.version1.localizing() + " \(versionName ?? "")" + "(\(buildNumber ?? ""))"
    }
    
    func configUI() {
        sideMenutblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SideMenuTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SideMenuTVC.rawValue)
        
        sideMenutblVw.reloadData()
    }

}

//MARK: - TableView DataSource and Delegate Methods
extension SideMenuVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            return sideMenuModel.name.count
        } else {
            return sideMenuMemberModel.name.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SideMenuTVC.rawValue, for: indexPath) as? SideMenuTVC
        else { return UITableViewCell() }
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            cell.titleImg.image = UIImage(named: sideMenuModel.images[indexPath.row])
            cell.titleNameLbl.text = sideMenuModel.name[indexPath.row]
        } else {
            cell.titleImg.image = UIImage(named: sideMenuMemberModel.images[indexPath.row])
            cell.titleNameLbl.text = sideMenuMemberModel.name[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SideMenuTVC.rawValue, for: indexPath) as? SideMenuTVC
        cell?.delegate = self
        cell?.selectedIndexPath(indexPath: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//
//  ProfileVC.swift
//  TimeControllApp
//
//  Created by mukesh on 02/07/22.
//

import UIKit

class ProfileVC: BaseViewController {

    @IBOutlet weak var profiletblVw: UITableView!
    @IBOutlet weak var profileTitleLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var notificationCountView: UIView!
    @IBOutlet weak var notificationCountLbl: UILabel!
    
    var userData : UserDetails?

    private var profileMenuModel = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpLocalization()
        profileMenuModel.name = [LocalizationKey.personalInfo.localizing(),LocalizationKey.kidsInfo.localizing(),LocalizationKey.closestRelative.localizing(),LocalizationKey.homeLocation.localizing(),LocalizationKey.settings.localizing()]
        profiletblVw.reloadData()
        hitGetUsersDetailsApi(id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
    }
    
    func configUI() {
        
        self.notificationCountLbl.text = GlobleVariables.notificationCount > 99 ? "99+" : "\(GlobleVariables.notificationCount)"
        notificationCountView.setNeedsLayout()
        notificationCountView.layer.cornerRadius = notificationCountView.frame.height/2
        notificationCountView.layer.masksToBounds = true
        if GlobleVariables.notificationCount > 0 {
            notificationCountView.isHidden = false
        }else {
            notificationCountView.isHidden = true
        }
        
        profiletblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ProfileTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ProfileTVC.rawValue)
        profiletblVw.reloadData()
    }
    
    func setUpLocalization() {
        profileTitleLbl.text = LocalizationKey.profile.localizing()
    }
    
    @IBAction func btnNotificationAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnUploadPhotoAction(_ sender: Any) {
        ImagePickerManager().pickImage(self){ [self] image,path  in
            print(path)
            let imageData:NSData = image.jpegData(compressionQuality: 0.1)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            AllUsersVM.shared.saveUserAttachment(imageId: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", imageData: strBase64, fileName: path, type: "jpeg") { (errorMsg,loginMessage,attachIds)  in
                self.imageSaveAPI(id: String(attachIds))
                self.profileImg.image = image
                let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
                UserDefaults.standard.setValue(strUrl + "/\(attachIds)", forKey: UserDefaultKeys.userImageId)
            }
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileMenuModel.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ProfileTVC.rawValue, for: indexPath) as? ProfileTVC
        else { return UITableViewCell() }
        cell.titleImg.image = UIImage(named: profileMenuModel.images[indexPath.row])
        cell.titleNameLbl.text = profileMenuModel.name[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ProfileTVC.rawValue, for: indexPath) as? ProfileTVC
        cell?.delegate = self
        cell?.selectedIndexPath(indexPath: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: APi Work in View controller
extension ProfileVC{
    
    func hitGetUsersDetailsApi(id: String) -> Void {
        let param = [String:Any]()
        AllUsersVM.shared.getUsersDetailsApi(parameters: param, id: id, isAuthorization: true) { [self] obj,responseData  in
            userData = obj.user
            print("userData is : ", userData)
            nameLbl.text = (userData?.first_name ?? "") + " " + (userData?.last_name ?? "")
            let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
            let url = URL(string: strUrl + "/\(userData?.image ?? "")")
            print("Profile URL ",url)
            profileImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            profileImg.contentMode = .scaleAspectFill
//            profileImg.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.userImageId) ?? ""), placeholderImage: UIImage(named: "userImage"), options: .highPriority, completed: nil)
            userNameLbl.text = userData?.username ?? ""
        }
    }
    
    func imageSaveAPI(id: String) -> Void {
        var dataParam = [String:Any]()
        dataParam["image"] = id

        print(dataParam)
        
        AllUsersVM.shared.saveHomeLocationApi(parameters: dataParam, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj in
//            hitGetUsersDetailsApi(id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
            print(obj)
        }
    }
}


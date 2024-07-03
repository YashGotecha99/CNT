//
//  UserProfileVC.swift
//  TimeControllApp
//
//  Created by prashant on 02/02/23.
//

import UIKit

class UserProfileVC: BaseViewController {

    @IBOutlet weak var usersTitleLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var personalFullnameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var personalInformationLbl: UILabel!
    @IBOutlet weak var staticNameLbl: UILabel!
    @IBOutlet weak var staticEmailLbl: UILabel!
    @IBOutlet weak var staticAboutLbl: UILabel!
    @IBOutlet weak var fullProfileBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        usersTitleLbl.text = LocalizationKey.users.localizing()
        personalInformationLbl.text = LocalizationKey.personalInformation.localizing()
        staticNameLbl.text = LocalizationKey.name.localizing()
        emailLbl.text = LocalizationKey.email.localizing()
        aboutLbl.text = LocalizationKey.about.localizing()
        fullProfileBtn.setTitle(LocalizationKey.fullProfile.localizing(), for: .normal)
    }
    
    @IBAction func fullProfileBtnAction(_ sender: Any) {
        print("Full profile btn action")
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "UserProfileDetailsVC") as! UserProfileDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

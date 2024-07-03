//
//  ProfileTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 07/07/22.
//

import UIKit

class ProfileTVC: UITableViewCell {

    @IBOutlet weak var titleNameLbl: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    var delegate = ProfileVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func selectedIndexPath(indexPath:Int){
        if indexPath == 0 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "PersonalInfoVC") as! PersonalInfoVC
            delegate.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath == 1 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "KidsInfoVC") as! KidsInfoVC
            delegate.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath == 2 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ClosestRelativesVC") as! ClosestRelativesVC
            delegate.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath == 3 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "HomeLocationVC") as! HomeLocationVC
            delegate.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath == 4 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            delegate.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

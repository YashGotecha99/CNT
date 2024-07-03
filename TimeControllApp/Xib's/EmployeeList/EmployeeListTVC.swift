//
//  EmployeeListTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit

class EmployeeListTVC: UITableViewCell {

    @IBOutlet weak var selectedEmplyeeRadioBtn: UIButton!
    @IBOutlet weak var userNumberLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userStatusLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNumberImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(rowsData: UserList) -> Void {
        userNameLbl.text = (rowsData.first_name ?? "") + " " + (rowsData.last_name ?? "")
        userNumberLbl.text = rowsData.phone ?? ""
        userEmailLbl.text = rowsData.email ?? ""
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(rowsData.image ?? "")")
        userImage.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        userImage.contentMode = .scaleAspectFill

    }
    func setData(rowsData: UserListByProjectModel) -> Void {
        userNameLbl.text = (rowsData.fullname ?? "")

    }
}

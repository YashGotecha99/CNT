//
//  EmployeeListShiftTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit

class EmployeeListShiftTVC: UITableViewCell {

    @IBOutlet weak var selectedEmplyeeRadioBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLeading: NSLayoutConstraint!
    
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
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(rowsData.image ?? "")")
        userImage.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        userImage.contentMode = .scaleAspectFill

    }
    func setData(rowsData: UserListByProjectModel) -> Void {
        userNameLbl.text = (rowsData.fullname ?? "")

    }
    func setData(rowsData: Rooms) -> Void {
        userNameLbl.text = (rowsData.name ?? "")

    }
    
    func setData(room: Rooms) -> Void {
        userNameLbl.text = (room.fullname ?? "")

    }
    
    func setSwapData(availableUser: Availableusers) -> Void {
        userNameLbl.text = (availableUser.username ?? "")

    }
}

//
//  StartWorkTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 03/07/22.
//

import UIKit
import SDWebImage
class StartWorkTVC: UITableViewCell {

    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var startWorkBtn: UIButton!
    @IBOutlet weak var startWorkVw: UIView!
    @IBOutlet weak var workingHoursVw: UIView!
    @IBOutlet weak var runningTimerLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var pauseLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var pauseResumeImg: UIImageView!
    
    @IBOutlet weak var scheduleStartWorkBtn: UIButton!
    @IBOutlet weak var scheduleStartWorkVw: UIView!
    @IBOutlet weak var scheduleTaskName: UILabel!
    @IBOutlet weak var scheduleTime: UILabel!
    
    var currentTimelogData : CurrentTimelog?
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var noWorkRightNowLbl: UILabel!
    @IBOutlet weak var staticScheduleStartWorkLbl: UILabel!
    
    public var delegate = HomeVC()
    
    @IBOutlet weak var workToBeDoneNowLbl: UILabel!
    @IBOutlet weak var staticScheduleLbl: UILabel!
    @IBOutlet weak var staticStartWorkLbl: UILabel!
    @IBOutlet weak var viewDetailsLbl: UILabel!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var finishLbl: UILabel!
    @IBOutlet weak var clientNameLbl: UILabel!
    @IBOutlet weak var pauseVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        todayDate.text = dateFormatter.string(from: Date())
        workingHoursVw.isHidden = true
        scheduleStartWorkVw.isHidden = true
        userName.text = UserDefaults.standard.string(forKey: UserDefaultKeys.userFullname) ?? ""
//        userImage.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.userImageId) ?? ""), placeholderImage: UIImage(named: "userImage"), options: .highPriority, completed: nil)
//        userImage.contentMode = .scaleAspectFill
//        logoImg.sd_setImage(with: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.clientImage) ?? ""), placeholderImage: UIImage(named: "appLogo"), options: .highPriority, completed: nil)
        
//        print("GlobleVariables.clientControlPanelConfiguration is : ", GlobleVariables.clientControlPanelConfiguration)
//
//        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
//        let url = URL(string: strUrl + "/\(GlobleVariables.clientControlPanelConfiguration?.image ?? "")")
//        logoImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
//
//        clientNameLbl.text = GlobleVariables.clientControlPanelConfiguration?.name
//        viewDetailsLbl.text = LocalizationKey.viewDetails.localizing()
//        totalTimeLbl.text = LocalizationKey.totalTime.localizing()
//        finishLbl.text = LocalizationKey.finish.localizing()
//        pauseLbl.text = LocalizationKey.pause.localizing()
//        workToBeDoneNowLbl.text = LocalizationKey.workToBeDoneNow.localizing()
//        staticScheduleLbl.text = LocalizationKey.schedule.localizing()
//        staticStartWorkLbl.text = LocalizationKey.startwork.localizing()
//        noWorkRightNowLbl.text = LocalizationKey.noWorkRightNow.localizing()
//        staticScheduleStartWorkLbl.text = LocalizationKey.startwork.localizing()

        // Initialization code
//        let param = [String:Any]()
//        AllUsersVM.shared.getUsersDetailsApi(parameters: param, id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0", isAuthorization: true) { [self] obj,responseData  in
//            let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
//            let url = URL(string: strUrl + "/\(obj.user?.image ?? "")")
//            userImage.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
//        }
    }

    
    func setupLocalizationData() {
        viewDetailsLbl.text = LocalizationKey.viewDetails.localizing()
        totalTimeLbl.text = LocalizationKey.totalTime.localizing()
        finishLbl.text = LocalizationKey.finish.localizing()
        pauseLbl.text = LocalizationKey.pause.localizing()
        workToBeDoneNowLbl.text = LocalizationKey.workToBeDoneNow.localizing()
        staticScheduleLbl.text = LocalizationKey.schedule.localizing()
        staticStartWorkLbl.text = LocalizationKey.startwork.localizing()
        noWorkRightNowLbl.text = LocalizationKey.noWorkRightNow.localizing()
        staticScheduleStartWorkLbl.text = LocalizationKey.startwork.localizing()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    @IBAction func startWorkBtnAction(_ sender: Any) {
//        workingHoursVw.isHidden = false
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectTasksVC") as! SelectTasksVC
        vc.isComingFrom = "StartHours"
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func scheduleStartWorkBtn(_ sender: Any) {
//        workingHoursVw.isHidden = false
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectTasksVC") as! SelectTasksVC
        vc.isComingFrom = "StartHours"
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func finishBtnAction(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FinishWorkVC") as! FinishWorkVC
        vc.currentTimelogData = currentTimelogData
        vc.isFrom = "home"
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func viewDetailsBtnAction(_ sender: Any) {
        let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "AddWorkDocumentVC") as! AddWorkDocumentVC
        vc.comingFrom = "workHourDetail"
        vc.id = "\(currentTimelogData?.id ?? 0)"
        vc.taskId = "\(currentTimelogData?.task_id ?? 0)"
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
}

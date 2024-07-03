//
//  SwapTradesPMTVC.swift
//  TimeControllApp
//
//  Created by yash on 16/01/23.
//

import UIKit

protocol SwapTradesPMTVCDelegate: class {
    func onAcceptBtn(requestShift:RequestShift?)
    func onRejectBtn(requestShift:RequestShift?)
    func onOvertimeBtn(requestShift: RequestShift?)
}

class SwapTradesPMTVC: UITableViewCell {
    
    @IBOutlet weak var SwapView: UIView!
    @IBOutlet weak var swapLbl: UILabel!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var acceptBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var fromNameLbl: UILabel!
    @IBOutlet weak var fromProfileImg: UIImageView!
    @IBOutlet weak var toProfileImg: UIImageView!
    @IBOutlet weak var toNameLbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var toRoleLbl: UILabel!
    @IBOutlet weak var swapOtherView: UIView!
    @IBOutlet weak var staticShiftTimingLbl: UILabel!
    @IBOutlet weak var staticRoleDepartmentLbl: UILabel!
    @IBOutlet weak var btnOvertime: UIButton!
    @IBOutlet weak var taskNameNumberLbl: UILabel!
    
    weak var delegate : SwapTradesPMTVCDelegate?
    
    var selectedRequestShift : RequestShift?
    @IBOutlet weak var swapTradesImg: UIImageView!
    @IBOutlet weak var btnInfoObj: UIButton!
    @IBOutlet weak var btnOvertimeImg: UIButton!
    
    var swapTradesVCDelegate = SwapTradesPMVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        staticShiftTimingLbl.text = LocalizationKey.shiftTiming.localizing()
        staticRoleDepartmentLbl.text = LocalizationKey.shiftTiming.localizing()
//        staticRoleDepartmentLbl.text = LocalizationKey.roleDepartment.localizing()

        SwapView.clipsToBounds = true
        SwapView.layer.cornerRadius = 15
        SwapView.layer.maskedCorners = [.layerMaxXMinYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
        delegate?.onAcceptBtn(requestShift: selectedRequestShift)
    }
    
    @IBAction func rejectBtnAction(_ sender: Any) {
        delegate?.onRejectBtn(requestShift: selectedRequestShift)
    }
    
    
    @IBAction func btnClickedOvertime(_ sender: Any) {
        delegate?.onOvertimeBtn(requestShift: selectedRequestShift)
    }
    
    func setCellValue(requestShift:RequestShift,selectedSegmentIndex:Int){
        selectedRequestShift = requestShift
        if requestShift.isOvertime ?? false {
            btnOvertime.isHidden = false
            btnInfoObj.isHidden = false
            btnOvertimeImg.isHidden = false
        } else {
            btnOvertime.isHidden = true
            btnInfoObj.isHidden = true
            btnOvertimeImg.isHidden = true
        }
        
        fromNameLbl.text = requestShift.from_user
        toNameLbl.text = requestShift.accepted_username
        taskNameNumberLbl.text = "\(requestShift.task_number ?? 0)" + " | " + (requestShift.task_name ?? "")
        dateLbl.text = requestShift.shift_date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        toRoleLbl.text = "\(swapTradesVCDelegate.logTime(time: requestShift.accepted_user_start_time ?? 0)) - \(swapTradesVCDelegate.logTime(time: requestShift.accepted_user_end_time ?? 0))"
        timelbl.text = "\(swapTradesVCDelegate.logTime(time: requestShift.start_time ?? 0)) - \(swapTradesVCDelegate.logTime(time: requestShift.end_time ?? 0))"
        
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let urlFrom = URL(string: strUrl + "/\(requestShift.from_user_image ?? "")")
        fromProfileImg.sd_setImage(with: urlFrom , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        fromProfileImg.contentMode = .scaleAspectFill
        let urlTo = URL(string: strUrl + "/\(requestShift.accepted_user_image ?? "")")
        toProfileImg.sd_setImage(with: urlTo , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        toProfileImg.contentMode = .scaleAspectFill
        if selectedSegmentIndex == 0 {
            acceptBtn.isUserInteractionEnabled = true
            rejectBtn.isHidden = false
            
            acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            acceptBtn.setTitle(LocalizationKey.accept.localizing(), for: .normal)
            acceptBtnWidth.constant = 85
        } else {
            acceptBtn.isUserInteractionEnabled = false
            rejectBtn.isHidden = true
            
            if requestShift.is_approved ?? true {
                acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
                acceptBtn.setTitle(LocalizationKey.approved.localizing(), for: .normal)
                acceptBtnWidth.constant = 85
            }else if requestShift.is_rejected ?? true {
                acceptBtn.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
                acceptBtn.setTitle(LocalizationKey.rejected.localizing(), for: .normal)
                acceptBtnWidth.constant = 85
            }
        }
        if requestShift.swap_type == "trade-shift" {
            swapLbl.text = LocalizationKey.swapes.localizing()
//            SwapView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            SwapView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            toNameLbl.isHidden = false
            toProfileImg.isHidden = false
            swapOtherView.isHidden = false
            toRoleLbl.isHidden = false
            staticRoleDepartmentLbl.isHidden = false
            swapTradesImg.image = UIImage(named: "SwapTrades")
        } else if requestShift.swap_type == "grab-shift" {
            swapLbl.text = LocalizationKey.grabShift.localizing()
            SwapView.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.6352941176, blue: 0.6470588235, alpha: 1)
            toNameLbl.isHidden = true
            toProfileImg.isHidden = true
            fromNameLbl.text = requestShift.accepted_username
            swapOtherView.isHidden = true
            let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
            let urlFrom = URL(string: strUrl + "/\(requestShift.accepted_user_image ?? "")")
            fromProfileImg.sd_setImage(with: urlFrom , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
            fromProfileImg.contentMode = .scaleAspectFill
            toRoleLbl.isHidden = true
            staticRoleDepartmentLbl.isHidden = true
            swapTradesImg.image = UIImage(named: "SwapTrades")
        } else if requestShift.swap_type == "swap-shift" {
            swapLbl.text = LocalizationKey.trades.localizing()
            SwapView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            toNameLbl.isHidden = false
            toProfileImg.isHidden = false
            swapOtherView.isHidden = false
            toRoleLbl.isHidden = false
            staticRoleDepartmentLbl.isHidden = false
            swapTradesImg.image = UIImage(named: "oneway")
            
            
//            toNameLbl.isHidden = false
//            toProfileImg.isHidden = false
////            fromNameLbl.text = requestShift.accepted_username
//            swapOtherView.isHidden = true
////            let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
////            let urlFrom = URL(string: strUrl + "/\(requestShift.accepted_user_image ?? "")")
////            fromProfileImg.sd_setImage(with: urlFrom , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
//            toRoleLbl.isHidden = true
//            staticRoleDepartmentLbl.isHidden = false
//            swapTradesImg.image = UIImage(named: "oneway")
        }
        else {
            swapLbl.text = LocalizationKey.sickLeave.localizing()
            SwapView.backgroundColor = #colorLiteral(red: 1, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
            toNameLbl.isHidden = false
            toProfileImg.isHidden = false
            swapOtherView.isHidden = false
            toRoleLbl.isHidden = false
            staticRoleDepartmentLbl.isHidden = false
            swapTradesImg.image = UIImage(named: "SwapTrades")
        }
    }
    
}

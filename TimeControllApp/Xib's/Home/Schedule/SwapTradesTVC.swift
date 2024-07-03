//
//  SwapTradesTVC.swift
//  TimeControllApp
//
//  Created by yash on 11/01/23.
//

import UIKit

protocol SwapTradesTVCDelegate: class {
    func onAcceptBtn(requestShift:RequestShift?)
    func onRejectBtn(requestShift:RequestShift?)
}

class SwapTradesTVC: UITableViewCell {

    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var acceptBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    weak var delegate : SwapTradesTVCDelegate?
    
    var selectedRequestShift : RequestShift?
    
    var swapTradesVCDelegate = SwapTradesVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValue(requestShift:RequestShift,selectedSegmentIndex:Int){
        selectedRequestShift = requestShift
        nameLbl.text = requestShift.from_user
        roleLbl.text = requestShift.from_user_role == "z_none" ? LocalizationKey.others.localizing() : requestShift.from_user_role
        timeLbl.text = "\(requestShift.shift_date?.convertAllFormater(formated: "E") ?? ""), " + "\(swapTradesVCDelegate.logTime(time: requestShift.start_time ?? 0)) - \(swapTradesVCDelegate.logTime(time: requestShift.end_time ?? 0))"
        
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let urlTo = URL(string: strUrl + "/\(requestShift.from_user_image ?? "")")
        photoImg.sd_setImage(with: urlTo , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        photoImg.contentMode = .scaleAspectFill
        if selectedSegmentIndex == 0 {
            acceptBtn.isUserInteractionEnabled = true
            rejectBtn.isHidden = false
        } else {
            acceptBtn.isUserInteractionEnabled = false
            rejectBtn.isHidden = true
        }
        
        if requestShift.is_accepted ?? false && requestShift.is_approved ?? false {
            acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            acceptBtn.setTitle(LocalizationKey.swapped.localizing(), for: .normal)
            acceptBtnWidth.constant = 85
        }else if requestShift.is_accepted ?? false {
            acceptBtn.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            acceptBtn.setTitle(LocalizationKey.awaitingPM.localizing(), for: .normal)
            acceptBtnWidth.constant = 110
        }else if requestShift.is_rejected ?? false || requestShift.is_declined ?? false {
            acceptBtn.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            acceptBtn.setTitle(LocalizationKey.cancelled.localizing(), for: .normal)
            acceptBtnWidth.constant = 85
            acceptBtn.isUserInteractionEnabled = false
            rejectBtn.isHidden = true
        } else {
            acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            acceptBtn.setTitle(LocalizationKey.accept.localizing(), for: .normal)
            acceptBtnWidth.constant = 85
        }
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
        delegate?.onAcceptBtn(requestShift: selectedRequestShift)
    }
    
    @IBAction func rejectBtnAction(_ sender: Any) {
        delegate?.onRejectBtn(requestShift:selectedRequestShift)
    }
}

//
//  AvailabilityDayTVC.swift
//  TimeControllApp
//
//  Created by yash on 20/01/23.
//

import UIKit

protocol AvailabilityDayTVCDelegate: class {
    func onBtnAllDay(indexPath: IndexPath, isAllDay : Bool)
    func onFromTimeClicked(indexPathFromTime: IndexPath, selectedTextFrom : String)
    func onToTimeClicked(indexPathToTime: IndexPath, selectedTextTo : String)
    func onSelectedCommentText(commentIndexPath: IndexPath, comment : String)
    func onAvailable(availableIndexPath: IndexPath, availableData : String)
}

class AvailabilityDayTVC: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var btnAllDay: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAvailable: UIButton!
    @IBOutlet weak var btnNotAvailable: UIButton!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var commentTVw: UITextView!
    
    @IBOutlet weak var btnFromDate: UIButton!
    @IBOutlet weak var btnToDate: UIButton!
    
    weak var delegate : AvailabilityDayTVCDelegate?
    var selectedIndexPath : IndexPath?
    var isAllDay = true
    var isAvailability = true

    //MARK: Localizations

    @IBOutlet weak var staticStatusLbl: UILabel!
    @IBOutlet weak var staticCommentLbl: UILabel!
    @IBOutlet weak var staticAvailableLbl: UILabel!
    @IBOutlet weak var staticNotAvailableLbl: UILabel!
    @IBOutlet weak var staticAllDayLbl: UILabel!
    @IBOutlet weak var staticSelectAvailabilityLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        staticStatusLbl.text = LocalizationKey.status.localizing()
        staticCommentLbl.text = LocalizationKey.comment.localizing()
        staticAvailableLbl.text = LocalizationKey.available.localizing()
        staticNotAvailableLbl.text = LocalizationKey.notAvailable.localizing()
        staticAllDayLbl.text = LocalizationKey.allDay.localizing()
        staticSelectAvailabilityLbl.text = LocalizationKey.selectAvailability.localizing()
        txtFromDate.placeholder = LocalizationKey.from.localizing()
        txtToDate.placeholder = LocalizationKey.to.localizing()
        
        commentTVw.delegate = self
        setTimeViewUI()
    }
    
    func setTimeViewUI(){
        if isAllDay {
            timeViewHeight.constant = 0
            mainViewHeight.constant = 256
            timeView.isHidden = true
        } else {
            timeViewHeight.constant = 75
            mainViewHeight.constant = 331
            timeView.isHidden = false
        }
    }

    @IBAction func btnClickedAvailable(_ sender: Any) {
        isAvailability = true
        btnAvailable.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnNotAvailable.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        delegate?.onAvailable(availableIndexPath: selectedIndexPath ?? IndexPath(), availableData: "available")
    }
    
    @IBAction func btnClickedNotAvailable(_ sender: Any) {
        isAvailability = false
        btnNotAvailable.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnAvailable.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        delegate?.onAvailable(availableIndexPath: selectedIndexPath ?? IndexPath(), availableData: "not available")
    }
    
    @IBAction func btnClickedFromTime(_ sender: Any) {
        delegate?.onFromTimeClicked(indexPathFromTime: selectedIndexPath ?? IndexPath(), selectedTextFrom: "fromTime")
    }
    
    @IBAction func btnClickedToTime(_ sender: Any) {
        delegate?.onToTimeClicked(indexPathToTime: selectedIndexPath ?? IndexPath(), selectedTextTo: "toTime")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnAllDay(_ sender: Any) {
        if isAllDay {
            isAllDay = false
            btnAllDay.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
        } else {
            isAllDay = true
            btnAllDay.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
        setTimeViewUI()
        delegate?.onBtnAllDay(indexPath: selectedIndexPath ?? IndexPath(), isAllDay: isAllDay)
    }
    
    func setWeekendData (availabilityData: AvailabilityData, selectedFromTime: Int ) {
    
        if (availabilityData.from != nil || availabilityData.to != nil) {
            isAllDay = false
            btnAllDay.setImage(UIImage(named: "UnselectTickSquare"), for: .normal)
            if (availabilityData.from != nil) {
                txtFromDate.text = logTime(time: availabilityData.from ?? 0)
            }
            if (availabilityData.to != nil) {
                txtToDate.text = logTime(time: availabilityData.to ?? 0)
            }
        } else {
            isAllDay = true
            btnAllDay.setImage(UIImage(named: "SelectedTickSquare"), for: .normal)
        }
        setTimeViewUI()
        
        if (availabilityData.availability_type == "available") {
            isAvailability = true
            btnAvailable.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnNotAvailable.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        } else {
            isAvailability = false
            btnAvailable.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnNotAvailable.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        }
        commentTVw.text = availabilityData.comment
        delegate?.onBtnAllDay(indexPath: selectedIndexPath ?? IndexPath(), isAllDay: isAllDay)
    }
    
    func setCellValue(indexPath:IndexPath, availabilityData: [AvailabilityData], selectedFromTime: Int, allAvailabilityData: Availability_request){
        selectedIndexPath = indexPath
        let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        let userIDAPI =  "\(allAvailabilityData.user_id ?? 0)"
        
        if userID == userIDAPI {
            if allAvailabilityData.status == "pending" {
                btnAllDay.isUserInteractionEnabled = true
                btnAvailable.isUserInteractionEnabled = true
                btnNotAvailable.isUserInteractionEnabled = true
                btnFromDate.isUserInteractionEnabled = true
                btnToDate.isUserInteractionEnabled = true
                commentTVw.isUserInteractionEnabled = true
            }
            else {
                btnAllDay.isUserInteractionEnabled = false
                btnAvailable.isUserInteractionEnabled = false
                btnNotAvailable.isUserInteractionEnabled = false
                btnFromDate.isUserInteractionEnabled = false
                btnToDate.isUserInteractionEnabled = false
                commentTVw.isUserInteractionEnabled = false
            }
        }
        else {
            btnAllDay.isUserInteractionEnabled = false
            btnAvailable.isUserInteractionEnabled = false
            btnNotAvailable.isUserInteractionEnabled = false
            btnFromDate.isUserInteractionEnabled = false
            btnToDate.isUserInteractionEnabled = false
            commentTVw.isUserInteractionEnabled = false
        }
        switch indexPath.row {
        case 2:
            lblDay.text = "Monday"
            if (availabilityData.count > 0) {
                setWeekendData(availabilityData: availabilityData[0], selectedFromTime: selectedFromTime)
            }
        case 3:
            lblDay.text = "Tuesday"
            if (availabilityData.count > 0) {
                setWeekendData(availabilityData: availabilityData[1], selectedFromTime: selectedFromTime)
            }
        case 4:
            lblDay.text = "Wednesday"
            if (availabilityData.count > 0) {
                setWeekendData(availabilityData: availabilityData[2], selectedFromTime: selectedFromTime)
            }
        case 5:
            lblDay.text = "Thursday"
            if (availabilityData.count > 0) {
                setWeekendData(availabilityData: availabilityData[3], selectedFromTime: selectedFromTime)
            }
        case 6:
            lblDay.text = "Friday"
            if (availabilityData.count > 0) {
                setWeekendData(availabilityData: availabilityData[4], selectedFromTime: selectedFromTime)
            }
        case 7:
            lblDay.text = "Saturday"
            if (availabilityData.count > 0) {
                setWeekendData(availabilityData: availabilityData[5], selectedFromTime: selectedFromTime)
            }
        case 8:
            lblDay.text = "Sunday"
            if (availabilityData.count > 0) {
                setWeekendData(availabilityData: availabilityData[6], selectedFromTime: selectedFromTime)
            }
        default:
            print()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.onSelectedCommentText(commentIndexPath: selectedIndexPath ?? IndexPath(), comment: textView.text)
    }
}

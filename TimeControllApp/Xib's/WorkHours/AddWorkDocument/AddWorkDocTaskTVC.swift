//
//  AddWorkDocTaskTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 16/07/22.
//

import UIKit

class AddWorkDocTaskTVC: UITableViewCell {

    @IBOutlet weak var lblOngoingTime: UILabel!
    
    @IBOutlet weak var btnTask: UIButton!
    
    @IBOutlet weak var btnDate: UIButton!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnOpenMap: UIButton!
    
    @IBOutlet weak var lblStartTime: UILabel!
    
    @IBOutlet weak var lblEndTime: UILabel!
    
    @IBOutlet weak var lblTask: UILabel!
    
    @IBOutlet weak var lblBreakTime: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblProjectName: UILabel!
    
    @IBOutlet weak var btnStartTime: UIButton!
    
    @IBOutlet weak var btnEndTime: UIButton!
    
    @IBOutlet weak var lblStartEnd: UILabel!
    
    @IBOutlet weak var btnBreakTime: UIButton!
    
    @IBOutlet weak var btnStartEnd: UIButton!
    
    @IBOutlet weak var vwBreak: UIView!
    
    @IBOutlet weak var btnBreak: UIButton!
    
    @IBOutlet weak var lblTakeBreak: UILabel!
    
    
    @IBOutlet weak var vwStartTime: UIView!
    
    @IBOutlet weak var totalTimeLbl: UILabel!
    
    @IBOutlet weak var totalTimeVw: UIView!
        
    @IBOutlet weak var timerTimeVw: UIView!
    @IBOutlet weak var breakTimeVw: UIView!
    @IBOutlet weak var brakTimeStackVw: UIStackView!
    @IBOutlet weak var endTimeVw: UIView!
    @IBOutlet weak var runTimerLbl: UILabel!
    @IBOutlet weak var gpsStartTimeLbl: UILabel!
    @IBOutlet weak var gpsEndTimeLbl: UILabel!
    
    var seconds = 0
    var timer = Timer()

    var currentTimelogData : Timelog?

    public var delegate = AddWorkDocumentVC()

    var dashboardScheduleData = [newScheduleModel]()
    
    @IBOutlet weak var breakVw: UIView!
    
    //MARK: Localizations

    @IBOutlet weak var staticStartTimeLbl: UILabel!
    @IBOutlet weak var staticEndTimeLbl: UILabel!
    @IBOutlet weak var staticBreakTimeLbl: UILabel!
    @IBOutlet weak var staticTotalTimeLbl: UILabel!
    @IBOutlet weak var staticFinishNowLbl: UILabel!
    @IBOutlet weak var staticTakeBreakLbl: UILabel!
    @IBOutlet weak var staticTrackerDataLbl: UILabel!
    @IBOutlet weak var staticInTimeLbl: UILabel!
    @IBOutlet weak var staticOutTimeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        staticStartTimeLbl.text = LocalizationKey.startTime.localizing()
        staticEndTimeLbl.text = LocalizationKey.endTime.localizing()
        staticBreakTimeLbl.text = LocalizationKey.breakTime.localizing()
        staticTotalTimeLbl.text = LocalizationKey.totalTime.localizing()
        lblStartEnd.text = LocalizationKey.finishNow.localizing()
        lblTakeBreak.text = LocalizationKey.takeBreak.localizing()
        staticFinishNowLbl.text = LocalizationKey.finishNow.localizing()
        staticTakeBreakLbl.text = LocalizationKey.takeBreak.localizing()
        staticTrackerDataLbl.text = LocalizationKey.trackerGpsData.localizing()
        staticInTimeLbl.text = LocalizationKey.inTime.localizing()
        staticOutTimeLbl.text = LocalizationKey.outTime.localizing()
        
//        self.runTimer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func btnStartEndAction(_ sender: UIButton) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FinishWorkVC") as! FinishWorkVC
        vc.timeLogData = currentTimelogData
        vc.isFrom = "details"
        vc.dashboardScheduleData = dashboardScheduleData
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setData(rowsData: Rows) -> Void {
        
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
            seconds += 1
            runTimerLbl.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

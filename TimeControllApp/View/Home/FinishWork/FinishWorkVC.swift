//
//  FinishWorkVC.swift
//  TimeControllApp
//
//  Created by mukesh on 07/08/22.
//

import UIKit
import SVProgressHUD
import CoreLocation

class FinishWorkVC: BaseViewController, SignatureProtocol, CLLocationManagerDelegate {

    @IBOutlet weak var comentTv: UITextView!
    @IBOutlet weak var imgAddSignature: UIImageView!
    @IBOutlet weak var btnSignature: UIButton!
    @IBOutlet weak var imgSignature: UIImageView!
    @IBOutlet weak var btnChangeSignature: UIButton!
    @IBOutlet weak var changeSignatureVw: UIView!
    @IBOutlet weak var imgSetSignature: UIImageView!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    @IBOutlet weak var finishWorkTitleLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var signatureLbl: UILabel!
    @IBOutlet weak var didYouGetAnyLbl: UILabel!
    @IBOutlet weak var noLbl: UILabel!
    @IBOutlet weak var yesLbl: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    
    @IBOutlet weak var reasontblView: UITableView!
    @IBOutlet weak var reasonPopupView: UIView!
    @IBOutlet weak var selectAReasonLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    var reasonArray : [ClockInOutReasons]? = []
    var reasonsType = String()
    var selectedReasonIndex = -1
    var isEarlyForFinishWork = Bool()
    var isLateForFinishWork = Bool()
    
    var injury = "no"
    var currentTimelogData : CurrentTimelog?
    var timeLogData : Timelog?
    var isFrom = ""
    
    var workDetailsData : CurrentTimelog?
    
    let locationManager = CLLocationManager()
    var currentCorrdinate = CLLocationCoordinate2D()
    var signatureImg: UIImage?

    @IBOutlet weak var injuryVw: UIView!
    @IBOutlet weak var injuryLbl: UILabel!
    
     var isSignature = false
    
    var dashboardScheduleData = [newScheduleModel]()

    @IBOutlet weak var lblSelectAnomaliesReason: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        applyControlPanelBasicRules()
        getCurrentLocation()
        getWorkHoursAPI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        finishWorkTitleLbl.text = LocalizationKey.endOfTheDay.localizing()
        commentLbl.text = LocalizationKey.comment.localizing()
        signatureLbl.text = LocalizationKey.signature.localizing()
        injuryLbl.text = LocalizationKey.didYouGetAnyInjuryAtSiteToday.localizing()
        noLbl.text = LocalizationKey.no.localizing()
        yesLbl.text = LocalizationKey.yes.localizing()
        finishBtn.setTitle(LocalizationKey.finish.localizing(), for: .normal)
        lblSelectAnomaliesReason.text = LocalizationKey.pleaseSelectASuitableComment.localizing()
        cancelBtn.setTitle(LocalizationKey.cancel.localizing(), for: .normal)
        okBtn.setTitle(LocalizationKey.ok.localizing(), for: .normal)
    }
    
    func applyControlPanelBasicRules() {
        reasonPopupView.isHidden = true
        reasontblView.register(UINib.init(nibName: TABLE_VIEW_CELL.ChildListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue)
        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.displayCommentAfterFinish ?? false) {
            comentTv.isUserInteractionEnabled = true
            
        } else {
            comentTv.isUserInteractionEnabled = true
        }
        
        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowQucikChecklist ?? false) {
            injuryVw.isHidden = false
        } else {
            injuryVw.isHidden = true
        }

        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.quickCheckListText != nil) {
            injuryLbl.text = GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.quickCheckListText
        }
        
        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.signatureModalAfterWorklog ?? false) {
            btnSignature.isUserInteractionEnabled = true
        } else {
            btnSignature.isUserInteractionEnabled = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelReasonBtn(_ sender: Any) {
        reasonPopupView.isHidden = true
    }
    @IBAction func okReasonBtn(_ sender: Any) {
        if selectedReasonIndex < 0 {
            let alert = UIAlertController(title: "", message: LocalizationKey.pleaseProvideReason.localizing(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizationKey.ok.localizing(), style: .default, handler: { action in
                // start work
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            switch reasonsType {
                
            case AnomalyTrackerReasonsEnum.offSiteClockOut.rawValue:
                self.workHoursFinishAPI(isEarly: isEarlyForFinishWork, isLate: isLateForFinishWork, isOnTime: false, isOffsite: true, comment: reasonArray?[selectedReasonIndex].reason ?? "")
                reasonPopupView.isHidden = true
                
            case AnomalyTrackerReasonsEnum.earlyClockOut.rawValue:
                self.workHoursFinishAPI(isEarly: true, isLate: false, isOnTime: false, isOffsite: false, comment: reasonArray?[selectedReasonIndex].reason ?? "")
                reasonPopupView.isHidden = true
                
            case AnomalyTrackerReasonsEnum.lateClockOut.rawValue:
                self.workHoursFinishAPI(isEarly: false, isLate: true, isOnTime: false, isOffsite: false, comment: reasonArray?[selectedReasonIndex].reason ?? "")
                reasonPopupView.isHidden = true
                
            default:
                print("Check anomalies")
            }
        }
    }
    

    @IBAction func btnChangeSignatureClicked(_ sender: Any) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDrawSignatureClicked(_ sender: Any) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func signatureImg(signatureImage: UIImage) {
        signatureImg = signatureImage
        isSignature = true
        imgAddSignature.isHidden = true
        imgSignature.isHidden = true
        imgSetSignature.isHidden = false
        imgSetSignature.image = signatureImage
        changeSignatureVw.isHidden = false
        btnSignature.cornerRadius = 10
        btnSignature.borderWidth = 0.5
        btnSignature.borderColor = VBColorEnum.BorderColor.getColor()
    }
    
    @IBAction func btnNoClicked(_ sender: Any) {
        injury = "no"
        btnNo.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnYes.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
    }
    
    @IBAction func btnYesClicked(_ sender: Any) {
        injury = "yes"
        btnNo.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnYes.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
    }
    
    @IBAction func btnFinishClicked(_ sender: Any) {
        
        
        if (comentTv.text == "" && GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.displayCommentAfterFinish ?? false) {
            self.showAlert(message: LocalizationKey.pleaseWriteWhatTasksDidYouDoToday.localizing(), strtitle: "")
        } else if (isSignature == false && GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.signatureModalAfterWorklog ?? false) {
            self.showAlert(message: LocalizationKey.pleaseEnterSignature.localizing(), strtitle: "")
        } else {
            if checkLocationEnable() {
                /*
                if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.displayCommentAfterFinish ?? false || GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.signatureModalAfterWorklog ?? false) {
                    // Update API
                    updateWorkHoursAPI()
                } else if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowQucikChecklist ?? false && injury == "yes") {
                    // Injury API
                    
                    injuryWorkHoursAPI()
                } else {
                    if dashboardScheduleData.count > 0 {
                        self.checkSchedule()
                    } else {
                        finishWorkNotSchedule(isEarly: false, isLate: false, isOnTime: false)
    //                    self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
                    }
                }
                 */
                callIfGPSObligatoryNotAvailable()
            } else {
                if isGPSObligatory() {
                    let alert = UIAlertController(title: LocalizationKey.allowLocationAccess.localizing(), message: LocalizationKey.yourEmployerHasMadeGPSUsageMandatoryPleaseTurnOnYourGPS.localizing(), preferredStyle: UIAlertController.Style.alert)
                    
                    // Button to Open Settings
                    alert.addAction(UIAlertAction(title: LocalizationKey.settings.localizing(), style: UIAlertAction.Style.default, handler: { action in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)")
                            })
                        }
                    }))
                    alert.addAction(UIAlertAction(title: LocalizationKey.ok.localizing(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    callIfGPSObligatoryNotAvailable()
                }
            }
        }
    }
    
    //MARK: Check If GPS Obligatory Not Available

    func callIfGPSObligatoryNotAvailable() {
        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.displayCommentAfterFinish ?? false || GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.signatureModalAfterWorklog ?? false) {
            // Update API
            updateWorkHoursAPI()
        } else if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowQucikChecklist ?? false && injury == "yes") {
            // Injury API
            
            injuryWorkHoursAPI()
        } else {
            if dashboardScheduleData.count > 0 {
                self.checkSchedule()
            } else {
                if checkAnomaly() {
                    finishWorkNotSchedule(isEarly: false, isLate: false, isOnTime: false)
                } else {
                    self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
                }
//                finishWorkNotSchedule(isEarly: false, isLate: false, isOnTime: false)
//                    self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
            }
        }
    }
    
    //MARK: Check GPS Location

    func checkLocationEnable() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    return true
                @unknown default:
//                    break
                    return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    //MARK: Check GPS Obligatory

    func isGPSObligatory() -> Bool {
//        return GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs == "gps" && GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
        
        return GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
    }
    
    //MARK: Check Schedule data
    /*
    func checkSchedule() {
        let endBuffer = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.endBufferTimeForClockOut ?? 0
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: currentDate)
        
        let currentTime = Date()
        let calendar = Calendar.current
        let currentTimeWithoutDate = calendar.date(bySettingHour: calendar.component(.hour, from: currentTime), minute: calendar.component(.minute, from: currentTime), second: 0, of: currentTime)!
        let currentTimeInMinutes1 = (Int)(currentTimeWithoutDate.timeIntervalSince1970 / 60)
        
        let calendar1 = Calendar.current
        let now1 = Date()
        let components1 = calendar1.dateComponents([.hour, .minute], from: now1)
        var currentTimeInMinutes = Int()
        if let hours = components1.hour, let minutes = components1.minute {
            currentTimeInMinutes = (hours * 60) + minutes
            print("Total minutes from current time: \(currentTimeInMinutes)")
        } else {
            print("Failed to retrieve time components.")
        }

        var scheduleToday: [newScheduleModel] = []
        for i in 0..<dashboardScheduleData.count {
            if dashboardScheduleData[i].for_date == formattedDate {
                scheduleToday.append(dashboardScheduleData[i])
            }
        }
        print("Schedule data is : ", scheduleToday)
        if scheduleToday.count == 1 {
            if currentTimeInMinutes >= scheduleToday[0].start_time! && currentTimeInMinutes <= scheduleToday[0].end_time! - endBuffer {
                if isGPSObligatory() {
                    // Finish work check
                    finishWorkSchedule(schedule: scheduleToday[0], currentTimeInMinutes: currentTimeInMinutes, onTime: false)
                } else {
                    
                    workHoursFinishAPI()
                }
            } else {
                if isGPSObligatory() {
                    // Finish work check
                    finishWorkSchedule(schedule: scheduleToday[0], currentTimeInMinutes: currentTimeInMinutes, onTime: true)
                } else {
                    
                    workHoursFinishAPI()
                }
            }
        } else if scheduleToday.count > 1 {
            var currentSchedule: [newScheduleModel] = []
            for i in 0..<scheduleToday.count {
                if currentTimeInMinutes >= (scheduleToday[i].start_time ?? 0) - 30 && currentTimeInMinutes <= (scheduleToday[i].end_time ?? 0) - 30 {
                    currentSchedule.append(scheduleToday[i])
                    break
                }
            }
            
            if ((currentSchedule.count) != 0)  {
                if currentTimeInMinutes <= scheduleToday[0].end_time! && currentTimeInMinutes >= scheduleToday[0].end_time! - endBuffer {
                    if isGPSObligatory() {
                        // Finish work check
                        finishWorkSchedule(schedule: currentSchedule[0], currentTimeInMinutes: currentTimeInMinutes, onTime: false)
                    } else {
                        workHoursFinishAPI()
                    }
                } else {
                    if isGPSObligatory() {
                        // Finish work check
                        finishWorkSchedule(schedule: currentSchedule[0], currentTimeInMinutes: currentTimeInMinutes, onTime: true)
                    } else {
                        workHoursFinishAPI()
                    }
                }
            }
        } else {
            workHoursFinishAPI()
        }
    }
    */
    
    func getExactCurrentTimeInMinutes() -> Int {
        /*
        let timeZone = TimeZone(identifier: "GMT")!
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        let currentDate1 = dateFormatter.string(from: Date())

        let currentDateSplit = currentDate1.components(separatedBy: ":")
        let currentHours: String = currentDateSplit[0]
        let currentMinute: String = currentDateSplit[1]
        
       return (Int(currentHours)! + (GlobleVariables.timezoneGMT ?? 0)) * 60 + Int(currentMinute)!
        */
        guard let timeZone = TimeZone(identifier: "GMT") else {
            return 0
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        let currentDate1 = dateFormatter.string(from: Date())
        
        let currentDateSplit = currentDate1.components(separatedBy: ":")
        let currentHours: String = currentDateSplit[0]
        let currentMinute: String = currentDateSplit[1]
        
//       return (Int(currentHours) + (GlobleVariables.timezoneGMT ?? 0)) * 60 + Int(currentMinute)
        
        let currentHoursInt = Int(currentHours) ?? 0
        let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
        let currentMinuteInt = Int(currentMinute) ?? 0

        var totalMinutes = 0
        if currentHoursInt + timezoneOffset < 0 {
            totalMinutes = (currentHoursInt + timezoneOffset + 24) * 60 + currentMinuteInt
        } else {
            totalMinutes = (currentHoursInt + timezoneOffset) * 60 + currentMinuteInt
        }
        return totalMinutes
    }
    
    func checkSchedule() {
        let endBuffer = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.endBufferTimeForClockOut ?? 0
        let currentDate = getCurrentDateFromGMT()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: currentDate)
        
        let currentTime = getCurrentDateFromGMT()
        let calendar = Calendar.current
        let currentTimeWithoutDate = calendar.date(bySettingHour: calendar.component(.hour, from: currentTime), minute: calendar.component(.minute, from: currentTime), second: 0, of: currentTime)!
        let currentTimeInMinutes1 = (Int)(currentTimeWithoutDate.timeIntervalSince1970 / 60)

        let currentTimeInMinutes = getExactCurrentTimeInMinutes()
        print("currentTimeInMinutes is : ", currentTimeInMinutes)
        print("dashboardScheduleData is : ", dashboardScheduleData)
        var scheduleToday: [newScheduleModel] = []
        for i in 0..<dashboardScheduleData.count {
            if dashboardScheduleData[i].for_date == formattedDate {
                scheduleToday.append(dashboardScheduleData[i])
            }
        }
        print("Schedule data is : ", scheduleToday)
        if scheduleToday.count == 1 {
            //For Early logout
            if currentTimeInMinutes >= scheduleToday[0].start_time ?? 0 && currentTimeInMinutes <= (scheduleToday[0].end_time ?? 0) - endBuffer {
                self.genericCheck(schedule: scheduleToday[0], currentTimeInMinutes: currentTimeInMinutes, isEarly: true, isLate: false, isOnTime: false)
            } //for ontime logout
            else if currentTimeInMinutes >= (scheduleToday[0].end_time ?? 0) - endBuffer && currentTimeInMinutes <= (scheduleToday[0].end_time ?? 0) + endBuffer {
                self.genericCheck(schedule: scheduleToday[0], currentTimeInMinutes: currentTimeInMinutes, isEarly: false, isLate: false, isOnTime: true)
            } //for late logout
            else {
                self.genericCheck(schedule: scheduleToday[0], currentTimeInMinutes: currentTimeInMinutes, isEarly: false, isLate: true, isOnTime: false)
            }
        } else if scheduleToday.count > 1 {
            var currentSchedule: [newScheduleModel] = []
            for i in 0..<scheduleToday.count {
                print("currentTimeInMinutes is : ", currentTimeInMinutes)
                print("scheduleToday[i].start_time ?? 0 is : ", scheduleToday[i].start_time ?? 0)
                print("scheduleToday[i].end_time ?? 0 is : ", scheduleToday[i].end_time ?? 0)

                if currentTimeInMinutes >= (scheduleToday[i].start_time ?? 0) && currentTimeInMinutes <= (scheduleToday[i].end_time ?? 0) {
                    currentSchedule.append(scheduleToday[i])
                    break
                } else if currentTimeInMinutes <= scheduleToday[i].start_time ?? 0 && currentTimeInMinutes <= (scheduleToday[i].end_time ?? 0) {
                    currentSchedule.append(scheduleToday[i])
                    break
                } else if currentTimeInMinutes >= scheduleToday[i].start_time ?? 0 && currentTimeInMinutes >= (scheduleToday[i].end_time ?? 0) {
                    currentSchedule.append(scheduleToday[i])
                    break
                }
            }
            
            print("currentSchedule is : ", currentSchedule)
            
            if ((currentSchedule.count) != 0)  {
                
                print("Is pass")
                
                if currentTimeInMinutes <= currentSchedule[0].start_time ?? 0 && currentTimeInMinutes <= (currentSchedule[0].end_time ?? 0) - endBuffer {
                    self.genericCheck(schedule: currentSchedule[0], currentTimeInMinutes: currentTimeInMinutes, isEarly: true, isLate: false, isOnTime: false)
                } else if currentTimeInMinutes >= (currentSchedule[0].end_time ?? 0) - endBuffer && currentTimeInMinutes <= (currentSchedule[0].end_time ?? 0) + endBuffer {
                    self.genericCheck(schedule: currentSchedule[0], currentTimeInMinutes: currentTimeInMinutes, isEarly: false, isLate: false, isOnTime: true)
                } else {
                    self.genericCheck(schedule: currentSchedule[0], currentTimeInMinutes: currentTimeInMinutes, isEarly: false, isLate: true, isOnTime: false)
                }
            }
        } else {
            self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
        }
    }
    
    //MARK: Check generic check
    
    func genericCheck( schedule: newScheduleModel, currentTimeInMinutes: Int, isEarly: Bool, isLate: Bool, isOnTime: Bool ) {
        if checkAnomaly() {
            finishWorkSchedule(schedule: schedule, currentTimeInMinutes: currentTimeInMinutes, isEarly: isEarly, isLate: isLate, isOnTime: isOnTime)
            return
        } else {
            workHoursFinishAPI(isEarly: isEarly, isLate: isLate, isOnTime: isOnTime, isOffsite: false, comment: "")
            return
        }
    }

    //MARK: Check Anomaly

    private func checkAnomaly() -> Bool {
        return GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs != "autoschedule" && GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
    }
    
    //MARK: Check Finish work Schedule
    
    /*
    func finishWorkSchedule(schedule: newScheduleModel, currentTimeInMinutes: Int, onTime: Bool) {
        let currentLat = currentCorrdinate.latitude
        let currentLon = currentCorrdinate.longitude
        let targetLocation = schedule.gps_data?.split(separator: ",")
        let targetLat = Double(targetLocation?[0] ?? "")
        let targetLon = Double(targetLocation?[1] ?? "")
        
        let distance = distanceBetween(currentLatitude: currentLat, currentLongitude: currentLon, targetLatitude: targetLat ?? 0.0, targetLongitude: targetLon ?? 0.0)
        print("distance ", distance)
        
        if let allowedDistance = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.gpsAllowedDistance, allowedDistance != 0 {
            
            if distance <= Double(allowedDistance) {
                // The current location is within a 500-meter radius of the target location
                if onTime {
                    
                    workHoursFinishAPI()
                } else {
                    let title = "Confirm Finish Work?"
                    let message = "Hey you still have schedule time left, Do you want to go home early today?"
                    showAlert(title: title, message: message)
                }
            } else {
                // The current location is not within a 500-meter radius of the target location
                let title = "Confirm Finish Work?"
                let message = "You are not at your work sight, and still have schedule time left."
                showAlert(title: title, message: message)
            }
        } else {
            if distance <= 100 {
                // The current location is within a 100-meter radius of the target location
                if onTime {
                    
                    workHoursFinishAPI()
                } else {
                    let title = "Confirm Finish Work?"
                    let message = "Hey you still have schedule time left, Do you want to go home early today?"
                    showAlert(title: title, message: message)
                }
            } else {
                // The current location is not within a 100-meter radius of the target location
                let title = "Confirm Finish Work?"
                let message = "You are not at your work sight, and still have schedule time left."
                showAlert(title: title, message: message)
            }
        }
    }
    */
    
    func finishWorkSchedule(schedule: newScheduleModel, currentTimeInMinutes: Int, isEarly: Bool, isLate: Bool, isOnTime: Bool) {
        let currentLat = currentCorrdinate.latitude
        let currentLon = currentCorrdinate.longitude
        let targetLocation = schedule.gps_data?.split(separator: ",")
        let targetLat = Double(targetLocation?[0] ?? "")
        let targetLon = Double(targetLocation?[1] ?? "")
        self.isEarlyForFinishWork = isEarly
        self.isLateForFinishWork = isLate
        
        let distance = distanceBetween(currentLatitude: currentLat, currentLongitude: currentLon, targetLatitude: targetLat ?? 0.0, targetLongitude: targetLon ?? 0.0)
        print("distance ", distance)
        
        if let allowedDistance = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.gpsAllowedDistance, allowedDistance != 0 {
            
            if distance <= Double(allowedDistance) {
                // The current location is within a 500-meter radius of the target location
                if isEarly {
                    let title = LocalizationKey.heyYouStillHaveScheduleTimeLeft.localizing()
                    let message = LocalizationKey.heyYouHaveStillSomeScheduledTimeLeft.localizing() + "\n\n" + LocalizationKey.doYouWantToFinishNow.localizing()
                    let heading = LocalizationKey.whyDoYouWanToGoHomeEarlyToday.localizing()
                    self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.earlyClockOut
                    self.reasonsType = AnomalyTrackerReasonsEnum.earlyClockOut.rawValue
                    self.reasontblView.reloadData()
                    self.showAlert(title: "", message: message, heading: heading, isEarly: true, isOffsite: false, isLate: false)
                    return
                }  else if isLate {
                    let title = LocalizationKey.lateShift.localizing()
                    let message = LocalizationKey.youAreEndingTheWorkLateToday.localizing()
                    let heading = LocalizationKey.whyDoYouWanToGoHomeEarlyToday.localizing()
                    self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.lateClockOut
                    self.reasonsType = AnomalyTrackerReasonsEnum.lateClockOut.rawValue
                    self.reasontblView.reloadData()
                    self.showAlert(title: "", message: message, heading: heading, isEarly: false, isOffsite: false, isLate: true)
                    return
                } else {
                    self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
                }
            } else {
                // The current location is not within a 500-meter radius of the target location
                if isEarly {
                    let title = LocalizationKey.heyYouStillHaveSomeTimeLeftBeforeScheduling.localizing()
                    let message = LocalizationKey.heyYouHaveStillSomeScheduledTimeLeft.localizing() + "\n\n" + LocalizationKey.andYouHaventArrivedAtTheSiteEitherWouldYouLikeToEnd.localizing()
                    let heading = LocalizationKey.whyDoYouWanToGoHomeEarlyToday
                    self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.offSiteClockOut
                    self.reasonsType = AnomalyTrackerReasonsEnum.offSiteClockOut.rawValue
                    self.reasontblView.reloadData()
                    self.showAlert(title: "", message: message, heading: heading, isEarly: true, isOffsite: true, isLate: false)
                    return
                } else if isLate {
                    let title = LocalizationKey.youAreRunningLateTodayYourPMWillBeInformed.localizing()
                    let message = LocalizationKey.timeControlHasNoticedThatYoureEndingYourWorkLateTodayPleaseSelectAReasonFromTheNextScreen.localizing()
                    let heading = LocalizationKey.whyDoYouWanToGoHomeEarlyToday
                    self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.offSiteClockOut
                    self.reasonsType = AnomalyTrackerReasonsEnum.offSiteClockOut.rawValue
                    self.reasontblView.reloadData()
                    self.showAlert(title: "", message: message, heading: heading, isEarly: false, isOffsite: true, isLate: true)
                    return
                } else {
//                    let title = "Hello, Time & Control noticed that you are not at the site yet"
//                    let message = "Would you like to proceed?"
//                    let heading = "You are not at your work sight?"
                    
                    let title = LocalizationKey.timeControlHasNoticedThatYoureNotAtTheWorkSite.localizing()
                    let message = LocalizationKey.timeControlHasNoticedThatYoureNotAtTheWorkSite.localizing() + "\n\n" + LocalizationKey.doYouStillWantToClockOut.localizing()
                    let heading = LocalizationKey.whyAreYouClockingOutOutsideTheWorkLocation.localizing()
                    self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.offSiteClockOut
                    self.reasonsType = AnomalyTrackerReasonsEnum.offSiteClockOut.rawValue
                    self.reasontblView.reloadData()
                    self.showAlert(title: "", message: message, heading: heading, isEarly: false, isOffsite: true, isLate: false)
                    return
                }
            }
        }
    }
    
    //MARK: Check Finish work when schedule not available
    
    func finishWorkNotSchedule(isEarly: Bool, isLate: Bool, isOnTime: Bool) {
        var currentTimeInMinutes = getExactCurrentTimeInMinutes()
        
        let currentLat = currentCorrdinate.latitude
        let currentLon = currentCorrdinate.longitude
        let targetLocation = isFrom == "home" ? currentTimelogData?.gps_data?.task?.split(separator: ",") : timeLogData?.gps_data?.task?.split(separator: ",")
        let targetLat = Double(targetLocation?[0] ?? "")
        let targetLon = Double(targetLocation?[1] ?? "")
        
        let distance = distanceBetween(currentLatitude: currentLat, currentLongitude: currentLon, targetLatitude: targetLat ?? 0.0, targetLongitude: targetLon ?? 0.0)
        print("distance ", distance)
        
        if let allowedDistance = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.gpsAllowedDistance, allowedDistance != 0 {
            
            if distance <= Double(allowedDistance) {
                // The current location is within a 500-meter radius of the target location
                self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
            } else {
                // The current location is not within a 500-meter radius of the target location
//                let title = "Hello, Time & Control noticed that you are not at the site yet"
//                let message = "Would you like to proceed?"
//                let heading = "You are not at your work sight?"
                
                let title = LocalizationKey.timeControlHasNoticedThatYoureNotAtTheWorkSite.localizing()
                let message = LocalizationKey.timeControlHasNoticedThatYoureNotAtTheWorkSite.localizing() + "\n\n" + LocalizationKey.doYouStillWantToClockOut.localizing()
                let heading = LocalizationKey.whyAreYouClockingOutOutsideTheWorkLocation.localizing()
                self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.offSiteClockOut
                self.reasonsType = AnomalyTrackerReasonsEnum.offSiteClockOut.rawValue
                self.isEarlyForFinishWork = false
                self.isLateForFinishWork = false
                self.reasontblView.reloadData()
                self.showAlert(title: "", message: message, heading: heading, isEarly: false, isOffsite: true, isLate: false)
                return
            }
        }
    }
    
    //MARK: Get the distance
    
    func distanceBetween(currentLatitude: Double, currentLongitude: Double, targetLatitude: Double, targetLongitude: Double) -> Double {
        let manager = CLLocationManager() //location manager for user's current location
        let destinationCoordinates = CLLocation(latitude: targetLatitude, longitude: targetLongitude) //coordinates for destinastion
        // let destinationCoordinates = CLLocation(latitude: (30.7046), longitude: (76.7179)) //coordinates for destinastion
        let selfCoordinates = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        //   let selfCoordinates = CLLocation(latitude: (30.7377), longitude: (76.6792)) //user's location
        return selfCoordinates.distance(from: destinationCoordinates) //return distance in **meters**
    }
    
    //MARK: Open the alert view
    
    /*
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            // start work
            self.workHoursFinishAPI()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    */
    
    
    func showAlert(title: String, message: String, heading: String, isEarly: Bool, isOffsite: Bool, isLate: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            // start work
            if self.checkControlPanelAnomalies() {
                let heading = heading
//                self.showCustomDialogForReason(heading: heading, isEarly: isEarly, isOffSite: isOffsite)
                self.reasonPopupView.isHidden = false
            } else {
                self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
            }
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Open the reason dialog

    private func showCustomDialogForReason(heading: String, isEarly: Bool, isOffSite: Bool) {
        let alert = UIAlertController(title: heading, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = LocalizationKey.reason.localizing()
        }
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            
            guard let reason = alert.textFields?[0].text else {
                return
            }
            if (reason == "") {
                self.showAlert(message: LocalizationKey.pleaseProvideReason.localizing(), strtitle: "")
                //                return
            } else {
                self.workHoursFinishAPI(isEarly: isEarly, isLate: false, isOnTime: false, isOffsite: isOffSite, comment: reason)
            }
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Check control panel anomalies
    
    private func checkControlPanelAnomalies() -> Bool {
        return GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.trackAnomalies ?? false
    }
    
    //MARK: Get the current location
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.main.async {
            // your code here
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentCorrdinate = locValue
    }
    
//    var distanceToUsersCurrentLocation: Double {
//        let manager = CLLocationManager() //location manager for user's current location
//        let destinationCoordinates = CLLocation(latitude: (Double(lat) ?? 0.0), longitude: (Double(long) ?? 0.0)) //coordinates for destinastion
//        // let destinationCoordinates = CLLocation(latitude: (30.7046), longitude: (76.7179)) //coordinates for destinastion
//        let selfCoordinates = CLLocation(latitude: (currentCorrdinate.latitude ?? 0.0), longitude: (currentCorrdinate.longitude ?? 0.0))
//        //   let selfCoordinates = CLLocation(latitude: (30.7377), longitude: (76.6792)) //user's location
//        return selfCoordinates.distance(from: destinationCoordinates) //return distance in **meters**
//    }
}


//MARK: - TableView DataSource and Delegate Methods
extension FinishWorkVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue, for: indexPath) as? ChildListTVC
        else { return UITableViewCell() }
        cell.childNameLbl.text = reasonArray?[indexPath.row].reason
        cell.childNameLbl.numberOfLines = 0
        
        if selectedReasonIndex == indexPath.row {
            cell.selectChildBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        }
        else {
            cell.selectChildBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReasonIndex = indexPath.row
        reasontblView.reloadData()
    }
}


//MARK: APi Work in View controller
extension FinishWorkVC{
    func workHoursFinishAPI(isEarly: Bool, isLate: Bool, isOnTime: Bool, isOffsite: Bool, comment: String) {
        SVProgressHUD.show()
        var param = [String:Any]()
        var endGps = [String:Any]()
        
        var start = [String:Any]()
        var end = [String:Any]()
        var anamoly = [String:Any]()
        var anomalyTrackerReason = [String:Any]()
        
        var shiftData = [String:Any]()
        var deviceDetails = [String:Any]()

        let currentTime = getCurrentDateFromGMT()
        let calendar = Calendar.current
        let currentTimeWithoutDate = calendar.dateComponents([.hour, .minute], from: currentTime)
        let TimeInMinutes = (currentTimeWithoutDate.hour! * 60) + currentTimeWithoutDate.minute!

        var coords = [String:Any]()
        let timestamp = currentTime.timeIntervalSince1970
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:currentCorrdinate.latitude, longitude: currentCorrdinate.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                var currentLocationAddress = ""
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                currentLocationAddress = addressString
                
                coords["altitude"] = 0.0
                coords["altitudeAccuracy"] = 0
                coords["latitude"] = self.currentCorrdinate.latitude
                coords["accuracy"] =  0.0
                coords["longitude"] = self.currentCorrdinate.longitude
                coords["heading"] = 0.0
                coords["speed"] = 0.0

                endGps["coords"] = coords
                endGps["timestamp"] = timestamp
                endGps["locationString"] = currentLocationAddress
//                endGps["locationString"] = isFrom == "home" ? currentTimelogData?.location_string : timeLogData?.location_string
                endGps["decision"] =  "off-bounds"
                endGps["is_ok"] = false
        //        endGps["diff"] = false
                endGps["manual"] = false
                      
                start["is_early"] = self.isFrom == "home" ? self.currentTimelogData?.anomaly?.start?.is_early : self.timeLogData?.anomaly?.start?.is_early
                start["is_offsite"] = self.isFrom == "home" ? self.currentTimelogData?.anomaly?.start?.is_offsite : self.timeLogData?.anomaly?.start?.is_offsite
                start["is_late"] = self.isFrom == "home" ? self.currentTimelogData?.anomaly?.start?.is_late : self.timeLogData?.anomaly?.start?.is_late
                start["comment"] = self.isFrom == "home" ? self.currentTimelogData?.anomaly?.start?.comment : self.timeLogData?.anomaly?.start?.comment

                end["is_early"] = isEarly
                end["is_offsite"] = isOffsite
                end["is_late"] = isLate
                end["comment"] = comment

                anamoly["start"] = start
                anamoly["end"] = end
                
                if self.selectedReasonIndex > -1 {
                    anomalyTrackerReason["reason"] = self.reasonArray?[self.selectedReasonIndex].reason ?? ""
                    anomalyTrackerReason["value"] = self.reasonArray?[self.selectedReasonIndex].value ?? ""
                    anomalyTrackerReason["code"] = self.reasonArray?[self.selectedReasonIndex].code ?? ""
                    anomalyTrackerReason["sendNotification"] = self.reasonArray?[self.selectedReasonIndex].sendNotification ?? false
                    anomalyTrackerReason["autoAdjust"] = self.reasonArray?[self.selectedReasonIndex].autoAdjust ?? false
//                    anomalyTrackerReason["actualTime"] = TimeInMinutes
                    
                    param["anomalyTrackerReason"] = anomalyTrackerReason
                }
                
                param["endGps"] = endGps
                param["description"] = self.comentTv.text
                param["anomaly"] = anamoly

                if (self.currentTimelogData?.data?.deviceDetails != nil) {
                    shiftData["shiftId"] = self.currentTimelogData?.data?.shiftId
                    
                    shiftData["autoClockIn"] = self.currentTimelogData?.data?.autoClockIn
                    shiftData["autoClockOut"] = false
                    
                    deviceDetails["device"] = self.currentTimelogData?.data?.deviceDetails?.device
                    deviceDetails["deviceModel"] = self.currentTimelogData?.data?.deviceDetails?.deviceModel
                    deviceDetails["osVersion"] = self.currentTimelogData?.data?.deviceDetails?.osVersion
                    deviceDetails["appVersion"] = self.currentTimelogData?.data?.deviceDetails?.appVersion
                    deviceDetails["buildNumber"] = self.currentTimelogData?.data?.deviceDetails?.buildNumber
                    shiftData["deviceDetails"] = deviceDetails
                } else {
                    shiftData["shiftId"] = 0
                    
                    shiftData["autoClockIn"] = false
                    shiftData["autoClockOut"] = false
                    
                    deviceDetails["device"] = "iOS"
                    deviceDetails["deviceModel"] = UIDevice.current.model
                    deviceDetails["osVersion"] = UIDevice.current.systemVersion
                    deviceDetails["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    deviceDetails["buildNumber"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                    shiftData["deviceDetails"] = deviceDetails
                }
                
//                shiftData["shiftId"] = self.currentTimelogData?.id != 0 ? self.currentTimelogData?.id : 0
//                
//                shiftData["autoClockIn"] = false
//                shiftData["autoClockOut"] = false
//                
//                deviceDetails["device"] = "iOS"
//                deviceDetails["deviceModel"] = UIDevice.current.model
//                deviceDetails["osVersion"] = UIDevice.current.systemVersion
//                deviceDetails["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//                deviceDetails["buildNumber"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
//                shiftData["deviceDetails"] = deviceDetails
//                param["data"] = shiftData

                print("Finish work hour params : ", param)
                
                WorkHourVM.shared.finishWorkHoursAPI(parameters: param, id: self.isFrom == "home" ? self.currentTimelogData?.id ?? 0 : self.timeLogData?.id ?? 0, isAuthorization: true) { [self] obj in
                    
                    print("Finish respone is : ", obj)
                    showAlert(message: LocalizationKey.yourWorkHoursFinished.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
                        if self.isFrom == "home" {
                            self.navigationController?.popViewController(animated: true)
                        }
                        else {
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        }
                    }
                }
            }
        })
    }
    
    func updateWorkHoursAPI() {
        SVProgressHUD.show()
        var param = [String:Any]()
        var data = [String:Any]()
        
        if signatureImg != nil {
            data["signature"]  = "data:image/png;base64," + (convertImageToBase64String(img: self.signatureImg ?? UIImage()) ?? "")
        }

        param["description"] = comentTv.text
        param["data"] = data
        print("Update work hour params : ", param)
        
        WorkHourVM.shared.updateWorkHoursAPI(parameters: param, id: isFrom == "home" ? currentTimelogData?.id ?? 0 : timeLogData?.id ?? 0, isAuthorization: true) { [self] obj in
            
            print("Update respone is : ", obj)
            
            if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowQucikChecklist ?? false && injury == "yes") {
                injuryWorkHoursAPI()
            } else {
                if dashboardScheduleData.count > 0 {
                    self.checkSchedule()
                } else {
                    if checkAnomaly() {
                        finishWorkNotSchedule(isEarly: false, isLate: false, isOnTime: false)
                    } else {
                        self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
                    }
//                    self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
                }
//                workHoursFinishAPI()
            }
        }
    }
    func getWorkHoursAPI() {
        SVProgressHUD.show()
        
        print("icurrentTimelogData?.id ",isFrom == "home" ? currentTimelogData?.id ?? 0 : timeLogData?.id ?? 0)
        WorkHourVM.shared.getWorkHoursAPI(id: isFrom == "home" ? currentTimelogData?.id ?? 0 : timeLogData?.id ?? 0, isAuthorization: true) { [self] obj in
            
            workDetailsData = obj.timelog
            print("getWorkHours respone is : ", obj)
        }
    }
    
    func injuryWorkHoursAPI() {
        SVProgressHUD.show()
        
        workDetailsData?.data?.isInjury = true
        print("id ", isFrom == "home" ? currentTimelogData?.id ?? 0 : timeLogData?.id ?? 0)
        do{
            let jsonData = try JSONEncoder().encode(workDetailsData)
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                print(jsonObject)
                WorkHourVM.shared.injuryWorkHoursAPI(parameters: jsonObject, id: isFrom == "home" ? currentTimelogData?.id ?? 0 : timeLogData?.id ?? 0, isAuthorization: true) { [self] obj in
                    
                    print("Injury respone is : ", obj)
                    if dashboardScheduleData.count > 0 {
                        self.checkSchedule()
                    } else {
                        if checkAnomaly() {
                            finishWorkNotSchedule(isEarly: false, isLate: false, isOnTime: false)
                        } else {
                            self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
                        }
//                        finishWorkNotSchedule(isEarly: false, isLate: false, isOnTime: false)
//                        self.workHoursFinishAPI(isEarly: false, isLate: false, isOnTime: false, isOffsite: false, comment: "")
                    }
//                    workHoursFinishAPI()
                }
            }
        }catch {
            print(error.localizedDescription)
            SVProgressHUD.show()
        }
    }
}

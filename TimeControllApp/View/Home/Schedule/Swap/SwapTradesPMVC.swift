//
//  SwapTradesPMVC.swift
//  TimeControllApp
//
//  Created by yash on 16/01/23.
//

import UIKit

class SwapTradesPMVC: BaseViewController {
    
    @IBOutlet weak var SwapTradesListTblVw: UITableView!
    
    @IBOutlet weak var scheduleSegmentControl: UISegmentedControl!
    @IBOutlet weak var bottomSheetMainView: UIView!
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var sheetAcceptBtn: UIButton!
    @IBOutlet weak var sheetCancelBtn: UIButton!
    @IBOutlet weak var sheetMessageLbl: UILabel!
    @IBOutlet weak var sheetImage: UIImageView!
    @IBOutlet weak var swapTradesTitleLbl: UILabel!
    @IBOutlet weak var staticAcceptedLbl: UILabel!
    
    var requestTradesList : [RequestShift] = []
    
    var myRequestTradesList : [RequestShift] = []
    
    var selectedRequestShift : RequestShift?
    
    var selectedAction = ""
    @IBOutlet weak var staticMessageSwapTradeGrab: UILabel!
    var isNotificationForMySwap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isNotificationForMySwap {
            scheduleSegmentControl.selectedSegmentIndex = 1
            swapTradesMyList()
        } else {
            scheduleSegmentControl.selectedSegmentIndex = 0
            swapTradesList()
        }
        setUpLocalization()
        configUI()
//        swapTradesList()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        swapTradesTitleLbl.text = LocalizationKey.schedule.localizing()
        scheduleSegmentControl.setTitle(LocalizationKey.newRequests.localizing(), forSegmentAt: 0)
        scheduleSegmentControl.setTitle(LocalizationKey.mySwapsTrades.localizing(), forSegmentAt: 1)
        staticAcceptedLbl.text = LocalizationKey.accepted.localizing()
        sheetMessageLbl.text = LocalizationKey.thankYouForAcceptingTheRequestTheManagerHasBeenInformedPleaseWaitForTheApproval.localizing()
        sheetAcceptBtn.setTitle(LocalizationKey.accept.localizing(), for: .normal)
        sheetCancelBtn.setTitle(LocalizationKey.cancel.localizing(), for: .normal)
        staticMessageSwapTradeGrab.text = LocalizationKey.theFollowingMembersHaveSentRequestsForTradeGrabOrSwap.localizing()
    }
    
    func configUI() {
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        scheduleSegmentControl.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
        scheduleSegmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        self.SwapTradesListTblVw.separatorColor = UIColor.clear
        
        sheetView.layer.cornerRadius = 39
        sheetView.layer.masksToBounds = true
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        bottomSheetMainView.addGestureRecognizer(tap)
        bottomSheetMainView.isHidden = true
        
        SwapTradesListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SwapTradesPMTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SwapTradesPMTVC.rawValue)
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        SwapTradesListTblVw.reloadData()
        if sender.selectedSegmentIndex == 0 {
            self.swapTradesList()
        } else if sender.selectedSegmentIndex == 1 {
            self.swapTradesMyList()
        }
    }
    
    @IBAction func acceptBtn(_ sender: Any) {
        if selectedAction == "accept"{
            if selectedRequestShift?.swap_type == "trade-shift" {
                tradeAcceptedRejected(status: "approved")
            } else if selectedRequestShift?.swap_type == "grab-shift" {
                swapAcceptedRejected(status: "approved")
            } else if selectedRequestShift?.swap_type == "swap-shift" {
                swapAcceptedRejected(status: "approved")
            } else {
                swapAcceptedRejected(status: "approved")
            }
            
//            swapAcceptedRejected(status: "approved")
//            tradeAcceptedRejected(status: "approved")
        } else if selectedAction == "reject"{
            if selectedRequestShift?.swap_type == "trade-shift" {
                tradeAcceptedRejected(status: "rejected")
            } else if selectedRequestShift?.swap_type == "grab-shift" {
                swapAcceptedRejected(status: "rejected")
            } else if selectedRequestShift?.swap_type == "swap-shift" {
                swapAcceptedRejected(status: "rejected")
            } else {
                swapAcceptedRejected(status: "rejected")
            }
//            swapAcceptedRejected(status: "rejected")
//            tradeAcceptedRejected(status: "rejected")
        }
        bottomSheetMainView.isHidden = true
    }
    @IBAction func cancelBtn(_ sender: Any) {
        bottomSheetMainView.isHidden = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        bottomSheetMainView.isHidden = true
    }

    func showAlertForCheckSchedule(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            if self.selectedRequestShift?.swap_type == "trade-shift" {
                self.tradeAcceptedRejected(status: "approved")
            } else if self.selectedRequestShift?.swap_type == "grab-shift" {
                self.swapAcceptedRejected(status: "approved")
            } else if self.selectedRequestShift?.swap_type == "swap-shift" {
                self.swapAcceptedRejected(status: "approved")
            } else {
                self.swapAcceptedRejected(status: "approved")
            }
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func minutesToHoursAndMinutesOvetime(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func convertValueInDecimal (totalTime: Int) -> String {
        if (String(totalTime).count == 1) {
            return String(format: "%02d", totalTime)
        } else{
            return "\(totalTime)"
        }
    }
}

extension SwapTradesPMVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 1
        if scheduleSegmentControl.selectedSegmentIndex == 0 {
            count = requestTradesList.count
        } else if scheduleSegmentControl.selectedSegmentIndex == 1 {
            count = myRequestTradesList.count
        } else {
            count = 0
        }
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noScheduleAvailable.localizing()
            noDataLabel.textColor     = Constant.appColor
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            noDataLabel.lineBreakMode = .byWordWrapping
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            staticMessageSwapTradeGrab.isHidden = true
        }else{
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
            staticMessageSwapTradeGrab.isHidden = false
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleSegmentControl.selectedSegmentIndex == 0 {
            return requestTradesList.count
        } else if scheduleSegmentControl.selectedSegmentIndex == 1 {
            return myRequestTradesList.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SwapTradesPMTVC.rawValue, for: indexPath) as? SwapTradesPMTVC else { return UITableViewCell() }
//        if scheduleSegmentControl.selectedSegmentIndex == 0 {
//            cell.rejectBtn.isHidden = false
//            cell.acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
//
//            cell.acceptBtn.setTitle("Accept", for: .normal)
//            cell.acceptBtnWidth.constant = 85
//
//            if indexPath.row == 0  {
//                cell.swapLbl.text = "Sick Leave"
//                cell.SwapView.backgroundColor = #colorLiteral(red: 1, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
//            } else {
//                cell.swapLbl.text = "Swap-Trade"
//                cell.SwapView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
//            }
//        } else {
//            cell.rejectBtn.isHidden = true
//            if indexPath.row == 0 || indexPath.row == 1 {
//                cell.acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
//                cell.acceptBtn.setTitle("Swapped", for: .normal)
//                cell.acceptBtnWidth.constant = 85
//
//                cell.swapLbl.text = "Sick Leave"
//                cell.SwapView.backgroundColor = #colorLiteral(red: 1, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
//            } else {
//                cell.acceptBtn.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
//                cell.acceptBtn.setTitle("Rejected", for: .normal)
//                cell.acceptBtnWidth.constant = 85
//
//                cell.swapLbl.text = "Swap-Trade"
//                cell.SwapView.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
//            }
//        }
        if scheduleSegmentControl.selectedSegmentIndex == 0 {
            let obj = requestTradesList[indexPath.row]
            cell.setCellValue(requestShift: obj,selectedSegmentIndex:0)
            cell.delegate = self
            return cell
        } else if scheduleSegmentControl.selectedSegmentIndex == 1 {
            let obj = myRequestTradesList[indexPath.row]
            cell.setCellValue(requestShift: obj,selectedSegmentIndex:1)
            cell.delegate = self
            return cell
        } else {
            return  UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
extension SwapTradesPMVC: SwapTradesPMTVCDelegate {
    func onAcceptBtn(requestShift: RequestShift?) {
        selectedRequestShift = requestShift
        print("selectedRequestShift",selectedRequestShift)
        
        // swapperTotal
        let swapperTotal = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMins ?? 0)
        
       let finalSwapperTotal = "\(convertValueInDecimal(totalTime: swapperTotal.hours)):\(convertValueInDecimal(totalTime: swapperTotal.leftMinutes))"
        
        
        // swapperAfterTotal
        let swapperAfterTotal = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0)
        
       let finalSwapperAfterTotal = "\(convertValueInDecimal(totalTime: swapperAfterTotal.hours)):\(convertValueInDecimal(totalTime: swapperAfterTotal.leftMinutes))"
        
        
        // swapperOvertime
        let swapperOvertime = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.swapperOvertimeMin ?? 0)
        
       let finalSwapperOvertime = "\(convertValueInDecimal(totalTime: swapperOvertime.hours)):\(convertValueInDecimal(totalTime: swapperOvertime.leftMinutes))"
        
        
        // acceptorTotal
        let acceptorTotal = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMins ?? 0)
        
       let finalAcceptorTotal = "\(convertValueInDecimal(totalTime: acceptorTotal.hours)):\(convertValueInDecimal(totalTime: acceptorTotal.leftMinutes))"
        
        
        // acceptorAfterTotal
        let acceptorAfterTotal = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0)
        
       let finalAcceptorAfterTotal = "\(convertValueInDecimal(totalTime: acceptorAfterTotal.hours)):\(convertValueInDecimal(totalTime: acceptorAfterTotal.leftMinutes))"
        
        
        // acceptorOvertime
        let acceptorOvertime = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.acceptorOvertimeMin ?? 0)
        
       let finalAcceptorOvertime = "\(convertValueInDecimal(totalTime: acceptorOvertime.hours)):\(convertValueInDecimal(totalTime: acceptorOvertime.leftMinutes))"
        
        var calcPeriod = ""
        if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeCalcRules?.calc_period == "day" {
            calcPeriod = LocalizationKey.day.localizing()
        } else if GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeCalcRules?.calc_period == "week" {
            calcPeriod = LocalizationKey.week.localizing()
        } else {
            calcPeriod = LocalizationKey.month.localizing()
        }
        
        if (selectedRequestShift?.swap_type == "trade-shift") {
            if (selectedRequestShift?.isOvertime ?? false && (selectedRequestShift?.from_user_role ?? "" != selectedRequestShift?.accepted_user_role ?? "")) {
                if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 && requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theSwapWillChangeTheShiftHoursTo.localizing()) \(finalSwapperAfterTotal) \(LocalizationKey.hours.localizing()),  \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalSwapperOvertime) \(LocalizationKey.hours.localizing()).\n\n\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theSwapWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).\n\n \(LocalizationKey.andTheseTwoEmployeesDoNotHaveTheSameProfession.localizing())", message: "\n\n\(LocalizationKey.doYouStillWantToApproveThisSwapShift.localizing())")
                } else if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theSwapWillChangeTheShiftHoursTo.localizing()) \(finalSwapperAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalSwapperOvertime) \(LocalizationKey.hours.localizing()).\n\n \(LocalizationKey.andTheseTwoEmployeesDoNotHaveTheSameProfession.localizing()).", message: "\n\n\(LocalizationKey.doYouStillWantToApproveThisSwapShift.localizing())")

                } else if requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theSwapWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).\n\n \(LocalizationKey.andTheseTwoEmployeesDoNotHaveTheSameProfession.localizing()).", message: "\n\n\(LocalizationKey.doYouStillWantToApproveThisSwapShift.localizing())")
                }
            }else if selectedRequestShift?.isOvertime ?? false {
                
                if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 && requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theSwapWillChangeTheShiftHoursTo.localizing()) \(finalSwapperAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalSwapperOvertime) \(LocalizationKey.hours.localizing()).\n\n\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod), \(LocalizationKey.theSwapWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).", message: "\n\n\(LocalizationKey.doYouStillWantToApproveThisSwapShift.localizing())")
                } else if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod), \(LocalizationKey.theSwapWillChangeTheShiftHoursTo.localizing()) \(finalSwapperAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalSwapperOvertime) \(LocalizationKey.hours.localizing()).", message: "\n\n\(LocalizationKey.doYouStillWantToApproveThisSwapShift.localizing())")

                } else if requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod), \(LocalizationKey.theSwapWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).", message: "\n\n\(LocalizationKey.doYouStillWantToApproveThisSwapShift.localizing())")
                }
            } else if (selectedRequestShift?.from_user_role ?? "" != selectedRequestShift?.accepted_user_role ?? "") {
                showAlertForCheckSchedule(title: "\(LocalizationKey.theseTwoEmployeesDoNotHaveTheSameProfession.localizing()).", message: "\n\n\(LocalizationKey.doYouStillWantToApproveThisSwapShift.localizing())")
            } else {
                sheetCancelBtn.isHidden = false
                sheetAcceptBtn.isHidden = false
                sheetAcceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
                sheetAcceptBtn.setTitle(LocalizationKey.accept.localizing(), for: .normal)
                sheetMessageLbl.text = LocalizationKey.areYouSureDoYouWantYouAcceptTheRequest.localizing()
                sheetImage.image = UIImage(named: "accept")
    //            selectedRequestShift = requestShift
                selectedAction = "accept"
                
                bottomSheetMainView.isHidden = false
            }
        } else if (selectedRequestShift?.swap_type == "swap-shift"){
            if (selectedRequestShift?.isOvertime ?? false && (selectedRequestShift?.from_user_role ?? "" != selectedRequestShift?.accepted_user_role ?? "")) {
                if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 && requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theTradeWillChangeTheShiftHoursTo.localizing()) \(finalSwapperAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalSwapperOvertime) \(LocalizationKey.hours.localizing()).\n\n\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theTradeWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).\n\n \(LocalizationKey.andTheseTwoEmployeesDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToApproveThisTradeShift.localizing())")
                } else if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theTradeWillChangeTheShiftHoursTo.localizing()) \(finalSwapperAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalSwapperOvertime) \(LocalizationKey.hours.localizing()).\n\n \(LocalizationKey.andTheseTwoEmployeesDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToApproveThisTradeShift.localizing())")
                } else if requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theTradeWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).\n\n \(LocalizationKey.andTheseTwoEmployeesDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToApproveThisTradeShift.localizing())")
                }
            }else if selectedRequestShift?.isOvertime ?? false {
                if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 && requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theTradeWillChangeTheShiftHoursTo.localizing()) \(finalSwapperAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalSwapperOvertime) \(LocalizationKey.hours.localizing()).\n\n\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theTradeWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).", message: "\(LocalizationKey.doYouStillWantToApproveThisTradeShift.localizing())")
                } else if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalSwapperTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theTradeWillChangeTheShiftHoursTo.localizing()) \(finalSwapperAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalSwapperOvertime) \(LocalizationKey.hours.localizing()).", message: "\(LocalizationKey.doYouStillWantToApproveThisTradeShift.localizing())")
                } else if requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
                    showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "") \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theTradeWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).", message: "\(LocalizationKey.doYouStillWantToApproveThisTradeShift.localizing())")
                }
            } else if (selectedRequestShift?.from_user_role ?? "" != selectedRequestShift?.accepted_user_role ?? "") {
                showAlertForCheckSchedule(title: "\(LocalizationKey.theseTwoEmployeesDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToApproveThisTradeShift.localizing())")
            } else {
                sheetCancelBtn.isHidden = false
                sheetAcceptBtn.isHidden = false
                sheetAcceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
                sheetAcceptBtn.setTitle(LocalizationKey.accept.localizing(), for: .normal)
                sheetMessageLbl.text = LocalizationKey.areYouSureDoYouWantYouAcceptTheRequest.localizing()
                sheetImage.image = UIImage(named: "accept")
    //            selectedRequestShift = requestShift
                selectedAction = "accept"
                
                bottomSheetMainView.isHidden = false
            }
        } else {
            if selectedRequestShift?.isOvertime ?? false {
                showAlertForCheckSchedule(title: "\(selectedRequestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? ""): \(LocalizationKey.hasWorked.localizing()) \(finalAcceptorTotal) \(LocalizationKey.hoursThis.localizing()) \(calcPeriod). \(LocalizationKey.theGrabWillChangeTheShiftHoursTo.localizing()) \(finalAcceptorAfterTotal) \(LocalizationKey.hours.localizing()), \(LocalizationKey.resultingInAnOvertimePaymentOf.localizing()) \(finalAcceptorOvertime) \(LocalizationKey.hours.localizing()).", message: "\(LocalizationKey.doYouStillWantToApproveThisGrabShift.localizing())")
            } else {
                sheetCancelBtn.isHidden = false
                sheetAcceptBtn.isHidden = false
                sheetAcceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
                sheetAcceptBtn.setTitle(LocalizationKey.accept.localizing(), for: .normal)
                sheetMessageLbl.text = LocalizationKey.areYouSureDoYouWantYouAcceptTheRequest.localizing()
                sheetImage.image = UIImage(named: "accept")
    //            selectedRequestShift = requestShift
                selectedAction = "accept"
                
                bottomSheetMainView.isHidden = false
            }
        }
    }
    
    func onRejectBtn(requestShift: RequestShift?) {
        sheetCancelBtn.isHidden = false
        sheetAcceptBtn.isHidden = false
        sheetAcceptBtn.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
        sheetAcceptBtn.setTitle(LocalizationKey.reject.localizing(), for: .normal)
        sheetMessageLbl.text = LocalizationKey.areYouSureDoYouWantYouRejectTheRequest.localizing()
        sheetImage.image = UIImage(named: "reject")
        selectedRequestShift = requestShift
        selectedAction = "reject"
        
        bottomSheetMainView.isHidden = false
    }
    
    func onOvertimeBtn(requestShift: RequestShift?) {
        
        let title = "\(LocalizationKey.overtimes.localizing())\n"
        var message = ""

        // swapperTotal
        let swapperTotal = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMins ?? 0)
        
       let finalSwapperTotal = "\(convertValueInDecimal(totalTime: swapperTotal.hours)):\(convertValueInDecimal(totalTime: swapperTotal.leftMinutes))"
        
        
        // swapperAfterTotal
        let swapperAfterTotal = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0)
        
       let finalSwapperAfterTotal = "\(convertValueInDecimal(totalTime: swapperAfterTotal.hours)):\(convertValueInDecimal(totalTime: swapperAfterTotal.leftMinutes))"
        
        
        // swapperOvertime
        let swapperOvertime = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.swapperOvertimeMin ?? 0)
        
       let finalSwapperOvertime = "\(convertValueInDecimal(totalTime: swapperOvertime.hours)):\(convertValueInDecimal(totalTime: swapperOvertime.leftMinutes))"
        
        
        // acceptorTotal
        let acceptorTotal = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMins ?? 0)
        
       let finalAcceptorTotal = "\(convertValueInDecimal(totalTime: acceptorTotal.hours)):\(convertValueInDecimal(totalTime: acceptorTotal.leftMinutes))"
        
        
        // acceptorAfterTotal
        let acceptorAfterTotal = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0)
        
       let finalAcceptorAfterTotal = "\(convertValueInDecimal(totalTime: acceptorAfterTotal.hours)):\(convertValueInDecimal(totalTime: acceptorAfterTotal.leftMinutes))"
        
        
        // acceptorOvertime
        let acceptorOvertime = minutesToHoursAndMinutesOvetime(requestShift?.shiftTransactionOvertimeDetails?.acceptorOvertimeMin ?? 0)
        
       let finalAcceptorOvertime = "\(convertValueInDecimal(totalTime: acceptorOvertime.hours)):\(convertValueInDecimal(totalTime: acceptorOvertime.leftMinutes))"
        
        // Check condition
        if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 && requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
            message = "\("\(LocalizationKey.swapperName.localizing()) : \(requestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "")\n\n\(LocalizationKey.totalScheduleHours.localizing()) : \(finalSwapperTotal)\n\(LocalizationKey.totalHoursAfterSwap.localizing()) : \(finalSwapperAfterTotal)\n\(LocalizationKey.overtime.localizing()) : \(finalSwapperOvertime)\n\n\n\(LocalizationKey.acceptorName.localizing()) : \(requestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "")\n\n\(LocalizationKey.totalScheduleHours.localizing()) : \(finalAcceptorTotal)\n\(LocalizationKey.totalHoursAfterSwap.localizing()) : \(finalAcceptorAfterTotal)\n\(LocalizationKey.overtime.localizing()) : \(finalAcceptorOvertime)")"
        } else if requestShift?.shiftTransactionOvertimeDetails?.swapperShiftTotalMinsAfterSwap ?? 0 > 0 {
            message = "\("\(LocalizationKey.swapperName.localizing()) : \(requestShift?.shiftTransactionOvertimeDetails?.swapperName ?? "")\n\n\(LocalizationKey.totalScheduleHours.localizing()) : \(finalSwapperTotal)\n\(LocalizationKey.totalHoursAfterSwap.localizing()) : \(finalSwapperAfterTotal)\n\(LocalizationKey.overtime.localizing()) : \(finalSwapperOvertime)")"
        } else if requestShift?.shiftTransactionOvertimeDetails?.acceptorShiftTotalMinsAfterSwap ?? 0 > 0 {
            message = "\("\(LocalizationKey.acceptorName.localizing()) : \(requestShift?.shiftTransactionOvertimeDetails?.acceptorName ?? "")\n\n\(LocalizationKey.totalScheduleHours.localizing()) : \(finalAcceptorTotal)\n\(LocalizationKey.totalHoursAfterSwap.localizing()) : \(finalAcceptorAfterTotal)\n\(LocalizationKey.overtime.localizing()) : \(finalAcceptorOvertime)")"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        alert.addAction(UIAlertAction(title: LocalizationKey.ok.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SwapTradesPMVC{
    private func swapTradesList(){
        var param = [String:Any]()
        ScheduleListVM.shared.swapTradesListForPm(parameters: param){ [self] obj in
//            self.requestTradesList = obj.rows?.filter({ $0.is_approved != true && $0.is_rejected != true }) ?? []
            self.requestTradesList = obj.rows?.filter({ $0.is_approved != true && $0.is_rejected != true && $0.is_accepted == true }) ?? []

            self.SwapTradesListTblVw.reloadData()
        }
    }
    private func swapTradesMyList(){
        var param = [String:Any]()
//        param["myTransactions"] = "true"
        
        print(param)
        
        ScheduleListVM.shared.swapTradesListForPm(parameters: param){ [self] obj in
//            self.myRequestTradesList = obj.rows ?? []
            self.myRequestTradesList = obj.rows?.filter({ $0.is_approved == true || $0.is_rejected == true }) ?? []
            self.SwapTradesListTblVw.reloadData()
        }
    }
    private func swapAcceptedRejected(status:String){
        var param = [String:Any]()
        param["shift_id"] = selectedRequestShift?.shift_id
        param["swap_id"] = selectedRequestShift?.swap_id
        param["swap_history_id"] = selectedRequestShift?.swap_history_id
        param["toUser"] = selectedRequestShift?.accepted_id
        param["status"] = status
        
        ScheduleListVM.shared.swapAcceptedRejectedByPm(parameters: param){ [self] obj in
            bottomSheetMainView.isHidden = true
            swapTradesList()
        }
    }
    
    private func tradeAcceptedRejected(status:String){
        var param = [String:Any]()
        
        param["from_shift_id"] = selectedRequestShift?.shift_id
        param["from_user_id"] = selectedRequestShift?.from_user_id
        param["status"] = status
        param["swap_history_id"] = selectedRequestShift?.swap_history_id
        param["swap_id"] = selectedRequestShift?.swap_id
        param["toUser"] = selectedRequestShift?.accepted_id

        ScheduleListVM.shared.tradeAcceptedRejectedByPm(parameters: param){ [self] obj in
            bottomSheetMainView.isHidden = true
            swapTradesList()
        }
    }
}

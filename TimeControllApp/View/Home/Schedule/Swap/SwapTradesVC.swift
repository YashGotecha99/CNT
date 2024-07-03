//
//  SwapTradesVC.swift
//  TimeControllApp
//
//  Created by yash on 11/01/23.
//

import UIKit

class SwapTradesVC: BaseViewController {
    
    @IBOutlet weak var SwapTradesListTblVw: UITableView!
    @IBOutlet weak var scheduleSegmentControl: UISegmentedControl!
    @IBOutlet weak var bottomSheetMainView: UIView!
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var sheetAcceptBtn: UIButton!
    @IBOutlet weak var sheetCancelBtn: UIButton!
    @IBOutlet weak var sheetMessageLbl: UILabel!
    @IBOutlet weak var sheetImage: UIImageView!
    @IBOutlet weak var swapTradesTitleLbl: UILabel!
    
    var requestTradesList : [FormattedRequestShifts] = []
    
    var myRequestTradesList : [FormattedRequestShifts] = []
    
    var selectedRequestShift : RequestShift?
    
    var selectedAction = ""
    
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
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        swapTradesTitleLbl.text = LocalizationKey.schedule.localizing()
        scheduleSegmentControl.setTitle(LocalizationKey.newRequests.localizing(), forSegmentAt: 0)
        scheduleSegmentControl.setTitle(LocalizationKey.mySwapsTrades.localizing(), forSegmentAt: 1)
        sheetMessageLbl.text = LocalizationKey.thankYouForAcceptingTheRequestTheManagerHasBeenInformedPleaseWaitForTheApproval.localizing()
        sheetAcceptBtn.setTitle(LocalizationKey.accept.localizing(), for: .normal)
        sheetCancelBtn.setTitle(LocalizationKey.cancel.localizing(), for: .normal)
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
        
        SwapTradesListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SwapTradesTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SwapTradesTVC.rawValue)
        SwapTradesListTblVw.register(UINib.init(nibName: "DateHeaderView", bundle: .main), forHeaderFooterViewReuseIdentifier: "DateHeaderView")
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
            swapAccepted()
        } else if selectedAction == "reject"{
            swapRejected()
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
            self.swapAccepted()
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension SwapTradesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 0
        if scheduleSegmentControl.selectedSegmentIndex == 0 {
            count = requestTradesList.count
        } else if scheduleSegmentControl.selectedSegmentIndex == 1 {
            count = myRequestTradesList.count
        }
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noTradeRequestAvailable.localizing()
            noDataLabel.textColor     = Constant.appColor
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            noDataLabel.lineBreakMode = .byWordWrapping
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            
        }else{
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleSegmentControl.selectedSegmentIndex == 0 {
            return requestTradesList[section].data?.count ?? 0
        } else if scheduleSegmentControl.selectedSegmentIndex == 1 {
            return myRequestTradesList[section].data?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SwapTradesTVC.rawValue, for: indexPath) as? SwapTradesTVC else { return UITableViewCell() }
//        if scheduleSegmentControl.selectedSegmentIndex == 0 {
//            cell.rejectBtn.isHidden = false
//            cell.acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
//
//            cell.acceptBtn.setTitle("Accept", for: .normal)
//            cell.acceptBtnWidth.constant = 85
//        } else {
//            cell.rejectBtn.isHidden = true
//            if indexPath.row == 0 {
//                cell.acceptBtn.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
//                cell.acceptBtn.setTitle("Cancel", for: .normal)
//                cell.acceptBtnWidth.constant = 85
//            } else if indexPath.row == 1 {
//                cell.acceptBtn.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
//                cell.acceptBtn.setTitle("Swapped", for: .normal)
//                cell.acceptBtnWidth.constant = 85
//            } else {
//                cell.acceptBtn.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
//                cell.acceptBtn.setTitle("Awaiting PM", for: .normal)
//                cell.acceptBtnWidth.constant = 110
//            }
//        }
        if scheduleSegmentControl.selectedSegmentIndex == 0 {
            guard let obj = requestTradesList[indexPath.section].data?[indexPath.row] else {return UITableViewCell()}
            cell.setCellValue(requestShift: obj,selectedSegmentIndex:0)
            cell.delegate = self
            return cell
        } else if scheduleSegmentControl.selectedSegmentIndex == 1 {
            guard let obj = myRequestTradesList[indexPath.section].data?[indexPath.row] else {return UITableViewCell()}
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SwapTradesListTblVw.dequeueReusableHeaderFooterView(withIdentifier: "DateHeaderView") as? DateHeaderView
        if scheduleSegmentControl.selectedSegmentIndex == 0 {
            //MARK: Change the date formate from configuration
//            headerView?.dateLbl.text = requestTradesList[section].for_date
            headerView?.dateLbl.text = requestTradesList[section].for_date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        } else if scheduleSegmentControl.selectedSegmentIndex == 1 {
            //MARK: Change the date formate from configuration
            headerView?.dateLbl.text = myRequestTradesList[section].for_date?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}
extension SwapTradesVC: SwapTradesTVCDelegate {
    
    func onAcceptBtn(requestShift: RequestShift?) {
        selectedRequestShift = requestShift
        
        if selectedRequestShift?.swap_type == "trade-shift" {
            if ((selectedRequestShift?.isAnomaly ?? 0 > 0) && (selectedRequestShift?.from_user_role ?? "" != selectedRequestShift?.accepted_user_role ?? "")) {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAreScheduledToHaveFewerWorkingHoursComparedToTheShiftYouWantToSwapWithYourColleague.localizing()).\n\n \(LocalizationKey.andYouAndYourColleagueDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToGoAhead.localizing())?")
            } else if ((selectedRequestShift?.isAnomaly ?? 0 < 0) && (selectedRequestShift?.from_user_role ?? ""  != selectedRequestShift?.accepted_user_role ?? "")) {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAreScheduledToHaveMoreWorkingHoursComparedToTheShiftYouWantToSwapWithYourColleague.localizing()).\n\n \(LocalizationKey.andYouAndYourColleagueDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToGoAhead.localizing())?")
            } else if (selectedRequestShift?.isAnomaly ?? 0 > 0) {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAreScheduledToHaveFewerWorkingHoursComparedToTheShiftYouWantToSwapWithYourColleague.localizing()).", message: "\(LocalizationKey.doYouStillWantToGoAhead.localizing())?")
            } else if (selectedRequestShift?.isAnomaly ?? 0 < 0) {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAreScheduledToHaveMoreWorkingHoursComparedToTheShiftYouWantToSwapWithYourColleague.localizing()).", message: "\(LocalizationKey.doYouStillWantToGoAhead.localizing())?")
            } else if (selectedRequestShift?.from_user_role ?? ""  != selectedRequestShift?.accepted_user_role ?? "") {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAndYourColleagueDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToSwapThisShift.localizing())?")
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
        } else if selectedRequestShift?.swap_type == "swap-shift" {
            if ((selectedRequestShift?.isAnomaly ?? 0 > 0) && (selectedRequestShift?.from_user_role ?? "" != selectedRequestShift?.accepted_user_role ?? "")) {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAreScheduledToHaveFewerWorkingHoursComparedToTheShiftYouWantToTradeWithYourColleague.localizing()).\n\n \(LocalizationKey.andYouAndYourColleagueDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToGoAhead.localizing())?")
            } else if ((selectedRequestShift?.isAnomaly ?? 0 < 0) && (selectedRequestShift?.from_user_role ?? ""  != selectedRequestShift?.accepted_user_role ?? "")) {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAreScheduledToHaveMoreWorkingHoursComparedToTheShiftYouWantToTradeWithYourColleague.localizing()).\n\n \(LocalizationKey.andYouAndYourColleagueDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToGoAhead.localizing())?")
            } else if (selectedRequestShift?.isAnomaly ?? 0 > 0) {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAreScheduledToHaveFewerWorkingHoursComparedToTheShiftYouWantToTradeWithYourColleague.localizing()).", message: "\(LocalizationKey.doYouStillWantToGoAhead.localizing())?")
            } else if (selectedRequestShift?.isAnomaly ?? 0 < 0) {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAreScheduledToHaveMoreWorkingHoursComparedToTheShiftYouWantToTradeWithYourColleague.localizing()).", message: "\(LocalizationKey.doYouStillWantToGoAhead.localizing())?")
            } else if (selectedRequestShift?.from_user_role ?? ""  != selectedRequestShift?.accepted_user_role ?? "") {
                showAlertForCheckSchedule(title: "\(LocalizationKey.heyYouAndYourColleagueDoNotHaveTheSameProfession.localizing()).", message: "\(LocalizationKey.doYouStillWantToSwapThisShift.localizing())?")
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
    
    
}

//MARK: APi Work in View controller
extension SwapTradesVC{
    private func swapTradesList(){
        var param = [String:Any]()
        param["isMobile"] = "true"
        param["pendingOnly"] = "true"
        param["swap_trade_shift"] = "true"
        ScheduleListVM.shared.swapTradesList(parameters: param){ [self] obj in
            self.requestTradesList = obj.formattedShifts ?? []
            self.SwapTradesListTblVw.reloadData()
        }
    }
    private func swapTradesMyList(){
        var param = [String:Any]()
        param["myTransactions"] = "true"
        param["isMobile"] = "true"
        param["swap_trade_shift"] = "true"

        print(param)
        
        ScheduleListVM.shared.swapTradesMyList(parameters: param){ [self] obj in
            self.myRequestTradesList = obj.formattedShifts ?? []
            self.SwapTradesListTblVw.reloadData()
        }
    }
    private func swapAccepted(){
        var param = [String:Any]()
        param["shift_id"] = selectedRequestShift?.shift_id
        param["swap_id"] = selectedRequestShift?.swap_id
        param["swap_history_id"] = selectedRequestShift?.swap_history_id
        ScheduleListVM.shared.swapAccepted(parameters: param){ [self] obj in
            bottomSheetMainView.isHidden = true
            swapTradesList()
        }
    }
    
    private func swapRejected(){
        var param = [String:Any]()
        param["shift_id"] = selectedRequestShift?.shift_id
        param["swap_id"] = selectedRequestShift?.swap_id
        param["swap_history_id"] = selectedRequestShift?.swap_history_id
        ScheduleListVM.shared.swapRejected(parameters: param){ [self] obj in
            bottomSheetMainView.isHidden = true
            swapTradesList()
        }
    }
}


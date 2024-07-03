//
//  UpToGrabsListVC.swift
//  TimeControllApp
//
//  Created by yash on 30/01/23.
//

import UIKit

class UpToGrabsListVC: BaseViewController {
    
    @IBOutlet weak var UpToGrabsTblVw: UITableView!
    var upToGrabsList : [FormattedRequestShifts] = []

    @IBOutlet weak var bottomSheet: UIView!
    var selectedIndexPathRow = 0
    var selectedIndexPathSection = 0
    
    //MARK: Localizations
    @IBOutlet weak var upToGrabsTitleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization() {
        upToGrabsTitleLbl.text = LocalizationKey.upForGrabs.localizing()
        messageLbl.text = LocalizationKey.thankYouForTakingTheShiftTheManagerHasBeenInformedPleaseWaitForTheApproval.localizing()
    }
    
    func configUI() {
        bottomSheet.isHidden = true
        self.UpToGrabsTblVw.separatorColor = UIColor.clear
        UpToGrabsTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.UpToGrabsListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.UpToGrabsListTVC.rawValue)
        UpToGrabsTblVw.register(UINib.init(nibName: "DateHeaderView", bundle: .main), forHeaderFooterViewReuseIdentifier: "DateHeaderView")
        grabShiftList()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func grabBtnAction(sender: UIButton){
        let selectedIndexpath = sender.tag
        
        grabAccepted(shiftId: upToGrabsList[selectedIndexPathSection].data?[selectedIndexPathRow].shift_id ?? 0, swapId: upToGrabsList[selectedIndexPathSection].data?[selectedIndexPathRow].swap_id ?? 0, swapHistoryId: upToGrabsList[selectedIndexPathSection].data?[selectedIndexPathRow].swap_history_id ?? 0)
    }
    
    @IBAction func closeBottomAction(_ sender: Any) {
        bottomSheet.isHidden = true
        grabShiftList()
    }
    
}


//MARK: - TableView DataSource and Delegate Methods
extension UpToGrabsListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = 0
        count = upToGrabsList.count
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.notAvailable.localizing()
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
        return upToGrabsList[section].data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.UpToGrabsListTVC.rawValue, for: indexPath) as? UpToGrabsListTVC else { return UITableViewCell() }

        cell.selectionStyle = .none
        guard let obj = upToGrabsList[indexPath.section].data?[indexPath.row] else {return UITableViewCell()}
        cell.setCellValue(requestShift: obj,selectedSegmentIndex:0)
        cell.delegate = self
//        cell.grabBtn.tag = indexPath.row
//        if (!(obj.is_accepted ?? false)) {
//            cell.grabBtn.addTarget(self, action: #selector(grabBtnAction(sender:)), for: .touchUpInside)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPathRow = indexPath.row
        selectedIndexPathSection = indexPath.section
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UpToGrabsTblVw.dequeueReusableHeaderFooterView(withIdentifier: "DateHeaderView") as? DateHeaderView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let grabDate = dateFormatter.date(from: upToGrabsList[section].for_date ?? "")
        let dateFormatter1 = DateFormatter()
        
        //MARK: Change the date formate from configuration
//        dateFormatter1.dateFormat = "dd MMM yyyy"
        dateFormatter1.dateFormat = GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format

        let grabDateSection = dateFormatter1.string(from: grabDate ?? Date())
        
        headerView?.dateLbl.text = grabDateSection
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

// Tableview button click event delegate
extension UpToGrabsListVC: UpToGrabButtonClickedTVCDelegate {
    
    func onGrabBtnClicked(cell: UpToGrabsListTVC) {
        let indexPathData = self.UpToGrabsTblVw.indexPath(for: cell)
        
        grabAccepted(shiftId: upToGrabsList[indexPathData?.section ?? 0].data?[indexPathData?.row ?? 0].shift_id ?? 0, swapId: upToGrabsList[indexPathData?.section ?? 0].data?[indexPathData?.row ?? 0].swap_id ?? 0, swapHistoryId: upToGrabsList[indexPathData?.section ?? 0].data?[indexPathData?.row ?? 0].swap_history_id ?? 0)
    }
}

//MARK: APi Work in View controller
extension UpToGrabsListVC{
    private func grabShiftList(){
        var param = [String:Any]()
        param["isMobile"] = "true"
        param["grab_shift"] = "true"
        ScheduleListVM.shared.swapTradesList(parameters: param){ [self] obj in
            print("Grab Shift is : ", obj)
            self.upToGrabsList = obj.formattedShifts ?? []
            self.UpToGrabsTblVw.reloadData()
        }
    }
    
    private func grabAccepted(shiftId: Int, swapId: Int, swapHistoryId: Int){
        var param = [String:Any]()
        param["shift_id"] = shiftId
        param["swap_id"] = swapId
        param["swap_history_id"] = swapHistoryId
        
        ScheduleListVM.shared.swapAccepted(parameters: param){ [self] obj in
            bottomSheet.isHidden = false
//            bottomSheetMainView.isHidden = true
//            swapTradesList()
        }
    }
}

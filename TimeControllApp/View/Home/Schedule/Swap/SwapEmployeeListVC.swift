//
//  SwapEmployeeListVC.swift
//  TimeControllApp
//
//  Created by yash on 10/01/23.
//

import UIKit

class SwapEmployeeListVC: BaseViewController {
    
    @IBOutlet weak var employeeTblVw: UITableView!
    @IBOutlet weak var swapEmployeeListTitleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var employeeList : [ShiftByUser] = []
    
    var for_date = ""
    var tradeshift = ""
    
    var selectedShiftArray : [ShiftsOfUser] = []
    
    var delegate =  SwapDetailsVC()
    
    @IBOutlet weak var staticMessageSwapLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        swapEmployeeListTitleLbl.text = LocalizationKey.schedule.localizing()
        saveBtn.setTitle(LocalizationKey.save.localizing(), for: .normal)
        staticMessageSwapLbl.text = LocalizationKey.employeesAvailableForSwapingAShift.localizing()
    }
    
    func configUI() {
        shiftsListApi(date: for_date, tradeshiftId: tradeshift)
        self.employeeTblVw.separatorColor = UIColor.clear
        employeeTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SwapEmployeeTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SwapEmployeeTVC.rawValue)
    }

    @IBAction func btnSave(_ sender: Any) {
        delegate.selectedShiftArray = self.selectedShiftArray
        if selectedShiftArray.count > 0 {
            delegate.employeeTblVw.isHidden = false
            delegate.contentViewHeight.constant = CGFloat(470 + (240*selectedShiftArray.count))
        }
        delegate.employeeTblVw.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: - TableView DataSource and Delegate Methods
extension SwapEmployeeListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0

        var count = employeeList.count
        if count < 1 {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = LocalizationKey.noEmployeeAvailable.localizing()
            noDataLabel.textColor     = Constant.appColor
            noDataLabel.textAlignment = .center
            noDataLabel.numberOfLines = 0
            noDataLabel.lineBreakMode = .byWordWrapping
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            staticMessageSwapLbl.isHidden = true
        }else{
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
            staticMessageSwapLbl.isHidden = false
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SwapEmployeeTVC.rawValue, for: indexPath) as? SwapEmployeeTVC else { return UITableViewCell() }
        let obj = employeeList[indexPath.row]
        cell.setCellValue(shiftsByUser: obj, date: for_date, row: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = employeeList[indexPath.row]
        return CGFloat(((obj.shifts?.count ?? 0) + 1)*115)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension SwapEmployeeListVC{
    private func shiftsListApi(date : String,tradeshiftId: String){
       var param = [String:Any]()
        param["for_date"] = date
        param["tradeshift"] = tradeshiftId
        
        ScheduleListVM.shared.shiftsList(parameters: param){ [self] obj in
            employeeList = obj
            self.employeeTblVw.reloadData()
        }
       
   }
}


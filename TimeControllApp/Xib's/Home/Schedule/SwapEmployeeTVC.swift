//
//  SwapEmployeeTVC.swift
//  TimeControllApp
//
//  Created by yash on 10/01/23.
//

import UIKit

class SwapEmployeeTVC: UITableViewCell {
    
  
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var shiftTableView: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var profilePhotoImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var roleLbl: UILabel!
    @IBOutlet weak var dateLeading: NSLayoutConstraint!
    @IBOutlet weak var staticRoleDepartmentLbl: UILabel!
    
    var shiftArray : [ShiftsOfUser] = []
    
    var delegate = SwapEmployeeListVC()
    
    var selectedRow = -1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shiftTableView.register(UINib.init(nibName: TABLE_VIEW_CELL.MemberShiftTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.MemberShiftTVC.rawValue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValue(shiftsByUser:ShiftByUser,date:String,row:Int){
        if row == 0 {
            //MARK: Change the date formate from configuration
//            dateLbl.text = date.convertAllFormater(formated: "dd.MM.yyyy")
            dateLbl.text = date.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")

            dateLbl.isHidden = false
            roundView.isHidden = false
        } else {
            dateLbl.isHidden = true
            roundView.isHidden = true
        }
        lineView.isHidden = false
        dateLeading.constant = 34
        nameLbl.text = shiftsByUser.userName
        roleLbl.text = shiftsByUser.role
        shiftArray = shiftsByUser.shifts ?? []
        shiftTableView.allowsSelection = true
        shiftTableView.reloadData()
    }
    
    func setCellValue(shiftsOfUser:ShiftsOfUser){
        dateLbl.isHidden = true
        roundView.isHidden = true
        lineView.isHidden = true
        dateLeading.constant = 20
        nameLbl.text = shiftsOfUser.full_name
        roleLbl.text = shiftsOfUser.role
        shiftArray = []
        shiftArray.append(shiftsOfUser)
        shiftTableView.allowsSelection = false
        shiftTableView.reloadData()
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension SwapEmployeeTVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.MemberShiftTVC.rawValue, for: indexPath) as? MemberShiftTVC else { return UITableViewCell() }
        let obj = shiftArray[indexPath.row]
        cell.setCellValue(shift: obj)
        
        if self.selectedRow == indexPath.row {
            cell.checkboxImg.image = UIImage(named: "SelectedTickSquare")
        } else {
            cell.checkboxImg.image = UIImage(named: "UnselectTickSquare")
        }
        if dateLeading.constant == 20 {
            cell.checkboxImg.isHidden = true
        } else {
            cell.checkboxImg.isHidden = false
        }
        
        cell.delegate = self.delegate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MemberShiftTVC else {
            return
        }
        if self.selectedRow == indexPath.row {
            if let idx = self.delegate.selectedShiftArray.firstIndex(where: { $0.id == cell.selectedShift?.id }) {
                self.delegate.selectedShiftArray.remove(at: idx)
            }
            self.selectedRow = -1
        } else {
            self.selectedRow = indexPath.row
            if let idx = self.delegate.selectedShiftArray.firstIndex(where: { $0.id == cell.selectedShift?.id }) {
                self.delegate.selectedShiftArray.remove(at: idx)
            }
            self.delegate.selectedShiftArray.append(cell.selectedShift!)
        }
        self.shiftTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

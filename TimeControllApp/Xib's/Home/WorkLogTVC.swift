//
//  WorkLogTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 04/07/22.
//

import UIKit

class WorkLogTVC: UITableViewCell {

    @IBOutlet weak var allWorkLogtblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var allWorkLogtblView: UITableView!
    
    var lastThreeWorkLog = [lastWorkLogModel]()
    @IBOutlet weak var lastWorkLogsLbl: UILabel!
    @IBOutlet weak var seeAllBtnObj: UnderlineTextButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        allWorkLogtblView.delegate = self
        allWorkLogtblView.dataSource = self
        allWorkLogtblView.reloadData()
        // Initialization code
    }

    func setupLocalizationData() {
        lastWorkLogsLbl.text = LocalizationKey.lastWorkLog.localizing()
        seeAllBtnObj.setTitle(LocalizationKey.seeAll.localizing(), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - TableView DataSource and Delegate Methods
extension WorkLogTVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastThreeWorkLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.AllWorkLogTVC.rawValue, for: indexPath) as? AllWorkLogTVC else { return UITableViewCell() }
        cell.workLogNameLbl.text = lastThreeWorkLog[indexPath.row].name
        
        //MARK: Change the date formate from configuration

//        cell.workLogDateTimeLbl.text = "\(lastThreeWorkLog[indexPath.row].forDate.convertAllFormater(formated: "dd.MM")) \(logTime(time: lastThreeWorkLog[indexPath.row].from)) - \(logTime(time: lastThreeWorkLog[indexPath.row].to))"
        cell.workLogDateTimeLbl.text = "\(lastThreeWorkLog[indexPath.row].forDate.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "")) \(logTime(time: lastThreeWorkLog[indexPath.row].from)) - \(logTime(time: lastThreeWorkLog[indexPath.row].to))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}



class AllWorkLogTVC: UITableViewCell {
    
    @IBOutlet weak var workLogDateTimeLbl: UILabel!
    @IBOutlet weak var workLogNameLbl: UILabel!
    
}

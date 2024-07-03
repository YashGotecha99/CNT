//
//  ReportVC.swift
//  TimeControllApp
//
//  Created by mukesh on 31/07/22.
//

import UIKit

class ReportVC: BaseViewController {
    
    @IBOutlet weak var reportTitleLbl: UILabel!

    @IBOutlet weak var reportListTblVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        reportTitleLbl.text = LocalizationKey.reports.localizing()
    }
    
    func configUI() {
        reportListTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ReportListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ReportListTVC.rawValue)
        
        reportListTblVw.reloadData()
    }


}

//MARK: - TableView DataSource and Delegate Methods
extension ReportVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ReportListTVC.rawValue, for: indexPath) as? ReportListTVC
        else { return UITableViewCell() }
        
        cell.employeePayloadLbl.text = LocalizationKey.employeePayrollReport.localizing()
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddReportVC") as! AddReportVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

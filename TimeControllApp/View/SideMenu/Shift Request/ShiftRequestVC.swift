//
//  ShiftRequestVC.swift
//  TimeControllApp
//
//  Created by mukesh on 24/07/22.
//

import UIKit

class ShiftRequestVC: BaseViewController {

    @IBOutlet weak var shiftRequestsTitleLbl: UILabel!
    @IBOutlet weak var shiftRequestTblVw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        shiftRequestsTitleLbl.text = LocalizationKey.shiftRequests.localizing()
    }
    
    func configUI() {
        shiftRequestTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ShiftRequestDetailTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ShiftRequestDetailTVC.rawValue)
        
        shiftRequestTblVw.reloadData()
    }
    

}

//MARK: - TableView DataSource and Delegate Methods
extension ShiftRequestVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ShiftRequestDetailTVC.rawValue, for: indexPath) as? ShiftRequestDetailTVC
        else { return UITableViewCell() }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

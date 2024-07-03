//
//  AddChildVC.swift
//  TimeControllApp
//
//  Created by prashant on 13/06/23.
//

import Foundation
import UIKit

protocol SelectChildProtocol {
    
    func selectedChild(selectedChildData: Kids, selectedChildIndex : Int)
}

class AddChildVC: BaseViewController {
    
    @IBOutlet weak var staticSelectChildLbl: UILabel!
    @IBOutlet weak var selectChildTblVw: UITableView!
    @IBOutlet weak var btnApplyObj: UIButton!
    
    var kidsData : [Kids] = []
    var selectedIndex = -1
    var delegate : SelectChildProtocol?
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
    }
    
    func setUpLocalization(){
        staticSelectChildLbl.text = LocalizationKey.selectChild.localizing()
        btnApplyObj.setTitle(LocalizationKey.apply.localizing(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hitGetChildDataApi(id: UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
    }
    
    
    //MARK: Functions
    func configUI() {
      //  projectListtblView.tableFooterView = vwFooter
        
        selectChildTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.ChildListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue)
      //  projectListtblView.reloadData()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
        self.dismiss(animated: true)
        if selectedIndex != -1 {
            delegate?.selectedChild(selectedChildData: kidsData[selectedIndex], selectedChildIndex: selectedIndex + 1)
        } else {
            showAlert(message: LocalizationKey.pleaseSelectChild.localizing(), strtitle: LocalizationKey.error.localizing())
        }
    }
    
}

//MARK: - TableView DataSource and Delegate Methods
extension AddChildVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return kidsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue, for: indexPath) as? ChildListTVC
        else { return UITableViewCell() }
                
        cell.setData(childData: kidsData[indexPath.row])
        
        if selectedIndex == indexPath.row {
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
        selectedIndex = indexPath.row
        selectChildTblVw.reloadData()
    }
}

//MARK: Extension Api's
extension AddChildVC {
    
    func hitGetChildDataApi(id: String) -> Void {
        var param = [String:Any]()
        AllUsersVM.shared.getUsersDetailsApi(parameters: param, id: id, isAuthorization: true) { [self] obj,responseData  in
            kidsData = obj.user?.data?.kids ?? []
            if kidsData.count < 1 {
//                noDataView.isHidden = false
            } else {
//                noDataView.isHidden = true
            }
            selectChildTblVw.reloadData()
        }
    }
}


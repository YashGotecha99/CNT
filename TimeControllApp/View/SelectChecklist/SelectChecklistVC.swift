//
//  SelectChecklistVC.swift
//  TimeControllApp
//
//  Created by yash on 03/03/23.
//

import UIKit

protocol SelectChecklistProtocol {
    
    func checkListId(checklistId: String, checklistName: String)
}

class SelectChecklistVC: BaseViewController {
    
    @IBOutlet weak var selectChecklistTitleLbl: UILabel!
    
    @IBOutlet weak var checkListtblView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    
    var arrRows : [ChecklistsRows]?
    
    var selectedIndex = -1
    
    @IBOutlet weak var txtSearch: UITextField!
    var delegate : SelectChecklistProtocol?
    var filterArrRows : [ChecklistsRows]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        selectChecklistTitleLbl.text = LocalizationKey.selectChecklist.localizing()
        applyBtn.setTitle(LocalizationKey.apply.localizing(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        hitChecklistApi()
    }
    
    //MARK: Functions
    func configUI() {
      //  projectListtblView.tableFooterView = vwFooter
        
        checkListtblView.register(UINib.init(nibName: TABLE_VIEW_CELL.ProjectListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ProjectListTVC.rawValue)
      //  projectListtblView.reloadData()
    }
    
    //MARK: Button Actions
    
    
    @IBAction func btnClickedBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
//    @IBAction func btnBackAction(_ sender: UIButton) {
//
//        self.dismiss(animated: true)
//    }
    
    @IBAction func btnApplyAction(_ sender: UIButton) {
        
        self.dismiss(animated: true)

        if selectedIndex != -1 {
            
            guard  let checklistData = filterArrRows?[selectedIndex] else {
                
                return
            }
            
            delegate?.checkListId(checklistId: "\(checklistData.id ?? 0)", checklistName: checklistData.name ?? "")
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

}

//MARK: - TableView DataSource and Delegate Methods
extension SelectChecklistVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return filterArrRows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ProjectListTVC.rawValue, for: indexPath) as? ProjectListTVC
        else { return UITableViewCell() }
      
    
        guard  let checklistData = filterArrRows?[indexPath.row] else {
            return cell
        }

        cell.setData(data: checklistData)
                
        if selectedIndex == indexPath.row {
            
            cell.btnSelect.setImage(UIImage(named: "selectRadioIcon"), for: .normal)

        }
        else {
            
            cell.btnSelect.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        selectedIndex = indexPath.row

        checkListtblView.reloadData()
        
    }
}

extension SelectChecklistVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if currentText.isEmpty {
            hitChecklistApi()
        } else {
            filterArrRows = arrRows?.filter { arrCheckListData in
                guard let nameData = arrCheckListData.name else { return false }
                return nameData.lowercased().contains(currentText.lowercased())
            }
        }
        checkListtblView.reloadData()
        return true
    }
}


//MARK: Extension Api's
extension SelectChecklistVC {
    
    func hitChecklistApi() -> Void {
        
        CheckListVM.shared.getUsersChecklist(isAuthorization: true) { [self] obj in
            
           // self.arrProjects = obj
            
            self.arrRows = obj
            self.filterArrRows = self.arrRows
            checkListtblView.reloadData()
        }
    }
}

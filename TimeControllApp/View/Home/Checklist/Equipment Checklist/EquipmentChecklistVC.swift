//
//  EquipmentChecklistVC.swift
//  TimeControllApp
//
//  Created by mukesh on 06/08/22.
//

import UIKit

protocol ChecklistVCDelegate: AnyObject {
    func checkChecklistSegmentIndex(segmentIndex: Int)
}

class EquipmentChecklistVC: BaseViewController {

    @IBOutlet weak var equipmentTblVw: UITableView!
    
    @IBOutlet weak var checklistLbl: UILabel!
    
    @IBOutlet weak var openImgView: UIView!
    
    @IBOutlet weak var bigImg: UIImageView!
    
    var checkList : ChecklistsRows?
    
    var selectedCheckList : ChecklistsRows?
    
    var selectedChecklistSegmmentIndex = Int()
    weak var delegate : ChecklistVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        configUI()
    }
  
    func setUpLocalization(){
        checklistLbl.text = LocalizationKey.checklist.localizing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkListDetailsApi(id: "\(selectedCheckList?.id ?? 0)")
    }
    func configUI() {
        equipmentTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.CheckListStatusTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.CheckListStatusTVC.rawValue)
        
        equipmentTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.PowerOffCheckListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.PowerOffCheckListTVC.rawValue)
        
        equipmentTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.MainElementTableTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.MainElementTableTVC.rawValue)
//        checkListDetailsApi(id: "\(selectedCheckList?.id ?? 0)")
        
        equipmentTblVw.estimatedRowHeight = 60
        equipmentTblVw.rowHeight = UITableView.automaticDimension
        openImgView.isHidden = true
    }
    
    func popUpImage(path:URL?){
        openImgView.isHidden = false
        bigImg.sd_setImage(with: path , placeholderImage: UIImage(named: "docImg.png"))
    }
    
    @IBAction func crossBtnAction(_ sender: Any) {
        openImgView.isHidden = true
    }
    
    @IBAction func btnBackChecklistAction(_ sender: Any) {
        delegate?.checkChecklistSegmentIndex(segmentIndex: selectedChecklistSegmmentIndex)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension EquipmentChecklistVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return checkList?.element_data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.CheckListStatusTVC.rawValue, for: indexPath) as? CheckListStatusTVC else { return UITableViewCell() }
            guard let c = checkList else {
                return UITableViewCell()
            }
            guard let s = selectedCheckList else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setCellValue(selectedCheckList: s, checkList: c , checkListId: selectedCheckList?.id ?? 0)
            return cell
        }
        
        guard let mainElement = checkList?.element_data?[indexPath.row] else {
            return UITableViewCell()
        }
        if mainElement.elements?.count ?? 0 > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.MainElementTableTVC.rawValue, for: indexPath) as? MainElementTableTVC else { return UITableViewCell() }
            guard let checkList = selectedCheckList else {return UITableViewCell()}
            cell.setCellValue(elementData: mainElement, checkListId: selectedCheckList?.id ?? 0, selectedChecklists: checkList)
            cell.updateTableviews()
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.PowerOffCheckListTVC.rawValue, for: indexPath) as? PowerOffCheckListTVC else { return UITableViewCell() }
            guard let checkList = selectedCheckList else {return UITableViewCell()}
            cell.setCellValue(element: mainElement, checkListId: selectedCheckList?.id ?? 0, isFromMain: true, selectedChecklists: checkList, selectedCheckListElementData: mainElement)
            cell.updateTableviews()
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//        if indexPath.section == 0 {
//            return UITableView.automaticDimension
//        }else {
//            guard let mainElement = checkList?.element_data?[indexPath.row] else {
//                return 0
//            }
//            if mainElement.elements?.count ?? 0 > 0 {
//                var width : CGFloat = CGFloat()
//                for obj in mainElement.elements ?? [] {
//                    width = width + CGFloat((obj.elements?.count ?? 0) * 360) + 280
//                }
//                width = width + 360
//                return width
//            } else {
//                return UITableView.automaticDimension
//            }
//        }
//        return 3000
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
}

//MARK: APi Work in View controller
extension EquipmentChecklistVC{
     func checkListDetailsApi(id : String){
       CheckListVM.shared.checkListDetails(id: id) { [self] obj in
           self.checkList = obj.checklist?[0]
           self.equipmentTblVw.reloadData()
           self.equipmentTblVw.layoutIfNeeded()
           self.equipmentTblVw.beginUpdates()
           self.equipmentTblVw.endUpdates()
           self.equipmentTblVw.reloadData()
       }
   }
}

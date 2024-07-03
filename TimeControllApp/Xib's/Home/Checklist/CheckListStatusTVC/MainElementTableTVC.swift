//
//  MainElementTableTVC.swift
//  TimeControllApp
//
//  Created by yash on 22/02/23.
//

import UIKit

class MainElementTableTVC: UITableViewCell {
    

    @IBOutlet weak var detailsTblVw: CustomTableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentByUserLbl: UILabel!
    
    @IBOutlet weak var adminCollectionVw: UICollectionView!
    @IBOutlet weak var memberCollectionVw: UICollectionView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var adminAttachmentsView: UIView!
    @IBOutlet weak var commentByMemberView: UIView!
    @IBOutlet weak var memberAttachmentsView: UIView!
    
    var mainElement : Elements?
    
    var selectedCheckList : ChecklistsRows?
    
    var checkListID = 0
    
    var adminAttachmentsArray : [String] = []
    
    var memberAttachmentsArray : [String] = []
    
    var delegate = EquipmentChecklistVC()
    
    var mainElementTopHeight = 34
    
    @IBOutlet weak var staticInfoFromAdmin: UILabel!
    @IBOutlet weak var staticCommentsByMemberLbl: UILabel!
    @IBOutlet weak var staticImageByMemberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        staticInfoFromAdmin.text = LocalizationKey.infoFromAdmin.localizing()
        staticImageByMemberLbl.text = LocalizationKey.imageFileByMember.localizing()
        staticCommentsByMemberLbl.text = LocalizationKey.commentByMember.localizing()
        
        configUI()
    }
    
    func configUI() {
        detailsTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.PowerOffCheckListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.PowerOffCheckListTVC.rawValue)
        detailsTblVw.register(UINib.init(nibName: TABLE_VIEW_CELL.SecoundElementTableTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SecoundElementTableTVC.rawValue)
        
        adminCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
        
        detailsTblVw.estimatedRowHeight = 60
        detailsTblVw.rowHeight = UITableView.automaticDimension
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValue(elementData:Elements,checkListId:Int,selectedChecklists:ChecklistsRows){
        self.mainElement = elementData
        self.checkListID = checkListId
        self.selectedCheckList = selectedChecklists
        nameLbl.text = elementData.name ?? ""
        if elementData.comment != "" && elementData.comment != nil {
            commentView.isHidden = false
            commentLbl.text = elementData.comment ?? ""
            mainElementTopHeight = mainElementTopHeight + 60
        } else {
            commentView.isHidden = true
        }
        if elementData.attachments != "" && elementData.attachments != nil {
            adminAttachmentsView.isHidden = false
            self.adminAttachmentsArray = elementData.attachments?.components(separatedBy: ",") ?? []
            mainElementTopHeight = mainElementTopHeight + 60
        } else {
            adminAttachmentsView.isHidden = true
        }
        if elementData.attachments_by_user != "" && elementData.attachments_by_user != nil {
            memberAttachmentsView.isHidden = false
            self.memberAttachmentsArray = elementData.attachments_by_user?.components(separatedBy: ",") ?? []
            mainElementTopHeight = mainElementTopHeight + 60
        } else {
            memberAttachmentsView.isHidden = true
        }
        if elementData.comment_by_user != "" && elementData.comment_by_user != nil {
            commentByUserLbl.text = elementData.comment_by_user ?? ""
            commentByMemberView.isHidden = false
            mainElementTopHeight = mainElementTopHeight + 60
        } else {
            commentByMemberView.isHidden = true
        }
    }
    
    func updateTableviews(){
        self.detailsTblVw.reloadData()
        self.memberCollectionVw.reloadData()
        self.adminCollectionVw.reloadData()
    }
    
}
//MARK: - TableView DataSource and Delegate Methods
extension MainElementTableTVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainElement?.elements?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let secoundElement = mainElement?.elements?[indexPath.row] else {
            return UITableViewCell()
        }
        guard let mainElement = mainElement else {
            return UITableViewCell()
        }
        
        if secoundElement.elements?.count ?? 0 > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SecoundElementTableTVC.rawValue, for: indexPath) as? SecoundElementTableTVC else { return UITableViewCell() }
            guard let checkList = selectedCheckList else {return UITableViewCell()}
            cell.setCellValue(element: secoundElement, checkListId: checkListID, selectedChecklists: checkList, selectedCheckListElementData: mainElement)
            cell.updateTableviews()
            cell.delegate = delegate
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.PowerOffCheckListTVC.rawValue, for: indexPath) as? PowerOffCheckListTVC else { return UITableViewCell() }
            guard let checkList = selectedCheckList else {return UITableViewCell()}
            cell.setCellValue(element: secoundElement, checkListId: checkListID, isFromMain: false, selectedChecklists: checkList, selectedCheckListElementData: mainElement)
            cell.updateTableviews()
            cell.delegate = delegate
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//        guard let secoundElement = mainElement?.elements?[indexPath.row] else {
//            return 0
//        }
//
//        if secoundElement.elements?.count ?? 0 > 0 {
//            return CGFloat(((secoundElement.elements?.count ?? 0) * 360) + 280)
//        } else {
//            return UITableView.automaticDimension
//        }
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        detailsTblVw.reloadData()
//
//            // if the table view is the last UI element, you might need to adjust the height
//            let size = CGSize(width: targetSize.width,
//                              height: detailsTblVw.frame.origin.y + detailsTblVw.contentSize.height)
//            return size
//    }
    
}

//MARK: - CollectionView Delegate & Datasource
extension MainElementTableTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == adminCollectionVw) {
            return adminAttachmentsArray.count
        } else {
            return memberAttachmentsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = adminCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
            return UICollectionViewCell()
        }
        cell.crossView.isHidden = true
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        if (collectionView == adminCollectionVw) {
            let url = URL(string: strUrl + "/\(adminAttachmentsArray[indexPath.row])")
            cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        } else {
            let url = URL(string: strUrl + "/\(memberAttachmentsArray[indexPath.row])")
            cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url : URL?
        if (collectionView == adminCollectionVw) {
            url = URL(string: strUrl + "/\(adminAttachmentsArray[indexPath.row])")
        } else {
            url = URL(string: strUrl + "/\(memberAttachmentsArray[indexPath.row])")
        }
        delegate.popUpImage(path: url)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 60
        let itemHeight = 60
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

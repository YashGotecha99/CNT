//
//  PowerOffCheckListTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 06/08/22.
//

import UIKit

class PowerOffCheckListTVC: UITableViewCell {

    @IBOutlet weak var addDocChecklistBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentByUserLbl: UILabel!
    
    @IBOutlet weak var adminCollectionVw: UICollectionView!
    @IBOutlet weak var memberCollectionVw: UICollectionView!
    @IBOutlet weak var yesLbl: UILabel!
    @IBOutlet weak var noLbl: UILabel!
    @IBOutlet weak var naLbl: UILabel!
    @IBOutlet weak var daLbl: UILabel!
    @IBOutlet weak var yesView: UIView!
    @IBOutlet weak var yesImg: UIImageView!
    @IBOutlet weak var noView: UIView!
    @IBOutlet weak var noImg: UIImageView!
    @IBOutlet weak var naView: UIView!
    @IBOutlet weak var naImg: UIImageView!
    @IBOutlet weak var daView: UIView!
    @IBOutlet weak var daImg: UIImageView!
    
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var adminAttachmentsView: UIView!
    @IBOutlet weak var commentByMemberView: UIView!
    @IBOutlet weak var memberAttachmentsView: UIView!
    @IBOutlet weak var mainViewTrailling: NSLayoutConstraint!
    @IBOutlet weak var mainViewleading: NSLayoutConstraint!
    
    var delegate = EquipmentChecklistVC()
    var element : Elements?
    var selectedCheckList : ChecklistsRows?
    var selectedCheckListElementData : Elements?
    
    var checkListID = 0
    
    var adminAttachmentsArray : [String] = []
    
    var memberAttachmentsArray : [String] = []
    @IBOutlet weak var staticInfoFromAdmin: UILabel!
    @IBOutlet weak var staticCommentsByMemberLbl: UILabel!
    @IBOutlet weak var staticImageByMemberLbl: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        staticInfoFromAdmin.text = LocalizationKey.infoFromAdmin.localizing()
        staticImageByMemberLbl.text = LocalizationKey.imageFileByMember.localizing()
        staticCommentsByMemberLbl.text = LocalizationKey.commentByMember.localizing()
        yesLbl.text = LocalizationKey.yes.localizing()
        noLbl.text = LocalizationKey.no.localizing()
        naLbl.text = LocalizationKey.na.localizing()
        daLbl.text = LocalizationKey.da.localizing()
        
        adminCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValue(element:Elements,checkListId:Int,isFromMain:Bool,selectedChecklists:ChecklistsRows,selectedCheckListElementData:Elements){
        self.element = element
        self.checkListID = checkListId
        self.selectedCheckList = selectedChecklists
        self.selectedCheckListElementData = selectedCheckListElementData
        nameLbl.text = element.name ?? ""
        if element.comment != "" && element.comment != nil {
            commentView.isHidden = false
            commentLbl.text = element.comment ?? ""
        } else {
            commentView.isHidden = true
        }
        if element.attachments != "" && element.attachments != nil {
            adminAttachmentsView.isHidden = false
            self.adminAttachmentsArray = element.attachments?.components(separatedBy: ",") ?? []
        } else {
            adminAttachmentsView.isHidden = true
        }
        if element.attachments_by_user != "" && element.attachments_by_user != nil {
            memberAttachmentsView.isHidden = false
            self.memberAttachmentsArray = element.attachments_by_user?.components(separatedBy: ",") ?? []
        } else {
            memberAttachmentsView.isHidden = true
        }
        if element.comment_by_user != "" && element.comment_by_user != nil {
            commentByUserLbl.text = element.comment_by_user ?? ""
            commentByMemberView.isHidden = false
        } else {
            commentByMemberView.isHidden = true
        }
        if isFromMain {
            mainViewleading.constant = 20
            mainViewTrailling.constant = 20
        } else {
            mainViewleading.constant = 0
            mainViewTrailling.constant = 0
        }
        
        setButtonUI(status: element.status ?? "")
    }
    
    func updateTableviews(){
        self.memberCollectionVw.reloadData()
        self.adminCollectionVw.reloadData()
    }
    
    func setButtonUI(status:String){
        if status.uppercased() == "NOT APPLICABLE" {
            yesView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            yesImg.image = UIImage(named: "tick")
            yesLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            noView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            noImg.image = UIImage(named: "crossIcon")
            noLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            naView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 1)
            naImg.image = UIImage(named: "questionIconWhite")
            naLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            daView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            daImg.image = UIImage(named: "da")
            daLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
        } else if status.uppercased() == "DEVIATION" {
            yesView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            yesImg.image = UIImage(named: "tick")
            yesLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            noView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            noImg.image = UIImage(named: "crossIcon")
            noLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            naView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            naImg.image = UIImage(named: "questionIcon")
            naLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            
            daView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
//            daImg.image = UIImage(named: "da")
            daLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            daImg.image = UIImage(named: "da")!.withRenderingMode(.alwaysTemplate)
            daImg.tintColor = .white
        }else if status.uppercased() == "NO" {
            yesView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            yesImg.image = UIImage(named: "tick")
            yesLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            noView.backgroundColor = #colorLiteral(red: 1, green: 0.4470588235, blue: 0.4470588235, alpha: 1)
            noImg.image = UIImage(named: "crossIconWhite")
            noLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            naView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            naImg.image = UIImage(named: "questionIcon")
            naLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            
            daView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            daImg.image = UIImage(named: "da")
            daLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
        } else if status.uppercased() == "DONE" {
            yesView.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            yesImg.image = UIImage(named: "tickWhite")
            yesLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            noView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            noImg.image = UIImage(named: "crossIcon")
            noLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            naView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            naImg.image = UIImage(named: "questionIcon")
            naLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            
            daView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            daImg.image = UIImage(named: "da")
            daLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
        }else {
            yesView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            yesImg.image = UIImage(named: "tick")
            yesLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            noView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            noImg.image = UIImage(named: "crossIcon")
            noLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            naView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            naImg.image = UIImage(named: "questionIcon")
            naLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
            
            daView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.05)
            daImg.image = UIImage(named: "da")
            daLbl.textColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1411764706, alpha: 0.4)
        }
    }
    
    @IBAction func btnYes(_ sender: Any) {
        print("selectedCheckList is : ", selectedCheckListElementData?.siginig_required ?? false)
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "UploadDocChecklistVC") as! UploadDocChecklistVC
        vc.element = self.element
        vc.checkListID = self.checkListID
        vc.isSignedRequired = selectedCheckListElementData?.siginig_required ?? false
        vc.isPhotoRequired = selectedCheckListElementData?.photo_required ?? false
        vc.delegate = self
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnNo(_ sender: Any) {
        showPopup()
    }
    @IBAction func btnNA(_ sender: Any) {
        CheckListCheck(status: "Not Applicable")
    }
    @IBAction func addDocBtnAction(_ sender: Any) {
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "UploadDocChecklistVC") as! UploadDocChecklistVC
//        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDeviation(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "AddDeviationVC") as! AddDeviationVC
        vc.element = self.element
        vc.checkListID = self.checkListID
        vc.selectedCheckList = self.selectedCheckList
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPopup() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Please enter reason to continue"
        }
        alert.addAction(UIAlertAction(title: LocalizationKey.save.localizing(), style: .default, handler: { action in
            
            guard let reason = alert.textFields?[0].text else {
                return
            }
            if (reason == "") {
                self.delegate.showAlert(message: LocalizationKey.pleaseProvideReason.localizing(), strtitle: "")
            } else {
                self.CheckListCheck(status: "NO", withComment: reason)
            }
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.cancel.localizing(), style: .cancel, handler: nil))
        delegate.present(alert, animated: true, completion: nil)
    }
}

//MARK: - CollectionView Delegate & Datasource
extension PowerOffCheckListTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
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
//            let url = URL(string: strUrl + "/\(memberAttachmentsArray[indexPath.row].drop(while: { $0.isWhitespace }))")
            cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 29.0
        let itemHeight = 29.0
        return CGSize(width: itemWidth, height: itemHeight)
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
}

extension PowerOffCheckListTVC : UploadDocChecklistVCDelegate {
    func onAccepted() {
        setButtonUI(status: "DONE")
    }
}

//MARK: Extension Api's
extension PowerOffCheckListTVC {
    private func CheckListCheck(status:String, withComment comment: String = ""){
        var param = [String:Any]()
        
        param["id"] = self.checkListID
        param["status"] = status
        
        var elementData = [String:Any]()
        elementData["id"] = element?.id
        elementData["name"] = element?.name
        elementData["parent_id"] = element?.parent_id
        elementData["client_id"] = element?.client_id
        elementData["comment"] = element?.comment
        elementData["attachments"] = element?.attachments
        elementData["created_by"] = element?.created_by
        elementData["updated_by"] = 0
        elementData["created_at"] = element?.created_at
        elementData["updated_at"] = ""
        elementData["hints"] = element?.hints
        elementData["elements"] = []
        elementData["status"] = element?.status
        elementData["updated_by_name"] = ""
        elementData["comment_by_user"] = comment
        elementData["due_date"] = element?.due_date
        
        param["element_data"] = elementData
        print(param)
        
        CheckListVM.shared.checkListCheck(parameters: param){ [self] obj in
            print(obj.checklist)
//            setButtonUI(status: status)
            
            delegate.checkListDetailsApi(id:"\(delegate.selectedCheckList?.id ?? 0)")
        }
    }
}

//
//  CheckListStatusTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 06/08/22.
//

import UIKit

class CheckListStatusTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var startDataLbl: UILabel!
    @IBOutlet weak var doneDateLbl: UILabel!
    @IBOutlet weak var createdByLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    
    @IBOutlet weak var checkAllSignatureView: UIView!
    @IBOutlet weak var signatureButtonStack: UIStackView!
    @IBOutlet weak var signAllBtn: UIButton!
    @IBOutlet weak var checkAllBtn: UIButton!
    @IBOutlet weak var uploadSignatureBgImg: UIImageView!
    @IBOutlet weak var staticStartDateLbl: UILabel!
    @IBOutlet weak var staticDoneDateLbl: UILabel!
    @IBOutlet weak var staticCreatedByLbl: UILabel!
    @IBOutlet weak var staticUserLbl: UILabel!
    @IBOutlet weak var staticSignatureLbl: UILabel!

    var checkListID = 0
    
    var delegate = EquipmentChecklistVC()
    var signatureImg: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLbl.text = LocalizationKey.earthmovingEquipments.localizing()
        staticStartDateLbl.text = LocalizationKey.startDate.localizing()
        staticDoneDateLbl.text = LocalizationKey.doneDate.localizing()
        staticCreatedByLbl.text = LocalizationKey.createdBy.localizing()
        staticUserLbl.text = LocalizationKey.user.localizing()
        staticSignatureLbl.text = LocalizationKey.signature.localizing()
        signAllBtn.setTitle(LocalizationKey.signAll, for: .normal)
        checkAllBtn.setTitle(LocalizationKey.checkAll, for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCellValue(selectedCheckList:ChecklistsRows,checkList:ChecklistsRows,checkListId:Int){
        self.checkListID = checkListId
        nameLbl.text = selectedCheckList.name
        
        //MARK: Change the date formate from configuration
//        startDataLbl.text = (selectedCheckList.created_at != nil) ? selectedCheckList.created_at?.convertAllFormater(formated: "dd.MM.yyyy") : ""
//        doneDateLbl.text = (selectedCheckList.updated_at != nil) ? selectedCheckList.updated_at?.convertAllFormater(formated: "dd.MM.yyyy") : ""
        
        startDataLbl.text = (selectedCheckList.created_at != nil) ? selectedCheckList.created_at?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "") : ""
        doneDateLbl.text = (selectedCheckList.updated_at != nil) ? selectedCheckList.updated_at?.convertAllFormater(formated: GlobleVariables.clientControlPanelConfiguration?.data?.dateTimeRules?.short_date_format ?? "") : ""

        createdByLbl.text = "\(selectedCheckList.created_by_first_name ?? "") \(selectedCheckList.created_by_last_name ?? "")"
        userLbl.text = "\(selectedCheckList.first_name ?? "") \(selectedCheckList.last_name ?? "")"
        
        if signatureImg != nil {
            return
        }
        if checkList.status?.capitalizingFirstLetter() != "Approved" && checkList.status?.capitalizingFirstLetter() != "Done" {
            if checkList.allow_check_all ?? false {
                checkAllSignatureView.isHidden = true
                checkAllBtn.isHidden = true
            }else {
                checkAllSignatureView.isHidden = true
                signatureButtonStack.isHidden = true
            }
        } else {
            checkAllSignatureView.isHidden = true
            signatureButtonStack.isHidden = true
        }
    }
    
    @IBAction func checkAllBtn(_ sender: Any) {
        if signatureImg == nil {
            return
        } else {
            checkAll()
        }
    }
    @IBAction func addSignatureBtn(_ sender: Any) {
        guard let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "SignatureVC") as? SignatureVC else {
            return
        }
        vc.delegate = self
        delegate.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CheckListStatusTVC : SignatureProtocol {
    func signatureImg(signatureImage: UIImage) {
        signatureImg = signatureImage
        uploadSignatureBgImg.image = signatureImage
        uploadSignatureBgImg.contentMode = .scaleAspectFit
        uploadSignatureBgImg.layer.borderWidth = 0.5
        
        checkAllSignatureView.isHidden = false
        signatureButtonStack.isHidden = false
        checkAllBtn.isHidden = false
        
        signAllBtn.setTitle(LocalizationKey.changeSignature.localizing(), for: .normal)
    }
}

extension CheckListStatusTVC {
    private func checkAll(){
        var param = [String:Any]()
        
        param["id"] = self.checkListID
        param["due_date"] = "\(Date())"
        
        if signatureImg != nil {
            param["signature"] = "data:image/png;base64," + (self.delegate.convertImageToBase64String(img: signatureImg ?? UIImage()) ?? "")
        }
        
        CheckListVM.shared.checkAll(parameters: param){ [self] obj in
            self.delegate.showAlert(message: obj.message ?? "", strtitle: LocalizationKey.success.localizing()) {_ in
                self.delegate.navigationController?.popViewController(animated: true)
            }
        }
    }
}

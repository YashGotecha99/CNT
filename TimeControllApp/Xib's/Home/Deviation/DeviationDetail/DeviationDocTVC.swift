//
//  DeviationDocTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 23/07/22.
//

import UIKit

protocol DeviationDocDetailsTVCDelegate: AnyObject {
    func onUrgencyUpdated(uregencyData: String)
    func onTextViewDidEndEditingData(textViewData: String, textViewType: String)
    func deviationAttachmentAfterDelete(afterDeleterAttachmentData : [[String:Any]])
}

class DeviationDocTVC: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var docCollectionVw: UICollectionView!
    @IBOutlet weak var btnNormal: UIButton!
    @IBOutlet weak var btnUrgent: UIButton!
    @IBOutlet weak var btnCritical: UIButton!
    
    var deviationsDetailsData : DeviationDetails?
    var arrDeviationAttahmentsData : [[String:Any]] = []
//    @IBOutlet weak var deviationsHeightConstraints: NSLayoutConstraint!
//    @IBOutlet weak var attachmentHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var attachmentVw: UIView!
    @IBOutlet weak var dueDateVw: UIView!
    @IBOutlet weak var responsibleVw: UIView!
    @IBOutlet weak var howToCorrectVw: UIView!
    @IBOutlet weak var happenAgainVw: UIView!
    @IBOutlet weak var fixThisVw: UIView!
    @IBOutlet weak var hourlyRateVw: UIView!
    @IBOutlet weak var otherCostVw: UIView!
    @IBOutlet weak var totalVw: UIView!
    
    @IBOutlet weak var caughtDeviationVw: UIView!
    @IBOutlet weak var estimatedCaughtVw: UIView!
    @IBOutlet weak var whatCanBeCaughtVw: UIView!
    @IBOutlet weak var consequenceCaughtVw: UIView!
    @IBOutlet weak var howToPreventCaughtVw: UIView!
    
    @IBOutlet weak var totalHoursVw: UIView!
    
    @IBOutlet weak var estimatedCaughtTxtVw: UITextView!
    @IBOutlet weak var consequenceCaughtTxtVw: UITextView!
    @IBOutlet weak var whatCanBeCaughtTxtVw: UITextView!
    @IBOutlet weak var howToPreventCaughtTxtVw: UITextView!
    
    @IBOutlet weak var dueDateTxt: UITextField!
    @IBOutlet weak var responsibleNameLbl: UILabel!
    @IBOutlet weak var responsibleImg: UIImageView!
    @IBOutlet weak var responsibleStatusLbl: UILabel!
    
    @IBOutlet weak var howToCorrectTxtVw: UITextView!
    @IBOutlet weak var howToStopTxtVw: UITextView!
    @IBOutlet weak var howToFixTxtVw: UITextView!
    
    @IBOutlet weak var totalHoursTxt: UITextField!
    @IBOutlet weak var hourlyRateTxt: UITextField!
    @IBOutlet weak var otherCostTxt: UITextField!
    @IBOutlet weak var totalTxt: UITextField!
    
    @IBOutlet weak var btnBrowseToUpload: UIButton!
    @IBOutlet weak var imgUpload: UIImageView!
    @IBOutlet weak var imgUploadIcon: UIImageView!

    @IBOutlet weak var responsibleFirstVw: UIView!
    @IBOutlet weak var responsibleSecondVw: UIView!
    @IBOutlet weak var btnResponsibilty: UIButton!
    
    @IBOutlet weak var btnDueDate: UIButton!
    
    @IBOutlet weak var staticUrgencyLbl: UILabel!
    @IBOutlet weak var staticNormalLbl: UILabel!
    @IBOutlet weak var staticUrgentLbl: UILabel!
    @IBOutlet weak var staticCriticalLbl: UILabel!
    @IBOutlet weak var deviationAttachmentLbl: UILabel!
    @IBOutlet weak var deviationAttachment2Lbl: UILabel!
    @IBOutlet weak var caughtDeviationDetailsLbl: UILabel!
    @IBOutlet weak var estimatedCauseOfDeviationLbl: UILabel!
    @IBOutlet weak var describeConsequenceOfTheDeviationLbl: UILabel!
    @IBOutlet weak var describeWhatCanBeDoneLbl: UILabel!
    @IBOutlet weak var describeHowToPreventItLbl: UILabel!
    @IBOutlet weak var deviationControlLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var responsibilityLbl: UILabel!
    @IBOutlet weak var howToCorrectLbl: UILabel!
    @IBOutlet weak var howToStopItHappenAgainLbl: UILabel!
    @IBOutlet weak var howDidWeFixThisLbl: UILabel!
    @IBOutlet weak var costsAndHoursLbl: UILabel!
    @IBOutlet weak var enterTotalHoursLbl: UILabel!
    @IBOutlet weak var enterHourlyRateLbl: UILabel!
    @IBOutlet weak var otherCostsLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var staticCostAndHoursVw: UIView!
    @IBOutlet weak var staticDeviationContolVw: UIView!
    weak var delegate : DeviationDocDetailsTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        estimatedCaughtTxtVw.delegate = self
        consequenceCaughtTxtVw.delegate = self
        whatCanBeCaughtTxtVw.delegate = self
        howToPreventCaughtTxtVw.delegate = self
        
        howToCorrectTxtVw.delegate = self
        howToStopTxtVw.delegate = self
        howToFixTxtVw.delegate = self
        
        totalHoursTxt.delegate = self
        hourlyRateTxt.delegate = self
        otherCostTxt.delegate = self
        totalTxt.delegate = self
        
        docCollectionVw.delegate = self
        docCollectionVw.dataSource = self
        
        staticUrgentLbl.text = LocalizationKey.urgency.localizing()
        staticNormalLbl.text = LocalizationKey.normal.localizing()
        staticUrgentLbl.text = LocalizationKey.urgent.localizing()
        staticCriticalLbl.text = LocalizationKey.critical.localizing()
        deviationAttachmentLbl.text = LocalizationKey.deviationAttachments.localizing()
        deviationAttachment2Lbl.text = LocalizationKey.deviationAttachments.localizing()
        caughtDeviationDetailsLbl.text = LocalizationKey.caughtDeviationDetails.localizing()
        estimatedCauseOfDeviationLbl.text = LocalizationKey.estimatedCauseOfDeviation.localizing()
        describeConsequenceOfTheDeviationLbl.text = LocalizationKey.describeConsequenceOfTheDeviation.localizing()
        describeWhatCanBeDoneLbl.text = LocalizationKey.describeWhatCanBeDone.localizing()
        describeHowToPreventItLbl.text = LocalizationKey.describeHowToPreventIt.localizing()
        deviationControlLbl.text = LocalizationKey.deviationControl.localizing()
        dueDateLbl.text = LocalizationKey.dueDate.localizing()
        responsibilityLbl.text = LocalizationKey.responsibility.localizing()
        howToCorrectLbl.text = LocalizationKey.howToCorrect.localizing()
        howToStopItHappenAgainLbl.text = LocalizationKey.howToStopItHappenAgain.localizing()
        howDidWeFixThisLbl.text = LocalizationKey.howDidWeFixThis.localizing()
        costsAndHoursLbl.text = LocalizationKey.costAndHours.localizing()
        enterTotalHoursLbl.text = LocalizationKey.enterTotalHours.localizing()
        enterHourlyRateLbl.text = LocalizationKey.enterHourlyRate.localizing()
        otherCostsLbl.text = LocalizationKey.otherCost.localizing()
        totalLbl.text = LocalizationKey.total.localizing()
        
        configUI()
        // Initialization code
    }

    func configUI() {
        docCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
        
       // setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(deviationsDetailsData : DeviationDetails?, arrAttahmentsData : [[String:Any]], attachementManually : Bool, responsibleId: String, responsibleName: String, deviationDueDate: String) -> Void {
        self.deviationsDetailsData = deviationsDetailsData
        self.arrDeviationAttahmentsData = arrAttahmentsData
        print("self.deviationsDetailsData is : ", self.deviationsDetailsData )
        print("deviationsDetailsData is : ", deviationsDetailsData )

        if (deviationsDetailsData?.urgency == "normal") {
            btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        } else if (deviationsDetailsData?.urgency == "urgent") {
            btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        } else {
            btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            btnCritical.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        }
        if self.arrDeviationAttahmentsData.count == 0 {
            attachmentVw.isHidden = true
        } else {
            attachmentVw.isHidden = false
        }
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            dueDateVw.isHidden = false
            dueDateTxt.text = deviationDueDate.convertAllFormater(formated: "yyyy-MM-dd")
            
            if deviationsDetailsData?.transitions?.count ?? 0 > 0 {
                if (deviationsDetailsData?.transitions?[0].name == "assign" || deviationsDetailsData?.transitions?[0].name == "unassign" || deviationsDetailsData?.transitions?[0].name == "reassign") {
                    responsibleVw.isHidden = false
                    let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
                    if attachementManually {
                        responsibleSecondVw.isHidden = false
                        responsibleNameLbl.text = responsibleName
                        let url = URL(string: strUrl + "/\(deviationsDetailsData?.assignee?.image ?? "")")
                        responsibleImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                        responsibleImg.contentMode = .scaleAspectFill
                        //                    responsibleStatusLbl.text = deviationsDetailsData?.transitions?[0].name
                    } else {
                        if (deviationsDetailsData?.assignee != nil) {
                            responsibleSecondVw.isHidden = false
                            responsibleNameLbl.text = (deviationsDetailsData?.assignee?.first_name ?? "") + " " + (deviationsDetailsData?.assignee?.last_name ?? "")
                            let url = URL(string: strUrl + "/\(deviationsDetailsData?.assignee?.image ?? "")")
                            responsibleImg.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
                            responsibleImg.contentMode = .scaleAspectFill
                            responsibleStatusLbl.text = deviationsDetailsData?.transitions?[0].name
                        } else {
                            responsibleSecondVw.isHidden = true
                        }
                    }
                }
                else {
                    responsibleVw.isHidden = true
                }
            }
             else {
                responsibleVw.isHidden = true
            }
            howToCorrectVw.isHidden = false
            happenAgainVw.isHidden = false
            fixThisVw.isHidden = false
            
            howToCorrectTxtVw.text = deviationsDetailsData?.txt_how_to_correct
            howToStopTxtVw.text = deviationsDetailsData?.txt_how_to_stop
            howToFixTxtVw.text = deviationsDetailsData?.txt_fix
            
            estimatedCaughtTxtVw.isUserInteractionEnabled = true
            consequenceCaughtTxtVw.isUserInteractionEnabled = true
            whatCanBeCaughtTxtVw.isUserInteractionEnabled = true
            howToPreventCaughtTxtVw.isUserInteractionEnabled = true
            
        } else {
            dueDateVw.isHidden = true
            responsibleVw.isHidden = true
            let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
            let userIDAPI =  "\(deviationsDetailsData?.assigned_id ?? 0)"
            if userID == userIDAPI {
                howToCorrectVw.isHidden = false
                happenAgainVw.isHidden = false
                fixThisVw.isHidden = false
                
                howToCorrectTxtVw.text = deviationsDetailsData?.txt_how_to_correct
                howToStopTxtVw.text = deviationsDetailsData?.txt_how_to_stop
                howToFixTxtVw.text = deviationsDetailsData?.txt_fix
                
                totalHoursVw.isHidden = false
                hourlyRateVw.isHidden = false
                otherCostVw.isHidden = false
                totalVw.isHidden = false
                
                staticDeviationContolVw.isHidden = false
                staticCostAndHoursVw.isHidden = false

                totalHoursTxt.text = "\(deviationsDetailsData?.spent_hours ?? 0)"
                hourlyRateTxt.text = "\(deviationsDetailsData?.spent_rate ?? 0)"
                otherCostTxt.text = "\(deviationsDetailsData?.spent_other ?? 0)"
                totalTxt.text = "\(deviationsDetailsData?.spent_total ?? 0)"
            } else {
                howToCorrectVw.isHidden = true
                happenAgainVw.isHidden = true
                fixThisVw.isHidden = true
                
                totalHoursVw.isHidden = true
                hourlyRateVw.isHidden = true
                otherCostVw.isHidden = true
                totalVw.isHidden = true
                
                btnNormal.isUserInteractionEnabled = false
                btnUrgent.isUserInteractionEnabled = false
                btnCritical.isUserInteractionEnabled = false
                
                staticDeviationContolVw.isHidden = true
                staticCostAndHoursVw.isHidden = true
            }
            estimatedCaughtTxtVw.isUserInteractionEnabled = false
            consequenceCaughtTxtVw.isUserInteractionEnabled = false
            whatCanBeCaughtTxtVw.isUserInteractionEnabled = false
            howToPreventCaughtTxtVw.isUserInteractionEnabled = false
        }
        estimatedCaughtTxtVw.text = deviationsDetailsData?.txt_cause
        consequenceCaughtTxtVw.text = deviationsDetailsData?.txt_consequence
        whatCanBeCaughtTxtVw.text = deviationsDetailsData?.txt_tbd
        howToPreventCaughtTxtVw.text = deviationsDetailsData?.txt_prevent
        
        docCollectionVw.reloadData()
    }
    
    @IBAction func btnClickedNormal(_ sender: Any) {
        btnNormal.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        delegate?.onUrgencyUpdated(uregencyData: "normal")
    }
    
    @IBAction func btnClickedUrgent(_ sender: Any) {
        btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnUrgent.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        btnCritical.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        delegate?.onUrgencyUpdated(uregencyData: "urgent")
    }
    
    @IBAction func btnClickedCritical(_ sender: Any) {
        btnNormal.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnUrgent.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
        btnCritical.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
        delegate?.onUrgencyUpdated(uregencyData: "critical")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == estimatedCaughtTxtVw {
            delegate?.onTextViewDidEndEditingData(textViewData: textView.text, textViewType: "txt_cause")
        } else if textView == consequenceCaughtTxtVw {
            delegate?.onTextViewDidEndEditingData(textViewData: textView.text, textViewType: "txt_consequence")
        } else if textView == whatCanBeCaughtTxtVw {
            delegate?.onTextViewDidEndEditingData(textViewData: textView.text, textViewType: "txt_tbd")
        } else if textView == howToPreventCaughtTxtVw {
            delegate?.onTextViewDidEndEditingData(textViewData: textView.text, textViewType: "txt_prevent")
        } else if textView == howToCorrectTxtVw {
            delegate?.onTextViewDidEndEditingData(textViewData: textView.text, textViewType: "txt_how_to_correct")
        } else if textView == howToStopTxtVw {
            delegate?.onTextViewDidEndEditingData(textViewData: textView.text, textViewType: "txt_how_to_stop")
        } else {
            delegate?.onTextViewDidEndEditingData(textViewData: textView.text, textViewType: "txt_fix")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == totalHoursTxt {
            delegate?.onTextViewDidEndEditingData(textViewData: textField.text ?? "", textViewType: "spent_hours")
        } else if textField == hourlyRateTxt {
            delegate?.onTextViewDidEndEditingData(textViewData: textField.text ?? "", textViewType: "spent_rate")
        } else if textField == otherCostTxt {
            delegate?.onTextViewDidEndEditingData(textViewData: textField.text ?? "", textViewType: "spent_other")
        } else {
            delegate?.onTextViewDidEndEditingData(textViewData: textField.text ?? "", textViewType: "spent_total")
        }
    }
    
    @objc func btnClickedCross(_ sender: UIButton) {
        
    }
    
}

//MARK: - CollectionView Delegate & Datasource
extension DeviationDocTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDeviationAttahmentsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = docCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
            return UICollectionViewCell()
        }
        
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            cell.crossView.isHidden = false
        } else {
            let userID = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
            let userIDAPI =  "\(deviationsDetailsData?.assigned_id ?? 0)"
            if userID == userIDAPI {
                cell.crossView.isHidden = false
            } else {
                cell.crossView.isHidden = true
            }
        }
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(arrDeviationAttahmentsData[indexPath.row]["id"] ?? 0)")
        cell.uploadImg.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))
        cell.btnCross.addTarget(self, action: #selector(self.btnClickedCross), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 84.0
        let itemHeight = 84.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        arrDeviationAttahmentsData.remove(at: indexPath.row)
        docCollectionVw.reloadData()
        delegate?.deviationAttachmentAfterDelete(afterDeleterAttachmentData: arrDeviationAttahmentsData)
    }
}

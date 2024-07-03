//
//  ExtraWorkTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 24/07/22.
//

import UIKit

class ExtraWorkTVC: UITableViewCell {
    @IBOutlet weak var extraWorkCVCHeight: NSLayoutConstraint!
    @IBOutlet weak var extraWorkLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleTypeExpenseLbl: UILabel!
    @IBOutlet weak var titleExtraHoursLbl: UILabel!
    
    @IBOutlet weak var extraHoursLbl: UILabel!

    @IBOutlet weak var extraWorkCommentLbl: UILabel!
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var extraWorkDocCollectionVw: UICollectionView!
    
//    var extraWorkPDFData = [expensePDF]()
    var extraWorkPDFData = [String]()

    //MARK: Localizations

    @IBOutlet weak var staticExtraHoursLbl: UILabel!
    @IBOutlet weak var staticCommentLbl: UILabel!
    @IBOutlet weak var staticUploadDocumentsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLbl.text = LocalizationKey.extraWork.localizing()
        titleTypeExpenseLbl.text = LocalizationKey.typeOfExtraWork.localizing()
        staticExtraHoursLbl.text = LocalizationKey.extraHours.localizing()
        staticCommentLbl.text = LocalizationKey.comment.localizing()
        staticUploadDocumentsLbl.text = LocalizationKey.uploadDocuments.localizing()
        
        extraWorkDocCollectionVw.delegate = self
        extraWorkDocCollectionVw.dataSource = self
        configUI()
        // Initialization code
    }

    func configUI() {
//        titleLbl.text = "Extra Work"
//        titleTypeExpenseLbl.text = "Type of Extra Work"
//        titleExtraHoursLbl.text = "Extra Hours"
//        typeExpenseLbl.text = "Materials"
//        extraHoursLbl.text = "5:30 hrs"
        
        extraWorkDocCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
        
       // setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - CollectionView Delegate & Datasource
extension ExtraWorkTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return extraWorkPDFData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = extraWorkDocCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
            return UICollectionViewCell()
        }
        cell.crossView.isHidden = true
//        let urls =  URL(string: "https://tidogkontroll.no/api/attachments/\(extraWorkPDFData[indexPath.row])")
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let urls =  URL(string: strUrl + "/\(extraWorkPDFData[indexPath.row])")
        cell.uploadImg.sd_setImage(with: urls , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
//        cell.uploadImg.sd_setImage(with: extraWorkPDFData[indexPath.row].expensePDF , placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 84.0
        let itemHeight = 84.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        extraWorkPDFData.remove(at: indexPath.row)
//        extraWorkDocCollectionVw.reloadData()
//    }
}

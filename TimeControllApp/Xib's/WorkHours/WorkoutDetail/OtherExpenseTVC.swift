//
//  OtherExpenseTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 24/07/22.
//

import UIKit

class OtherExpenseTVC: UITableViewCell {
    @IBOutlet weak var docCollectionVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var otherExpenseLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var otherExpenseTitleLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    @IBOutlet weak var uploadDocumentLbl: UILabel!
    
    
    @IBOutlet weak var costExpenseLbl: UILabel!
    
    @IBOutlet weak var expenseTypeLbl: UILabel!
    
    @IBOutlet weak var docExpenseCollectionVw: UICollectionView!
    
//    var expensePDFData = [expensePDF]()
    var expensePDFData = [String]()
    
    
    //MARK: Localizations

    @IBOutlet weak var staticOtherExpenseTypeLbl: UILabel!
    @IBOutlet weak var staticCostExpenseLbl: UILabel!
    @IBOutlet weak var staticCommentLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        otherExpenseTitleLbl.text = LocalizationKey.otherExpenses.localizing()
        staticOtherExpenseTypeLbl.text = LocalizationKey.expensesType.localizing()
        staticCostExpenseLbl.text = LocalizationKey.cost.localizing()
        staticCommentLbl.text = LocalizationKey.comment.localizing()
        uploadDocumentLbl.text = LocalizationKey.uploadDocuments.localizing()

        docExpenseCollectionVw.delegate = self
        docExpenseCollectionVw.dataSource = self
        configUI()
        // Initialization code
    }

    func configUI() {
        docExpenseCollectionVw.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue)
        
       // setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - CollectionView Delegate & Datasource
extension OtherExpenseTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expensePDFData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = docExpenseCollectionVw.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDocCVC.rawValue, for: indexPath) as? DeviationDocCVC else {
            return UICollectionViewCell()
        }
        cell.crossView.isHidden = true
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let urls =  URL(string: strUrl + "/\(expensePDFData[indexPath.row])")
        cell.uploadImg.sd_setImage(with: urls, placeholderImage: UIImage(named: "ic_userPlaceHolder.png"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 84.0
        let itemHeight = 84.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        expensePDFData.remove(at: indexPath.row)
//        docExpenseCollectionVw.reloadData()
//    }
}

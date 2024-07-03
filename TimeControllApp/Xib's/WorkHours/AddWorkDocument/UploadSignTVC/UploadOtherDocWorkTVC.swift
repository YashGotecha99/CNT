//
//  UploadOtherDocWorkTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 17/07/22.
//

import UIKit

protocol UploadDocumentProtocol {
//    func uploadDocumentUpdatedData(uploadDocumentData: [String])
    func uploadDocumentUpdatedData(uploadDocumentData: [[String:Any]])
    func openImageInViewImage(url:URL?)
}

class UploadOtherDocWorkTVC: UITableViewCell {

    @IBOutlet weak var imgAddSignature: UIImageView!
    @IBOutlet weak var btnSignature: UIButton!
    @IBOutlet weak var imgSignature: UIImageView!
    @IBOutlet weak var btnChangeSignature: UIButton!
    
    @IBOutlet weak var btnBrowseToUpload: UIButton!
    @IBOutlet weak var imgUpload: UIImageView!
    @IBOutlet weak var imgUploadIcon: UIImageView!
    @IBOutlet weak var changeSignatureVw: UIView!
    
    @IBOutlet weak var imgSetSignature: UIImageView!
    
    @IBOutlet weak var totalWOrkingHours: UILabel!
    
    @IBOutlet weak var overtimeHours: UILabel!
    
    @IBOutlet weak var uploadDocumentsCollectionView: UICollectionView!
    @IBOutlet weak var uploadDocumentsVw: UIView!
    var arrUploadDocumentsData : [[String:Any]] = []

    @IBOutlet weak var descriptionTxtVw: UITextView!
    var delegate: UploadDocumentProtocol? = nil

    //MARK: Localizations

    @IBOutlet weak var staticOtherDocumentsLbl: UILabel!
    @IBOutlet weak var staticCommentLbl: UILabel!
    @IBOutlet weak var staticSignatureLbl: UILabel!
    @IBOutlet weak var staticWorkingHoursLbl: UILabel!
    @IBOutlet weak var staticOvertimeHoursLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        staticOtherDocumentsLbl.text = LocalizationKey.otherDocuments.localizing()
        staticCommentLbl.text = LocalizationKey.comment.localizing()
        staticSignatureLbl.text = LocalizationKey.signature.localizing()
        staticWorkingHoursLbl.text = LocalizationKey.workingHours.localizing()
        btnChangeSignature.setTitle(LocalizationKey.changeSignature.localizing(), for: .normal)
        staticOvertimeHoursLbl.text = LocalizationKey.overtimeHours.localizing()
        
        self.uploadDocumentsCollectionView.delegate = self
        self.selectionStyle = .none
        
        uploadDocumentsCollectionView.delegate = self
        uploadDocumentsCollectionView.dataSource = self
        configUI()

    }

    func configUI() {
        uploadDocumentsCollectionView.register(UINib(nibName: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(arrDocumentsData : [[String:Any]]) {
        arrUploadDocumentsData = arrDocumentsData
        uploadDocumentsCollectionView.reloadData()
    }
    
}

//MARK: - CollectionView Delegate & Datasource
extension UploadOtherDocWorkTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUploadDocumentsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = uploadDocumentsCollectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.UploadDocumentsCVC.rawValue, for: indexPath) as? UploadDocumentsCVC else {
            return UICollectionViewCell()
        }
        
//        cell.lblName.text = arrOvertimeTypes[indexPath.row]["name"] as? String
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(arrUploadDocumentsData[indexPath.row]["id"] ?? 0)")
        cell.imgUpload.sd_setImage(with: url , placeholderImage: UIImage(named: "docImg.png"))

        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(self.clickToCloseBtn), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 118.0
        let itemHeight = 92.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
        let url = URL(string: strUrl + "/\(arrUploadDocumentsData[indexPath.row]["id"] ?? 0)")
        delegate?.openImageInViewImage(url: url)
    }
    
    @objc func clickToCloseBtn(_ sender: UIButton) {
        let id = sender.tag
        arrUploadDocumentsData.remove(at: id)
        delegate?.uploadDocumentUpdatedData(uploadDocumentData: arrUploadDocumentsData )
        uploadDocumentsCollectionView.reloadData()
    }
}

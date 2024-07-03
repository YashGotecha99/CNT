//
//  DeviationDetailTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 20/07/22.
//

import UIKit

class DeviationDetailTVC: UITableViewCell {

    @IBOutlet weak var deviationDetailCollection: UICollectionView!
    var deviationsDetailsData : DeviationDetails?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deviationDetailCollection.delegate = self
        deviationDetailCollection.dataSource = self
        configUI()
        // Initialization code
    }

    func configUI() {
        deviationDetailCollection.register(UINib(nibName: COLLECTION_VIEW_CELL.DeviationDetailCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDetailCVC.rawValue)
        
       // setupCollectionView()
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
       // let cellSize = UIScreen.main.bounds.width / 3 - 8
        layout.itemSize = CGSize(width: deviationDetailCollection.frame.size.width / 2.5, height: 65)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        deviationDetailCollection.collectionViewLayout = layout
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(deviationsDetailsData : DeviationDetails?) -> Void {
        self.deviationsDetailsData = deviationsDetailsData
        deviationDetailCollection.reloadData()
    }
    
}

//MARK: - CollectionView Delegate & Datasource
extension DeviationDetailTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = deviationDetailCollection.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.DeviationDetailCVC.rawValue, for: indexPath) as? DeviationDetailCVC else {
            return UICollectionViewCell()
        }
        
        if indexPath.row == 0 {
            cell.statusKeyLbl.text = LocalizationKey.status.localizing()
            cell.statusValueLbl.text = deviationsDetailsData?.status
        } else if indexPath.row == 1 {
            cell.statusKeyLbl.text = LocalizationKey.responsible.localizing()
            cell.statusValueLbl.text = (deviationsDetailsData?.assignee?.first_name ?? "N/A") + " " + (deviationsDetailsData?.assignee?.last_name ?? "")
        } else if indexPath.row == 2 {
            cell.statusKeyLbl.text = LocalizationKey.reportedBy.localizing()
            cell.statusValueLbl.text = (deviationsDetailsData?.reporter?.first_name ?? "") + " " + (deviationsDetailsData?.reporter?.last_name ?? "")
        } else if indexPath.row == 3 {
            cell.statusKeyLbl.text = LocalizationKey.project.localizing()
            cell.statusValueLbl.text = deviationsDetailsData?.project?.name
        } else if indexPath.row == 4 {
            cell.statusKeyLbl.text = LocalizationKey.tasks.localizing()
            cell.statusValueLbl.text = deviationsDetailsData?.task?.name
        } else if indexPath.row == 5 {
            cell.statusKeyLbl.text = LocalizationKey.deviationSubject.localizing()
            cell.statusValueLbl.text = deviationsDetailsData?.subject
        } else if indexPath.row == 6 {
            cell.statusKeyLbl.text = LocalizationKey.dueDate.localizing()
            cell.statusValueLbl.text = deviationsDetailsData?.due_date?.convertAllFormater(formated: "EEEE, MMM-dd-yyyy")
        } else {
            cell.statusKeyLbl.text = LocalizationKey.deviationDetails.localizing()
            cell.statusValueLbl.text = deviationsDetailsData?.comments
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = deviationDetailCollection.bounds.width/2.01
        let itemHeight = 75.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

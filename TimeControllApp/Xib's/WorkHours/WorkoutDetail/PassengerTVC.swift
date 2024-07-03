//
//  PassengerTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 24/07/22.
//

import UIKit

protocol PassengerProtocol {
    func deletePassengerData(passengerData : [Passenger])
}

class PassengerTVC: UITableViewCell {

    @IBOutlet weak var clvPassanger: UICollectionView!
    
    var arrPassangers = [Passenger]()
    var delegate: PassengerProtocol? = nil

    //MARK: Localizations
    @IBOutlet weak var staticPassangerTitleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        staticPassangerTitleLbl.text = LocalizationKey.passanger.localizing()
        self.selectionStyle = .none
        
        clvPassanger.delegate = self
        clvPassanger.dataSource = self
        configUI()

    }
    
    func configUI() {
        clvPassanger.register(UINib(nibName: COLLECTION_VIEW_CELL.PassangerCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.PassangerCVC.rawValue)
        clvPassanger.reloadData()
       // setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clickToCross(_ sender: UIButton) {
        let selectedIndexpath = sender.tag
        arrPassangers.remove(at: selectedIndexpath)
        delegate?.deletePassengerData(passengerData: arrPassangers)
        clvPassanger.reloadData()
    }
}


extension PassengerTVC: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPassangers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = clvPassanger.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.PassangerCVC.rawValue, for: indexPath) as? PassangerCVC else {
            return UICollectionViewCell()
        }
        
        cell.lblPassangerName.text = arrPassangers[indexPath.item].passengerName
        cell.crossBtn.tag = indexPath.row
        cell.crossBtn.addTarget(self, action: #selector(self.clickToCross), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = clvPassanger.bounds.width/2.01
        let itemHeight = 60.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
    
    

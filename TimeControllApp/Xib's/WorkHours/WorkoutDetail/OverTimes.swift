//
//  OverTimes.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 11/11/22.
//

import UIKit

protocol OverTimesProtocol {
    
    func overTimeClicked(indexPath:Int)
    
}
struct Overtime{
    var key = ""
    var value = ""
    init(key: String = "", value: String = "") {
        self.key = key
        self.value = value
    }
}

class OverTimes: UITableViewCell {
    
    @IBOutlet weak var clvOverTime: UICollectionView!
    
//    var arrOvertimeTypes = OvertimesData?(nilLiteral: {}())
    var arrOvertimeTypes : [Overtime_types]? = []

    var defaultArray = [Overtime(key: "50%",value: "00:00"),Overtime(key: "100%",value: "00:00"),Overtime(key: "Other",value: "00:00")]
    
    var delegate: OverTimesProtocol? = nil

    //MARK: Localizations

    @IBOutlet weak var staticOvertimesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        staticOvertimesLbl.text = LocalizationKey.overtimes.localizing()
        clvOverTime.delegate = self
        clvOverTime.dataSource = self
        configUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configUI() {
        clvOverTime.register(UINib(nibName: COLLECTION_VIEW_CELL.OverTimeCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.OverTimeCVC.rawValue)
        
    }
}


//MARK: - CollectionView Delegate & Datasource
extension OverTimes : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOvertimeTypes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = clvOverTime.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.OverTimeCVC.rawValue, for: indexPath) as? OverTimeCVC else {
            return UICollectionViewCell()
        }
        
        print("arrOvertimeTypes is : ", arrOvertimeTypes)
        /*
         if (indexPath.row == 0) {
         cell.lblName.text = arrOvertimeTypes?.fifty?.name ?? "50%"
         cell.lblTime.text = arrOvertimeTypes?.fifty?.value ?? "00:00"
         }
         else if (indexPath.row == 1) {
         cell.lblName.text = arrOvertimeTypes?.hundred?.name ?? "100%"
         cell.lblTime.text = arrOvertimeTypes?.hundred?.value ?? "00:00"
         }
         else if (indexPath.row == 2) {
         cell.lblName.text = arrOvertimeTypes?.other?.name ?? "Other"
         cell.lblTime.text = arrOvertimeTypes?.other?.value ?? "00:00"
         }
         */
        
        cell.lblName.text = arrOvertimeTypes?[indexPath.row].name ?? "Other"
        cell.lblTime.text = arrOvertimeTypes?[indexPath.row].value ?? "00:00"
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.overtimeAutomaticMode ?? false) || (GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.allowWeeklyManualOvertimeRegister ?? false) {
//            // message
//            Toast.show(message: "Overtime is being calculated Automatic or Weekly", controller: UIViewController())
//        } else {
//            if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
//                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
//                    delegate?.overTimeClicked(indexPath: indexPath.row)
//                } else {
//                    // Message
//                    Toast.show(message: "PM cannot manage overtime", controller: UIViewController())
//                }
//            } else {
//                if GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.pmManagesOvertime ?? false {
//                    // message
//                    Toast.show(message: "Only PM can manage overtime", controller: UIViewController())
//                } else {
//                    delegate?.overTimeClicked(indexPath: indexPath.row)
//                }
//            }
//        }
        delegate?.overTimeClicked(indexPath: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = clvOverTime.bounds.width/3.01
        let itemHeight = 50.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}


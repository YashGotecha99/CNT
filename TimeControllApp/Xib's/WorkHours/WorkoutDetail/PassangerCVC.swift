//
//  PassangerCVC.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 11/11/22.
//

import UIKit

class PassangerCVC: UICollectionViewCell {

    @IBOutlet weak var lblPassangerName: UILabel!
    @IBOutlet weak var crossBtn: UIButton!
    
    //MARK: Localizations
    @IBOutlet weak var lblStaticPassangerNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblStaticPassangerNameLbl.text = LocalizationKey.passangerName.localizing()
        // Initialization code
    }

}

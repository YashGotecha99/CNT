//
//  RegiterMilesTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 24/07/22.
//

import UIKit

class RegiterMilesTVC: UITableViewCell {

    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    
    //MARK: Localizations

    @IBOutlet weak var staticRegisterMilesLbl: UILabel!
    @IBOutlet weak var staticDistanceLbl: UILabel!
    @IBOutlet weak var staticDistanceFromLbl: UILabel!
    @IBOutlet weak var staticDistanceToLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        staticRegisterMilesLbl.text = LocalizationKey.registerMiles.localizing()
        staticDistanceLbl.text = LocalizationKey.distance.localizing()
        staticDistanceFromLbl.text = LocalizationKey.from.localizing()
        staticDistanceToLbl.text = LocalizationKey.to.localizing()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

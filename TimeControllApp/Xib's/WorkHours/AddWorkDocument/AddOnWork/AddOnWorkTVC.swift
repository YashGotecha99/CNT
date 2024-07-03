//
//  AddOnWorkTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 17/07/22.
//

import UIKit

class AddOnWorkTVC: UITableViewCell {

    @IBOutlet weak var extraWorkPlusVw: UIView!
    @IBOutlet weak var registerKilometerPlusVw: UIView!
    @IBOutlet weak var extraPassengerPlusVw: UIView!
    @IBOutlet weak var otherExpensesPlusVw: UIView!
    @IBOutlet weak var extraWorkBtn: UIButton!
    @IBOutlet weak var otherExpensesBtn: UIButton!
    @IBOutlet weak var extraPassengerBtn: UIButton!
    @IBOutlet weak var registerkilometerBtn: UIButton!
    
    //MARK: Localizations

    @IBOutlet weak var staticRegisterKilometerLbl: UILabel!
    @IBOutlet weak var staticExtraPassangerLbl: UILabel!
    @IBOutlet weak var staticOtherExpensesLbl: UILabel!
    @IBOutlet weak var staticExtraWorkLbl: UILabel!
    @IBOutlet weak var staticAddOnLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        staticAddOnLbl.text = LocalizationKey.addOn.localizing()
        staticRegisterKilometerLbl.text = LocalizationKey.registerKilometer.localizing()
        staticExtraPassangerLbl.text = LocalizationKey.extraPassanger.localizing()
        staticOtherExpensesLbl.text = LocalizationKey.otherExpenses.localizing()
        staticExtraWorkLbl.text = LocalizationKey.extraWork.localizing()
        
        extraWorkPlusVw.clipsToBounds = true
        extraWorkPlusVw.layer.cornerRadius = 10
        extraWorkPlusVw.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        
        registerKilometerPlusVw.clipsToBounds = true
        registerKilometerPlusVw.layer.cornerRadius = 10
        registerKilometerPlusVw.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner]

        extraPassengerPlusVw.clipsToBounds = true
        extraPassengerPlusVw.layer.cornerRadius = 10
        extraPassengerPlusVw.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        
        otherExpensesPlusVw.clipsToBounds = true
        otherExpensesPlusVw.layer.cornerRadius = 10
        otherExpensesPlusVw.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMaxYCorner]

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

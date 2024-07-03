//
//  KidsTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 09/07/22.
//

import UIKit

protocol KidsTVCTVCProtocol {
    
    func removeChild(index:Int)
}

class KidsTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateOfBirthLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var diseaseLbl: UILabel!
    @IBOutlet weak var caretackLbl: UILabel!
    @IBOutlet weak var staticDateOfBirthLbl: UILabel!
    @IBOutlet weak var staticAge: UILabel!
    @IBOutlet weak var staticDiseaseLbl: UILabel!
    @IBOutlet weak var staticCaretackLbl: UILabel!
    
    
    var delegate : KidsTVCTVCProtocol?
    var selectedIndex = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        staticDateOfBirthLbl.text = LocalizationKey.dateOfBirth.localizing()
        staticAge.text = LocalizationKey.age.localizing()
        staticDiseaseLbl.text = LocalizationKey.haveChronicDisease.localizing()
        staticCaretackLbl.text = LocalizationKey.confirmedExtraCaretakeDays.localizing()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValueForCell(kid:Kids,index:Int){
        self.selectedIndex = index
        nameLbl.text = kid.name
        dateOfBirthLbl.text = kid.date
        ageLbl.text = String(kid.date?.calcAge(birthday: kid.date ?? "", fromFormet: "yyyy-dd-mm") ?? 0)
        diseaseLbl.text = kid.chronic_disease
        
        staticAge.isHidden = false
        staticDiseaseLbl.isHidden = false
        staticCaretackLbl.isHidden = false
        
        dateOfBirthLbl.isHidden = false
        ageLbl.isHidden = false
        diseaseLbl.isHidden = false
        caretackLbl.isHidden = false
    }
    func setValueForCell(nomines:Nomines,index:Int){
        self.selectedIndex = index
        nameLbl.text = nomines.name
        staticDateOfBirthLbl.text = nomines.contactNumber
        
        staticAge.isHidden = true
        staticDiseaseLbl.isHidden = true
        staticCaretackLbl.isHidden = true
        
        dateOfBirthLbl.isHidden = true
        ageLbl.isHidden = true
        diseaseLbl.isHidden = true
        caretackLbl.isHidden = true
    }
    @IBAction func btnDeleteKids(_ sender: Any) {
        delegate?.removeChild(index: selectedIndex)
    }
    
}

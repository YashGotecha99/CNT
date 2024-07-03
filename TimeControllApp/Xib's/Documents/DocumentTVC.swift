//
//  DocumentTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 06/07/22.
//

import UIKit

class DocumentTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var staticCreatedBy: UILabel!
    @IBOutlet weak var staticStatus: UILabel!
    @IBOutlet weak var createdByLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValue(document:DocumentRows){
        staticCreatedBy.text = LocalizationKey.createdBy.localizing()
        staticStatus.text = LocalizationKey.status.localizing()
        
        nameLbl.text = document.template_name
        createdByLbl.text = document.created_by
        statusLbl.text = document.status == nil ? "Unsigned" : "Signed"
        dateLbl.text = "\(document.updated_at?.convertAllFormater(formated: "EEE") ?? "") \(document.updated_at?.convertAllFormater(formated: "dd") ?? "") \(document.updated_at?.convertAllFormater(formated: "LLL") ?? "")"
    }
    
}

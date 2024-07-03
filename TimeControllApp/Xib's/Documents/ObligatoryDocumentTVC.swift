//
//  ObligatoryDocumentTVC.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 05/06/23.
//

import UIKit

class ObligatoryDocumentTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
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
        
        nameLbl.text = document.template_name
        dateLbl.text = "\(document.updated_at?.convertAllFormater(formated: "EEE") ?? "") \(document.updated_at?.convertAllFormater(formated: "dd") ?? "") \(document.updated_at?.convertAllFormater(formated: "LLL") ?? "")"
    }
    
}

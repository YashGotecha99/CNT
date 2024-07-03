//
//  ProjectListTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 31/07/22.
//

import UIKit

class ChildListTVC: UITableViewCell {

    @IBOutlet weak var childNameLbl: UILabel!
    @IBOutlet weak var selectChildBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(childData: Kids) -> Void {
        self.childNameLbl.text = childData.name
    }
}

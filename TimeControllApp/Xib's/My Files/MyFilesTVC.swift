//
//  MyFilesTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 06/07/22.
//

import UIKit

class MyFilesTVC: UITableViewCell {

    @IBOutlet weak var shadowVw: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowVw.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        shadowVw.layer.shadowOpacity = 0.5
        shadowVw.layer.shadowOffset = .zero
        shadowVw.layer.shadowRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

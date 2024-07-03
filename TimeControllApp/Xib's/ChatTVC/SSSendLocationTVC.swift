//
//  SSSendLocationTVC.swift
//  Sales Suite
//
//  Created by MACBOOK on 02/08/22.
//

import UIKit

class SSSendLocationTVC: UITableViewCell {

    @IBOutlet weak var mapTitleVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapTitleVw.clipsToBounds = true
        mapTitleVw.layer.cornerRadius = 20
        mapTitleVw.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


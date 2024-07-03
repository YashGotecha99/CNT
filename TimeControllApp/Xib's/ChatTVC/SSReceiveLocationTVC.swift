//
//  SSReceiveLocationTVC.swift
//  Sales Suite
//
//  Created by MACBOOK on 03/08/22.
//

import UIKit

class SSReceiveLocationTVC: UITableViewCell {

    @IBOutlet weak var mapTitleVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mapTitleVw.clipsToBounds = true
        mapTitleVw.layer.cornerRadius = 20
        mapTitleVw.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  SSGetTextMessageTVC.swift
//  Sales Suite
//
//  Created by MACBOOK on 01/08/22.
//

import UIKit

class ReceiveTextMessageTVC: UITableViewCell {

    @IBOutlet weak var receiveMsgUserImg: UIImageView!
    @IBOutlet weak var receiveMsgLbl: UILabel!
    @IBOutlet weak var msgTimingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

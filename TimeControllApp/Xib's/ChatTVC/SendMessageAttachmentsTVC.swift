//
//  SendMessageAttachmentsTVC.swift
//  TimeControllApp
//
//  Created by prashant on 19/04/23.
//

import UIKit

class SendMessageAttachmentsTVC: UITableViewCell {

    @IBOutlet weak var msgTimingLbl: UILabel!
    @IBOutlet weak var sentMsgLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var attachmentImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

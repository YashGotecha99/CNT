//
//  DeviationTVC.swift
//  TimeControllApp
//
//  Created by mukesh on 17/07/22.
//

import UIKit

class DeviationTVC: UITableViewCell {

    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusBackgroundVw: UIView!
    @IBOutlet weak var titleDeviationLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var dueDateStaticLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configUI(index:Int) {
        if index == 0 {
            titleDeviationLbl.textColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            backgroundVw.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
//            statusLbl.text = LocalizationKey.new.localizing()
            statusBackgroundVw.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3137254902, blue: 0.6745098039, alpha: 1)
            dueDateStaticLbl.isHidden = true
            dueDateLbl.isHidden = true
        } else if index == 1 {
            titleDeviationLbl.textColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            backgroundVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
//            statusLbl.text = LocalizationKey.working.localizing()
            statusBackgroundVw.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.6862745098, blue: 0.3725490196, alpha: 1)
            dueDateStaticLbl.isHidden = false
            dueDateLbl.isHidden = false
        } else {
            titleDeviationLbl.textColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            backgroundVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
//            statusLbl.text = LocalizationKey.done.localizing()
            statusBackgroundVw.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.6862745098, blue: 0.3960784314, alpha: 1)
            dueDateStaticLbl.isHidden = false
            dueDateLbl.isHidden = false
        }
    }
    
    func setData(deviationsData: DeviationsList) -> Void {
        statusLbl.text = deviationsData.status?.capitalizingFirstLetter()
        titleDeviationLbl.text = "\(deviationsData.id ?? 0)" + " | " + (deviationsData.subject ?? "")
        projectNameLbl.text = (deviationsData.project_name ?? "")
        dueDateLbl.text = deviationsData.due_date?.convertAllFormater(formated: "dd-MM-yy")
    }
}

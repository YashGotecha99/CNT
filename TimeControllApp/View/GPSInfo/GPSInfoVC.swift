//
//  GPSInfoVC.swift
//  TimeControllApp
//
//  Created by mukesh on 02/07/22.
//

import UIKit

class GPSInfoVC: UIViewController {

    @IBOutlet weak var gpsInfoLbl: UILabel!
    @IBOutlet weak var yourGpsLocationLbl: UILabel!
    @IBOutlet weak var readMoreLbl: UILabel!
    @IBOutlet weak var infoLinkBtn: UnderlineTextButton!
    @IBOutlet weak var readBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
//        infoLinkBtn.setTitle( "norsktimeregister.no", for: .normal)
        
//        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://norsktimeregister.no/api/"
        
        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://tidogkontroll.no/api/"
        
        infoLinkBtn.setTitle( base_url == "https://norsktimeregister.no/api/" ? "timeandcontrol.no" : "timeandcontrol.com" , for: .normal)

        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        gpsInfoLbl.text = LocalizationKey.gPSInfo.localizing()
        yourGpsLocationLbl.text = LocalizationKey.yourGPSLocationIsUsedToAutomaticallyRecordYourWorkingHours.localizing()
        readMoreLbl.text = LocalizationKey.readMoreAboutPrivacyAt.localizing()
        readBtn.setTitle(LocalizationKey.read.localizing(), for: .normal)
    }
    
    @IBAction func goToHomeScreen(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func gpsInfoClicked(_ sender: Any) {
        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://norsktimeregister.no/api/"
        
        if let url = URL(string: base_url == "https://norsktimeregister.no/api/" ? "https://timeandcontrol.no/privacy" : "https://timeandcontrol.com/privacy"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

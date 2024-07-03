//
//  MoreScheduleVC.swift
//  TimeControllApp
//
//  Created by yash on 06/01/23.
//

import UIKit

class MoreScheduleVC: BaseViewController {
    
    
    @IBOutlet weak var moreScheduleTitleLbl: UILabel!
    @IBOutlet weak var upFotGrabsLbl: UILabel!
    @IBOutlet weak var updateAvailabiltyLbl: UILabel!
    @IBOutlet weak var swapTradesLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        // Do any additional setup after loading the view.
    }
    
    func setUpLocalization(){
        moreScheduleTitleLbl.text = LocalizationKey.schedule.localizing()
        upFotGrabsLbl.text = LocalizationKey.upForGrabs.localizing()
        updateAvailabiltyLbl.text = LocalizationKey.updateAvailabilty.localizing()
        swapTradesLbl.text = LocalizationKey.swapTrades.localizing()
    }
    
    @IBAction func UpToGrabsBtn(_ sender: Any) {
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "UpToGrabsListVC") as! UpToGrabsListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func SwapTradesBtn(_ sender: Any) {
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "member" {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesVC") as! SwapTradesVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SwapTradesPMVC") as! SwapTradesPMVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func UpdateAvailabityBtn(_ sender: Any) {
        let vc = STORYBOARD.AVAILABILITY.instantiateViewController(withIdentifier: "AvailabilityListVC") as! AvailabilityListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

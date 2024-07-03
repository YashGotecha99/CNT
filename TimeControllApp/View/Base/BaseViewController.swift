//
//  BaseViewController.swift
//  TimeControllApp
//
//  Created by mukesh on 10/07/22.
//

import UIKit
import SideMenu
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       // setupSideMenu()
        // Do any additional setup after loading the view.
    }
    
    public func setupSideMenu() {
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier:"menuLeftNavigationController") as? SideMenuNavigationController
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func notificationBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sidemenuBtnAction(_ sender: Any) {
        SideMenuManager.default.leftMenuNavigationController?.presentationStyle = .menuSlideIn
        SideMenuManager.default.leftMenuNavigationController?.presentationStyle.onTopShadowOpacity = 1

//        var sideMenuSet = SideMenuSettings()
//        sideMenuSet.presentationStyle = .viewSlideOut
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "menuLeftNavigationController") as! UISideMenuNavigationController
        nextViewController.menuWidth = 270.0
        nextViewController.presentationStyle = .menuSlideIn
        
        nextViewController.presentationStyle.onTopShadowOpacity = 1
       // nextViewController.settings.SideMenuPresentationStyle = .menuSlideIn
      //  nextViewController.SideMenuPresentationStyle = .menuSlideIn
        
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func chatBtnAction(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
 

//
//  TabbarVC.swift
//  TimeControllApp
//
//  Created by Abhishek on 02/07/22.
//

import UIKit

class TabbarVC: UITabBarController, UITabBarControllerDelegate {

    var Home: HomeVC!
    var WorkHours: WorkHoursVC!
    var Files: FilesVC!
    var Document: DocumentVC!
    var Profile: ProfileVC!

    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
                tabBar.layer.shadowOpacity = 0.5
                tabBar.layer.shadowOffset = CGSize.zero
                tabBar.layer.shadowRadius = 5
                self.tabBar.layer.borderColor = UIColor.clear.cgColor
                self.tabBar.layer.borderWidth = 0
                self.tabBar.clipsToBounds = false
                self.tabBar.backgroundColor = UIColor.white
                UITabBar.appearance().shadowImage = UIImage()
                UITabBar.appearance().backgroundImage = UIImage()
        
        let unselectedColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let selectedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        Home = (STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC)
        WorkHours = (STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "WorkHoursVC") as! WorkHoursVC)
        Files = (STORYBOARD.FILES.instantiateViewController(withIdentifier: "FilesVC") as! FilesVC)
        Document = (STORYBOARD.DOCUMENTS.instantiateViewController(withIdentifier: "DocumentVC") as! DocumentVC)
        Profile = (STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC)
        //
        self.delegate = self
        
//        let firstViewController:UIViewController = Home
//        let customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
//        customTabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -8, right: 0);
//        firstViewController.tabBarItem = customTabBarItem
        
        Home.tabBarItem.image = UIImage(named: "unselectHome")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Home.tabBarItem.selectedImage = UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Home.tabBarItem.title = LocalizationKey.home.localizing()
        Home.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Home.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)

        
        WorkHours.tabBarItem.image = UIImage(named: "unselectTimeSquare")
        WorkHours.tabBarItem.selectedImage = UIImage(named: "selectedworkinghour")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        WorkHours.tabBarItem.title = LocalizationKey.workHours.localizing()
        WorkHours.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        WorkHours.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Files.tabBarItem.image = UIImage(named: "unselectFolder")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Files.tabBarItem.selectedImage = UIImage(named: "selectFiles")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Files.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        Files.tabBarItem.title = LocalizationKey.myFiles.localizing()
        Files.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Files.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Document.tabBarItem.image = UIImage(named: "unselectDoc")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Document.tabBarItem.selectedImage = UIImage(named: "selectdocuments")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Document.tabBarItem.title = LocalizationKey.documents.localizing()
        Document.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Document.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Profile.tabBarItem.image = UIImage(named: "unselectProfile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Profile.tabBarItem.selectedImage = UIImage(named: "selectProfile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Profile.tabBarItem.title = LocalizationKey.profile.localizing()
        Profile.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Profile.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        //
        
 
        
       // self.tabBar.tintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.white
       // tabBar.isTranslucent = false
        
        
        self.setViewControllers([Home,WorkHours,Files,Document,Profile], animated: true)
        
        // Do any additional setup after loading the view.
 */
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
                tabBar.layer.shadowOpacity = 0.5
                tabBar.layer.shadowOffset = CGSize.zero
                tabBar.layer.shadowRadius = 5
                self.tabBar.layer.borderColor = UIColor.clear.cgColor
                self.tabBar.layer.borderWidth = 0
                self.tabBar.clipsToBounds = false
                self.tabBar.backgroundColor = UIColor.white
                UITabBar.appearance().shadowImage = UIImage()
                UITabBar.appearance().backgroundImage = UIImage()
        
        let unselectedColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let selectedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        Home = (STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC)
        WorkHours = (STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "WorkHoursVC") as! WorkHoursVC)
        Files = (STORYBOARD.FILES.instantiateViewController(withIdentifier: "FilesVC") as! FilesVC)
        Document = (STORYBOARD.DOCUMENTS.instantiateViewController(withIdentifier: "DocumentVC") as! DocumentVC)
        Profile = (STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC)
        //
        self.delegate = self
        
//        let firstViewController:UIViewController = Home
//        let customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
//        customTabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -8, right: 0);
//        firstViewController.tabBarItem = customTabBarItem
        
        Home.tabBarItem.image = UIImage(named: "unselectHome")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Home.tabBarItem.selectedImage = UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Home.tabBarItem.title = LocalizationKey.home.localizing()
        Home.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Home.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)

        
        WorkHours.tabBarItem.image = UIImage(named: "unselectTimeSquare")
        WorkHours.tabBarItem.selectedImage = UIImage(named: "selectedworkinghour")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        WorkHours.tabBarItem.title = LocalizationKey.workHours.localizing()
        WorkHours.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        WorkHours.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Files.tabBarItem.image = UIImage(named: "unselectFolder")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Files.tabBarItem.selectedImage = UIImage(named: "selectFiles")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Files.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        Files.tabBarItem.title = LocalizationKey.myFiles.localizing()
        Files.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Files.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Document.tabBarItem.image = UIImage(named: "unselectDoc")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Document.tabBarItem.selectedImage = UIImage(named: "selectdocuments")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Document.tabBarItem.title = LocalizationKey.documents.localizing()
        Document.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Document.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Profile.tabBarItem.image = UIImage(named: "unselectProfile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Profile.tabBarItem.selectedImage = UIImage(named: "selectProfile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Profile.tabBarItem.title = LocalizationKey.profile.localizing()
        Profile.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Profile.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        //
        
 
        
       // self.tabBar.tintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.white
       // tabBar.isTranslucent = false
        
        
        self.setViewControllers([Home,WorkHours,Files,Document,Profile], animated: true)
    }

/*
    override func viewWillAppear(_ animated: Bool) {
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
                tabBar.layer.shadowOpacity = 0.5
                tabBar.layer.shadowOffset = CGSize.zero
                tabBar.layer.shadowRadius = 5
                self.tabBar.layer.borderColor = UIColor.clear.cgColor
                self.tabBar.layer.borderWidth = 0
                self.tabBar.clipsToBounds = false
                self.tabBar.backgroundColor = UIColor.white
                UITabBar.appearance().shadowImage = UIImage()
                UITabBar.appearance().backgroundImage = UIImage()
        
        let unselectedColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let selectedColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        Home = (STORYBOARD.HOME.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC)
        WorkHours = (STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "WorkHoursVC") as! WorkHoursVC)
        Files = (STORYBOARD.FILES.instantiateViewController(withIdentifier: "FilesVC") as! FilesVC)
        Document = (STORYBOARD.DOCUMENTS.instantiateViewController(withIdentifier: "DocumentVC") as! DocumentVC)
        Profile = (STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC)
        //
        self.delegate = self
        
//        let firstViewController:UIViewController = Home
//        let customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
//        customTabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -8, right: 0);
//        firstViewController.tabBarItem = customTabBarItem
        
        Home.tabBarItem.image = UIImage(named: "unselectHome")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Home.tabBarItem.selectedImage = UIImage(named: "selectedhomeicon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Home.tabBarItem.title = LocalizationKey.home.localizing()
        Home.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Home.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)

        
        WorkHours.tabBarItem.image = UIImage(named: "unselectTimeSquare")
        WorkHours.tabBarItem.selectedImage = UIImage(named: "selectedworkinghour")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        WorkHours.tabBarItem.title = LocalizationKey.workHours.localizing()
        WorkHours.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        WorkHours.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Files.tabBarItem.image = UIImage(named: "unselectFolder")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Files.tabBarItem.selectedImage = UIImage(named: "selectFiles")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Files.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        Files.tabBarItem.title = LocalizationKey.myFiles.localizing()
        Files.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Files.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Document.tabBarItem.image = UIImage(named: "unselectDoc")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Document.tabBarItem.selectedImage = UIImage(named: "selectdocuments")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Document.tabBarItem.title = LocalizationKey.documents.localizing()
        Document.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Document.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        Profile.tabBarItem.image = UIImage(named: "unselectProfile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Profile.tabBarItem.selectedImage = UIImage(named: "selectProfile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        Profile.tabBarItem.title = LocalizationKey.profile.localizing()
        Profile.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        Profile.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        
        //
        
 
        
       // self.tabBar.tintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.white
       // tabBar.isTranslucent = false
        
        
        self.setViewControllers([Home,WorkHours,Files,Document,Profile], animated: true)
        
        // Do any additional setup after loading the view.
    }
 */
}

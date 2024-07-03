//
//  SceneDelegate.swift
//  TimeControllApp
//
//  Created by mukesh on 01/07/22.
//

import UIKit
import Alamofire
import SVProgressHUD
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if let name = UserDefaults.standard.string(forKey: UserDefaultKeys.token){
            self.window = UIWindow(windowScene: windowScene)
            //self.window =  UIWindow(frame: UIScreen.main.bounds)
            
            guard let rootVC = STORYBOARD.MAIN.instantiateViewController(identifier: "TabbarVC") as? TabbarVC else {
                print("ViewController not found")
                return
            }
            userLoadConfig()
            let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        }
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    
    func userLoadConfig() {
        SVProgressHUD.show()
        let params : Parameters = [:]
        DataService.sharedInstance.getDataWithHeader(api: endPointURL.LOADUSERCONFIG, param: params, completion: { (response,resultDict, errorMsg)  in
            SVProgressHUD.dismiss()
            if let status = response?["success"] as? Bool {
                if status == true {
                    if let dicData = response?["response"] as? NSDictionary {
                        if let data = dicData["config"] as? NSDictionary {
                            if let clientData = data["client"] as? NSDictionary {
                                print(clientData["image"])
                                print(clientData["name"])
//                                UserDefaults.standard.setValue("https://tidogkontroll.no/api/attachments/\(clientData["image"] as? String ?? "")", forKey: UserDefaultKeys.clientImage)
                                let url = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
                                UserDefaults.standard.setValue(url + "/\(clientData["image"] as? String ?? "")", forKey: UserDefaultKeys.clientImage)
                                UserDefaults.standard.setValue(url + "/\(clientData["name"] as? String ?? "")", forKey: UserDefaultKeys.clientName)
                                UserDefaultKeys.expenseTypes.removeAll()
                                UserDefaultKeys.extraWork.removeAll()
                                if let clientDetails = clientData["data"] as? NSDictionary {
                                    
                                    if let extendedRules = clientDetails["extendedRules"] as? NSDictionary {
                                        
                                         print(extendedRules)
                                        
                                        if let expenseTypes = extendedRules["expense_types"] as? [NSDictionary] {
                                            for i in 0..<expenseTypes.count{
                                                UserDefaultKeys.expenseTypes.append(expenseTypes[i]["name"] as? String ?? "")
                                            }
                                        }
                                        
                                        if let extraWork = extendedRules["extrawork_types"] as? [NSDictionary] {
                                            for i in 0..<extraWork.count{
                                                UserDefaultKeys.extraWork.append(extraWork[i]["name"] as? String ?? "")
                                            }
                                        }
                                       // UserDefaultKeys.expenseTypes = extendedRules["expense_types"] as? [NSDictionary] ?? []
                                       // UserDefaultKeys.extraWork = extendedRules["extrawork_types"] as? [NSDictionary] ?? []
                                     //
                                       // UserDefaults.standard.setValue(extendedRules["expense_types"] as? [NSDictionary], forKey: )
                                       // UserDefaults.standard.synchronize()
                                    }
                                    
                                    if let basicRules = clientDetails["basicRules"] as? NSDictionary {
                                       
                                        if let overtimetypes = basicRules["overtime_types"] as? [AnyObject] {
                                            
                                            print(overtimetypes)
                                            GlobleVariables.arrOvertimeTypes = overtimetypes
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                
            }
        })
    }
    
}

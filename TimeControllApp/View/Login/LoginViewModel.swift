//
//  LoginViewModel.swift
//  TimeControllApp
//
//  Created by mukesh on 14/08/22.
//

import Foundation
import Alamofire



class LoginViewModel {
    
    func userLogin(email:String,password:String,completion: @escaping (Bool,String, Int)-> Void) {
        
        let params : Parameters = [
            "user": [
                "email": email,
                "password": password
            ]
        ]
        
        DataService.sharedInstance.getData(api: endPointURL.LOGIN, param: params, completion: { (response,resultDict, errorMsg, apiStatusCode)  in
            
            if let userData = response?["user"] as? NSDictionary {
                
                print(userData)
                 
                if let userId = userData["id"] as? Int{
                    UserDefaults.standard.setValue("\(userId)", forKey: UserDefaultKeys.userId)
                }
                
                if let token = userData["token"] as? String {
                    UserDefaults.standard.setValue(token, forKey: UserDefaultKeys.token)
                }
                
                if let userType = userData["user_type"] as? String {
                    UserDefaults.standard.setValue(userType, forKey: UserDefaultKeys.userType)
                }
                
                if let userName = userData["username"] as? String {
                    UserDefaults.standard.setValue(userName, forKey: UserDefaultKeys.userName)
                }
                
                if let userImage = userData["image"] as? String {
                    UserDefaults.standard.setValue(userImage, forKey: UserDefaultKeys.userImageIdAPI)
                }
                
                if let userImage = userData["image"] as? String {
                    let strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.SAVEATTACHMENT as NSString)
                    UserDefaults.standard.setValue(strUrl + "/\(userImage)", forKey: UserDefaultKeys.userImageId)
                }
                
                if let userFirstName = userData["first_name"] as? String, let userLastName = userData["last_name"] as? String{
                    UserDefaults.standard.setValue(userFirstName + " " + userLastName, forKey: UserDefaultKeys.userFullname)
                }
                
                if let clienId = userData["client_id"] as? Int{
                    UserDefaults.standard.setValue("\(clienId)", forKey: UserDefaultKeys.clientId)
                }
//                if let token = userData["token"] as? String {
//                    UserDefaults.standard.setValue(token, forKey: UserDefaultKeys.userId)
//                }
//
//                if let token = userData["token"] as? String {
//                    UserDefaults.standard.setValue(token, forKey: UserDefaultKeys.userImageId)
//                }
                
//                if status as? String ?? "" == "Please login first" {
//
//                   // ChopeServices.sharedInstance.pleaseLoginFirst(status: "Please login first", vc: self )
//                    return
//                }  else {
//
//                    if status as? String ?? "" == "ok" {
//                        do {
//                            let data = try JSONDecoder().decode(SSAgentDataModel.self, from: resultDict!)
//                            self.allAgentList.append(contentsOf: data.results ?? [])
//                           // self.allAgentList = data.results ?? []
//                           print(data)
//                        }
//                        catch {
//
//                        }
//                    } else {
//                        AlertMessage.displayMessageAlert(title: status as! String, message: response?["error"] as! String)
//                    }
//
//                }
                completion(true, "Login Successfully", apiStatusCode)
            } else {
                if apiStatusCode == 403 {
                    completion(false,response?["error"] as? String ?? "", apiStatusCode)
                } else {
                    if let dicData = response?["errors"] as? NSDictionary {
                        completion(false,dicData["error"] as? String ?? "", apiStatusCode)
                    }
                }
            }
        })
    }
    
    
}


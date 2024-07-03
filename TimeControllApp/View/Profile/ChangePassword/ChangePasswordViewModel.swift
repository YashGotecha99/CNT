//
//  ChangePasswordViewModel.swift
//  TimeControllApp
//
//  Created by mukesh on 14/09/22.
//

import Foundation
import Alamofire
class ChangePasswordViewModel {
    
    func changePassword(email:String,password:String,completion: @escaping (Bool,String)-> Void) {
        
        let params : Parameters = [
                "email": email,
                "password" : password,
        ]
        
        DataService.sharedInstance.getData(api: endPointURL.RESETPASSWORD, param: params, completion: { (response,resultDict, errorMsg, apiStatusCode)  in
            
            if let status = response?["success"] as? Bool {
                
                 if status == true {
                    completion(true, response?["message"] as? String ?? "")
                } else {
                    completion(false, response?["message"] as? String ?? "")
                }
                
               
            } else {
                if let dicData = response?["errors"] as? NSDictionary {
                    completion(false,dicData["error"] as? String ?? "")
                }
                
            }
        })
    }
    
}
    


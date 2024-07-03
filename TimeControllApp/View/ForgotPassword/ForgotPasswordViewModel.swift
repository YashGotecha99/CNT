//
//  ForgotPasswordViewModel.swift
//  TimeControllApp
//
//  Created by mukesh on 13/09/22.
//

import Foundation
import Alamofire

class ForgotPasswordViewModel {
    
    func forgotPassword(email:String,completion: @escaping (Bool,String, Int)-> Void) {
        
        let params : Parameters = [
                "email": email,
        ]
        
        DataService.sharedInstance.getData(api: endPointURL.FORGOTPASSWORD, param: params, completion: { (response,resultDict, errorMsg, apiStatusCode)  in
            
            if let status = response?["success"] as? Bool {
                
                 if status == true {
                    completion(true, "OTP Successfully Sent Your Mail", apiStatusCode)
                } else {
                    completion(false, response?["message"] as? String ?? "", apiStatusCode)
                }
                
               
            } else {
                if let dicData = response?["errors"] as? NSDictionary {
                    completion(false,dicData["error"] as? String ?? "", apiStatusCode)
                }
                
            }
        })
    }
    
}
    

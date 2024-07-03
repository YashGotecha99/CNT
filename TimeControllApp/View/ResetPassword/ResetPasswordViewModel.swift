//
//  ResetPasswordViewModel.swift
//  TimeControllApp
//
//  Created by mukesh on 14/09/22.
//

import Foundation
import Alamofire

class ResetPasswordViewModel {
    
    func resetPassword(email:String,otp:String,completion: @escaping (Bool,String, Int)-> Void) {
        
        let params : Parameters = [
                "email": email,
                "email_otp":otp,
        ]
        
        DataService.sharedInstance.getData(api: endPointURL.VERIFYOTP, param: params, completion: { (response,resultDict, errorMsg, apiStatusCode)  in
            
            if let status = response?["success"] as? Bool {
                if status == true {
                    completion(true, response?["message"] as? String ?? "", apiStatusCode)
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
    

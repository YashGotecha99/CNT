//
//  AllUsersVM.swift
//  TimeControllApp
//
//  Created by prashant on 13/02/23.
//

import UIKit
import Alamofire

class AvailabilityVM: NSObject {
    
    static let shared = AvailabilityVM()
        
    func getAllAvailabilityData(parameters: parameters, isAuthorization: Bool, completion:@escaping (AvailabilityModel) -> Void){

        ApiManager.shared.fetch(type: AvailabilityModel.self, httpMethod: .get, api: endPointURL.getAvailability, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getAvailabilityByID(parameters: parameters, id: Int, isAuthorization: Bool, completion:@escaping (AvailabilityDetailsModel) -> Void){

        ApiManager.shared.fetch(type: AvailabilityDetailsModel.self, httpMethod: .get, api: endPointURL.getAvailabilityByID + "\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func updateAvailabilityByID(parameters: parameters, id: Int, isAuthorization: Bool, completion:@escaping (AvailabilityDetailsModel) -> Void){
        
        ApiManager.shared.post(type: AvailabilityDetailsModel.self, httpMethod: .put, api: endPointURL.getAvailabilityByID + "\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func createAvailability(parameters: parameters, isAuthorization: Bool, completion:@escaping (AvailabilityDetailsModel) -> Void){
        
        ApiManager.shared.post(type: AvailabilityDetailsModel.self, httpMethod: .post, api: endPointURL.createAvailability, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func approvedRejectAvailabilityByID(parameters: parameters, availabilityID: Int, isAuthorization: Bool, completion:@escaping (AvailabilityModel) -> Void){
        
        ApiManager.shared.post(type: AvailabilityModel.self, httpMethod: .put, api: endPointURL.getAvailabilityByID + "\(availabilityID)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}

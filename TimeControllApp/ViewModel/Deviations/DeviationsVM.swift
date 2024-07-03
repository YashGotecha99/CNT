//
//  DeviationsVM.swift
//  TimeControllApp
//
//  Created by prashant on 31/03/23.
//

import Foundation
import Alamofire

class DeviationsVM: NSObject {
    
    static let shared = DeviationsVM()
        
    func getDeviationsData(parameters: parameters, isAuthorization: Bool, completion:@escaping (DeviationsListModel) -> Void){

        ApiManager.shared.fetch(type: DeviationsListModel.self, httpMethod: .get, api: endPointURL.getDeviations, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getDeviationsByID(parameters: parameters, id: Int, isAuthorization: Bool, completion:@escaping (DeviationsDetailsModel) -> Void){

        ApiManager.shared.fetch(type: DeviationsDetailsModel.self, httpMethod: .get, api: endPointURL.getDeviations + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func createDeviation(parameters: parameters,completion: @escaping (DeviationsListModel)-> Void) {
        
        ApiManager.shared.post(type: DeviationsListModel.self, httpMethod: .post,api: endPointURL.getDeviations + "/", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func updateDeviation(parameters: parameters,id: Int, isAuthorization: Bool, completion: @escaping (DeviationsDetailsModel)-> Void) {
        
        ApiManager.shared.fetch(type: DeviationsDetailsModel.self, httpMethod: .put, api: endPointURL.getDeviations + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func assignMember(parameters: parameters,id: Int, isAuthorization: Bool, completion: @escaping (DeviationsDetailsModel)-> Void) {
        
        ApiManager.shared.fetch(type: DeviationsDetailsModel.self, httpMethod: .put, api: endPointURL.getDeviations + "/\(id)" + endPointURL.assignMember, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func unAssignMember(parameters: parameters,id: Int, isAuthorization: Bool, completion: @escaping (DeviationsDetailsModel)-> Void) {
        
        ApiManager.shared.fetch(type: DeviationsDetailsModel.self, httpMethod: .put, api: endPointURL.getDeviations + "/\(id)" + endPointURL.unAssignMember, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func reAssignMember(parameters: parameters,id: Int, isAuthorization: Bool, completion: @escaping (DeviationsDetailsModel)-> Void) {
        
        ApiManager.shared.fetch(type: DeviationsDetailsModel.self, httpMethod: .put, api: endPointURL.getDeviations + "/\(id)" + endPointURL.reAssignMember, parameters: parameters, isAuthorization: true) { success, result,value  in
            
            if success{
                print("success is : ", success)
                print("result is : ", result)
                print("value is : ", value)

                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func createChecklistDeviation(parameters: parameters,completion: @escaping (DeviationsListModel)-> Void) {
        
        ApiManager.shared.post(type: DeviationsListModel.self, httpMethod: .post,api: endPointURL.checklistDeviation, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func deleteDeviationsAPI(parameters: parameters, id: Int, isAuthorization: Bool, completion:@escaping (DeviationsListModel) -> Void){
        
        ApiManager.shared.fetch(type: DeviationsListModel.self, httpMethod: .delete, api: endPointURL.getDeviations + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}

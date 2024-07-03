//
//  CheckListVM.swift
//  TimeControllApp
//
//  Created by yash on 20/02/23.
//

import Foundation
import Alamofire

class CheckListVM: NSObject {
    
    static let shared = CheckListVM()
    
    func checkList(parameters: parameters,completion: @escaping (ChecklistsModel)-> Void) {
        ApiManager.shared.fetch(type: ChecklistsModel.self, httpMethod: .get,api:endPointURL.checkList, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func checkListDetails(id: String, completion:@escaping (CheckListDetail) -> Void){
        ApiManager.shared.fetch(type: CheckListDetail.self, httpMethod: .get, api: endPointURL.checkListDetails + "/\(id)", parameters: nil, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func checkListCheck(parameters: parameters,completion: @escaping (CheckListCheck)-> Void) {
        
        ApiManager.shared.post(type: CheckListCheck.self, httpMethod: .post,api: endPointURL.checkListCheck, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    func checkAll(parameters: parameters,completion: @escaping (CheckListCheck)-> Void) {
        
        ApiManager.shared.post(type: CheckListCheck.self, httpMethod: .post,api: endPointURL.checkAll, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func addCheckList(parameters: parameters,completion: @escaping (CheckListCheck)-> Void) {
        
        ApiManager.shared.post(type: CheckListCheck.self, httpMethod: .post,api: endPointURL.addCheckList, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    func checkListApprove(parameters: parameters,completion: @escaping (CheckListCheck)-> Void) {
        
        ApiManager.shared.post(type: CheckListCheck.self, httpMethod: .post,api: endPointURL.checkListApprove, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func checkListDelete(id:Int,completion: @escaping (CheckListCheck)-> Void) {
        ApiManager.shared.post(type: CheckListCheck.self, httpMethod: .delete,api: endPointURL.checkList + "/\(id)", parameters: nil, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func getUsersChecklist(isAuthorization: Bool, completion:@escaping ([ChecklistsRows]) -> Void){

        ApiManager.shared.fetchforProduct(type: [ChecklistsRows].self, httpMethod: .post, api: endPointURL.userCheckList, parameters: nil, isAuthorization: true) { success, result  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}

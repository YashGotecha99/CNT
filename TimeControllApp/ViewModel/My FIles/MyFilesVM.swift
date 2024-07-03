//
//  MyFilesVM.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 12/06/23.
//

import Foundation
import Alamofire

class MyFilesVM: NSObject {
    
    static let shared = MyFilesVM()
    
    func getMyFilesData(parameters: parameters, isAuthorization: Bool,userId: String, completion:@escaping (MyFilesModel) -> Void){

        ApiManager.shared.fetch(type: MyFilesModel.self, httpMethod: .get, api: endPointURL.myFilesData + "/\(userId)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getMyContractData(parameters: parameters, isAuthorization: Bool, completion:@escaping (MyFilesModel) -> Void){

        ApiManager.shared.fetch(type: MyFilesModel.self, httpMethod: .get, api: endPointURL.myContractData, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    
    func getMyFilesByIdData(parameters: parameters, isAuthorization: Bool,userId: String,fileId: Int, completion:@escaping (MyFilesByID) -> Void){

        ApiManager.shared.fetch(type: MyFilesByID.self, httpMethod: .get, api: endPointURL.myFilesByIdData + "/\(fileId)/\(userId)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getMyContractsByIdData(parameters: parameters, isAuthorization: Bool,contractId: Int, completion:@escaping (MyFilesByID) -> Void){

        ApiManager.shared.fetch(type: MyFilesByID.self, httpMethod: .get, api: endPointURL.myContractData + "/\(contractId)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func updateContractOrInternalDocByIdData(parameters: parameters, isAuthorization: Bool,contractId: Int, completion:@escaping (MyFilesByID) -> Void){
        
        ApiManager.shared.post(type: MyFilesByID.self, httpMethod: .put, api: endPointURL.myContractData + "/\(contractId)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func addContractOrInternalDocByIdData(parameters: parameters, isAuthorization: Bool, completion:@escaping (MyFilesByID) -> Void){
        
        ApiManager.shared.post(type: MyFilesByID.self, httpMethod: .post, api: endPointURL.myContractData, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func deleteMyFiles(fileId:Int,completion: @escaping (MyFilesModel)-> Void) {
        ApiManager.shared.post(type: MyFilesModel.self, httpMethod: .delete,api: endPointURL.myFilesdelete + "/\(fileId)", parameters: nil, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func deleteContractsOrInternalDoc(fileId:Int,completion: @escaping (MyFilesModel)-> Void) {
        ApiManager.shared.post(type: MyFilesModel.self, httpMethod: .delete,api: endPointURL.myContractData + "/\(fileId)", parameters: nil, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getMyFilesAttechmentsApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (UserDetailsModel,[String:Any]) -> Void){
        
        ApiManager.shared.fetch(type: UserDetailsModel.self, httpMethod: .get, api: endPointURL.usersList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result, value)
            }
        }
    }
    
    func updateMyFilesAttechmentsApi(parameters: parameters, isAuthorization: Bool,id: String, completion:@escaping (UserDetailsModel) -> Void){
        
        ApiManager.shared.post(type: UserDetailsModel.self, httpMethod: .put, api: endPointURL.usersList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}

//
//  AllUsersVM.swift
//  TimeControllApp
//
//  Created by prashant on 13/02/23.
//

import UIKit
import Alamofire

class AllUsersVM: NSObject {
    
    static let shared = AllUsersVM()
        
    func getAllUsersApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (UserListModel) -> Void){

        ApiManager.shared.fetch(type: UserListModel.self, httpMethod: .get, api: endPointURL.usersList, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getUsersByProjectApi(id: String, isAuthorization: Bool, completion:@escaping ([UserListByProjectModel]) -> Void){

        ApiManager.shared.fetchforProduct(type: [UserListByProjectModel].self, httpMethod: .get, api: endPointURL.userByProject + "/\(id)", parameters: nil, isAuthorization: true) { success, result  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getUsersDetailsApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (UserDetailsModel,[String:Any]) -> Void){
        
        ApiManager.shared.fetch(type: UserDetailsModel.self, httpMethod: .get, api: endPointURL.usersList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result, value)
            }
        }
    }
    
    func saveUserAttachment(imageId: String, imageData:String,fileName:String,type:String,completion: @escaping (Bool,String,Int)-> Void) {
        let params : Parameters = [
            "to_model": "User",
            "to_id": imageId,
            "user_id": imageId,
            "filename": fileName,
            "filetype": type,
            "content": imageData,
            "data": []
        ]
        DataService.sharedInstance.postDataWithHeader(api: endPointURL.SAVEATTACHMENT, param: params, completion: { (response,resultDict, errorMsg)  in
            
            if let attachId = response?["id"] as? Int {
                completion(true, "save attachment",attachId ?? 0)
            } else {
                if let dicData = response?["errors"] as? NSDictionary {
                    completion(false,dicData["error"] as? String ?? "", 0)
                }
            }
        })
    }
    
    func getMangeProjectsAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping ([projectsModel]) -> Void){
        
        ApiManager.shared.fetchforProduct(type: [projectsModel].self, httpMethod: .get, api: endPointURL.manageProjectList, parameters: parameters, isAuthorization: true) { success, result in
            
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getDocumentsTemplatesAPI(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (UserDocumentsModel) -> Void){

        ApiManager.shared.fetchDocument(type: UserDocumentsModel.self, httpMethod: .get, api: endPointURL.documentsTemplatesList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func saveUserProfileDetailsApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (UserDetailsModel) -> Void){
        
        ApiManager.shared.post(type: UserDetailsModel.self, httpMethod: .put, api: endPointURL.usersList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getGPSLocationAddress(parameters: parameters, isAuthorization: Bool, completion:@escaping (GpsLocationAddress) -> Void){

        ApiManager.shared.fetchDocument(type: GpsLocationAddress.self, httpMethod: .get, api: endPointURL.gpsLocation, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func saveHomeLocationApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (UserDetailsModel) -> Void){
        
        ApiManager.shared.post(type: UserDetailsModel.self, httpMethod: .put, api: endPointURL.saveGpsLocation + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getHomeLocationApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (HomeLocationUsers) -> Void){

        ApiManager.shared.fetch(type: HomeLocationUsers.self, httpMethod: .get, api: endPointURL.getHomeLocation, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getVacationsUsersData(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (VacationsDataModel) -> Void){

        ApiManager.shared.fetch(type: VacationsDataModel.self, httpMethod: .get, api: endPointURL.vacationUserData + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}



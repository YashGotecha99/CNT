//
//  VacationAbsenceVM.swift
//  TimeControllApp
//
//  Created by yash on 03/02/23.
//

import Foundation
import Alamofire

class VacationAbsenceVM: NSObject {
    
    static let shared = VacationAbsenceVM()
    
    func pendingRequestList(parameters: parameters,completion: @escaping (AbsenceListModel)-> Void) {
        ApiManager.shared.fetch(type: AbsenceListModel.self, httpMethod: .get,api:endPointURL.pendingRequestList, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func vacationList(parameters: parameters,completion: @escaping (VacationListModel)-> Void) {
        ApiManager.shared.fetch(type: VacationListModel.self, httpMethod: .get,api:endPointURL.vacationList, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    func absenceList(parameters: parameters,completion: @escaping (AbsenceListModel)-> Void) {
        ApiManager.shared.fetch(type: AbsenceListModel.self, httpMethod: .get,api:endPointURL.absencesList, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func createVacation(parameters: parameters,completion: @escaping (createVacationModel)-> Void) {
        
        ApiManager.shared.post(type: createVacationModel.self, httpMethod: .post,api: endPointURL.vacationList, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func createAbsence(parameters: parameters,completion: @escaping (createAbsenceModel)-> Void) {
        
        ApiManager.shared.post(type: createAbsenceModel.self, httpMethod: .post,api: endPointURL.absencesList, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func approveOrRejectVacation(parameters: parameters, id: String, completion:@escaping (VacationRows) -> Void){
        ApiManager.shared.post(type: VacationRows.self, httpMethod: .put, api: endPointURL.approveOrRejectVacation + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    func approveOrRejectAbsence(parameters: parameters, id: String, completion:@escaping (AbsenceRows) -> Void){
        ApiManager.shared.post(type: AbsenceRows.self, httpMethod: .put, api: endPointURL.approveOrRejectAbsence + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getAbsenceDataByID(parameters: parameters, id: Int,completion: @escaping (PendingRequestDetailsModel)-> Void) {
        ApiManager.shared.fetch(type: PendingRequestDetailsModel.self, httpMethod: .get,api:endPointURL.absencesList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
 
    func updateAbsenceDataByID(parameters: parameters, id: Int,completion: @escaping (PendingRequestDetailsModel)-> Void) {
        ApiManager.shared.post(type: PendingRequestDetailsModel.self, httpMethod: .put,api:endPointURL.absencesList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func updateVacationDataByID(parameters: parameters, id: Int,completion: @escaping (PendingRequestDetailsModel)-> Void) {
        ApiManager.shared.post(type: PendingRequestDetailsModel.self, httpMethod: .put,api:endPointURL.vacationList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getVacationDataByID(parameters: parameters, id: Int,completion: @escaping (PendingRequestDetailsModel)-> Void) {
        ApiManager.shared.fetch(type: PendingRequestDetailsModel.self, httpMethod: .get,api:endPointURL.vacationList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func deleteAbsence(parameters: parameters, id: Int, completion:@escaping (AbsenceRows) -> Void){
        ApiManager.shared.post(type: AbsenceRows.self, httpMethod: .delete, api: endPointURL.absencesList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func deleteVacation(parameters: parameters, id: Int, completion:@escaping (AbsenceRows) -> Void){
        ApiManager.shared.post(type: AbsenceRows.self, httpMethod: .delete, api: endPointURL.vacationList + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getTranslationFromAPI(parameters: parameters, langCode: String,completion: @escaping (UserListByProjectModel)-> Void) {
        ApiManager.shared.fetchforProduct(type: UserListByProjectModel.self, httpMethod: .put,api:endPointURL.locales + langCode + endPointURL.translation, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
//    func getUsersByProjectApi(id: String, isAuthorization: Bool, completion:@escaping ([UserListByProjectModel]) -> Void){
//
//        ApiManager.shared.fetchforProduct(type: [UserListByProjectModel].self, httpMethod: .get, api: endPointURL.userByProject + "/\(id)", parameters: nil, isAuthorization: true) { success, result  in
//            if success{
//                guard let result = result else {return}
//                completion(result)
//            }
//        }
//    }
}

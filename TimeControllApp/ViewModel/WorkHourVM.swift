//
//  WorkHourVM.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 01/11/22.
//

import UIKit
import Alamofire

class WorkHourVM: NSObject {
    
    static let shared = WorkHourVM()
        
    func workHourApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (WorkHourModel) -> Void){
        
        ApiManager.shared.fetch(type: WorkHourModel.self, httpMethod: .get, api: endPointURL.timelogs, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func workHourDetailsApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (WorkDetailsModel,[String:Any]) -> Void){
        
        ApiManager.shared.fetch(type: WorkDetailsModel.self, httpMethod: .get, api: endPointURL.timelogs + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                
                
                
                
                
                completion(result, value)
            }
        }
    }
    
    
    func workGetTaskApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (TaskNameModel) -> Void){
        
        ApiManager.shared.fetch(type: TaskNameModel.self, httpMethod: .get, api: endPointURL.tasks + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func updateTaskApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (TaskNameModel) -> Void){
        
        ApiManager.shared.fetch(type: TaskNameModel.self, httpMethod: .put, api: endPointURL.tasks + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func addTaskApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (TaskNameModel) -> Void){
        
        ApiManager.shared.fetch(type: TaskNameModel.self, httpMethod: .post, api: endPointURL.tasks, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func workLookUpprojectsApi(parameters: parameters, isAuthorization: Bool, completion:@escaping ([projectsModel]) -> Void){

        ApiManager.shared.fetchforProduct(type: [projectsModel].self, httpMethod: .get, api: endPointURL.manageProjectList, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func workprojectsApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (TasksModel) -> Void){
        
        ApiManager.shared.fetch(type: TasksModel.self, httpMethod: .get, api: endPointURL.projects, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func workTasksApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (TasksModel) -> Void){
        
        ApiManager.shared.fetch(type: TasksModel.self, httpMethod: .get, api: endPointURL.tasks, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    
    func workLookupTasksApi(parameters: parameters, isAuthorization: Bool, completion:@escaping ([LookupTasks]) -> Void){
        
//        ApiManager.shared.fetch(type: LookupTasks.self, httpMethod: .get, api: endPointURL.getLopkupTasks, parameters: parameters, isAuthorization: true) { success, result,value in
//            if success{
//                guard let result = result else {return}
//                completion(result)
//            }
//        }
        ApiManager.shared.fetchforProduct(type: [LookupTasks].self, httpMethod: .get, api: endPointURL.getLopkupTasks, parameters: nil, isAuthorization: true) { success, result  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func addTasksApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (AddTaskModel) -> Void){
        
        ApiManager.shared.post(type: AddTaskModel.self, httpMethod: .post, api: endPointURL.addTask, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func addWorkHoursManualyApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (WorkDetailsModel) -> Void){
        
        ApiManager.shared.post(type: WorkDetailsModel.self, httpMethod: .post, api: endPointURL.saveWorkHours, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func saveTasksApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (WorkDetailsModel) -> Void){
        
        ApiManager.shared.post(type: WorkDetailsModel.self, httpMethod: .put, api: endPointURL.timelogs + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    
    func startTakApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (WorkDetailsModel) -> Void){
        
        ApiManager.shared.post(type: WorkDetailsModel.self, httpMethod: .put, api: endPointURL.timelogsstart + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func finishTakApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (WorkDetailsModel) -> Void){
        
        ApiManager.shared.post(type: WorkDetailsModel.self, httpMethod: .put, api: endPointURL.timelogsfinish + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func breakStartApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (WorkDetailsModel) -> Void){
        
        ApiManager.shared.post(type: WorkDetailsModel.self, httpMethod: .put, api: endPointURL.timelogsbreak + "/\(id)/start", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func breakStopApi(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (WorkDetailsModel) -> Void){
        
        ApiManager.shared.post(type: WorkDetailsModel.self, httpMethod: .put, api: endPointURL.timelogsbreak + "/\(id)/stop", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    
    func getDraftIdApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (WorkDetailsModel) -> Void){
        
        ApiManager.shared.fetch(type: WorkDetailsModel.self, httpMethod: .get, api: endPointURL.draftid, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    
    func saveAttachment(imageData:String,fileName:String,type:String,completion: @escaping (Bool,String,Int)-> Void) {
        
        let params : Parameters = [
            "to_model": "Timelog",
            "to_id": 0, 
            "user_id": UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "",
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
    
    func currentDraftOrSkipApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.fetch(type: CurrentStatusModel.self, httpMethod: .get, api: endPointURL.currentDraftOrSkip, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func currentDraftOrSkipAppdelegateApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.fetchAutologInOut(type: CurrentStatusModel.self, httpMethod: .get, api: endPointURL.currentDraftOrSkip, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func startWorkHoursApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.post(type: CurrentStatusModel.self, httpMethod: .post, api: endPointURL.saveWorkHours, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func startWorkHoursApiAppdelegate(parameters: parameters, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.postAppdelegate(type: CurrentStatusModel.self, httpMethod: .post, api: endPointURL.saveWorkHours, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func sendFcmTokenAndDeviceIDApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.post(type: CurrentStatusModel.self, httpMethod: .post, api: endPointURL.fcmToken, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func finishWorkHoursAPI(parameters: parameters, id: Int, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.post(type: CurrentStatusModel.self, httpMethod: .put, api: endPointURL.finishWorkHours + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func breakResumeWorkHoursAPI(parameters: parameters, id: Int, status: String, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.fetch(type: CurrentStatusModel.self, httpMethod: .put, api: endPointURL.breakResumeWorkHours + "/\(id)/" + "/\(status)/", parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func deleteWorkHoursAPI(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (WorkHourModel) -> Void){
        
        ApiManager.shared.fetch(type: WorkHourModel.self, httpMethod: .delete, api: endPointURL.saveWorkHours + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getWorkHoursAPI(id: Int, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.fetch(type: CurrentStatusModel.self, httpMethod: .get, api: endPointURL.saveWorkHours + "/\(id)", parameters: nil, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func approveWorkHoursAPI(parameters: parameters, id: String, isAuthorization: Bool, completion:@escaping (WorkHourModel) -> Void){
        
        ApiManager.shared.fetch(type: WorkHourModel.self, httpMethod: .put, api: endPointURL.approveRejectWorkHours + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getControlPanelConfiguration(parameters: parameters, isAuthorization: Bool, completion:@escaping (ControlPanelModel) -> Void){
        
        ApiManager.shared.fetch(type: ControlPanelModel.self, httpMethod: .get, api: endPointURL.getControlPanelConfiguration, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getControlPanelConfigurationAppdelegateApi(parameters: parameters, isAuthorization: Bool, completion:@escaping (ControlPanelModel) -> Void){
        
        ApiManager.shared.fetchAutologInOut(type: ControlPanelModel.self, httpMethod: .get, api: endPointURL.getControlPanelConfiguration, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func updateWorkHoursAPI(parameters: parameters, id: Int, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.post(type: CurrentStatusModel.self, httpMethod: .put, api: endPointURL.saveWorkHours + "/\(id)", parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func injuryWorkHoursAPI(parameters: parameters, id: Int, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.fetch(type: CurrentStatusModel.self, httpMethod: .put, api: endPointURL.setInjury + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
//    func notificationListAPI(parameters: parameters,completion: @escaping ([NotificationScreenModel])-> Void) {
//        ApiManager.shared.fetchforProduct(type: [NotificationScreenModel].self, httpMethod: .get,api:endPointURL.notification, parameters: parameters, isAuthorization: true) { success, result in
//            if success{
//                guard let result = result else {return}
//                completion(result)
//            }
//        }
//    }
    
    func notificationListAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping (NotificationScreenModel) -> Void){
        
        ApiManager.shared.fetch(type: NotificationScreenModel.self, httpMethod: .get, api: endPointURL.notification, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func clearNotificationAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping (NotificationScreenModel) -> Void){
        
        ApiManager.shared.fetch(type: NotificationScreenModel.self, httpMethod: .get, api: endPointURL.clearNotification, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func sendPayrollReportByMail(parameters: parameters, apiURL: String, isAuthorization: Bool, completion:@escaping (NotificationScreenModel) -> Void){
        
        ApiManager.shared.fetchPDFData(type: NotificationScreenModel.self, httpMethod: .get, api: apiURL, parameters: parameters, isAuthorization: true) { success, result,value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func updateNotificationReadStatus(parameters: parameters, isAuthorization: Bool, completion:@escaping (CurrentStatusModel) -> Void){
        
        ApiManager.shared.post(type: CurrentStatusModel.self, httpMethod: .post, api: endPointURL.readNotification, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func validateWithTripletexAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping (TaskNameModel) -> Void){
        
        ApiManager.shared.post(type: TaskNameModel.self, httpMethod: .post, api: endPointURL.validateTimelogWithIntegration, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getGroupsData( isAuthorization: Bool, completion:@escaping (VacationsDataModel) -> Void){
        ApiManager.shared.fetch(type: VacationsDataModel.self, httpMethod: .get, api: endPointURL.usersList + "/\(UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")", parameters: nil, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}

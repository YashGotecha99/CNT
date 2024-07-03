//
//  ScheduleListViewModel.swift
//  TimeControllApp
//
//  Created by yash on 12/12/22.
//

import Foundation
import Alamofire

class ScheduleListViewModel {
    
    var scheduleListModel : ScheduleListModel?
    
    func schedule(startDate:String,endDate:String,completion: @escaping (String)-> Void) {
        
        let params : Parameters = ["start":startDate,"end":endDate,"mobile":true]
            
            DataService.sharedInstance.getDataWithParam(api: endPointURL.SCHEDULE, param: params, completion: { (response,resultDict, errorMsg)  in
                
                do {
                    if let data = resultDict{
                        let value = try JSONDecoder().decode(ScheduleListModel.self, from: data)
                        self.scheduleListModel = value
                        completion("Successfully")
                    }
                }catch let error as NSError{
                    print(error)
                    completion(error as? String ?? "")
                }
            })
        }
    
}

class ScheduleListVM: NSObject {
    
    static let shared = ScheduleListVM()
    
    func scheduleFilterList(parameters: parameters,completion: @escaping (ScheduleListModel)-> Void) {
        ApiManager.shared.fetch(type: ScheduleListModel.self, httpMethod: .get,api:endPointURL.scheduleFilterList, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func scheduleList(parameters: parameters,completion: @escaping (FormattedScheduleListModel)-> Void) {
        ApiManager.shared.fetch(type: FormattedScheduleListModel.self, httpMethod: .get,api:endPointURL.scheduleList, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func shiftsList(parameters: parameters,completion: @escaping ([ShiftByUser])-> Void) {
        ApiManager.shared.fetchforProduct(type: [ShiftByUser].self, httpMethod: .get,api:endPointURL.shiftListByUser, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func sendRequestForTrade(parameters: parameters,completion: @escaping (TradeRequest)-> Void) {
        
        ApiManager.shared.post(type: TradeRequest.self, httpMethod: .post,api: endPointURL.sendRequestForTrade, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func sendRequestForSwapSwift(parameters: parameters,completion: @escaping (TradeRequest)-> Void) {
        
        ApiManager.shared.post(type: TradeRequest.self, httpMethod: .post,api: endPointURL.sendswaprequest, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func swapTradesList(parameters: parameters,completion: @escaping (SwapRequestShiftModal)-> Void) {
        ApiManager.shared.fetch(type: SwapRequestShiftModal.self, httpMethod: .get,api:endPointURL.swapShiftRequests, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    func swapTradesMyList(parameters: parameters,completion: @escaping (SwapRequestShiftModal)-> Void) {
        ApiManager.shared.fetch(type: SwapRequestShiftModal.self, httpMethod: .get,api:endPointURL.swapShiftRequests, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func swapAccepted(parameters: parameters,completion: @escaping (SwapAcceptReject)-> Void) {
        ApiManager.shared.post(type: SwapAcceptReject.self, httpMethod: .post,api: endPointURL.swapAccepted, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func swapRejected(parameters: parameters,completion: @escaping (SwapAcceptReject)-> Void) {
        ApiManager.shared.post(type: SwapAcceptReject.self, httpMethod: .post,api: endPointURL.swapRejected, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func swapTradesListForPm(parameters: parameters,completion: @escaping (RequestShiftsForPm)-> Void) {
        ApiManager.shared.fetch(type: RequestShiftsForPm.self, httpMethod: .get,api:endPointURL.swapShiftRequestsForPm, parameters: parameters, isAuthorization: true) { success, result, value in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func swapAcceptedRejectedByPm(parameters: parameters,completion: @escaping (SwapAcceptRejectPM)-> Void) {
        ApiManager.shared.post(type: SwapAcceptRejectPM.self, httpMethod: .post,api: endPointURL.swapAcceptedRejectedByPm, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func tradeAcceptedRejectedByPm(parameters: parameters,completion: @escaping (SwapAcceptRejectPM)-> Void) {
        ApiManager.shared.post(type: SwapAcceptRejectPM.self, httpMethod: .post,api: endPointURL.tradeAcceptedRejectedByPm, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func copyWeekAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping (ScheduleListModel) -> Void){
        
        ApiManager.shared.post(type: ScheduleListModel.self, httpMethod: .put, api: endPointURL.copyWeek, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func createShiftAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping (ScheduleListModel) -> Void){
        
        ApiManager.shared.post(type: ScheduleListModel.self, httpMethod: .post, api: endPointURL.createShift, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func setLanguageAPI(parameters: parameters, isAuthorization: Bool, completion:@escaping (ScheduleListModel) -> Void){
        
        ApiManager.shared.post(type: ScheduleListModel.self, httpMethod: .post, api: endPointURL.language, parameters: parameters, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getAllShiftCount(parameters: parameters, isAuthorization: Bool, completion:@escaping (ShiftCountModal) -> Void){
        
        ApiManager.shared.fetchforProduct(type: ShiftCountModal.self, httpMethod: .get, api: endPointURL.getAllCount, parameters: parameters, isAuthorization: true) { success, result in
            
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}

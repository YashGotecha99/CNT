//
//  CreateShiftVM.swift
//  TimeControllApp
//
//  Created by yash on 29/12/22.
//

import Foundation
import Alamofire

class CreateScheduleViewModel {
    
    
    func createSchedule(startDate:String,endDate:String,completion: @escaping (String)-> Void) {
        
        let params : Parameters = ["assignee_id":startDate,
                                   "project_id":startDate,
                                   "task_id":startDate,
                                   "for_date":startDate,
                                   "start_time":startDate,
                                   "end_time":startDate,
                                   "comment":endDate,
                                   "do_notify":true,
                                   "status":"pending"]
            
            DataService.sharedInstance.getDataWithParam(api: endPointURL.SCHEDULE, param: params, completion: { (response,resultDict, errorMsg)  in
                
                do {
                    if let data = resultDict{
                        let value = try JSONDecoder().decode(ScheduleListModel.self, from: data)
//                        self.scheduleListModel = value
                        completion("Successfully")
                    }
                }catch let error as NSError{
                    print(error)
                    completion(error as? String ?? "")
                }
            })
        }
    
}


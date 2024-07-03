//
//  HomeViewModel.swift
//  TimeControllApp
//
//  Created by mukesh on 17/09/22.
//

import Foundation
import Alamofire

struct lastWorkLogModel {
    var forDate: String
    var from: Int
    var to: Int
    var name: String
    init(forDate:String, from:Int, to:Int, name:String) {
        self.forDate = forDate
        self.from = from
        self.to = to
        self.name = name
    }
}

struct newScheduleModel {
    var start_time : Int?
    var end_time : Int?
    var paid_hours : String?
    var task_name : String?
    var for_date : String?
    var task_id : Int?
    var project_id : Int?
    var gps_data : String?
    var id : Int?
    var is_multiday : Bool?
    
    init(start_time : Int, end_time : Int, paid_hours : String, task_name : String, for_date : String, task_id : Int, project_id : Int, gps_data : String, id : Int, is_multiday : Bool) {
        self.start_time = start_time
        self.end_time = end_time
        self.paid_hours = paid_hours
        self.task_name = task_name
        self.for_date = for_date
        self.task_id = task_id
        self.project_id = project_id
        self.gps_data = gps_data
        self.id = id
        self.is_multiday = is_multiday
    }
}



class HomeViewModel {
    
    var lastWorkLog = [lastWorkLogModel]()
    var newSchedule = Int()
    var newDeviation = Int()
    var dashboardScheduleData = [newScheduleModel]()
    var notificationCountData = Int()

    func dashboard(completion: @escaping (Bool,String)-> Void) {
        
        let params : Parameters = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let todayDate = Date()
//        let strTodayDate = dateFormatter.string(from: todayDate)
        let strTodayDate = getCurrentDateFromGMTDate()
        print("strTodayDate is : ", strTodayDate)
        let fromData = "?from=" + strTodayDate + "&to=" + strTodayDate + "&mobile=true"
//        let fromData = "?from=" + "2024-03-04" + "&to=" + "2024-03-04" + "&mobile=true"

        DataService.sharedInstance.getDataWithHeader(api: endPointURL.DASHBOARD + fromData, param: params, completion: { (response,resultDict, errorMsg)  in
            
            if let dicData = response as? NSDictionary {
                
//                print(dicData)
                self.lastWorkLog = []
                if let lastWorkLogData = dicData["last3Timelogs"] as? [NSDictionary] {
                    for workLog in lastWorkLogData {
                        self.lastWorkLog.append(lastWorkLogModel.init(forDate: workLog["for_date"] as? String ?? "", from: workLog["from"] as? Int ?? 0, to: workLog["to"] as? Int ?? 0, name: workLog["name"] as? String ?? ""))
                    }
                }
                
                self.newSchedule = Int(dicData["schedule"] as? String ?? "") ?? 0
//                self.dashboardScheduleData = dicData["schedule"] as! [DashboardSchedule]
                
                self.dashboardScheduleData = []

                if let scheduleData = dicData["schedule"] as? [NSDictionary] {
                    for schedule in scheduleData {
                        
                        self.dashboardScheduleData.append(newScheduleModel(start_time: schedule["start_time"] as? Int ?? 0, end_time: schedule["end_time"] as? Int ?? 0, paid_hours: schedule["paid_hours"] as? String ?? "", task_name: schedule["task_name"] as? String ?? "", for_date: schedule["for_date"] as? String ?? "", task_id: schedule["task_id"] as? Int ?? 0 , project_id: schedule["project_id"] as? Int ?? 0 , gps_data: schedule["gps_data"] as? String ?? "", id: schedule["id"] as? Int ?? 0, is_multiday: schedule["is_multiday"] as? Bool ?? false ))
                    }
                }
                
                if let deviation = dicData["deviations"] as? NSDictionary {
                    self.newDeviation = Int(dicData["newDeviations"] as? String ?? "") ?? 0
                }
                
                
                
                
                if let notificationCount = dicData["notificationCounts"] as? NSDictionary {
                    
                    print("notificationCount is : ", notificationCount)
                    self.notificationCountData = notificationCount["unreadNotificationCount"] as! Int
                }
                
                completion(true, "Login Successfully")
            } else {
                if let dicData = response?["errors"] as? NSDictionary {
                    completion(false,dicData["error"] as? String ?? "")
                }
                
            }
        })
    }
    
    
    func getCurrentDateFromGMTDate() -> String {
        let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
//        let timezoneOffset = -10

        let serverTimeZone = "\(timezoneOffset)"
        var timezoneOffsetData = ""
        if serverTimeZone.contains("-") {
            timezoneOffsetData = serverTimeZone
        } else {
            timezoneOffsetData = "+\(serverTimeZone)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT\(timezoneOffsetData)")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let currentDateInGMT = dateFormatter.string(from: Date())
        return currentDateInGMT
    }
    
    func workHour(completion: @escaping (Bool,String)-> Void) {
            
//            let params : Parameters = ["pagesize":"20","page":"0","sort":[],"filters":"{\"status\":\"approved\",\"fromDate\":\"2022-09-13\",\"toDate\":\"2022-10-30\"}"]
        
        let params : Parameters = ["pagesize":"20","page":"0","sort":[],"filters":"{\"status\":\"active\"}"]
            
            DataService.sharedInstance.getDataWithParam(api: endPointURL.timelogs, param: params, completion: { (response,resultDict, errorMsg)  in
                
                if let dicData = response as? NSDictionary {
                    
                    print(dicData)
                    if let lastWorkLogData = dicData["last3Timelogs"] as? [NSDictionary] {
                        for workLog in lastWorkLogData {
                            self.lastWorkLog.append(lastWorkLogModel.init(forDate: workLog["for_date"] as? String ?? "", from: workLog["from"] as? Int ?? 0, to: workLog["to"] as? Int ?? 0, name: workLog["name"] as? String ?? ""))
                        }
                    }
                    
                    self.newSchedule = Int(dicData["schedule"] as? String ?? "") ?? 0
                    
                    if let deviation = dicData["deviations"] as? NSDictionary {
                        self.newDeviation = Int(dicData["newDeviations"] as? String ?? "") ?? 0
                    }
                    
                    completion(true, "Login Successfully")
                } else {
                    if let dicData = response?["errors"] as? NSDictionary {
                        completion(false,dicData["error"] as? String ?? "")
                    }
                    
                }
            })
        }
    
}



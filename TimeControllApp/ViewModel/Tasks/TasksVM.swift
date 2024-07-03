//
//  TasksVM.swift
//  TimeControllApp
//
//  Created by prashant on 15/05/23.
//

import Foundation
import Alamofire

class TasksVM: NSObject {
    
    static let shared = TasksVM()
    
    func getTasksData(parameters: parameters, isAuthorization: Bool, completion:@escaping (TasksScreenModel) -> Void){

        ApiManager.shared.fetch(type: TasksScreenModel.self, httpMethod: .get, api: endPointURL.tasks, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}

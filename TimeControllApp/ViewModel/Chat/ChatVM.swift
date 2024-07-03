//
//  ChatVM.swift
//  TimeControllApp
//
//  Created by Yash.Gotecha on 12/04/23.
//

import Foundation
import Alamofire

class ChatVM: NSObject {
    
    static let shared = ChatVM()
    
    func getRooms(parameters: parameters, isAuthorization: Bool, completion:@escaping (ProjectRooms) -> Void){

        ApiManager.shared.fetch(type: ProjectRooms.self, httpMethod: .get, api: endPointURL.getRooms, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getPrivateRooms(parameters: parameters, isAuthorization: Bool, completion:@escaping (ProjectRooms) -> Void){

        ApiManager.shared.fetch(type: ProjectRooms.self, httpMethod: .get, api: endPointURL.getPrivateRooms, parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getMembers(parameters: parameters, isAuthorization: Bool, completion:@escaping ([Rooms]) -> Void){

        ApiManager.shared.fetchforProduct(type: [Rooms].self, httpMethod: .get, api: endPointURL.getMembers, parameters: parameters, isAuthorization: true) { success, result  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func createPrivateRooms(parameters: parameters, isAuthorization: Bool, completion:@escaping (ProjectRooms) -> Void){

        ApiManager.shared.post(type: ProjectRooms.self, httpMethod: .post, api: endPointURL.getPrivateRooms, parameters: parameters, isAuthorization: true) { success, result  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getRoomIdFromMessages(parameters: parameters,id: Int, isAuthorization: Bool, completion:@escaping (ChatRoomMessagesModel) -> Void){

        ApiManager.shared.fetch(type: ChatRoomMessagesModel.self, httpMethod: .get, api: endPointURL.getRoomMessages + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func getRoomIdFromPrivateMessages(parameters: parameters,id: Int, isAuthorization: Bool, completion:@escaping (ChatRoomMessagesModel) -> Void){

        ApiManager.shared.fetch(type: ChatRoomMessagesModel.self, httpMethod: .get, api: endPointURL.getRoomPrivateMessages + "/\(id)", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
    
    func deletePrivateRoom(id:Int,completion: @escaping (ChatRoomMessagesModel)-> Void) {
        ApiManager.shared.post(type: ChatRoomMessagesModel.self, httpMethod: .delete,api: endPointURL.deleteChat + "/\(id)", parameters: nil, isAuthorization: true) { success, result in
            if success{
                guard let result = result else {return}
                completion(result)
            }
            
        }
    }
    
    func getSwapSwiftEmployeesList(parameters: parameters,id: Int, isAuthorization: Bool, completion:@escaping (swapSwiftEmployeesModel) -> Void){

        ApiManager.shared.fetch(type: swapSwiftEmployeesModel.self, httpMethod: .get, api: endPointURL.swapEmployees + "/\(id)" + "/available_assignees", parameters: parameters, isAuthorization: true) { success, result,value  in
            if success{
                guard let result = result else {return}
                completion(result)
            }
        }
    }
}




import Foundation
import SocketIO
//import SwiftProtobuf

//MARK: Create link through token 

//var manager = SocketManager(socketURL: URL(string: SocketBaseUrl)!, config: [.log(true),.connectParams(["token": UserDefaults.standard.value(forKey: "token") ?? ""]), .compress])
//var manager = SocketManager(socketURL: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://tidogkontroll.no/api/")!, config: [.log(true),.connectParams(["token": UserDefaults.standard.value(forKey: "token") ?? ""]), .compress])

//var manager = SocketManager(socketURL: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://norsktimeregister.no/api/")!, config: [.log(true),.connectParams(["token": UserDefaults.standard.value(forKey: "token") ?? ""]), .compress])

var manager = SocketManager(socketURL: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://tidogkontroll.no/api/")!, config: [.log(true),.connectParams(["token": UserDefaults.standard.value(forKey: "token") ?? ""]), .compress])



class SocketIoManager: NSObject {
    static var socket = manager.defaultSocket
    static let shared = SocketIoManager()
}

struct SocketId {
    
    //MARK: Emmiter 
    
    static let connectToChat = "connectToChat"
    
    static let disConnectToChat = "disConnectToChat"
    
    static let connectWithehlo = "ehlo"
    
    //MARK: send message 
    
//    static let sendMessage = "sendMessage"
    static let sendMessage = "chat-new-message"
    static let sendPrivateMessage = "chat-new-private-message"

    //MARK: Listener 
    
//    static let receiveMessage = "receiveMessage"
    static let receiveMessage = "chat-got-message"
    static let receivePrivateMessage = "chat-got-private-message"
    
    //MARK: callAction 
    
    static let callAction = "callAction"
    static let callResponseListen = "callActionOk"
}

// MARK: EXTENSION OF SOCKET IO MANAGER
extension SocketIoManager {
    
    class func establishConnection() {
        let socketConnectionStatus = socket.status
        
        switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
            
            case SocketIOStatus.connecting:
                print("socket connecting")
            
            case SocketIOStatus.disconnected:
                print("socket disconnected")
                socket.connect()
            
            case SocketIOStatus.notConnected:
                print("socket not connected")
                socket.connect()
        }
        
        print(socket.status)
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected in")
            var param = [String:Any]()
            param["client_id"] = Int(UserDefaults.standard.string(forKey: UserDefaultKeys.clientId) ?? "0")
            param["user_id"] = Int(UserDefaults.standard.string(forKey: UserDefaultKeys.userId) ?? "0")
            socket.emit(SocketId.connectWithehlo, param)
        }
    }
    
    class func closeConnection () {
        socket.disconnect()
    }
    
    class func reCreateConnection (token: String) {
        socket.disconnect()
//        manager = SocketManager(socketURL: URL(string: SocketBaseUrl)!, config: [.log(true),.connectParams(["token": token]), .compress])
        manager = SocketManager(socketURL: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://norsktimeregister.no/api/")!, config: [.log(true),.connectParams(["token": token]), .compress])
//        manager = SocketManager(socketURL: URL(string: UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://tidogkontroll.no/api/")!, config: [.log(true),.connectParams(["token": token]), .compress])

        socket = manager.defaultSocket
        establishConnection()
    }
    
    class func connectSocket() {
        socket.connect()
    }
    
}

//MARK: Emitters 

extension SocketIoManager {
    
    class func connectToChat(dict : [String : Any]) {
        print("connectToChat emit")
        socket.emit(SocketId.connectToChat, dict)
    }
    
    class func sendMessage(dict : [String : Any], selectedSegment: String) {
        if selectedSegment == "Project" {
            socket.emit(SocketId.sendMessage, dict)
        } else {
            socket.emit(SocketId.sendPrivateMessage, dict)
        }
    }
    
    class func disConnectToChat(dict : [String : Any]) {
        socket.emit(SocketId.disConnectToChat, dict)
    }
}

//MARK: Listener Methods 

extension SocketIoManager {
    
    //MARK: To send Encodable Object to socket emitter 
    
    class func emit<T: Encodable>(key: String, request: T)  {
        do{
            let data = try JSONEncoder().encode(request)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NSError()
            }
            socket.emit(key, dictionary)
        }catch let error{
            print(error)
        }
    }
    
    //MARK: To send Dict data to socket 
    
    class func emitDict(key: String, dict : [String: Any])  {
        socket.emit(key, dict)
    }
     
    
    //MARK: Listen new Request with Generic Way (Key for Socket, Response Generic Type, Result closure with Generic data Response 
    
    class func listenNewRequest<T>(key: String, type: T.Type, completion : @escaping (Result<T, Error>) -> Void) where T: Codable{
        socket.on(key) { (data, ack) in
            guard let dict = data[0] as? [String : Any] else {
                return
            }
            do {
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataReply = try! decoder.decode(T.self, from: json) //Check for Generic type and Convert the json
                completion(.success(dataReply)) //Complete the response with Generic data
            }catch let error{
                completion(.failure(error))
            }
           
        }
    }
    
    //MARK: To listen Message data  
    
    class func listenMessage(completionHandler : @escaping (([String : Any]?)->())) {
        
        socket.on(SocketId.receivePrivateMessage) { (data, ack) in
            
            guard let dict = data[0] as? [String : Any] else {
                return
            }
            print(dict)
            completionHandler(dict)
        }
    }
    
    class func listenProjectMessage(completionHandler : @escaping (([String : Any]?)->())) {
        
        socket.on(SocketId.receiveMessage) { (data, ack) in
            
            guard let dict = data[0] as? [String : Any] else {
                return
            }
            print(dict)
            completionHandler(dict)
        }
    }
    
    class func listenForCallResponse(completionHandler : @escaping (([String : Any]?)->())) {
        
        socket.on(SocketId.callResponseListen) { (data, ack) in
            
          guard let dict = data[0] as? [String : Any] else {
            return
          }
            completionHandler(dict)
        }
      }
}


//MARK: videoCall 

extension SocketIoManager {
    
    
    class func connectTovideoCall(dict : [String : Any]) {
        socket.emit(SocketId.callAction, dict)
    }
    
    class func disConnectTovideoCall(dict : [String : Any]) {
        socket.emit(SocketId.callAction, dict)
    }
}








//
//  ApiManager.swift
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD

public typealias parameters = [String: Any]
var token = "token"
var userToken :String = UserDefaults.standard.value(forKey: token) as! String

struct ErrorMessage {
    static let somethingWentWrong = "Something went wrong."
}

class ApiManager:NSObject{
    static let shared = ApiManager()
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
 
    fileprivate func printAPI_Before(strURL:String = "", parameters:[String:Any] = [:], headers: HTTPHeaders = [:]) {
        var str = "\(parameters)"
        str = str.replacingOccurrences(of: " = ", with: ":")
        str = str.replacingOccurrences(of: "\"", with: "")
        str = str.replacingOccurrences(of: ";", with: "")
        print("APi - \(strURL)\nParameters - \(str)\nHeaders - \(headers)")
    }
    
    fileprivate func printAPI_After(response :AFDataResponse<Any>) {
        if let value = response.value {
            print("result.value: \(value)") // result of response serialization
        }
        if let error = response.error {
            print("result.error: \(error)") // result of response serialization
        }
    }
    
    
    func fetchAutologInOut<T:Decodable>(type:T.Type, httpMethod:HTTPMethod,api:String = "",parameters : [String:Any]?,isAuthorization: Bool,completionHandler : @escaping (Bool, T?,[String:Any]) -> Void){
//        SVProgressHUD.show()
        var strUrl = String()
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
//        var parameter = parameters
//        if httpMethod == .get {
//            parameter = nil
//        }
        
        ApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters ?? [:], headers: headers)
        
//        let request = AF.request(strUrl, method: httpMethod, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
        
        let request = AF.request(strUrl, method: httpMethod, parameters: parameters, encoding:  URLEncoding.default, headers: headers)
        
        print("request body: \(request.convertible.urlRequest?.url)")

        request.responseJSON {
            response in
//            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
                print(response)
                if response.response?.statusCode == 403 {
                    let dicValue = response.value as? [String: Any]
                    self.SessionExpire(message: dicValue?["error"] as? String ?? "")
                    return
                }
                if response.response?.statusCode == 200 {
                    if response.value != nil {
                        if let dicValue = response.value as? [String: Any] {
                            if let statusCode = response.response?.statusCode as? Int {
                                print(statusCode)
                                if statusCode == 200 {
                                    do {
                                        if let data = response.data{
                                            let value = try JSONDecoder().decode(type.self, from: data)
                                            completionHandler(true,value, response.value as? [String: Any] ?? [:])
                                        }
                                    }catch let error as NSError{
                                        print(error)
                                       self.AlertOnWindow(message: error.localizedDescription)
                                    }
                                }
                                else {
                                    self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                                }
                            }
                        }
                    }
                }
                else {
//                    if let dicValue = response.value as? [String: Any] {
//                        do {
//                            if let data = response.data{
//                                let value = try JSONDecoder().decode(type.self, from: data)
//                                completionHandler(true,value, response.value as? [String: Any] ?? [:])
//                            }
//                        }catch let error as NSError{
//                            print(error)
//                           self.AlertOnWindow(message: error.localizedDescription)
//                        }
////                        self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
//
//                    }else{
//                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
//
//                    }
                    // New Code
                    if let dicValue = response.value as? [String: Any] {
                        if let error = dicValue["error"] {
                            self.AlertOnWindow(message: error as? String ?? ErrorMessage.somethingWentWrong)
                        }
                        else if let errors = dicValue["errors"] as? [String: Any]  {
                            if let error = errors["error"] as? [String: Any] {
                                self.AlertOnWindow(message: errors["message"] as? String ?? ErrorMessage.somethingWentWrong)
                            } else{
                                self.AlertOnWindow(message: (errors["error"] as? String ?? dicValue["message"] as? String) ?? ErrorMessage.somethingWentWrong)
                            }
                        }
                        else {
                            self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                        }
                    }else{
                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
                        
                    }
                    //..
                }
                break
            case .failure(let error):
                completionHandler(false,nil,[:])
                self.AlertOnWindow(message: error.localizedDescription)
                
            }
        }
    }
    
    

    func fetch<T:Decodable>(type:T.Type, httpMethod:HTTPMethod,api:String = "",parameters : [String:Any]?,isAuthorization: Bool,completionHandler : @escaping (Bool, T?,[String:Any]) -> Void){
        SVProgressHUD.show()
        var strUrl = String()
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
//        var parameter = parameters
//        if httpMethod == .get {
//            parameter = nil
//        }
        
        ApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters ?? [:], headers: headers)
        
//        let request = AF.request(strUrl, method: httpMethod, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
        
        let request = AF.request(strUrl, method: httpMethod, parameters: parameters, encoding:  URLEncoding.default, headers: headers)
        
        print("request body: \(request.convertible.urlRequest?.url)")

        request.responseJSON {
            response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
//                print(response)
                if response.response?.statusCode == 403 {
                    let dicValue = response.value as? [String: Any]
                    self.SessionExpire(message: dicValue?["error"] as? String ?? "")
                    return
                }
                if response.response?.statusCode == 200 {
                    if response.value != nil {
                        if let dicValue = response.value as? [String: Any] {
                            if let statusCode = response.response?.statusCode as? Int {
                                print(statusCode)
                                if statusCode == 200 {
                                    do {
                                        if let data = response.data{
                                            let value = try JSONDecoder().decode(type.self, from: data)
                                            completionHandler(true,value, response.value as? [String: Any] ?? [:])
                                        }
                                    }catch let error as NSError{
                                        print(error)
                                       self.AlertOnWindow(message: error.localizedDescription)
                                    }
                                }
                                else {
                                    self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                                }
                            }
                        }
                    }
                }
                else {
//                    if let dicValue = response.value as? [String: Any] {
//                        do {
//                            if let data = response.data{
//                                let value = try JSONDecoder().decode(type.self, from: data)
//                                completionHandler(true,value, response.value as? [String: Any] ?? [:])
//                            }
//                        }catch let error as NSError{
//                            print(error)
//                           self.AlertOnWindow(message: error.localizedDescription)
//                        }
////                        self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
//
//                    }else{
//                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
//
//                    }
                    // New Code
                    if let dicValue = response.value as? [String: Any] {
                        if let error = dicValue["error"] {
                            self.AlertOnWindow(message: error as? String ?? ErrorMessage.somethingWentWrong)
                        }
                        else if let errors = dicValue["errors"] as? [String: Any]  {
                            if let error = errors["error"] as? [String: Any] {
                                self.AlertOnWindow(message: errors["message"] as? String ?? ErrorMessage.somethingWentWrong)
                            } else{
                                self.AlertOnWindow(message: (errors["error"] as? String ?? dicValue["message"] as? String) ?? ErrorMessage.somethingWentWrong)
                            }
                        }
                        else {
                            self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                        }
                    }else{
                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
                        
                    }
                    //..
                }
                break
            case .failure(let error):
                completionHandler(false,nil,[:])
                self.AlertOnWindow(message: error.localizedDescription)
                
            }
        }
    }
    
    func fetchforProduct<T:Decodable>(type:T.Type, httpMethod:HTTPMethod,api:String = "",parameters : [String:Any]?,isAuthorization: Bool,completionHandler : @escaping (Bool, T?) -> Void){
        SVProgressHUD.show()
        var strUrl = String()
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
        ApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters ?? [:], headers: headers)
       
       let request = AF.request(strUrl, method: httpMethod, parameters: parameters, encoding:  URLEncoding.default, headers: headers)
        
        print("request body: \(request.convertible.urlRequest?.url)")

        request.responseJSON {
            response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
                print(response)
                if response.response?.statusCode == 403 {
                    let dicValue = response.value as? [String: Any]
                    self.SessionExpire(message: dicValue?["error"] as? String ?? "")
                    return
                }
                if response.response?.statusCode == 200 {
                    if response.value != nil {
                      //  if let dicValue = response.value as? [String: Any] {
                           // if let statusCode = response.response?.statusCode as? Int {
                              //  print(statusCode)
                                if response.response?.statusCode == 200 {
                                    do {
                                      //  let courses = try JSONDecoder().decode([Course].self, from: data)

                                        if let data = response.data{
                                            let value = try JSONDecoder().decode(type.self, from: data)
                                            completionHandler(true,value)
                                        }
                                    }catch let error as NSError{
                                        print(error)
                                       self.AlertOnWindow(message: error.localizedDescription)
                                        
                                    }
                                }
                                else {
                                  //  self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                                    
                                }
                        //    }
                  //      }
                    }
                }
                else {
//                    if let dicValue = response.value as? [String: Any] {
//                        self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
//
//                    }else{
//                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
//
//                    }
                    
                    // New Code
                    if let dicValue = response.value as? [String: Any] {
                        if let error = dicValue["error"] {
                            self.AlertOnWindow(message: error as? String ?? ErrorMessage.somethingWentWrong)
                        }
                        else if let errors = dicValue["errors"] as? [String: Any]  {
                            if let error = errors["error"] as? [String: Any] {
                                self.AlertOnWindow(message: errors["message"] as? String ?? ErrorMessage.somethingWentWrong)
                            } else{
                                self.AlertOnWindow(message: (errors["error"] as? String ?? dicValue["message"] as? String) ?? ErrorMessage.somethingWentWrong)
                            }
                        }
                        else {
                            self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                        }
                    }else{
                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
                        
                    }
                    //..
                }
                break
            case .failure(let error):
                completionHandler(false,nil)
                self.AlertOnWindow(message: error.localizedDescription)
                
            }
        }
    }
    
    
    func post<T:Decodable>(type:T.Type, httpMethod:HTTPMethod,api:String = "",parameters : [String:Any]?,isAuthorization: Bool,completionHandler : @escaping (Bool, T?) -> Void){
        SVProgressHUD.show()
        var strUrl = String()
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
//        var parameter = parameters
//        if httpMethod == .get {
//            parameter = nil
//        }
        
        ApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters ?? [:], headers: headers)
        
        let request = AF.request(strUrl, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        print("request body: \(request.convertible.urlRequest?.url)")

        request.responseJSON {
            response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
                print(response)
                if response.response?.statusCode == 403 {
                    let dicValue = response.value as? [String: Any]
                    self.SessionExpire(message: dicValue?["error"] as? String ?? "")
                    return
                }
                if response.response?.statusCode == 200 {
                    if response.value != nil {
                        if let dicValue = response.value as? [String: Any] {
                            if let statusCode = response.response?.statusCode as? Int {
                                print(statusCode)
                                if statusCode == 200 {
                                    do {
                                        if let data = response.data{
                                            let value = try JSONDecoder().decode(type.self, from: data)
                                            completionHandler(true,value)
                                        }
                                    }catch let error as NSError{
                                        print(error)
                                       self.AlertOnWindow(message: error.localizedDescription)
                                        
                                    }
                                }
                                else {
                                    self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                                    
                                }
                            }
                        }
                    }
                }
                else {
                    // Old Code
//                    if let dicValue = response.value as? [String: Any] {
//                        if let error = dicValue["errors"] as? [String: Any] {
//                            self.AlertOnWindow(message: error["message"] as? String ?? ErrorMessage.somethingWentWrong)
//                        }else {
//                            self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
//                        }
//                    }else{
//                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
//
//                    }
                    //..
                    
                    // New Code
                    if let dicValue = response.value as? [String: Any] {
                        if let error = dicValue["error"] {
                            self.AlertOnWindow(message: error as? String ?? ErrorMessage.somethingWentWrong)
                        }
                        else if let errors = dicValue["errors"] as? [String: Any]  {
                            if let error = errors["error"] as? [String: Any] {
                                self.AlertOnWindow(message: errors["message"] as? String ?? ErrorMessage.somethingWentWrong)
                            } else{
                                self.AlertOnWindow(message: (errors["error"] as? String ?? dicValue["message"] as? String) ?? ErrorMessage.somethingWentWrong)
                            }
                        }
                        else {
                            self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                        }
                    }else{
                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
                        
                    }
                    //..
                }
                break
            case .failure(let error):
                completionHandler(false,nil)
                self.AlertOnWindow(message: error.localizedDescription)
                
            }
        }
    }
    
    
    // Appdelegate post API
    
    func postAppdelegate<T:Decodable>(type:T.Type, httpMethod:HTTPMethod,api:String = "",parameters : [String:Any]?,isAuthorization: Bool,completionHandler : @escaping (Bool, T?) -> Void){
        SVProgressHUD.show()
        var strUrl = String()
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
//        var parameter = parameters
//        if httpMethod == .get {
//            parameter = nil
//        }
        
        ApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters ?? [:], headers: headers)
        
        let request = AF.request(strUrl, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        print("request body: \(request.convertible.urlRequest?.url)")

        request.responseJSON {
            response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
                print(response)
//                if response.response?.statusCode == 403 {
//                    let dicValue = response.value as? [String: Any]
//                    self.SessionExpire(message: dicValue?["error"] as? String ?? "")
//                    return
//                }
                if response.response?.statusCode == 200 {
                    if response.value != nil {
                        if let dicValue = response.value as? [String: Any] {
                            if let statusCode = response.response?.statusCode as? Int {
                                print(statusCode)
                                if statusCode == 200 {
                                    do {
                                        if let data = response.data{
                                            let value = try JSONDecoder().decode(type.self, from: data)
                                            completionHandler(true,value)
                                        }
                                    }catch let error as NSError{
                                        print(error)
                                       self.AlertOnWindow(message: error.localizedDescription)
                                        
                                    }
                                }
                                else {
                                    self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                                    
                                }
                            }
                        }
                    }
                }
                else {
                    // Old Code
//                    if let dicValue = response.value as? [String: Any] {
//                        if let error = dicValue["errors"] as? [String: Any] {
//                            self.AlertOnWindow(message: error["message"] as? String ?? ErrorMessage.somethingWentWrong)
//                        }else {
//                            self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
//                        }
//                    }else{
//                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
//
//                    }
                    //..
                    
                    // New Code
//                    if let dicValue = response.value as? [String: Any] {
//                        if let error = dicValue["error"] {
//                            self.AlertOnWindow(message: error as? String ?? ErrorMessage.somethingWentWrong)
//                        }
//                        else if let errors = dicValue["errors"] as? [String: Any]  {
//                            if let error = errors["error"] as? [String: Any] {
//                                self.AlertOnWindow(message: errors["message"] as? String ?? ErrorMessage.somethingWentWrong)
//                            } else{
//                                self.AlertOnWindow(message: (errors["error"] as? String ?? dicValue["message"] as? String) ?? ErrorMessage.somethingWentWrong)
//                            }
//                        }
//                        else {
//                            self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
//                        }
//                    }else{
//                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
//                        
//                    }
                    //..
                }
                break
            case .failure(let error):
                completionHandler(false,nil)
                self.AlertOnWindow(message: error.localizedDescription)
                
            }
        }
    }
    
    
//    func UploadImageWithParameters<T:Decodable>(type:T.Type,image: Data?, api:String = "", params: [String: Any]?,completionHandler : @escaping (Bool, T?) -> Void) {
//      //  PROGRESS.hud.show()
//       // let nam = String(Date().timeStamp)
//        let base_url = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
//
//        let token = UserDefaults.standard.string(forKey: token) ?? ""
//        var headers : HTTPHeaders = ["Content-Type":"application/json",
//                                     "accept": "application/json"]
//        if !token.isEmpty {
//            headers["Authorization"] = token
//        }else{
//            headers["Authorization"] = "Guest"
//        }
//
//
//        AF.upload(multipartFormData: { multiPart in
//            for (key, value) in params ?? [:] {
//                if let temp = value as? String {
//                    multiPart.append(temp.data(using: .utf8)!, withName: key)
//                }
//                if let temp = value as? Int {
//                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
//                }
//                if let temp = value as? NSArray {
//                    temp.forEach({ element in
//                        let keyObj = key + "[]"
//                        if let string = element as? String {
//                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
//                        } else
//                        if let num = element as? Int {
//                            let value = "\(num)"
//                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
//                        }
//                    })
//                }
//            }
//            if image != nil{
//                multiPart.append(image!, withName: "upload", fileName: "file.png", mimeType: "image/png")
//            }
//
//        }, to: URL.init(string: base_url)!,
//                  method: .post, headers: headers)
//            .uploadProgress(queue: .main, closure: { progress in
//                //Current upload progress of file
//
//                print("Upload Progress: \(progress.fractionCompleted)")
//            })
//            .responseJSON(completionHandler: { response in
//
//                switch response.result {
//                case .success:
//                    print(response)
//                    //Loader.stop()
//                    if( response.data != nil){
//                        do {
//                            let value = try JSONDecoder().decode(type, from: response.data!)
//                            completionHandler(true,value)
//                        }catch let error as NSError{
//                            print(error)
//                        }
//                    }
//                    break
//                case .failure( let error):
//                    print(error.localizedDescription)
//               // Loader.stop()
//                    completionHandler(false,nil)
//                }
//
//
//                //Do what ever you want to do with response
//            })
//    }
    
    
    
    
//    func Apirequest(url:String,param:[String:Any]?,methodType:HTTPMethod,showIndicator: Bool,view:UIView,completionBlock: @escaping ( _ responseObject: Data) -> Void) {
//
//        print("Params : \(param)")
//        print("URL: \(url)")
//
//        if NetworkReachabilityManager()!.isReachable {
//
//            if showIndicator {
//
//               // ActivityIndicator.sharedInstance.showActivityIndicator(view: view)
//            }
//            let token = UserDefaults.standard.string(forKey: token) ?? ""
//            var headers : HTTPHeaders = ["Content-Type":"application/json",
//                                         "accept": "application/json"]
//            if !token.isEmpty {
//                headers["Authorization"] = token
//            }else{
//                headers["Authorization"] = "Guest"
//            }
//
//            AF.request(url, method : methodType, parameters : param, encoding : JSONEncoding.default , headers : headers).responseJSON { (response:DataResponse) in
//                print(response)
//              //  print("Header:- ",WebService.headers())
//              //  ActivityIndicator.sharedInstance.hideActivityIndicator()
//                // Proxy.shared.hideActivityIndicator()
//
//                switch(response.result)
//                {
//                case .success:
//
//                    if let responseData = response.data {
//                        do {
//
//                            if response.response?.statusCode == 200  {
//                                completionBlock(responseData)
//                            }
//                            else if (response.response?.statusCode == 400) {
//
//                                if let message = response.value as? [String : Any]
//                                {
//                                    if (message["message"] as? String) != nil
//                                    {
//                                        completionBlock(responseData)
//                                    //    Proxy.shared.displayStatusCodeAlert((message["message"] as! String))
//                                    }
//                                }
//                            }
//                            else if (response.response?.statusCode == 404) {
//
//                                if let message = response.value as? [String : Any]
//                                {
//                                    if (message["message"] as? String) != nil
//                                    {
//
//                                      //  Proxy.shared.displayStatusCodeAlert((message["message"] as! String))
//                                    }
//                                }
//                            }
////                            else if (response.response?.statusCode == 408) {
////                                isNotresponding()
////
////                            }
//
//                            else if (response.response?.statusCode == 500) {
//
//                                if let message = response.value as? [String : Any]
//                                {
//                                    if (message["message"] as? String) != nil
//                                    {
//                                     //   Proxy.shared.displayStatusCodeAlert((message["message"] as! String))
//                                    }
//                                }
//                            }
//                            else if (response.response?.statusCode == 300) {
//
//
//                            }
//                            else if (response.response?.statusCode == 401) {
//
////                                userDefault.set(false, forKey: Keys.isUserLoggedIn)
////                                userDefault.removeObject(forKey: Keys.secretKey)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.DeviceId)
//////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.deviceToken)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.UserId)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.token)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.TutorialStatus)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.profileImg)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverName)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverIsVerify)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverPhoneNumber)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverEmail)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverCountryCode)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.orderStatusID)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.orderID)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.orderStatusNumber)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverLatitude)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.driverLongitude)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.destinationLatitude)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.NotiToken)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isEmailVerify)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isPhoneVerify)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.profileStatus)
////                                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.socketIsConnected)
//
//                               // (UIApplication.shared.delegate as! AppDelegate).rootAsLogin()
//
//                            }
//                            else {
//
//                            }
//                        }
//                    }
//                    else {
//                        let alertController = UIAlertController(title: "", message:
//                                                                    response.error?.localizedDescription, preferredStyle: .alert)
//                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
//                        }))
//                        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//                    }
//
//                    debugPrint(response)
//
//                case .failure(let error):
//                    if (response.response?.statusCode == 404) {
//
//                        if let message = response.value as? [String : Any]
//                        {
//                            if (message["message"] as? String) != nil
//                            {
//                               // Proxy.shared.displayStatusCodeAlert((message["message"] as! String))
//                            }
//                        }
//                    }
//                    print(error.responseCode)
//
//                    if error.responseCode == NSURLErrorTimedOut{
//                       // Proxy.shared.displayStatusCodeAlert("Request timeout!")
//                    }
//                    else {
//
//                      //  Proxy.shared.displayStatusCodeAlert("Server not responding.")
//
//                    }
//
//                    break
//                }
//            }
//        }
//        else{
//            //Proxy.shared.hideActivityIndicator()
////            ActivityIndicator.sharedInstance.hideActivityIndicator()
////            Proxy.shared.openSettingApp()
//        }
//    }
    
    
//    func uploadimg<T:Decodable>(type:T.Type,img: Data?,api:String = "",isAuthorization: Bool,httpMethod:HTTPMethod,completionHandler : @escaping (Bool, T?) -> Void) {
//        PROGRESS.hud.show()
//        let nam = String(Date().timeStamp)
//        let base_url = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
//        let token = UserDefaults.standard.string(forKey: token) ?? ""
//        var headers : HTTPHeaders = ["Content-Type":"application/json",
//                                     "accept": "application/json"]
//        if !token.isEmpty {
//            headers["Authorization"] = token
//        }else{
//            headers["Authorization"] = "Guest"
//        }
//        let param = [String : AnyObject]()
//        AF.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in param {
//                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
//            }
//            if let data = img{
//                multipartFormData.append(data, withName: "image", fileName: nam, mimeType: "image/png")
//            }
//        },to: URL.init(string: base_url)!, usingThreshold: UInt64.init(),
//                  method: .post,
//                  headers: headers).response{  response in
//            PROGRESS.hud.dismiss()
//            if((response.error == nil)){
//                do{
//                    if let jsonData = response.data{
//                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
//                        print(parsedData)
//                        completionHandler(true,parsedData as? T)
//    //                    uploadedImage = parsedData["data"] ?? ""
//    //                    print(uploadedImage)
//    //                    ActivityIndicator.sharedInstance.hideActivityIndicator()
//                    }
//                }catch{
//                    print("error message")
//                   // ActivityIndicator.sharedInstance.hideActivityIndicator()
//                }
//            }else{
//    //            showAlert(message: response.error?.localizedDescription ?? "Error", strtitle: "Alert")
//    //            ActivityIndicator.sharedInstance.hideActivityIndicator()
//            }
//        }
//    }


    

    
    func AlertOnWindow(message: String) {
        let alert = UIAlertController(title: "Alert!!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        if let topvc = UIApplication.topMostViewController{
            topvc.present(alert, animated: true, completion: nil)
        }
    }
    
    func SessionExpire(message: String) {
        let alert = UIAlertController(title: "Alert!!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//            UserDefaults.standard.set(nil, forKey: token)
            self.gotoLoginAsRoot()
        }))
        // show the alert
        if let topvc = UIApplication.topMostViewController{
            topvc.present(alert, animated: true, completion: nil)
        }
    }
    
    func gotoLoginAsRoot() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.token)
        
        // First Way
        /*
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        let loginViewController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC")
        window.rootViewController = loginViewController
        window.makeKeyAndVisible()
         */
        
        
        // Second Way
        guard let window = UIApplication.shared.windows.first else {
            return
        }

        // Create an instance of the navigation controller and set LoginVC as its root
        let navigationController = UINavigationController()
        
        let oldNavigationController = window.rootViewController as? UINavigationController

        let loginViewController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC")
        oldNavigationController?.viewControllers = [loginViewController]

        // Set the navigation controller as the root view controller
        window.rootViewController = oldNavigationController
        window.makeKeyAndVisible()
        
    }
    
    func fetchDocument<T:Decodable>(type:T.Type, httpMethod:HTTPMethod,api:String = "",parameters : [String:Any]?,isAuthorization: Bool,completionHandler : @escaping (Bool, T?,[String:Any]) -> Void){
        SVProgressHUD.show()
        var strUrl = String()
//        strUrl = "https://norsktimeregister.no/api/" + api
//        if !DataService.isConnectedToNetwork()
//        {
//            DataService().networkErrorMsg()
//            return
//        }
//
//        let headers : HTTPHeaders = [
//            "Authorization" : "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjE5OCwidXNlcm5hbWUiOiJNb25pa2EgUE0iLCJleHAiOjE5OTU5NDk0ODEsImlhdCI6MTY3NTQwNTQ4MX0._JoxJGjSA2A1Cu5CQX0u14J7OedWdY4yVYYFGdBl-c0"
//        ]
        
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
        
//        var parameter = parameters
//        if httpMethod == .get {
//            parameter = nil
//        }
        
        ApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters ?? [:], headers: headers)
        
//        let request = AF.request(strUrl, method: httpMethod, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
        
        let request = AF.request(strUrl, method: httpMethod, parameters: parameters, encoding:  URLEncoding.default, headers: headers)
        
        print("request body: \(request.convertible.urlRequest?.url)")

        request.responseJSON {
            response in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success:
                print(response)
                if response.response?.statusCode == 403 {
                    let dicValue = response.value as? [String: Any]
                    self.SessionExpire(message: dicValue?["error"] as? String ?? "")
                    return
                }
                if response.response?.statusCode == 200 {
                    if response.value != nil {
                        if let dicValue = response.value as? [String: Any] {
                            if let statusCode = response.response?.statusCode as? Int {
                                print(statusCode)
                                if statusCode == 200 {
                                    do {
                                        if let data = response.data{
                                            let value = try JSONDecoder().decode(type.self, from: data)
                                            completionHandler(true,value, response.value as? [String: Any] ?? [:])
                                        }
                                    }catch let error as NSError{
                                        print(error)
                                       self.AlertOnWindow(message: error.localizedDescription)
                                    }
                                }
                                else {
                                    self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                                }
                            }
                        }
                    }
                }
                else {
                    if let dicValue = response.value as? [String: Any] {
                        self.AlertOnWindow(message: dicValue["message"] as? String ?? ErrorMessage.somethingWentWrong)
                        
                    }else{
                        self.AlertOnWindow(message: ErrorMessage.somethingWentWrong)
                        
                    }
                }
                break
            case .failure(let error):
                completionHandler(false,nil,[:])
                self.AlertOnWindow(message: error.localizedDescription)
                
            }
        }
    }
    
    func fetchPDFData<T:Decodable>(type:T.Type, httpMethod:HTTPMethod,api:String = "",parameters : [String:Any]?,isAuthorization: Bool,completionHandler : @escaping (Bool, T?,[String:Any]) -> Void){
        SVProgressHUD.show()
        var strUrl = String()
        strUrl = api
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
//        var parameter = parameters
//        if httpMethod == .get {
//            parameter = nil
//        }
        
        ApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters ?? [:], headers: headers)
        
//        let request = AF.request(strUrl, method: httpMethod, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
        
        let request = AF.request(strUrl, method: httpMethod, parameters: parameters, encoding:  URLEncoding.default, headers: headers)
        
        print("request body: \(request.convertible.urlRequest?.url)")

        request.responseJSON {
            response in
            SVProgressHUD.dismiss()
            self.AlertOnWindow(message: LocalizationKey.pdfSentOnYourEmailId.localizing())
        }
    }
    
}








//extension UIApplication {
//    static var topMostViewController: UIViewController? {
//        return UIWindow.window?.rootViewController?.visibleViewControllerforvc
//    }
//}
//extension UIViewController {
//    var visibleViewControllerforvc: UIViewController? {
//        if let navigationController = self as? UINavigationController {
//            return navigationController.topViewController?.visibleViewControllerforvc
//        } else if let tabBarController = self as? UITabBarController {
//            return tabBarController.selectedViewController?.visibleViewControllerforvc
//        } else if let presentedViewController = presentedViewController {
//            return presentedViewController.visibleViewControllerforvc
//        } else {
//            return self
//        }
//    }
//    
//}


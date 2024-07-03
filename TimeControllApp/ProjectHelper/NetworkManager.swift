//
//  NetworkManager.swift
//  PinkyPromise
//
//  Created by Gaurav Sharma on 30/07/22.
//

import Foundation
import SystemConfiguration
import Foundation
import Alamofire

typealias CompletionBlock           = (Bool, String?) -> Void
typealias CompletionBlockWithDict   = ([String:Any]?, String?) -> Void
typealias CompletionBlockWithArray  = ([Any]?, String?) -> Void
typealias CompletionBlockWithStatus  = (Bool?, String?) -> Void
typealias CompletionBlockWithError   = ([String:Any]?,Data?, String?) -> Void
typealias CompletionBlockWithStatusCodeError   = ([String:Any]?,Data?, String?, Int) -> Void

class DataService: NSObject {
    
    static let sharedInstance = DataService()
    
    func getData(api:String = "",param:[String:Any], completion: @escaping CompletionBlockWithStatusCodeError) {
        
        let url = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
            debugPrint(response)
            guard let data = response.data else {
                return
                
            }
            switch response.result {
            case .failure(let error):
                
                completion(nil,nil,error.localizedDescription, response.response!.statusCode)
            case .success(let value):
                
                let successItem = response.value as? [String:Any]
                if let data = response.data{
                    completion(successItem!,response.data,nil, response.response!.statusCode)
                }
            }
        })
    }
    
    func getDataWithHeader(api:String = "",param:[String:Any], completion: @escaping CompletionBlockWithError) {
        let url = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
             debugPrint(response)
                guard let data = response.data else {
                    return
                }
                switch response.result {
                case .failure(let error):
                    completion(nil,nil,error.localizedDescription)
                case .success(let value):
                    let successItem = response.value as? [String:Any]
                    completion(successItem!,response.data,nil )
                }
            })
    }
    
    
    func getDataWithParam(api:String = "",param:[String:Any], completion: @escaping CompletionBlockWithError) {
        let url = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
            if !DataService.isConnectedToNetwork()
            {
                DataService().networkErrorMsg()
                return
            }
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
            
            AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                 debugPrint(response)
                    guard let data = response.data else {
                        return
                    }
                    switch response.result {
                    case .failure(let error):
                        completion(nil,nil,error.localizedDescription)
                    case .success(let value):
                        let successItem = response.value as? [String:Any]
                        completion(successItem!,response.data,nil )
                    }
                })
        }
    
    func postDataWithHeader(api: String = "",param:[String:Any], completion: @escaping CompletionBlockWithError) {
        let url = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: api as NSString)
        if !DataService.isConnectedToNetwork()
        {
            DataService().networkErrorMsg()
            return
        }
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(UserDefaults.standard.string(forKey: UserDefaultKeys.token) ?? "")"
        ]
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
             debugPrint(response)
                guard let data = response.data else {
                    return
                }
                switch response.result {
                case .failure(let error):
                    completion(nil,nil,error.localizedDescription)
                case .success(let value):
                    let successItem = response.value as? [String:Any]
                    completion(successItem!,response.data,nil )
                }
            })
    }
    
//    func sendRequest(endPoint: String,parameters: [String: Any], completionHandler: @escaping CompletionBlockWithDict) {
//        if !DataService.isConnectedToNetwork()
//        {
//            DataService().networkErrorMsg()
//            return
//        }
//
//
//
//        AF.request(endPoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
//            debugPrint(response)
//
//            switch response.result {
//
//            case .success(let value):
//
//                if let successItem = value as? [String: Any] {
//                    completionHandler(successItem,nil)
//                }
//                break
//            case .failure(let error):
//
//                completionHandler(nil,error.localizedDescription)
//
//                break
//            }
//        }
//
//    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func networkErrorMsg()
    {
        displayToast("You are not connected to the internet")
    }
}

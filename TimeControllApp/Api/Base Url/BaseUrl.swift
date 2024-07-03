//
//  BaseUrl.swift
//
//

import Foundation
import UIKit

var isApplive = false
var liveURL = "https://tidogkontroll.no/api/"
//var liveURL = "https://norsktimeregister.no/api/"
var SocketBaseUrl = "https://tidogkontroll.no/api/"
//var SocketBaseUrl = "https://norsktimeregister.no/api/"

//var liveURL = "http://172.18.5.222:3000/api/"
////var liveURL = "https://norsktimeregister.no/api/"
//var SocketBaseUrl = "http://172.18.5.222:3000/api/"


var serverUrl : String {
    
    return liveURL
}

class BaseUrl: NSObject {
    static let sharedInstance = BaseUrl()
    
    override init() {
    }
    
    func CreateMainUrl(optionalUrl:NSString) -> String {
//        let base_url = "\(serverUrl)"
//        let base_url = "\(GlobleVariables.dynamicBaseUrl)"
//        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://norsktimeregister.no/api/"
        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://tidogkontroll.no/api/"
        let main_url = "\(base_url )\(optionalUrl )"
        return main_url as String
    }
    
    func CreateMediaUrl(optionalUrl:NSString) -> String {
//        let base_url = serverUrl
//        let base_url = "\(GlobleVariables.dynamicBaseUrl)"
//        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://norsktimeregister.no/api/"
        let base_url = UserDefaults.standard.string(forKey: UserDefaultKeys.serverChangeURL) ?? "https://tidogkontroll.no/api/"
        let main_url = "\(base_url )\(optionalUrl )"
        return main_url as String
    }
    
//    func CreateUploadUrl(optionalUrl:NSString) -> String {
//        let base_url = UploadUrl
//        let main_url = "\(base_url )\(optionalUrl )"
//        return main_url as String
//    }
}

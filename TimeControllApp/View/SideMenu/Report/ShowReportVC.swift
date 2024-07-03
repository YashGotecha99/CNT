//
//  ShowReportVC.swift
//  TimeControllApp
//
//  Created by prashant on 06/06/23.
//

import UIKit
import WebKit

class ShowReportVC: BaseViewController {

    @IBOutlet weak var showReportTitleLbl: UILabel!
    @IBOutlet weak var staticEmailLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var downloadAsPDFBtn: UIButton!
    @IBOutlet weak var sendPDFByEmailBtn: UIButton!
    @IBOutlet weak var webVw: WKWebView!
    
    var strUrl = ""
    var getParamData = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Param data is : ", getParamData["projectname"])
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func configUI(){
        let url: URL! = URL(string: strUrl)
        webVw.load(URLRequest(url: url))
    }
    
    @IBAction override func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func downloadAsPDFBtn(_ sender: Any) {
        downloadAsPDF()
    }
    
    @IBAction func sendPDFByEmailBtn(_ sender: Any) {
        if emailTxt.text == "" {
            self.showAlert(message: LocalizationKey.pleaseEnterEmail.localizing(), strtitle: LocalizationKey.alert.localizing())
            return
        }
        sendPDFByEmail()
    }
}

extension ShowReportVC {
    
    func sendPDFByEmail() -> Void {
        let startOfWeekDate = Date().startOfWeek
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        let serverStartOfWeekDate = serverDateFormatter.string(from: startOfWeekDate)

        var param = [String:Any]()
        param["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        param["mode"] = getParamData["mode"]
        param["mail"] = true
        param["all_members"] =  false
        param["pdf"] = true
        param["excel"] = false
        param["zirius"] = false
        param["users"] = getParamData["users"]
        param["email"] = emailTxt.text
        param["approved_only"] = getParamData["approved_only"]
        param["project"] = ""
        param["gps"] = nil
        param["consider_overtime"] = nil
        param["projectname"] = getParamData["projectname"]
        param["start"] = getParamData["start"]
        param["end"] = getParamData["end"]
        param["weekStart"] = serverStartOfWeekDate
        param["include_images"] = true
        param["include_extra"] = nil
        param["include_extra_images"] = nil
        param["include_distance"] = nil
        param["include_travel_expenses"] = nil
        param["include_other_expenses"] = nil
        param["include_weekend_hours"] = getParamData["include_weekend_hours"]
        param["include_missing_hours"] = false
        param["is_project_mode"] = getParamData["is_project_mode"]
        param["preview"] = false
        param["authorization"] = UserDefaults.standard.string(forKey: UserDefaultKeys.token)

        var strUrl = String()
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.sendReport as NSString)

        // Create URL components
        var urlComponents = URLComponents(string: strUrl)

        // Create an array to store the query items
        var queryItems = [URLQueryItem]()

        // Iterate over the parameters dictionary
        for (key, value) in param {
            // Create a query item with the parameter key and value
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            // Add the query item to the array
            queryItems.append(queryItem)
        }

        // Set the query items of the URL components
        urlComponents?.queryItems = queryItems

        // Get the updated URL string with the query parameters
        if let updatedUrlString = urlComponents?.url?.absoluteString {
            strUrl = updatedUrlString
        }
        print("strUrl",strUrl)
        let param1 = [String:Any]()

        WorkHourVM.shared.sendPayrollReportByMail(parameters: param1, apiURL: strUrl ,isAuthorization: false) { [self] obj in
            
//            showAlert(message: LocalizationKey.pdfSentOnYourEmailId.localizing(), strtitle: LocalizationKey.success.localizing()) {_ in
//                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    
    func downloadAsPDF() -> Void {
        let startOfWeekDate = Date().startOfWeek
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-MM-dd"
        let serverStartOfWeekDate = serverDateFormatter.string(from: startOfWeekDate)

        var param = [String:Any]()
        param["user_id"] = UserDefaults.standard.string(forKey: UserDefaultKeys.userId)
        param["mode"] = getParamData["mode"]
        param["mail"] = false
        param["all_members"] =  false
        param["pdf"] = true
        param["excel"] = false
        param["zirius"] = false
        param["users"] = getParamData["users"]
        param["email"] = ""
        param["approved_only"] = getParamData["approved_only"]
        param["project"] = ""
        param["gps"] = nil
        param["consider_overtime"] = nil
        param["projectname"] = getParamData["projectname"]
        param["start"] = getParamData["start"]
        param["end"] = getParamData["end"]
        param["weekStart"] = serverStartOfWeekDate
        param["include_images"] = true
        param["include_extra"] = nil
        param["include_extra_images"] = nil
        param["include_distance"] = nil
        param["include_travel_expenses"] = nil
        param["include_other_expenses"] = nil
        param["include_weekend_hours"] = getParamData["include_weekend_hours"]
        param["include_missing_hours"] = false
        param["is_project_mode"] = getParamData["is_project_mode"]
        param["preview"] = false
        param["authorization"] = UserDefaults.standard.string(forKey: UserDefaultKeys.token)

        var strUrl = String()
        strUrl = BaseUrl.sharedInstance.CreateMainUrl(optionalUrl: endPointURL.sendReport as NSString)

        // Create URL components
        var urlComponents = URLComponents(string: strUrl)

        // Create an array to store the query items
        var queryItems = [URLQueryItem]()

        // Iterate over the parameters dictionary
        for (key, value) in param {
            // Create a query item with the parameter key and value
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            // Add the query item to the array
            queryItems.append(queryItem)
        }

        // Set the query items of the URL components
        urlComponents?.queryItems = queryItems

        // Get the updated URL string with the query parameters
        if let updatedUrlString = urlComponents?.url?.absoluteString {
            strUrl = updatedUrlString
        }
        print("strUrl",strUrl)
        if let url = URL(string: strUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

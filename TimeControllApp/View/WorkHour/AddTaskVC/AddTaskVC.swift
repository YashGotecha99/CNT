//
//  AddTaskVC.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 09/11/22.
//

import UIKit

class AddTaskVC: UIViewController, SelectProjectProtocol, TaskMapVCProtocol {
    
    

    @IBOutlet weak var txtProjectName: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtLeaveNumber: UITextField!
    
    @IBOutlet weak var segmentedControler: UISegmentedControl!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var txtZipCode: UITextField!
    
    @IBOutlet weak var txtFr: UITextField!
    
    @IBOutlet weak var txtnr: UITextField!
    
    @IBOutlet weak var txtGPSData: UITextField!
    
    @IBOutlet weak var txtDescription: UITextField!
    
    @IBOutlet weak var txtEstimateHours: UITextField!
    
    @IBOutlet weak var segmentEstwork: UISegmentedControl!
    
    var lat = "59.9139"
    var long = "10.7522"
    
    var projectId = String()
    var selectedTab = String()
    
    //MARK: Localizations

    @IBOutlet weak var taskInfoTitleLbl: UILabel!
    @IBOutlet weak var staticProjectNameLbl: UILabel!
    @IBOutlet weak var staticNameLbl: UILabel!
    @IBOutlet weak var staticNumberLbl: UILabel!
    @IBOutlet weak var staticAddressLbl: UILabel!
    @IBOutlet weak var staticZipCodeLbl: UILabel!
    @IBOutlet weak var staticCityLbl: UILabel!
    @IBOutlet weak var staticGnrLbl: UILabel!
    @IBOutlet weak var staticBnrLbl: UILabel!
    @IBOutlet weak var staticGpsDataLbl: UILabel!
    @IBOutlet weak var staticDescriptionLbl: UILabel!
    @IBOutlet weak var staticCostAndExpenseLbl: UILabel!
    @IBOutlet weak var staticEstimatedHours: UILabel!
    @IBOutlet weak var saveBtnObj: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        selectedTab = segmentedControler.titleForSegment(at: segmentedControler.selectedSegmentIndex) ?? ""
        hitprojectsApi()
    }
    
    func setUpLocalization(){
        taskInfoTitleLbl.text  = LocalizationKey.taskInfoLbl.localizing()
        staticProjectNameLbl.text  = LocalizationKey.project.localizing()
        staticNameLbl.text = LocalizationKey.name.localizing()
        staticNumberLbl.text = LocalizationKey.number.localizing()
        staticAddressLbl.text = LocalizationKey.address.localizing()
        staticZipCodeLbl.text = LocalizationKey.zipCode.localizing()
        staticCityLbl.text = LocalizationKey.city.localizing()
        staticGnrLbl.text = LocalizationKey.gNr.localizing()
        staticBnrLbl.text = LocalizationKey.bNr.localizing()
        staticGpsDataLbl.text = LocalizationKey.gPSData.localizing()
        staticDescriptionLbl.text = LocalizationKey.dESCRIPTION.localizing()
        staticCostAndExpenseLbl.text = LocalizationKey.costAndExpenses.localizing()
        staticEstimatedHours.text = LocalizationKey.estimatedHours.localizing()
        saveBtnObj.setTitle(LocalizationKey.save.localizing(), for: .normal)
        
        txtProjectName.placeholder = LocalizationKey.enterProjectName.localizing()
        txtName.placeholder = LocalizationKey.enterTaskName.localizing()
        txtLeaveNumber.placeholder = LocalizationKey.leaveTheFieldToBeFilledAutomatically.localizing()
        txtAddress.placeholder = LocalizationKey.address.localizing()
        txtZipCode.placeholder = LocalizationKey.zipCode.localizing()
        txtCity.placeholder = LocalizationKey.postPlace.localizing()
        txtFr.placeholder = LocalizationKey.gNr.localizing()
        txtnr.placeholder = LocalizationKey.bNr.localizing()
        txtGPSData.placeholder = LocalizationKey.gpsData.localizing()
        txtDescription.placeholder = LocalizationKey.enterDescription.localizing()
        txtEstimateHours.placeholder = LocalizationKey.estimatedHours.localizing()
        
        segmentedControler.setTitle(LocalizationKey.active.localizing(), forSegmentAt: 0)
        segmentedControler.setTitle(LocalizationKey.inactive.localizing(), forSegmentAt: 1)
        segmentedControler.setTitle(LocalizationKey.inprogress.localizing(), forSegmentAt: 2)
        
        segmentEstwork.setTitle(LocalizationKey.daily.localizing(), forSegmentAt: 0)
        segmentEstwork.setTitle(LocalizationKey.weekly.localizing(), forSegmentAt: 1)
        segmentEstwork.setTitle(LocalizationKey.monthly.localizing(), forSegmentAt: 2)
        
    }
    
    //MARK: Delegate
    func projectId(projectId: String, projectName: String) {
        self.txtProjectName.text = projectName
        self.projectId = projectId
    }
    
    func selectedCorrdinates(lat: String, long: String) {
        self.txtGPSData.text = "\(lat), \(long)"
        self.lat = lat
        self.long = long
    }
    
  //MARK: Button Actions
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        addTaskApi()
   //   self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGpsAction(_ sender: UIButton) {
        let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "TaskMapVC") as! TaskMapVC
        vc.lat = "59.9139"
        vc.long = "10.7522"
        vc.isMapFrom = "AddTask"
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnProjectNameAction(_ sender: UIButton) {
        
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectProjectVC") as! SelectProjectVC
        if UserDefaults.standard.string(forKey: UserDefaultKeys.userType) == "pm"{
            vc.mode = "managers"
            vc.module = "no-module"
        } else {
            vc.mode = "members"
            vc.module = "no-module"
        }
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    func getLatLong(lat: Double, long: Double, addressMap: String, postalCode: String, cityName: String) {
        print("")
    }
    
}


extension AddTaskVC {
  
    func addTaskApi() {
        
//    Payload:-
//     address: "Time Square"
//    assignee_id: 3
//    b_nr: "gh"
//    contact_person: "contact name"
//    data: {
//      addressCache: "Time Square, Ahmedabad, 38000"
//    }
//    description: "Task Description 1111"
//    email: "1q1q@yopmail.com"
//    end_time: 1020
//    est_hours: 70
//    est_work: "weekly"
//    g_nr: "hg"
//    gps_data: "23.0498189,72.5013069"
//    members: [
//      {
//        user_id: 3
//      }
//    ]
//    name: "Task Testing"
//    phone: "6565789"
//    post_number: "38000"
//    post_place: "Ahmedabad"
//    project_id: 12
//    scheduled_days: "0,1,2,3,4"
//    start_time: 480
//    status: "active”
        
        var param = [String:Any]()
        var members = [[String:Any]]()
        var memberDetails = [String:Any]()
        memberDetails["user_id"] = 3
        members.append(memberDetails)

        var data = [String:Any]()
        
        data["require_hms"] =  true
        data["security_analyze"] = false
        data["addressCache"] = "\(self.txtAddress.text ?? ""), \(self.txtCity.text ?? ""), \(self.txtZipCode.text ?? "")"
        
        
        param["status"] = segmentedControler.titleForSegment(at: segmentedControler.selectedSegmentIndex) ?? ""
        param["est_work"] = segmentEstwork.titleForSegment(at: segmentEstwork.selectedSegmentIndex) ?? ""
        param["est_hours"] = self.txtEstimateHours.text
        param["b_nr"] = self.txtnr.text
        param["g_nr"] = self.txtFr.text

        
//        param["members"] = members
        param["data"] = data
        
  //      param["assignee_id"] = 3
        param["name"] = self.txtName.text
      //  param["start_time"] = 480
   //     param["end_time"] = 1020
    //    param["scheduled_days"] = "0,1,2,3,4"
        param["project_id"] = self.projectId
        param["address"] = self.txtAddress.text
        param["post_place"] = self.txtCity.text
        
        param["gps_data"] = self.txtGPSData.text //"30.7046,76.7179"

        param["post_number"] = self.txtZipCode.text
        param["description"] = self.txtDescription.text
              
        print(param)
        WorkHourVM.shared.addTasksApi(parameters: param, isAuthorization: true) { [self] obj in
            
            print(obj.message)
            self.navigationController?.popViewController(animated: true)

        }
    }
    
        
        func hitprojectsApi() -> Void {
            
            var param = [String:Any]()
            WorkHourVM.shared.workprojectsApi(parameters: param, isAuthorization: true) { [self] obj in
                
//                self.txtProjectName.text = obj.first?.fullname ?? ""
//
//                self.projectId = "\(obj.first?.id ?? 0)"
                
                self.txtProjectName.text = obj.rows?.first?.name ?? ""
                
                self.projectId = "\(obj.rows?.first?.id ?? 0)"
                
            }
        }

}

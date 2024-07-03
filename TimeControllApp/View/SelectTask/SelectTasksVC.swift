//
//  SelectTasksVC.swift
//  TimeControllApp
//
//  Created by mukesh on 30/07/22.
//

import UIKit
import CoreLocation

protocol AddTaskProjectNameProtocol {
    func getTaskProjectName(projectId: String, taskId: String)
}

class SelectTasksVC: BaseViewController, SelectProjectProtocol,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var selectTaskTitleLbl: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet var vwFooter: UIView!
    @IBOutlet weak var tblTasks: UITableView!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet weak var applyBtn: UIButton!
    
    @IBOutlet weak var reasontblView: UITableView!
    @IBOutlet weak var reasonPopupView: UIView!
    @IBOutlet weak var selectAReasonLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    var selectedScheduleData : [newScheduleModel] = []
    var reasonArray : [ClockInOutReasons]? = []
    var selectedReasonIndex = -1
    var selectedLookupTasks : LookupTasks?
    
    public var arrRows : [LookupTasks]?
    var filteredData : [LookupTasks]?
    private var selectedIndex = -1
    let locationManager = CLLocationManager()
    var currentCorrdinate = CLLocationCoordinate2D()
    var lat = String()
    var long = String()
    var isComingFrom = String()
    var projectId = ""
    
    @IBOutlet weak var addBtnObj: UIButton!
    
    @IBOutlet weak var lblSelectAnomaliesReason: UILabel!
    var delegate: AddTaskProjectNameProtocol?

    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
//        apiSearch()
    }
    
    func setUpLocalization(){
        selectTaskTitleLbl.text = LocalizationKey.selectTask.localizing()
        addBtnObj.setTitle(LocalizationKey.add.localizing(), for: .normal)
        txtSearch.placeholder = LocalizationKey.search.localizing()
        applyBtn.setTitle(LocalizationKey.apply.localizing(), for: .normal)
        selectAReasonLbl.text = LocalizationKey.pleaseSelectASuitableComment.localizing()
        cancelBtn.setTitle(LocalizationKey.cancel.localizing(), for: .normal)
        okBtn.setTitle(LocalizationKey.ok.localizing(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentLocation()
        configUI()
    }
    
    func apiSearch() {
        let apiKey = "AIzaSyBcGVvS9JvgWmMdFVEbPxZTUWUi9qJt4Vo"
        let bundleId = "com.Your uniqueBundleId here"
        let searchEngineId = "Tråklestinget, Moss, Norway"
        let serverAddress = String(format: "https://www.googleapis.com/customsearch/v1?q=%@&cx=%@&key=%@","Tråklestinget, Moss, Norway" ,searchEngineId, apiKey)


        let url = serverAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let finalUrl = URL(string: url!)
        let request = NSMutableURLRequest(url: finalUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
       // request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")

        let session = URLSession.shared

        let datatask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("asyncResult\(jsonResult)")
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        datatask.resume()
    }
    
    //MARK: Functions
    func configUI() {
        reasonPopupView.isHidden = true
        if isComingFrom == "CreateShiftVC" {
            addBtnObj.isHidden = true
        }
        hitTasksApi(projectId: self.projectId)
        if isComingFrom != "CreateShiftVC"{
            tblTasks.tableHeaderView = vwHeader
        }
        //   tblTasks.tableFooterView = vwFooter
        tblTasks.register(UINib.init(nibName: TABLE_VIEW_CELL.ProjectListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ProjectListTVC.rawValue)
        reasontblView.register(UINib.init(nibName: TABLE_VIEW_CELL.ChildListTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue)
    }
    
    //MARK: - Delegate
    func projectId(projectId: String, projectName: String) {
        if projectId != "0" {
            hitTasksApi(projectId: projectId)
        }
    }
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.main.async {
            // your code here
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentCorrdinate = locValue
    }
    
    var distanceToUsersCurrentLocation: Double {
        let manager = CLLocationManager() //location manager for user's current location
        let destinationCoordinates = CLLocation(latitude: (Double(lat) ?? 0.0), longitude: (Double(long) ?? 0.0)) //coordinates for destinastion
        // let destinationCoordinates = CLLocation(latitude: (30.7046), longitude: (76.7179)) //coordinates for destinastion
        let selfCoordinates = CLLocation(latitude: (currentCorrdinate.latitude ?? 0.0), longitude: (currentCorrdinate.longitude ?? 0.0))
        //   let selfCoordinates = CLLocation(latitude: (30.7377), longitude: (76.6792)) //user's location
        return selfCoordinates.distance(from: destinationCoordinates) //return distance in **meters**
    }
    
    
    
    //MARK: Button Actions
    
    @IBAction func cancelReasonBtn(_ sender: Any) {
        reasonPopupView.isHidden = true
    }
    @IBAction func okReasonBtn(_ sender: Any) {
        if selectedReasonIndex < 0 {
            let alert = UIAlertController(title: "", message: LocalizationKey.pleaseProvideReason.localizing(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizationKey.ok.localizing(), style: .default, handler: { action in
                // start work
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.hitStartWorkHoursApi(projectId: "\(selectedLookupTasks?.project_id ?? 0)", taskId: "\(selectedLookupTasks?.id ?? 0)", locationString: selectedLookupTasks?.address ?? "", isEarly: false, isOffsite: true, comment: reasonArray?[selectedReasonIndex].reason ?? "")
            reasonPopupView.isHidden = true
        }
    }
    
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShowAllProjectsAction(_ sender: UIButton) {
        
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectProjectVC") as! SelectProjectVC
        vc.delegate = self
        vc.mode = "no-acl"
        vc.module = "no-module"
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
        //  self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAddTask(_ sender: UIButton) {
        
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AddTasksVC") as! AddTasksVC
        //  let vc = STORYBOARD.WORKHOURS.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        vc.currentCorrdinate = currentCorrdinate
        vc.isComingFrom = isComingFrom
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnApplyAction(_ sender: UIButton) {
//        if distanceToUsersCurrentLocation > 2000 {
//            self.showAlert(message: "You are not at your task location", strtitle: "Alert")
//            return
//        } else {
            if selectedIndex != -1 {
                guard  let taskData = filteredData?[selectedIndex] else {
                    return
                }
                if (isComingFrom == "StartHours") {
                    self.checkAnomalyForTasksAndGpsData(selectedTaskData: taskData)
//                    hitStartWorkHoursApi(projectId: "\(taskData.project_id ?? 0)", taskId: "\(taskData.id ?? 0)", locationString: taskData.address ?? "")
                }
                else if (isComingFrom == "addWorkHour") {
                    self.delegate?.getTaskProjectName(projectId: "\(taskData.project_id ?? 0)", taskId: "\(taskData.id ?? 0)")
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                } else if isComingFrom == "CreateShiftVC" {
                    self.delegate?.getTaskProjectName(projectId: "\(taskData.name ?? "")", taskId: "\(taskData.id ?? 0)")
                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    hitdraftIdApi(projectId: "\(taskData.project_id ?? 0)", taskId: "\(taskData.id ?? 0)")
                }
            } else {
                self.showAlert(message: LocalizationKey.pleaseSelectTask.localizing(), strtitle: LocalizationKey.alert.localizing())
                return
            }
//        }
    }
    
    //MARK: Check Anomaly For Tasks And GpsData

    func checkAnomalyForTasksAndGpsData(selectedTaskData : LookupTasks) {
        print("checkAnomaly is : ", checkAnomaly())
        print("selectedTaskData.gps_data is : ", selectedTaskData.gps_data)
        print("checkLocationEnable() is : ", checkLocationEnable())
        
        if checkLocationEnable() {
            if checkAnomaly() && selectedTaskData.gps_data != "" {
                let currentLat = self.currentCorrdinate.latitude
                let currentLon = self.currentCorrdinate.longitude
                let targetLocation = selectedTaskData.gps_data?.split(separator: ",")
                let targetLat = Double(targetLocation?[0] ?? "")
                let targetLon = Double(targetLocation?[1] ?? "")
                let distance = distanceBetween(currentLatitude: currentLat, currentLongitude: currentLon, targetLatitude: targetLat ?? 0.0, targetLongitude: targetLon ?? 0.0)
                print("distance ", distance)
                
                print("allowedDistance is : ", GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.gpsAllowedDistance)
                
                if distance <= Double(GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.gpsAllowedDistance ?? 0){
                    hitStartWorkHoursApi(projectId: "\(selectedTaskData.project_id ?? 0)", taskId: "\(selectedTaskData.id ?? 0)", locationString: selectedTaskData.address ?? "", isEarly: false, isOffsite: false, comment: "")
                } else {
                    let title = LocalizationKey.helloTimeAndControlNoticedThatYouHaventArrivedAtTheSiteYet.localizing()
                    let message = LocalizationKey.helloTimeAndControlNoticedThatYouHaventArrivedAtTheSiteEither.localizing() + "\n\n" + LocalizationKey.wouldYouStillLikeToClockInForYourShift.localizing()
                    let heading = LocalizationKey.WhyDoYouWantToStartFromThisLocation.localizing()
                    self.reasonArray = GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.anomalyTrackerReasons?.offSiteClockIn
                    self.selectedLookupTasks = selectedTaskData
                    self.reasontblView.reloadData()
                    self.showAlert(title: "", message: message, selectedTaskData: selectedTaskData, heading: heading, isEarly: false, isOffsite: true)
                    return
                }
            } else {
                hitStartWorkHoursApi(projectId: "\(selectedTaskData.project_id ?? 0)", taskId: "\(selectedTaskData.id ?? 0)", locationString: selectedTaskData.address ?? "", isEarly: false, isOffsite: false, comment: "")
            }
        } else {
            if isGPSObligatory() {
                let alert = UIAlertController(title: LocalizationKey.allowLocationAccess.localizing(), message: LocalizationKey.yourEmployerHasMadeGPSUsageMandatoryPleaseTurnOnYourGPS.localizing(), preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: LocalizationKey.settings.localizing(), style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: LocalizationKey.ok.localizing(), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                hitStartWorkHoursApi(projectId: "\(selectedTaskData.project_id ?? 0)", taskId: "\(selectedTaskData.id ?? 0)", locationString: selectedTaskData.address ?? "", isEarly: false, isOffsite: false, comment: "")
            }
        }
    }
    
    func checkLocationEnable() -> Bool {
        /*
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    return true
                @unknown default:
//                    break
                    return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
         */
        if CLLocationManager.locationServicesEnabled() {
            let locationManager = CLLocationManager()
            switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse: 
                print("authorizedAlways")
                return true
            case .denied, .restricted: 
                print("denied")
                return false
            case .notDetermined:
                print("notDetermined")
//                locationManager.requestWhenInUseAuthorization()
                return false
            @unknown default:
                // Handle future cases
                print("default")
                return false
            }
        } else {
            // Location services are not enabled
            print("Location services are not enabled")
            return false
        }
    }
    
    //MARK: Check GPS Obligatory

    func isGPSObligatory() -> Bool {
//        return GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs == "gps" && GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
        return GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
    }
    
    //MARK: Check Anomaly

    private func checkAnomaly() -> Bool {
        print(" autoTimelogs is : ", GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs)
        print(" workinghourGPSObligatory is : ", GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.workinghourGPSObligatory)

        return GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.autoTimelogs != "autoschedule" && GlobleVariables.clientControlPanelConfiguration?.data?.basicRules?.workinghourGPSObligatory == true
    }
    
    //MARK: Get the distance
    
    func distanceBetween(currentLatitude: Double, currentLongitude: Double, targetLatitude: Double, targetLongitude: Double) -> Double {
        let manager = CLLocationManager() //location manager for user's current location
        let destinationCoordinates = CLLocation(latitude: targetLatitude, longitude: targetLongitude) //coordinates for destinastion
        // let destinationCoordinates = CLLocation(latitude: (30.7046), longitude: (76.7179)) //coordinates for destinastion
        let selfCoordinates = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        //   let selfCoordinates = CLLocation(latitude: (30.7377), longitude: (76.6792)) //user's location
        return selfCoordinates.distance(from: destinationCoordinates) //return distance in **meters**
    }
    
    //MARK: Open the alert view

    func showAlert(title: String, message: String, selectedTaskData: LookupTasks, heading: String, isEarly: Bool, isOffsite: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            // start work
            print("checkControlPanelAnomalies is : ", self.checkControlPanelAnomalies())
            
            if self.checkControlPanelAnomalies() {
                self.reasonPopupView.isHidden = false
//                self.showCustomDialogForReason(heading: heading, selectedTaskData: selectedTaskData)
            } else {
                
                self.hitStartWorkHoursApi(projectId: "\(selectedTaskData.project_id ?? 0)", taskId: "\(selectedTaskData.id ?? 0)", locationString: selectedTaskData.address ?? "", isEarly: false, isOffsite: false, comment: "")
            }
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Open the reason dialog

    private func showCustomDialogForReason( heading: String, selectedTaskData: LookupTasks) {
        let alert = UIAlertController(title: heading, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = LocalizationKey.reason.localizing()
        }
        alert.addAction(UIAlertAction(title: LocalizationKey.yes.localizing(), style: .default, handler: { action in
            
            guard let reason = alert.textFields?[0].text else {
                return
            }
            if (reason == "") {
                self.showAlert(message: LocalizationKey.pleaseProvideReason.localizing(), strtitle: "")
                //                return
            } else {
                self.hitStartWorkHoursApi(projectId: "\(selectedTaskData.project_id ?? 0)", taskId: "\(selectedTaskData.id ?? 0)", locationString: selectedTaskData.address ?? "", isEarly: false, isOffsite: true, comment: reason)
            }
        }))
        alert.addAction(UIAlertAction(title: LocalizationKey.no.localizing(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Check control panel anomalies
    
    private func checkControlPanelAnomalies() -> Bool {
        return GlobleVariables.clientControlPanelConfiguration?.data?.loginRules?.trackAnomalies ?? false
    }
}



//MARK: - TableView DataSource and Delegate Methods
extension SelectTasksVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == reasontblView {
            return reasonArray?.count ?? 0
        }
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == reasontblView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ChildListTVC.rawValue, for: indexPath) as? ChildListTVC
            else { return UITableViewCell() }
            cell.childNameLbl.text = reasonArray?[indexPath.row].reason
            cell.childNameLbl.numberOfLines = 0
            
            if selectedReasonIndex == indexPath.row {
                cell.selectChildBtn.setImage(UIImage(named: "selectRadioIcon"), for: .normal)
            }
            else {
                cell.selectChildBtn.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)
            }
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.ProjectListTVC.rawValue, for: indexPath) as? ProjectListTVC
            else { return UITableViewCell() }
          
            cell.lblProjectTitle.text = filteredData?[indexPath.row].name
            cell.lblLocationName.text = filteredData?[indexPath.row].address
            
            if selectedIndex == indexPath.row {
                
                cell.btnSelect.setImage(UIImage(named: "selectRadioIcon"), for: .normal)

            }
            else {
                
                cell.btnSelect.setImage(UIImage(named: "deselectRadioIcon"), for: .normal)

            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == reasontblView {
            selectedReasonIndex = indexPath.row
            reasontblView.reloadData()
        }else {
            let corrdinates = filteredData?[indexPath.row].gps_data
            
            let fullNameArr = corrdinates?.components(separatedBy: ",")
            
            self.lat = fullNameArr?.first ?? ""
            self.long = fullNameArr?.last ?? ""
            
            selectedIndex = indexPath.row

            tblTasks.reloadData()
    //
    //        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SelectProjectVC") as! SelectProjectVC
    //        vc.isComingFrom = .Project
    //        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension SelectTasksVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        if currentText.isEmpty {
            filteredData = arrRows
        } else {
            filteredData = arrRows?.filter { task in
                guard let name = task.name else { return false }
                return name.lowercased().contains(currentText.lowercased())
            }
        }
        tblTasks.reloadData()
       return true
    }
}


//MARK: Extension Api's
extension SelectTasksVC {

    func hitTasksApi(projectId: String, name: String = "") -> Void {
        
        var param = [String:Any]()

      //  param = ["pagesize":"100"]

       // if projectId != "" {
            
          // param = ["pagesize":"100","filters":"{\"project\":\"\(projectId)\"}"]
      //  }
//    https://tidogkontroll.no/api/tasks/lookup_tasks?name=D
//        param = ["pagesize":"100","filters":"{\"project\":\"\(projectId)\",\"name\":\"\(name)\"}"]
        
        print(param)
        WorkHourVM.shared.workLookupTasksApi(parameters: param, isAuthorization: true) { [self] obj in
            
            self.arrRows = obj
            
            if isComingFrom == "CreateShiftVC" {
                var tempFilterData = [LookupTasks]()
                
                for i in 0..<(self.arrRows?.count ?? 0) {
                    print("projectId is : ", projectId)
                    print("\(self.arrRows?[i].project_id ?? 0) is : ", "\(self.arrRows?[i].project_id ?? 0)")
                    print("projectId == \(self.arrRows?[i].project_id ?? 0) is : ", projectId == "\(self.arrRows?[i].project_id ?? 0)")
                    
                    if projectId == "\(self.arrRows?[i].project_id ?? 0)" {
                        guard let resultData = self.arrRows?[i] else {return}
                        tempFilterData.append(resultData)
                    }
                }
                self.filteredData = tempFilterData
            } else {
                self.filteredData = self.arrRows
            }
            print("FilteredData is : ", filteredData)
            tblTasks.reloadData()
            
        }
    }
    
    func hitdraftIdApi(projectId: String, taskId: String) -> Void {
        
        var param = [String:Any]()
        
        param = ["project_id":"\(projectId)","task_id":"\(taskId)"]
        
        print(param)
        
        WorkHourVM.shared.getDraftIdApi(parameters: param, isAuthorization: true) { [self] obj in
        
            print(obj.timelog?.id)
        }
    }
    
    func hitStartWorkHoursApi(projectId: String, taskId: String, locationString: String, isEarly: Bool, isOffsite: Bool, comment: String) -> Void {
        
        var param = [String:Any]()
        
        var startGps = [String:Any]()
        var start = [String:Any]()
        var end = [String:Any]()
        var anamoly = [String:Any]()

        var shiftData = [String:Any]()
        var deviceDetails = [String:Any]()
        
        var coords = [String:Any]()
        let timestamp = Date().timeIntervalSince1970
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:currentCorrdinate.latitude, longitude: currentCorrdinate.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                coords["altitude"] = 0
                coords["altitudeAccuracy"] = 0
                coords["latitude"] = self.currentCorrdinate.latitude
                coords["accuracy"] =  41
                coords["longitude"] = self.currentCorrdinate.longitude
                coords["heading"] = 0
                coords["speed"] = 0

                startGps["coords"] = coords
                startGps["timestamp"] = timestamp
                startGps["locationString"] = addressString
//                startGps["locationString"] = getLocationAddress(latitude: currentCorrdinate.latitude, longitude: currentCorrdinate.longitude)
                startGps["decision"] =  "off-bounds"
                startGps["is_ok"] = false
                startGps["diff"] = false
                        
                start["is_early"] = isEarly
                start["is_offsite"] = isOffsite
                start["comment"] = comment

                end["is_early"] = false
                end["is_offsite"] = false
                end["comment"] = ""

                anamoly["start"] = start
                anamoly["end"] = end
                
                param["task_id"] = taskId
                param["startGps"] = startGps
                param["location_string"] = locationString
                param["tracker_status"] = "started"
                param["anomaly"] = anamoly

                shiftData["shiftId"] = 0
                
                shiftData["autoClockIn"] = false
                shiftData["autoClockOut"] = false
                
                deviceDetails["device"] = "iOS"
                deviceDetails["deviceModel"] = UIDevice.current.model
                deviceDetails["osVersion"] = UIDevice.current.systemVersion
                deviceDetails["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                deviceDetails["buildNumber"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                shiftData["deviceDetails"] = deviceDetails

                param["data"] = shiftData
                
                print(param)
                
                WorkHourVM.shared.startWorkHoursApi(parameters: param, isAuthorization: true) { [self] obj in
                    print(obj.timelog?.id)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
        
       
    }
    
    //MARK: Get Location address from latitude and longitude
    
    func getLocationAddress(latitude: Double, longitude: Double) -> String {
        print("latitude : ", latitude)
        print("longitude : ", longitude)
        
        var locationString = String()
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:latitude, longitude: longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                locationString = addressString
                
            }
        })
        print("Location String : ", locationString)
        
        return locationString
    }
    
}

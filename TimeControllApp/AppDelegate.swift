//
//  AppDelegate.swift
//  TimeControllApp
//
//  Created by mukesh on 01/07/22.
//

import UIKit
import SVProgressHUD
import GoogleMaps
import GooglePlaces
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import FirebaseCrashlytics

import IQKeyboardManagerSwift

extension Notification.Name {
    static let apiCallCompleted = Notification.Name("ApiCallCompletedNotification")
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    var previousLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locationManager: CLLocationManager?
    var significatLocationManager : CLLocationManager?
    var lastLocationUpdateDate: Date?
    
    var previousLatitude : Double = 0.0
    var previousLongitude : Double = 0.0
    
    public var homeModel = HomeViewModel()
    var currentTimelogData : CurrentTimelog?
    var controlPanleConfiguration : ClientModel?
    var currentScheduleData : [newScheduleModel] = []
    var currentTimeInMinutesData = Int()
    var locationString = String()
    weak var notificationDelegate: NotificationDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let homeController = HomeVC()
//
//        // Set the delegate
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.notificationDelegate = homeController

        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: UIScreen.main.bounds.size.width/2, vertical: UIScreen.main.bounds.size.height/2))
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey(Constant.googleKey)
        GMSPlacesClient.provideAPIKey(Constant.googleKey)
        
        
        //Firebase configuration
        FirebaseApp.configure()
//        SocketIoManager.establishConnection()
        Messaging.messaging().delegate = self
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
//        application.registerForRemoteNotifications()

        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Error requesting authorization for remote notifications: \(error.localizedDescription)")
            }
            // Check if permission granted
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
//        let content = UNMutableNotificationContent()
//        let soundName = UNNotificationSoundName("notification_tone.wav")
//        content.sound = UNNotificationSound(named: soundName)

        if let launchOpt = launchOptions{
            if (launchOpt[UIApplication.LaunchOptionsKey.location] != nil) {
                self.significatLocationManager = CLLocationManager()
                self.significatLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
                self.significatLocationManager?.delegate = self
                //                self.significatLocationManager?.distanceFilter = 10
                self.significatLocationManager?.requestAlwaysAuthorization()
                if #available(iOS 9.0, *) {
                    self.significatLocationManager!.allowsBackgroundLocationUpdates = true
                }
                self.locationManager?.startUpdatingLocation()
            }else{
                self.locationManager = CLLocationManager()
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager?.delegate = self
                //                self.locationManager?.distanceFilter = 10
                self.locationManager?.requestAlwaysAuthorization()
                if #available(iOS 9.0, *) {
                    self.locationManager!.allowsBackgroundLocationUpdates = true
                }
                self.locationManager?.startUpdatingLocation()
            }
        } else {
            self.locationManager = CLLocationManager()
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.delegate = self
            //            self.locationManager?.distanceFilter = 10
            self.locationManager?.requestAlwaysAuthorization()
            if #available(iOS 9.0, *) {
                self.locationManager!.allowsBackgroundLocationUpdates = true
            }
            self.locationManager?.startUpdatingLocation()
        }
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
           print("Device ID: \(uuid)")
            UserDefaults.standard.setValue(uuid, forKey: UserDefaultKeys.deviceID)
        } else {
           print("Unable to retrieve device ID.")
        }
        return true
    }
    
    func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device token: \(token)")
        Messaging.messaging().apnsToken = deviceToken // For FCM token mapping
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.setValue(fcmToken, forKey: UserDefaultKeys.fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification response
        let userInfo = response.notification.request.content.userInfo
        guard let window = UIApplication.shared.keyWindow else { return }
        UserDefaults.standard.setValue(userInfo, forKey: UserDefaultKeys.notificationData)
        notificationDelegate?.didReceiveNotification(with: userInfo)
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("AppDelegate applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if self.significatLocationManager != nil {
            self.significatLocationManager?.startMonitoringSignificantLocationChanges()
        }else{
            self.locationManager?.startMonitoringSignificantLocationChanges()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("AppDelegate applicationWillEnterForeground")
        if self.significatLocationManager != nil {
            self.significatLocationManager?.startMonitoringSignificantLocationChanges()
        }else{
            self.locationManager?.startMonitoringSignificantLocationChanges()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("AppDelegate applicationDidBecomeActive")
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        if self.significatLocationManager != nil {
            self.significatLocationManager?.startMonitoringSignificantLocationChanges()
        }else{
            self.locationManager?.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedAlways {
                if self.significatLocationManager != nil {
                    self.significatLocationManager?.startMonitoringSignificantLocationChanges()
                }else{
                    self.locationManager?.startMonitoringSignificantLocationChanges()
                }
            } else if status == .authorizedWhenInUse {
                if self.significatLocationManager != nil {
                    self.significatLocationManager?.requestAlwaysAuthorization()
                }else{
                    self.locationManager?.requestAlwaysAuthorization()
                }
            } else {
                print("Location services not authorized.")
            }
        }
    
    //MARK: Get the updated location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        counter = 0
        let location: CLLocation = locations.last!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("AppDelegate applicationWillTerminate didUpdateLocations")

        guard let lastUpdateDate = lastLocationUpdateDate else {
            // Handle first location update
            lastLocationUpdateDate = Date()
            if (previousLatitude != 0.0 && previousLongitude != 0.0) {
                let distance = distanceBetween(currentLatitude: latitude, currentLongitude: longitude, targetLatitude: previousLatitude, targetLongitude: previousLongitude)
    //            if distance >= 400 {
                    previousLatitude = latitude
                    previousLongitude = longitude
                    //                sendNotification(latitude: previousLatitude, longitude: previousLongitude)
                    if UserDefaults.standard.string(forKey: UserDefaultKeys.token) != nil {
                        self.getControlPanelConfigurationRules()
                        self.dashboardApi()
                    }
    //            }
            } else {
                previousLatitude = latitude
                previousLongitude = longitude
    //            sendNotification(latitude: previousLatitude, longitude: previousLongitude)
                if UserDefaults.standard.string(forKey: UserDefaultKeys.token) != nil {
                    self.getControlPanelConfigurationRules()
                    self.dashboardApi()
                }
            }
            return
        }
        
        let timeIntervalBetweenUpdates = Date().timeIntervalSince(lastUpdateDate)
        if timeIntervalBetweenUpdates >= 20 { // Example: Throttle to every 10 seconds
            lastLocationUpdateDate = Date()
            if (previousLatitude != 0.0 && previousLongitude != 0.0) {
                let distance = distanceBetween(currentLatitude: latitude, currentLongitude: longitude, targetLatitude: previousLatitude, targetLongitude: previousLongitude)
    //            if distance >= 400 {
                    previousLatitude = latitude
                    previousLongitude = longitude
                    //                sendNotification(latitude: previousLatitude, longitude: previousLongitude)
                    if UserDefaults.standard.string(forKey: UserDefaultKeys.token) != nil {
                        self.getControlPanelConfigurationRules()
                        self.dashboardApi()
                    }
    //            }
            } else {
                previousLatitude = latitude
                previousLongitude = longitude
    //            sendNotification(latitude: previousLatitude, longitude: previousLongitude)
                if UserDefaults.standard.string(forKey: UserDefaultKeys.token) != nil {
                    self.getControlPanelConfigurationRules()
                    self.dashboardApi()
                }
            }
        }
    }
    
    //MARK: Get the distance
    
    func distanceBetween(currentLatitude: Double, currentLongitude: Double, targetLatitude: Double, targetLongitude: Double) -> Double {
        let manager = CLLocationManager() //location manager for user's current location
        let destinationCoordinates = CLLocation(latitude: targetLatitude, longitude: targetLongitude) //coordinates for destinastion
        let selfCoordinates = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        return selfCoordinates.distance(from: destinationCoordinates) //return distance in **meters**
    }
    
    //MARK: Get the dashboard data
    
    func dashboardApi(){
//        SVProgressHUD.show()
        homeModel.dashboard(){ (errorMsg,loginMessage) in
//            SVProgressHUD.dismiss()
            if errorMsg == true {
//                self.hometblView.reloadData()
            } else {
                displayToast(loginMessage)
            }
            self.checkCurrentDraftOrSkip()
        }
    }
    
    //MARK: Check current draft or skip

    func checkCurrentDraftOrSkip() {
//        SVProgressHUD.show()
        let param = [String:Any]()
        WorkHourVM.shared.currentDraftOrSkipAppdelegateApi(parameters: param, isAuthorization: true) { [self] obj in
            print("AppDelegate checkCurrentDraftOrSkip is :")
            print("AppDelegate obj.timelog is : ", obj.timelog)
            currentTimelogData = obj.timelog
//            if (currentTimelogData == nil) {
                self.getCurrentTimeInMinutes()
//            } else {
//                self.checkCurrentTimelogData()
//            }
        }
    }
    
    //MARK: Get Control panel configuration
    
    func getControlPanelConfigurationRules() {
//        SVProgressHUD.show()
        let param = [String:Any]()
        
        WorkHourVM.shared.getControlPanelConfigurationAppdelegateApi(parameters: param, isAuthorization: true) { [self] obj in
            controlPanleConfiguration = obj.client
            
            //MARK: Change the date formate from configuration

            if (obj.client?.data?.dateTimeRules?.short_date_format == "DD.MM.YYYY") {
                controlPanleConfiguration?.data?.dateTimeRules?.short_date_format = "dd.MM.YYYY"
            } else if (obj.client?.data?.dateTimeRules?.short_date_format == "DD-MM-YYYY") {
                controlPanleConfiguration?.data?.dateTimeRules?.short_date_format = "dd-MM-YYYY"
            } else if (obj.client?.data?.dateTimeRules?.short_date_format == "DD/MM/YYYY") {
                controlPanleConfiguration?.data?.dateTimeRules?.short_date_format = "dd/MM/YYYY"
            }
            
            if (obj.client?.data?.dateTimeRules?.time_format == "hh:mm") {
                controlPanleConfiguration?.data?.dateTimeRules?.time_format = "HH:mm"
            }
            
            GlobleVariables.clientControlPanelConfiguration = controlPanleConfiguration
            GlobleVariables.bizTypeControlPanelConfiguration = obj.biztype
            GlobleVariables.integrationDetailsControlPanelConfiguration = obj.integration_details
            GlobleVariables.timezoneGMT = obj.timezoneGMT
        }
    }
    
    func getExactCurrentTimeInMinutesAppDelegate() -> Int {
        guard let timeZone = TimeZone(identifier: "GMT") else {
            return 0
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "HH:mm"
        let currentDate1 = dateFormatter.string(from: Date())
        
        let currentDateSplit = currentDate1.components(separatedBy: ":")
        let currentHours: String = currentDateSplit[0]
        let currentMinute: String = currentDateSplit[1]
        
//       return (Int(currentHours) + (GlobleVariables.timezoneGMT ?? 0)) * 60 + Int(currentMinute)
        
        let currentHoursInt = Int(currentHours) ?? 0
        let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
        let currentMinuteInt = Int(currentMinute) ?? 0

        var totalMinutes = 0
        if currentHoursInt + timezoneOffset < 0 {
            totalMinutes = (currentHoursInt + timezoneOffset + 24) * 60 + currentMinuteInt
        }  else if currentHoursInt + timezoneOffset > 23 {
            totalMinutes = (currentHoursInt + timezoneOffset - 24) * 60 + currentMinuteInt
        }
        else {
            totalMinutes = (currentHoursInt + timezoneOffset) * 60 + currentMinuteInt
        }
        
        
        return totalMinutes
    }
    
    func getCurrentDateFromGMTAppdelegate() -> String {
        let timezoneOffset = GlobleVariables.timezoneGMT ?? 0
        let serverTimeZone = "\(timezoneOffset)"
        var timezoneOffsetData = ""
        if serverTimeZone.contains("-") {
            timezoneOffsetData = serverTimeZone
        } else {
            timezoneOffsetData = "+\(serverTimeZone)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT\(timezoneOffsetData)")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateInGMT = dateFormatter.string(from: Date())
        return currentDateInGMT
    }
    
    func getPreviousDateFromGMTAppdelegate(currentDate :  String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = currentDate
        guard let dateCurrent = dateFormatter.date(from: dateString) else { return "" }
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = -1

        guard let newDate = calendar.date(byAdding: dateComponents, to: dateCurrent) else { return "" }
        let previousDate = dateFormatter.string(from: newDate)
        print("previousDate is : ", previousDate)
        return previousDate
    }
    
    //MARK: Get the current time in minutes
    
    func getCurrentTimeInMinutes() {
        let currentDate = getCurrentDateFromGMTAppdelegate()
        let currentTimeInMinutes = getExactCurrentTimeInMinutesAppDelegate()
        currentTimeInMinutesData = currentTimeInMinutes

        print("currentTimeInMinutesData is :", currentTimeInMinutesData)

        let previousDate = getPreviousDateFromGMTAppdelegate(currentDate: currentDate)
        
        var scheduleToday: [newScheduleModel] = []
        for i in 0..<homeModel.dashboardScheduleData.count {
            if homeModel.dashboardScheduleData[i].for_date == currentDate {
                scheduleToday.append(homeModel.dashboardScheduleData[i])
            } else if homeModel.dashboardScheduleData[i].is_multiday ?? false && homeModel.dashboardScheduleData[i].for_date == previousDate {
                scheduleToday.append(homeModel.dashboardScheduleData[i])
            }
        }
        
        print("scheduleToday is : ", scheduleToday)
        
        if (currentTimelogData == nil) {
            if (scheduleToday.count > 0) {
                let startBuffer = controlPanleConfiguration?.data?.loginRules?.startBufferTimeForClockIn ?? 30
                if scheduleToday.count == 1 {
                    if currentTimeInMinutes >= (scheduleToday[0].start_time ?? 0) - startBuffer && currentTimeInMinutes <= (scheduleToday[0].end_time ?? 0) {
                        // Start schedule work
                        currentScheduleData = scheduleToday
                        startScheduleWork()
                    } else if scheduleToday[0].is_multiday ?? false && (currentTimeInMinutes >= (scheduleToday[0].start_time ?? 0) - startBuffer || currentTimeInMinutes <= (scheduleToday[0].end_time ?? 0)){
                        // Start schedule work
                        currentScheduleData = scheduleToday
                        startScheduleWork()
                    }
                    
                } else {
                    var currentSchedule: [newScheduleModel] = []
                    for i in 0..<scheduleToday.count {
                        if currentTimeInMinutes >= (scheduleToday[i].start_time ?? 0) - startBuffer && currentTimeInMinutes <= (scheduleToday[i].end_time ?? 0) {
                            currentSchedule.append(scheduleToday[i])
                            break
                        } else if scheduleToday[i].is_multiday ?? false && (currentTimeInMinutes >= (scheduleToday[i].start_time ?? 0) - startBuffer || currentTimeInMinutes <= (scheduleToday[i].end_time ?? 0)){
                            // Start schedule work
                            currentSchedule.append(scheduleToday[i])
                            break
                        }
                    }
        
                    if ((currentSchedule.count) != 0)  {
                        // Start schedule work
                        currentScheduleData = currentSchedule
                        startScheduleWork()
                    }
                }
            } else {
                currentScheduleData = []
            }
        } else {
            if (currentTimelogData?.tracker_status != "break") {
                let endBuffer = controlPanleConfiguration?.data?.loginRules?.endBufferTimeForClockOut ?? 30
                if (scheduleToday.count > 0) {
                    if scheduleToday.count == 1 {
                        print("currentDate is : ", currentDate)
                        
                        if checkLocationEnable() {
                            if checkAutomaticRules() {
                                if currentTimelogData?.data?.autoClockIn ?? false && currentTimelogData?.data?.shiftId == scheduleToday[0].id {
                                    if (scheduleToday[0].is_multiday ?? false && scheduleToday[0].for_date != currentDate) {
                                        if currentTimeInMinutes >= (scheduleToday[0].end_time ?? 0) {
                                            currentScheduleData = scheduleToday
                                            workHoursFinishAPI()
                                        }
                                    } else if (scheduleToday[0].is_multiday ?? false && scheduleToday[0].for_date == currentDate) {
                                        return // End date is not same day
                                    }
                                    else {
                                        if currentTimeInMinutes >= (scheduleToday[0].start_time ?? 0) && currentTimeInMinutes >= (scheduleToday[0].end_time ?? 0) {
                                            currentScheduleData = scheduleToday
                                            workHoursFinishAPI()
                                        } else {
                                            currentScheduleData = scheduleToday
                                            finishWorkSchedule()
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        var currentSchedule: [newScheduleModel] = []
                        for i in 0..<scheduleToday.count {
                            if currentTimelogData?.data?.shiftId == scheduleToday[i].id {
                                currentSchedule.append(scheduleToday[i])
                                break
                            }
                        }
                        
                        print("Finsh shift is : ", currentSchedule)
                        
                        if ((currentSchedule.count) != 0)  {
                            // Finish schedule work
                            if checkLocationEnable() {
                                if checkAutomaticRules() {
                                    if currentTimelogData?.data?.autoClockIn ?? false && currentTimelogData?.data?.shiftId == scheduleToday[0].id {
                                        if (currentSchedule[0].is_multiday ?? false && currentSchedule[0].for_date != currentDate) {
                                            if currentTimeInMinutes >= (currentSchedule[0].end_time ?? 0) {
                                                currentScheduleData = currentSchedule
                                                workHoursFinishAPI()
                                            }
                                        } else if (currentSchedule[0].is_multiday ?? false && currentSchedule[0].for_date == currentDate) {
                                            return // End date is not same day
                                        }
                                        else {
                                            if currentTimeInMinutes >= (currentSchedule[0].start_time ?? 0) && currentTimeInMinutes >= (currentSchedule[0].end_time ?? 0) {
                                                currentScheduleData = currentSchedule
                                                workHoursFinishAPI()
                                            } else {
                                                currentScheduleData = currentSchedule
                                                finishWorkSchedule()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Start schedule work
    
    func startScheduleWork() {
        if checkLocationEnable() {
            if checkAutomaticRules() {
                let currentLat = self.previousLatitude
                let currentLon = self.previousLongitude
                let targetLocation = currentScheduleData[0].gps_data?.split(separator: ",")
                let targetLat = Double(targetLocation?[0] ?? "")
                let targetLon = Double(targetLocation?[1] ?? "")
                
                let distance = distanceBetween(currentLatitude: currentLat, currentLongitude: currentLon, targetLatitude: targetLat ?? 0.0, targetLongitude: targetLon ?? 0.0)
                
                if let gpsAllowedDistance = controlPanleConfiguration?.data?.loginRules?.gpsAllowedDistance, gpsAllowedDistance != 0 {
                    if distance <= Double(gpsAllowedDistance) {
                        // The current location is within a 500-meter radius of the target location
//                        lookForBufferTime(schedule: currentScheduleData, currentTimeInMinutes: currentTimeInMinutesData)
                        self.hitStartWorkHoursApi(scheduleData: currentScheduleData, isGpsEnable: true)
                        return

                    } else {
                        // The current location is not within a 500-meter radius of the target location
                        return
                    }
                }
            }
        }
    }
    
    //MARK: Check the Buffer time

    func lookForBufferTime(schedule: [newScheduleModel], currentTimeInMinutes: Int) {
        let startBuffer = controlPanleConfiguration?.data?.loginRules?.startBufferTimeForClockIn ?? 30
        // Here user is between start time & buffer time
        
        if currentTimeInMinutes >= (schedule[0].start_time ?? 0) - startBuffer && currentTimeInMinutes <= (schedule[0].start_time ?? 0) + startBuffer {
            //start work

            self.hitStartWorkHoursApi(scheduleData: schedule, isGpsEnable: true)
            return
        }
    }
    
    //MARK: Finish schedule work

    func finishWorkSchedule() {
        if checkLocationEnable() {
            if checkAutomaticRules() {
                let currentLat = self.previousLatitude
                let currentLon = self.previousLongitude
                let targetLocation = currentScheduleData[0].gps_data?.split(separator: ",")
                let targetLat = Double(targetLocation?[0] ?? "")
                let targetLon = Double(targetLocation?[1] ?? "")
                print("targetLocation is : ", targetLocation)
                
                let distance = distanceBetween(currentLatitude: currentLat, currentLongitude: currentLon, targetLatitude: targetLat ?? 0.0, targetLongitude: targetLon ?? 0.0)
                print("distance is : ", distance)
                if let gpsAllowedDistance = controlPanleConfiguration?.data?.loginRules?.gpsAllowedDistance, gpsAllowedDistance != 0 {
                    print("gpsAllowedDistance is : ", gpsAllowedDistance)
                    if distance <= Double(gpsAllowedDistance) {
                        // The current location is within the allowed distance of the target location
                        return
                    } else {
                        // The current location is not within the allowed distance of the target location
                        // User has left the work site
                        workHoursFinishAPI()
                    }
                }
            }
        }
    }
    
    //MARK: Check Automatic rules

    private func checkAutomaticRules() -> Bool {
        print("controlPanleConfiguration?.data?.loginRules?.autoTimelogs is: ", controlPanleConfiguration?.data?.loginRules?.autoTimelogs)
        return controlPanleConfiguration?.data?.loginRules?.autoTimelogs == "gps"
    }
    
    //MARK: Check GPS Location

    func checkLocationEnable() -> Bool {
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
    }
    
    //MARK: Start work hours automatically

    func hitStartWorkHoursApi(scheduleData: [newScheduleModel], isGpsEnable: Bool) -> Void {
        var param = [String:Any]()
        var startGps = [String:Any]()
        var shiftData = [String:Any]()
        var deviceDetails = [String:Any]()

        var coords = [String:Any]()
        let timestamp = Date().timeIntervalSince1970
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:previousLatitude, longitude: previousLongitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks?[0]
                /*
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
                self.locationString = addressString
                */
                
                var addressString : String = ""
                var cityName : String = ""
                var postalCode : String = ""
                var countryName : String = ""
                
                if pm?.name != nil {
                    addressString = pm?.name ?? ""
                }
                
                if pm?.country != nil {
                    countryName = (pm?.country ?? "")
                    if pm?.country == "United States" {
                        if pm?.subLocality != nil {
                            addressString = addressString + ", " + (pm?.subLocality ?? "")
                        }
                    }
                }
                
                if pm?.postalCode != nil {
                    postalCode = pm?.postalCode ?? ""
                }
                
                if pm?.locality != nil {
                    //                    addressString = addressString + (pm?.locality ?? "") + ", "
                    cityName = pm?.locality ?? ""
                }
                
                self.locationString = addressString
                let targetLocation = self.currentScheduleData[0].gps_data?.split(separator: ",")
                let targetLat = Double(targetLocation?[0] ?? "")
                let targetLon = Double(targetLocation?[1] ?? "")

                let ceo: CLGeocoder = CLGeocoder()
                let loc: CLLocation = CLLocation(latitude:targetLat ?? 0.0, longitude: targetLon ?? 0.0)
                
                ceo.reverseGeocodeLocation(loc, completionHandler:
                                            {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = (placemarks ?? []) as [CLPlacemark]
                    
                    if pm.count > 0 {
                        var taskLocationAddress = ""
                        let pm = placemarks![0]
                        var addressString1 : String = ""
                        if pm.subLocality != nil {
                            addressString1 = addressString1 + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString1 = addressString1 + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString1 = addressString1 + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString1 = addressString1 + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString1 = addressString1 + pm.postalCode! + " "
                        }
                        taskLocationAddress = addressString1
                        
                        coords["altitude"] = 0
                        coords["altitudeAccuracy"] = 0
                        coords["latitude"] = self.previousLatitude
                        coords["accuracy"] =  41
                        coords["longitude"] = self.previousLongitude
                        coords["heading"] = 0
                        coords["speed"] = 0
                        
                        startGps["coords"] = coords
                        startGps["timestamp"] = timestamp
                        startGps["locationString"] = self.locationString
                        startGps["decision"] =  "off-bounds"
                        startGps["is_ok"] = false
                        startGps["diff"] = false
                        
                        param["task_id"] = scheduleData[0].task_id
                        param["startGps"] = startGps
                        
                        param["location_string"] = taskLocationAddress
                        param["tracker_status"] = "started"
                        
                        shiftData["shiftId"] = scheduleData[0].id
                        
                        shiftData["autoClockIn"] = true
                        shiftData["autoClockOut"] = false
                        
                        deviceDetails["device"] = "iOS"
                        deviceDetails["deviceModel"] = UIDevice.current.model
                        deviceDetails["osVersion"] = UIDevice.current.systemVersion
                        deviceDetails["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                        deviceDetails["buildNumber"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                        shiftData["deviceDetails"] = deviceDetails

                        param["data"] = shiftData

                        print("Appdelegate start param is : ", param)
                        
//                        WorkHourVM.shared.startWorkHoursApi(parameters: param, isAuthorization: true) { [self] obj in
//                            //            self.checkCurrentDraftOrSkip()
//                            NotificationCenter.default.post(name: .apiCallCompleted, object: nil)
//                        }
                        WorkHourVM.shared.startWorkHoursApiAppdelegate(parameters: param, isAuthorization: true) { [self] obj in
                            //            self.checkCurrentDraftOrSkip()
                            NotificationCenter.default.post(name: .apiCallCompleted, object: nil)
                            print("Appdelegate start response is : ", param)
                        }
                    }
                })
            }
        })
    }
    
    //MARK: Finish work hours automatically
    
    func workHoursFinishAPI() {
        var param = [String:Any]()
        var endGps = [String:Any]()
        var shiftData = [String:Any]()
        var deviceDetails = [String:Any]()

        var coords = [String:Any]()
        let timestamp = Date().timeIntervalSince1970
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:previousLatitude, longitude: previousLongitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    { [self](placemarks, error) in
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
                self.locationString = addressString
                
                coords["altitude"] = 0
                coords["altitudeAccuracy"] = 0
                coords["latitude"] = self.previousLatitude
                coords["accuracy"] =  41
                coords["longitude"] = self.previousLongitude
                coords["heading"] = 0
                coords["speed"] = 0

                endGps["coords"] = coords
                endGps["timestamp"] = timestamp
                endGps["locationString"] = self.locationString
                endGps["decision"] =  "off-bounds"
                endGps["is_ok"] = false
                endGps["diff"] = false
                        
                param["endGps"] = endGps
                param["description"] = ""
                
                
                if (currentTimelogData?.data?.deviceDetails != nil) {
                    shiftData["shiftId"] = self.currentTimelogData?.data?.shiftId
                    
                    shiftData["autoClockIn"] = self.currentTimelogData?.data?.autoClockIn
                    shiftData["autoClockOut"] = true
                    
                    deviceDetails["device"] = self.currentTimelogData?.data?.deviceDetails?.device
                    deviceDetails["deviceModel"] = self.currentTimelogData?.data?.deviceDetails?.deviceModel
                    deviceDetails["osVersion"] = self.currentTimelogData?.data?.deviceDetails?.osVersion
                    deviceDetails["appVersion"] = self.currentTimelogData?.data?.deviceDetails?.appVersion
                    deviceDetails["buildNumber"] = self.currentTimelogData?.data?.deviceDetails?.buildNumber
                    shiftData["deviceDetails"] = deviceDetails
                } else {
                    shiftData["shiftId"] = self.currentScheduleData[0].id
                    
                    shiftData["autoClockIn"] = true
                    shiftData["autoClockOut"] = true
                    
                    deviceDetails["device"] = "iOS"
                    deviceDetails["deviceModel"] = UIDevice.current.model
                    deviceDetails["osVersion"] = UIDevice.current.systemVersion
                    deviceDetails["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    deviceDetails["buildNumber"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                    shiftData["deviceDetails"] = deviceDetails
                }

                param["data"] = shiftData
                
                print("Finish work hour params : ", param)
                
                WorkHourVM.shared.finishWorkHoursAPI(parameters: param, id: self.currentTimelogData?.id ?? 0, isAuthorization: true) { [self] obj in
                    print("Appdelegate Finish respone is : ", obj)
                    NotificationCenter.default.post(name: .apiCallCompleted, object: nil)
                }
            }
        })
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
}

//
//  TaskMapVC.swift
//  TimeControllApp
//
//  Created by Ashish Rana on 06/11/22.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

protocol TaskMapVCProtocol {
    
    func getLatLong(lat:Double,long:Double,addressMap:String,postalCode:String,cityName:String)
    
}

class TaskMapVC: BaseViewController, GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var vwMap: GMSMapView!
    
    
    var locationManager = CLLocationManager()
    var placesClient = GMSPlacesClient()

    var polyline = GMSPolyline()
    var path = GMSPath()
    var lat = String()
    var long = String()
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    var address = String()

    var delegate: TaskMapVCProtocol?
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    var isMapFrom = ""
    var isTimelogData : Timelog?
    var currentTaskName = ""
    var currentLocationPin = false
    
    @IBOutlet weak var selectLocationLbl: UILabel!
    @IBOutlet weak var taskNameTitleLbl: UILabel!
    @IBOutlet weak var vwLocationDetails: UIView!
    @IBOutlet weak var locationDetailsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocalization()
        if (isMapFrom == "WorkHours") {
            searchBtn.isHidden = true
            btnClose.setTitle(LocalizationKey.close.localizing(), for: .normal)
            vwLocationDetails.isHidden = true
        }
        else {
            searchBtn.isHidden = false
            btnClose.setTitle(LocalizationKey.selectLocation.localizing(), for: .normal)
            vwLocationDetails.isHidden = false
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
//        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()

        placesClient = GMSPlacesClient.shared()
  
        
        let defaultLocation = CLLocation(latitude:76.217, longitude:30.7071)

        
      // Create a map.
      // let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude, zoom: 50.0)
        vwMap.camera = camera
        vwMap.settings.myLocationButton = true
        vwMap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vwMap.isMyLocationEnabled = true

        
        vwMap.delegate = self
        //self.hitApiDestination()
//        placeMarkerNearByDriver()
//        placeMarker()
    }
    
    func setUpLocalization(){
        taskNameTitleLbl.text = LocalizationKey.taskMap.localizing()
        searchBtn.setTitle(LocalizationKey.search.localizing(), for: .normal)
        selectLocationLbl.text = LocalizationKey.selectLocation.localizing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("sdfasdf")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        //  let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: 20.0)
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
//        self.latitude = 40.540310
//        self.longitude = -74.167660

        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let loc: CLLocation = CLLocation(latitude:40.540310, longitude: -74.167660)

        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks?[0]
                var addressString : String = ""
                var cityName : String = ""
                var postalCode : String = ""
                var countryName : String = ""
                var displayAddressString : String = ""
                
                if pm?.name != nil {
                    addressString = pm?.name ?? ""
                    displayAddressString = pm?.name ?? ""
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
                    displayAddressString = "\(displayAddressString), \(postalCode)"
                }
                
                if pm?.locality != nil {
                    //                    addressString = addressString + (pm?.locality ?? "") + ", "
                    cityName = pm?.locality ?? ""
                    displayAddressString = "\(displayAddressString), \(cityName)"
                }
                
                self.address = addressString
                
                self.locationDetailsLbl.text = "\(displayAddressString), \(countryName)"
                
            }
        })
        vwMap.camera = camera
        
        //        var position = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        //        var marker = GMSMarker(position: position)
        //        marker.title = "Hello World"
        //        marker.map = vwMap
        
        let startLat = isTimelogData?.gps_data?.start?.coords?.latitude
        let startLon = isTimelogData?.gps_data?.start?.coords?.longitude
        
        let endLat = isTimelogData?.gps_data?.end?.coords?.latitude
        let endtLon = isTimelogData?.gps_data?.end?.coords?.longitude
        
        let distance = distanceBetween(currentLatitude: startLat ?? 0.0, currentLongitude: startLon ?? 0.0, targetLatitude: endLat ?? 0.0, targetLongitude: endtLon ?? 0.0)
        print("distance ", distance)
        
        if distance <= 50 {
            if (isTimelogData?.gps_data?.start?.coords != nil && isTimelogData?.gps_data?.end?.coords != nil) {
                let startCordi = CLLocationCoordinate2D(latitude: isTimelogData?.gps_data?.start?.coords?.latitude ?? 0, longitude: isTimelogData?.gps_data?.start?.coords?.longitude ?? 0 )
                let startMarker : GMSMarker!
                startMarker = GMSMarker(position: startCordi)
                let from = Helper.minutesToHoursAndMinutes(isTimelogData?.from ?? 0)
                //            startMarker.title = "Start Time : \(from.hours):\(from.leftMinutes)"
                startMarker.title = "\(LocalizationKey.startTime.localizing()) : \(logTime(time: isTimelogData?.from ?? 0)) / \(LocalizationKey.endTime.localizing()) \(logTime(time: isTimelogData?.to ?? 0))"
                startMarker.snippet = isTimelogData?.gps_data?.start?.locationString
                //            startMarker.icon = UIImage(named: "ic_start_marker")
                startMarker.icon = self.imageWithImage(image: UIImage(named: "ic_start_marker")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
                startMarker.map = self.vwMap
            }
        } else {
            if (isTimelogData?.gps_data?.start?.coords != nil) {
                let startCordi = CLLocationCoordinate2D(latitude: isTimelogData?.gps_data?.start?.coords?.latitude ?? 0, longitude: isTimelogData?.gps_data?.start?.coords?.longitude ?? 0 )
                let startMarker : GMSMarker!
                startMarker = GMSMarker(position: startCordi)
                let from = Helper.minutesToHoursAndMinutes(isTimelogData?.from ?? 0)
                //            startMarker.title = "Start Time : \(from.hours):\(from.leftMinutes)"
                startMarker.title = "\(LocalizationKey.startTime.localizing()) : \(logTime(time: isTimelogData?.from ?? 0))"
                startMarker.snippet = isTimelogData?.gps_data?.start?.locationString
                //            startMarker.icon = UIImage(named: "ic_start_marker")
                startMarker.icon = self.imageWithImage(image: UIImage(named: "ic_start_marker")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
                startMarker.map = self.vwMap
            }
            
            if (isTimelogData?.gps_data?.end?.coords != nil) {
                let endCordi = CLLocationCoordinate2D(latitude: isTimelogData?.gps_data?.end?.coords?.latitude ?? 0 , longitude: isTimelogData?.gps_data?.end?.coords?.longitude ?? 0)
                let endMarker : GMSMarker!
                endMarker = GMSMarker(position: endCordi)
                let to = Helper.minutesToHoursAndMinutes(isTimelogData?.to ?? 0)
                //            endMarker.title = "End Time : \(to.hours):\(to.leftMinutes)"
                endMarker.title = "\(LocalizationKey.endTime.localizing()) : \(logTime(time: isTimelogData?.to ?? 0))"
                endMarker.snippet = isTimelogData?.gps_data?.end?.locationString
                //            endMarker.icon = UIImage(named: "ic_end_marker")
                endMarker.icon = self.imageWithImage(image: UIImage(named: "ic_end_marker")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
                endMarker.map = self.vwMap
            }
        }
        
        if (!currentLocationPin) {
            let currentMarker : GMSMarker!
            if (isMapFrom == "WorkHours") {
                let targetLocation = isTimelogData?.gps_data?.task?.split(separator: ",")
                let targetLat = Double(targetLocation?[0] ?? "")
                let targetLon = Double(targetLocation?[1] ?? "")

                let currentCordi = CLLocationCoordinate2D(latitude: targetLat ?? 0.0 , longitude: targetLon ?? 0.0)
                currentMarker = GMSMarker(position: currentCordi)
                currentMarker.title =  "\(LocalizationKey.tasks.localizing()) : \(currentTaskName)"
                currentMarker.snippet = isTimelogData?.location_string
                currentMarker.isDraggable = false
                
                let startLocation = CLLocationCoordinate2D(latitude: startLat ?? 0.0 , longitude: startLon ?? 0.0)
                let bounds = GMSCoordinateBounds(coordinate: startLocation, coordinate: currentCordi)

                self.vwMap?.animate(with: GMSCameraUpdate.fit(bounds,withPadding: 50.0))
                
            } else {
                let currentCordi = CLLocationCoordinate2D(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude)
                currentMarker = GMSMarker(position: currentCordi)
                currentMarker.title =  self.address
                //                currentMarker.snippet = isTimelogData?.location_string
                currentMarker.isDraggable = true
            }
            //            endMarker.icon = UIImage(named: "ic_end_marker")
            currentMarker.icon = self.imageWithImage(image: UIImage(named: "ic_current_marker")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
            currentMarker.map = self.vwMap
            currentLocationPin = true
        }
        //listLikelyPlaces()
        
        locationManager.stopUpdatingLocation()
    }

    
    // Camera change Position this methods will call every time
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
//        let markerPosition = marker.position
//        let cameraPosition = GMSCameraPosition.camera(withTarget: markerPosition, zoom: 15)
//        let markerLatitude = marker.position.latitude
//        let markerLongitude = marker.position.longitude
        latitude = marker.position.latitude
        longitude = marker.position.longitude
        
        var destinationLocation = CLLocation()
        destinationLocation = CLLocation(latitude: marker.position.latitude,  longitude: marker.position.longitude)
        let ceo: CLGeocoder = CLGeocoder()
        ceo.reverseGeocodeLocation(destinationLocation, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = (placemarks ?? []) as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks?[0]
                var addressString : String = ""
                var cityName : String = ""
                var postalCode : String = ""
                var countryName : String = ""
                var displayAddressString : String = ""
                
                if pm?.name != nil {
                    addressString = pm?.name ?? ""
                    displayAddressString = pm?.name ?? ""
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
                    displayAddressString = "\(displayAddressString), \(postalCode)"
                }
                
                if pm?.locality != nil {
                    //                    addressString = addressString + (pm?.locality ?? "") + ", "
                    cityName = pm?.locality ?? ""
                    displayAddressString = "\(displayAddressString), \(cityName)"
                }
                self.address = addressString
                self.locationDetailsLbl.text = "\(displayAddressString), \(countryName)"
            }
        })
        // Animate the map camera to the new position and zoom level
////        mapView.animate(to: cameraPosition)
//        mapView.animate(toZoom: cameraPosition)

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
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
      // Handle authorization for the location manager.
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
          fatalError()
        }

        // Handle authorization status
        switch status {
        case .restricted:
          print("Location access was restricted.")
        case .denied:
          print("User denied access to location.")
          // Display the map using the default location.
            vwMap.isHidden = false
        case .notDetermined:
          print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
          print("Location status is OK.")
        @unknown default:
          fatalError()
        }
      }

      // Handle location manager errors.
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
      }

    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
        openGooglePlacePicker()
    }
    
    //MARK: - PlaceMarker
    func placeMarker() {
        
        vwMap.clear()
        let marker = GMSMarker()
        let markerView = UIImageView(image: UIImage(named: "location100"))
        marker.iconView = markerView
        // marker.position = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
        marker.position = CLLocationCoordinate2D(latitude: isTimelogData?.gps_data?.start?.coords?.latitude ?? 0, longitude: isTimelogData?.gps_data?.start?.coords?.longitude ?? 0)
        marker.position = CLLocationCoordinate2D(latitude: isTimelogData?.gps_data?.end?.coords?.latitude ?? 0, longitude: isTimelogData?.gps_data?.end?.coords?.longitude ?? 0)
        marker.isFlat = true
        DispatchQueue.main.async {
            marker.map = self.vwMap
        }
        let camera = GMSCameraPosition.camera(withLatitude: (Double(lat) ?? 0.0), longitude: (Double(long) ?? 0.0), zoom: 30.0)
        self.vwMap?.setMinZoom(0.0, maxZoom: 25.0)
        self.vwMap?.animate(to: camera)
    }
    
    func placeMarkerNearByDriver() {
        
        vwMap.clear()
      //  arrNearByDriver = []
       //  for cordinates in arrLocation {
             let marker = GMSMarker()
           //  let image = UIImage(named: isBike == true ? "bikeMarker" : "carPlaceholder")!.withRenderingMode(.alwaysOriginal)
             let markerView = UIImageView(image: UIImage(named: "location100"))
             marker.iconView = markerView
          // marker.position = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
        marker.position = CLLocationCoordinate2D(latitude: (Double(lat) ?? 59.9139), longitude: (Double(long) ?? 10.7522))
             marker.isFlat = true
             DispatchQueue.main.async {
                 marker.map = self.vwMap
             }
          //   arrNearByDriver.append(marker)
      //   }
      //  "task": "22.9949088,72.60880259999999",
     //   30.7046
     //   76.7179
        let camera = GMSCameraPosition.camera(withLatitude: (Double(lat) ?? 0.0), longitude: (Double(long) ?? 0.0), zoom: 30.0)
        self.vwMap?.setMinZoom(0.0, maxZoom: 25.0)
        self.vwMap?.animate(to: camera)
     }
    
    
    @IBAction func currentLocBtnAction(_ sender: Any) {
        
     }
    
    @IBAction func selectLocBtnAction(_ sender: Any) {
        if (isMapFrom == "WorkHours") {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            getAddressFromLatLong()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getAddressFromLatLong() {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(latitude)")!
        //21.228124
        let lon: Double = Double("\(longitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//                let loc: CLLocation = CLLocation(latitude:59.282450, longitude: 11.086530)
//        let loc: CLLocation = CLLocation(latitude:40.540310, longitude: -74.167660)
        
        var addressString : String = ""
        var postalCode : String = ""
        var cityName : String = ""

        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks
            
            if pm?.count ?? 0 > 0 {
                let pm = placemarks?[0]
                print("pm is : ", pm)
                print("name is : ", pm?.name)
                print("name is : ", pm?.subLocality)

                
//                if pm?.subLocality != nil {
//                    addressString = addressString + (pm?.subLocality ?? "") + ", "
//                }
//                if pm?.thoroughfare != nil {
//                    addressString = addressString + (pm?.thoroughfare ?? "") + ", "
//                }
//
//                if pm?.administrativeArea != nil {
//                    addressString = addressString + (pm?.administrativeArea ?? "") + ", "
//                }
//
//                if pm?.subAdministrativeArea != nil {
//                    addressString = addressString + (pm?.subAdministrativeArea ?? "") + ", "
//                }
//
//                if pm?.isoCountryCode != nil {
//                    addressString = addressString + (pm?.isoCountryCode ?? "") + ", "
//                }
//
//                if pm?.inlandWater != nil {
//                    addressString = addressString + (pm?.inlandWater ?? "") + ", "
//                }
//
//                if pm?.inlandWater != nil {
//                    addressString = addressString + (pm?.inlandWater ?? "") + ", "
//                }
                
                if pm?.name != nil {
                    addressString = pm?.name ?? ""
                }
                
                
                if pm?.locality != nil {
//                    addressString = addressString + (pm?.locality ?? "") + ", "
                    cityName = pm?.locality ?? ""
                }
                if pm?.country != nil {
                    //postalCode = (pm?.country ?? "") + ", "
                    if pm?.country == "United States" {
                        if pm?.subLocality != nil {
                            addressString = addressString + ", " + (pm?.subLocality ?? "")
                        }
                    }
                }
                if pm?.postalCode != nil {
                    postalCode = pm?.postalCode ?? ""
                }
                
                //
                print(addressString)
            }
            
            self.delegate?.getLatLong(lat: center.latitude, long: center.longitude, addressMap: addressString, postalCode: postalCode, cityName: cityName)
            self.navigationController?.popViewController(animated: false)
        })
    }
}


extension TaskMapVC : GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        print("Place attributions: \(String(describing: place.attributions))")
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = place.coordinate.latitude
        //21.228124
        let lon: Double = place.coordinate.longitude
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        var addressString : String = ""
        var postalCode : String = ""
        var cityName : String = ""
        let loc: CLLocation = CLLocation(latitude:center.latitude,longitude:center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks
            
            if pm?.count ?? 0 > 0 {
                let pm = placemarks?[0]
                /*
                 if pm?.subLocality != nil {
                 addressString = addressString + (pm?.subLocality ?? "") + ", "
                 }
                 if pm?.thoroughfare != nil {
                 addressString = addressString + (pm?.thoroughfare ?? "") + ", "
                 }
                 
                 if pm?.administrativeArea != nil {
                 addressString = addressString + (pm?.administrativeArea ?? "") + ", "
                 }
                 
                 if pm?.subAdministrativeArea != nil {
                 addressString = addressString + (pm?.subAdministrativeArea ?? "") + ", "
                 }
                 
                 if pm?.isoCountryCode != nil {
                 addressString = addressString + (pm?.isoCountryCode ?? "") + ", "
                 }
                 
                 if pm?.inlandWater != nil {
                 addressString = addressString + (pm?.inlandWater ?? "") + ", "
                 }
                 
                 if pm?.inlandWater != nil {
                 addressString = addressString + (pm?.inlandWater ?? "") + ", "
                 }
                 
                 if pm?.locality != nil {
                 addressString = addressString + (pm?.locality ?? "") + ", "
                 cityName = pm?.locality ?? ""
                 }
                 if pm?.country != nil {
                 //postalCode = (pm?.country ?? "") + ", "
                 }
                 if pm?.postalCode != nil {
                 postalCode = pm?.postalCode ?? ""
                 }
                 */
                
                if pm?.name != nil {
                    addressString = pm?.name ?? ""
                }
                
                if pm?.locality != nil {
                    //                    addressString = addressString + (pm?.locality ?? "") + ", "
                    cityName = pm?.locality ?? ""
                }
                if pm?.country != nil {
                    //postalCode = (pm?.country ?? "") + ", "
                    if pm?.country == "United States" {
                        if pm?.subLocality != nil {
                            addressString = addressString + ", " + (pm?.subLocality ?? "")
                        }
                    }
                }
                if pm?.postalCode != nil {
                    postalCode = pm?.postalCode ?? ""
                }
                
                //
                print(addressString)
            }
            
            //                            self.delegate?.getLatLong(lat: center.latitude, long: center.longitude, addressMap: place.formattedAddress ?? "", postalCode: postalCode, cityName: cityName)
            self.delegate?.getLatLong(lat: center.latitude, long: center.longitude, addressMap: addressString, postalCode: postalCode, cityName: cityName)
            self.navigationController?.popViewController(animated: false)
        })
        
        
        
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    print(field.name)
                case kGMSPlaceTypeRoute:
                    print(field.name)
                case kGMSPlaceTypeNeighborhood:
                    print(field.name)
                case kGMSPlaceTypeLocality:
                    print(field.name)
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    print(field.name)
                case kGMSPlaceTypeCountry:
                    print(field.name)
                case kGMSPlaceTypePostalCode:
                    print(field.name)
                case kGMSPlaceTypePostalCodeSuffix:
                    print(field.name)
                    // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        
        
        getAddressFrom(location: place.coordinate)
        dismiss(animated: true, completion: nil)
    }
    
    
    func getAddressFrom(location: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(location) { response, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                guard let places = response?.results(),
                      let _ = places.first else {
                    return
                }
                print(places.first ?? "")
                
                
                //            coordinate: (31.468465, 76.270815)
                //            lines: Una, Himachal Pradesh 174303, India
                //            locality: Una
                //            administrativeArea: Himachal Pradesh
                //            postalCode: 174303
                //            country: India
                let fullAddress = places.first?.lines?[0]
                print(fullAddress ?? "")
                
                self.lat = "\(places.first?.coordinate.latitude ?? 0.0)"
                self.long = "\(places.first?.coordinate.longitude ?? 0.0)"
                
                self.placeMarkerNearByDriver()
                
                // self.delegate?.selectedCorrdinates(lat: self.lat, long: self.long)
                
                //  self.navigationController?.popViewController(animated: true)
                
                /*  self.txtFldAddressLine1.text  =  "\(places.first?.country ?? ""), \(places.first?.administrativeArea ?? ""), \(places.first?.locality ?? "")"
                 self.txtPostalCode.text = places.first?.postalCode
                 self.txtFldCountry.text = places.first?.country
                 self.txtFldState.text = places.first?.administrativeArea ?? places.first?.locality
                 self.txtFldCity.text = places.first?.locality
                 
                 dictProfileData["addressLine1"] = self.txtFldAddressLine1.text
                 dictProfileData["postalCode"] = self.txtPostalCode.text
                 dictProfileData["country"] = self.txtFldCountry.text
                 dictProfileData["state"] = self.txtFldState.text
                 dictProfileData["city"] =  self.txtFldCity.text
                 dictProfileData["lat"] = self.lat
                 dictProfileData["lng"] = self.long */
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func openGooglePlacePicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) |
                                                  UInt(GMSPlaceField.coordinate.rawValue) |
                                                  GMSPlaceField.addressComponents.rawValue |
                                                  GMSPlaceField.formattedAddress.rawValue)!
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        //filter.countries = ["us"]
        // filter.countries = ["NO"]
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
        //
        //        let autocompleteController = GMSAutocompleteViewController()
        //          autocompleteController.delegate = self
        //          let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.all.rawValue))
        //          autocompleteController.placeFields = fields
        //          let filter = GMSAutocompleteFilter()
        //          filter.type = .region
        //          filter.countries = ["us"]
        //          autocompleteController.autocompleteFilter = filter
        //          autocompleteController.modalPresentationStyle = .fullScreen
        //          present(autocompleteController, animated: true, completion: nil)
    }
    
    func hitApiDestination() {
        let str = "https://maps.googleapis.com/maps/api/directions/json?origin=30.7046,76.7179&destination=28.7041,77.1025&sensor=false&mode=driving&key=\(Constant.googleKey)"
        
        let url = URL(string: str)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data, data.count > 0 else {
                self.showAlert(message: error?.localizedDescription ?? "", strtitle: "Alert")
                return
            }
            print(String(data: data, encoding: .utf8)!)
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String : Any]
                guard dict["status"] as? String != "ZERO_RESULTS" else {
                    
                    
                    self.showAlert(message: LocalizationKey.weAreGettingSomeProblemFromGooglePleaseTryAgainLater.localizing(), strtitle: LocalizationKey.alert.localizing())
                    return
                }
                
                self.drawRoutes(dict: dict)
                
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
        
    }
    
    func hitDistanceApiMetrics() {
        var str = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\("30.7046"),\("76.7179")&destinations=\("28.7041"),\("77.1025")"
        print(str)
        str.append("&key=\(Constant.googleKey)")
        print(str)
        let url = URL(string: str)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data, data.count > 0 else {
                self.showAlert(message: error?.localizedDescription ?? "", strtitle: LocalizationKey.alert.localizing())
                return
            }
            print(String(data: data, encoding: .utf8)!)
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String : Any]
                
                guard dict["status"] as? String != "ZERO_RESULTS" else {
                    self.showAlert(message:  LocalizationKey.weAreGettingSomeProblemFromGooglePleaseTryAgainLater.localizing(), strtitle: LocalizationKey.alert.localizing())
                    return
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    
    func drawRoutes(dict : [String : Any]) {
        let routesArray = dict["routes"] as! [[String : Any]]
        if routesArray.count > 0 {
            let routeDict = routesArray[0]
            let routeOverViewPolyline = routeDict["overview_polyline"] as! [String : Any]
            let points = routeOverViewPolyline["points"]
            
            
            self.path = GMSPath.init(fromEncodedPath: points as! String)!
            let bounds = GMSCoordinateBounds(path: self.path)
            DispatchQueue.main.async {
                self.vwMap.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            }
            
            
            DispatchQueue.main.async { [self] in
                
                self.polyline.path = self.path
                self.polyline.strokeColor = Constant.appColor
                self.polyline.strokeWidth = 3.0
                self.polyline.map = self.vwMap
                
                
                let sourceCordi = CLLocationCoordinate2D(latitude: 30.7046 , longitude: 76.7179 )
                let destinationCordi = CLLocationCoordinate2D(latitude: 28.7041 , longitude: 77.1025)
                
                let homeMarker : GMSMarker!
                let homeicon = UIImage(named: "location100")!.withRenderingMode(.alwaysOriginal)
                let homeMarkerView = UIImageView(image: homeicon)
                let restaurentMarker : GMSMarker!
                let restaurentIcon = UIImage(named: "red100")!.withRenderingMode(.alwaysOriginal)
                let restaurentMarkerView = UIImageView(image: restaurentIcon)
                homeMarker = GMSMarker(position: destinationCordi)
                homeMarker.iconView = homeMarkerView
                homeMarker.map = self.vwMap
                restaurentMarker = GMSMarker(position: sourceCordi)
                restaurentMarker.iconView = restaurentMarkerView
                restaurentMarker.map = self.vwMap
            }
        } else {
            print("Falied to draw polyline")
        }
    }
}

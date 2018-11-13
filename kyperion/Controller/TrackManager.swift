//
//  TrackManager.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 27/08/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation
import Alamofire

class TrackManager {
    
    // MARK: Properties
    
    var arrayLocations : Array<CLLocation> = Array<CLLocation>()
    
    class var sharedManager: TrackManager {
        struct Singleton {
            static let trackManager = TrackManager()
        }
        return Singleton.trackManager
    }
    
    var lastLapHasEndLocation : Bool {
        return currentActivity.lastLap.lapFinish()
    }
    
    var lastLapEndLocationShouldBeFilled : Bool {
        return currentActivity.lastLap.lapFinish()
    }
    
    func addLocation(location: CLLocation){
        var count = arrayLocations.count
        if count == 0 {
            arrayLocations.append(location)
        }else{
            arrayLocations.insert(location, atIndex: count)
        }
    }
    
    private func generateLapDictionary(duration: String, distanceUnit dUnit: String, distanceValue dValue: String, locationStartLatitude locStartLat: String, locationStartLongitude locStartLon: String, locationEndLatitude locEndLat: String, locationEndLongitude locEndLon: String) -> Dictionary<String,String>{
        
        var newLap: Dictionary<String,String> = Dictionary<String,String>()
        newLap["duration"] = duration
        newLap["distanceUnit"] = dUnit
        newLap["distanceValue"] = dValue
        newLap["locationStartLatitude"] = locStartLat
        newLap["locationStartLongitude"] = locStartLon
        newLap["locationEndLatitude"] = locEndLat
        newLap["locationEndLongitude"] = locEndLon
        
        return newLap
    }
    
    func addLap(duration: String, distanceUnit dUnit: String, distanceValue dValue: String, locality: String, country: String, altitude: Double, horizontalAccuracy: Double, verticalAccuracy: Double, speed: Double, timestamp: NSDate, course: Double, name: String, locationLatitude locLat: Double, locationLongitude locLon: Double){
        
        var lap = KYLap()
        
        var numberOfLapInCurrentActivity = currentActivity.laps.count
        if numberOfLapInCurrentActivity == 0 {
            // Start Lap with with start Location
            lap = KYLap(order: numberOfLapInCurrentActivity, locality: locality, country: country, altitude: altitude, horizontalAccurancy: horizontalAccuracy, verticalAccurancy: verticalAccuracy, speed: speed, course: course, timestamp: timestamp, name: name, duration: duration, distanceUnit: dUnit, distanceValue: dValue, locationStartLatitude: locLat, locationStartLongitude: locLon, locationEndLatitude: 0.0, locationEndLongitude: 0.0)
            currentActivity.addNewLap(lap)
        }else{
            // Check if there is a lap started.
            if lastLapHasEndLocation {
                // If true, add End Location
                lap = currentActivity.addEndLocationToLastLap(course, locality: locality, country: country, duration: duration, dValue: dValue, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, speed: speed, timestamp: timestamp, name: name,  locLat: locLat, locLon: locLat)
                currentActivity.refreshLap(lap)
            }else{
                // i.o.c: Start Lap with with start Location
                //lap = currentActivity.addStartLocation(course, locality: locality, country: country, duration: duration, dValue: dValue, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, speed: speed, timestamp: timestamp, name: name,  locLat: locLat, locLon: locLat)
                var locationEndLatitudeOfLastLap = currentActivity.lastLap.endLocation.location.coordinate.latitude
                var locationEndLongitudeOfLastLap = currentActivity.lastLap.endLocation.location.coordinate.longitude
                lap = KYLap(order: numberOfLapInCurrentActivity, locality: locality, country: country, altitude: altitude, horizontalAccurancy: horizontalAccuracy, verticalAccurancy: verticalAccuracy, speed: speed, course: course, timestamp: timestamp, name: name, duration: duration, distanceUnit: dUnit, distanceValue: dValue, locationStartLatitude: locationEndLatitudeOfLastLap, locationStartLongitude: locationEndLongitudeOfLastLap, locationEndLatitude: locLat, locationEndLongitude: locLon)
                currentActivity.addNewLap(lap)
            }
            
        }
    }
    
    func addFirstLap(duration: String, distanceUnit dUnit: String, distanceValue dValue: String, location currentLocation: KYLocation){
        let locality = currentLocation.locality
        let country = currentLocation.country
        let altitude = currentLocation.location.altitude
        let latitude = currentLocation.location.coordinate.latitude
        let longitude = currentLocation.location.coordinate.longitude
        let locationStartLatitude = currentActivity.startLocation.location.coordinate.latitude
        let locationStartLongitude = currentActivity.startLocation.location.coordinate.longitude
        let horizontalAccuracy = currentLocation.location.horizontalAccuracy
        let verticalAccuracy = currentLocation.location.verticalAccuracy
        let speed = currentLocation.location.speed
        let timestamp = currentLocation.location.timestamp
        let course = currentLocation.location.course
        let name = currentLocation.name
        
        var lap = KYLap(order: 0, locality: locality, country: country, altitude: altitude, horizontalAccurancy: horizontalAccuracy, verticalAccurancy: verticalAccuracy, speed: speed, course: course, timestamp: timestamp, name: name, duration: duration, distanceUnit: dUnit, distanceValue: dValue, locationStartLatitude: latitude, locationStartLongitude: longitude, locationEndLatitude: latitude, locationEndLongitude: longitude)
        currentActivity.addNewLap(lap)
    }
    
    func addLap(duration: String, distanceUnit dUnit: String, distanceValue dValue: String, location currentLocation: KYLocation){
        let locality = currentLocation.locality
        let country = currentLocation.country
        let altitude = currentLocation.location.altitude
        let latitude = currentLocation.location.coordinate.latitude
        let longitude = currentLocation.location.coordinate.longitude
        var locationEndLatitudeOfLastLap = currentActivity.lastLap.endLocation.location.coordinate.latitude
        var locationEndLongitudeOfLastLap = currentActivity.lastLap.endLocation.location.coordinate.longitude
        let horizontalAccuracy = currentLocation.location.horizontalAccuracy
        let verticalAccuracy = currentLocation.location.verticalAccuracy
        let speed = currentLocation.location.speed
        let timestamp = currentLocation.location.timestamp
        let course = currentLocation.location.course
        let name = currentLocation.name
        
        var numberOfLapInCurrentActivity = currentActivity.laps.count
        var lap = KYLap(order: numberOfLapInCurrentActivity, locality: locality, country: country, altitude: altitude, horizontalAccurancy: horizontalAccuracy, verticalAccurancy: verticalAccuracy, speed: speed, course: course, timestamp: timestamp, name: name, duration: duration, distanceUnit: dUnit, distanceValue: dValue, locationStartLatitude: locationEndLatitudeOfLastLap, locationStartLongitude: locationEndLongitudeOfLastLap, locationEndLatitude: latitude, locationEndLongitude: longitude)
        currentActivity.addNewLap(lap)
    }
    
    func createActivity(sportType:SportType){
        currentActivity = KYActivity()
        currentActivity.userId = currentUser.userId
        currentActivity.activityId = "0"
        currentActivity.userPicture = currentUser.userPicture
        currentActivity.name = currentUser.firstName
        currentActivity.surname = currentUser.lastName
        currentActivity.sportType = sportType
    }
    
    func sendTrack(){
        
        var activityName = currentActivity.activityName
        var date = currentActivity.date
        var sportType = currentActivity.getTypeSport()
        if currentActivity.sportType == SportType.SWIMMING{
            sportType = SPORT_TYPE_SWIMMING
        }else if currentActivity.sportType == SportType.CYCLING{
            sportType = SPORT_TYPE_CYCLING
        }else if currentActivity.sportType == SportType.RUNNING{
            sportType = SPORT_TYPE_RUNNING
        }
        var userid = currentActivity.userId
        var training = currentActivity.trainingAPIFormatStr
        var laps = currentActivity.lapsAPIFormatString
        
        var JSONObject: [String : AnyObject] = ["activity_name": activityName,
            "date": date, "sport_type": sportType, "userid": userid, "training": training, "laps": laps]
        
        var obj : String = "{\"activity_name\": \"\(activityName)\",\"date\": \"\(date)\", \"sport_type\":\"\(sportType)\", \"userid\": \"\(userid)\", \"training\": \(training), \"laps\": \(laps)}"
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            let urlString = API(caseAPI:CONST_API_USER_ACTIVITY).url
            let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            let keyStr = "Token \(tokenUser)"
            mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            var err: NSError?
            Alamofire.request(.POST, mutableURLRequest, parameters: JSONObject, encoding: .Custom({
                (convertible, params) in
                var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
                let keyStr = "Token \(tokenUser)"
                mutableRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
                mutableRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                //mutableRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(JSONObject, options:  NSJSONWritingOptions(rawValue:0), error: &err)
                var myBodyString = obj
                mutableRequest.HTTPBody = myBodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                return (mutableRequest, nil)
            })).responseJSON {
                (request, response, data, error) -> Void in
                
                if(error == nil){
                    self.displayMessage(true, message: LocalizedString_ACT_CREATED)
                }else{
                    self.displayMessage(false, message: LocalizedString_ACT_NOT_CREATED)
                }
            }
        }
       
        
    }
    
    func displayMessage(updated: Bool, message: String){
        var title = updated ? "Success" : "Error"
        var image = updated ? AssetsManager.checkmarkImage : AssetsManager.crossImage
        KYHUD.sharedHUD.contentView = KYHUDStatusView(title: title, subtitle: message, image: image)
        KYHUD.sharedHUD.show()
        KYHUD.sharedHUD.hide(afterDelay: 3.0)
    }
    
    private func generateJSON() -> JSON{
        print("currentActivity: \n \(currentActivity)")
        var json: JSON = JSON(currentActivity)
        
        return json
    }
}
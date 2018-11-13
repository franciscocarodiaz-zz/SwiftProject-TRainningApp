//
//  ActivityMethods.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import SwiftyJSON

extension KYActivity{
    
    convenience init(listActivityData: JSON) {
        self.init()
        var errors = [String]()
        var listActivity = [KYCalendarActivityData]()
        
        for activityItem in listActivityData.arrayValue {
            var newActivity = KYCalendarActivityData(activityItem)
            
            listActivity.append(newActivity)
        }
        
        if(errors.count>0){
            self.userId = ""
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }else{
            currentUser.listActivity = listActivity
        }
        
    }
    
    convenience init(_ dictionary: JSON) {
        self.init()
        var errors = [String]()
        var listRecentActivity = [Dictionary<String, [KYActivity]>]()
        
        
        for (dateEvent,_) in dictionary{
            var newRecentActivity = Dictionary<String, [KYActivity]>()
            if let eventList = dictionary[dateEvent]["events"].array {
                
                var listOfEvent = [KYActivity]()
                
                for event in eventList {
                    let newEvent = KYActivity()
                    for(key, value) in event {
                        if let _ = event[key].string {
                            switch key {
                            case ACTIVITYPARAMS_USERID:
                                newEvent.userId = event[ACTIVITYPARAMS_USERID].string!
                            case ACTIVITYPARAMS_DATE:
                                newEvent.date = event[ACTIVITYPARAMS_DATE].string!
                            case ACTIVITYPARAMS_NAME:
                                newEvent.name = event[ACTIVITYPARAMS_NAME].string!
                            case ACTIVITYPARAMS_SPORT:
                                if value.string == SPORT_TYPE_CYCLING {
                                    newEvent.sportType = SportType.CYCLING
                                }else if value.string == SPORT_TYPE_GYM {
                                    newEvent.sportType = SportType.GYM
                                }else if value.string == SPORT_TYPE_RUNNING {
                                    newEvent.sportType = SportType.RUNNING
                                }else if value.string == SPORT_TYPE_SWIMMING {
                                    newEvent.sportType = SportType.SWIMMING
                                }
                            case ACTIVITYPARAMS_SURNAME:
                                newEvent.surname = event[ACTIVITYPARAMS_SURNAME].string!
                            case ACTIVITYPARAMS_TIME:
                                newEvent.time = event[ACTIVITYPARAMS_TIME].string!
                            case ACTIVITYPARAMS_VELOCITY:
                                newEvent.velocity = event[ACTIVITYPARAMS_VELOCITY].string!
                            case ACTIVITYPARAMS_USERPICTURE:
                                newEvent.userPicture = event[ACTIVITYPARAMS_USERPICTURE].string!
                            default:
                                print("KYActivity: No key " + key + " recognized for user object model.")
                                
                            }
                        } else {
                            if key == ACTIVITYPARAMS_DISTANCE {
                                if let value = value[PARAM_VALUE].string {
                                    newEvent.distance = value
                                }
                                if let unit = value[PARAM_UNIT].string {
                                    newEvent.distanceUnit = unit
                                }
                            }else if key == ACTIVITYPARAMS_PACE {
                                newEvent.pace = value[PARAM_VALUE].string!
                                newEvent.paceUnit = value[PARAM_UNIT].string!
                            }else if key == ACTIVITYPARAMS_USERID {
                                newEvent.userId = "\(event[ACTIVITYPARAMS_USERID])"
                            }else if key == ACTIVITYPARAMS_ACTIVITYID {
                                newEvent.activityId = "\(event[ACTIVITYPARAMS_ACTIVITYID])"
                            }else{
                                //errors.append(key)
                            }
                        }
                    }
                    listOfEvent.append(newEvent)
                }
                
                newRecentActivity[dateEvent] = listOfEvent
                
            }
                
            listRecentActivity.append(newRecentActivity)
            
        }
        
        if(errors.count>0){
            self.userId = ""
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }else{
            currentUser.recentActivity = listRecentActivity
        }
        
    }
    
    func getTypeSport() -> String {
        if self.sportType != SportType.ND {
            return "\(self.sportType)"
        }
        return SPORT_TYPE_ND_DEFAULT_IMAGE
    }
    
    func getTypeSportImage() -> UIImage {
        return UIImage(named: self.getTypeSport())!
    }
    
    func getIVFromTypeSportImage() -> UIImageView {
        return UIImageView(image: getTypeSportImage())
    }
    
    var dateFormat : String {
        let date_custom = NSDate.date(fromString: self.date, format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
        let dateStr = date_custom!.toMediumDateString()
        
        if date_custom!.isToday() {
            return NSLocalizedString("Today", comment: "Today string")
        }else if date_custom!.isYesterday() {
            return NSLocalizedString("Yesterday", comment: "Yesterday string")
        }else if date_custom!.isThisWeek() {
            return dateStr
        }else{
            let weekdayName = date_custom!.weekdayName
            let day = date_custom!.day
            let monthName = date_custom!.monthName.lowercaseString
            let year = date_custom!.year
            let resDate = "\(weekdayName), \(day) \(monthName) \(year)"
            return resDate
        }
    }
    
    var isInit : Bool {
        return self.startLocation.location.coordinate.latitude != 0
    }
    
    var trainingAPIFormat : String {
        //var res = "{\"duration\":"354.45","distance":{"unit":"Km","value":"4154.05"}}
        
        var counter = laps.count
        var distance = 0.0
        if counter > 1 {
            distance = laps[0].startLocation.location.calculateDistanceBetweenTwoLocations(laps[counter-1].endLocation.location)
        }
        
        let dictionaryAux = ["unit": "m", "value": "\(distance)"]
        let dictionary = ["duration": self.duration, "distance": dictionaryAux]
        let theJSONData = NSJSONSerialization.dataWithJSONObject(
            dictionary ,
            options: NSJSONWritingOptions(0),
            error: nil)
        let res = NSString(data: theJSONData!,
            encoding: NSASCIIStringEncoding)
        
        return String(res!)
        //return dictionary as! Dictionary<String, String>
    }
    
    var trainingAPIFormatStr : String {
        var res = "" //var res = "{\"duration\":"354.45","distance":{"unit":"Km","value":"4154.05"}}
        
        var counter = laps.count
        var distance = 0.0
        if counter > 1 {
            distance = laps[0].startLocation.location.calculateDistanceBetweenTwoLocations(laps[counter-1].endLocation.location)
        }
        return "{\"duration\":\"\(self.duration)\",\"distance\":{\"unit\":\"m\",\"value\":\"\(distance)\"}}"
    }
    
    var lapsAPIFormat : [NSDictionary] {
        var res = [NSDictionary]()
        
        var lapsSortedArray = lapsSorted()
        for lap in lapsSortedArray {
            
            let distanceAPIFormat = ["unit": "\(lap.distance.unit)",
                "value": lap.distance.value]
            
            var latitude = "\(startLocation.location.coordinate.latitude)"
            var longitude = "\(startLocation.location.coordinate.longitude)"
            let startLap = ["lat": latitude,
                "lon": longitude]
            
            latitude = "\(endLocation.location.coordinate.latitude)"
            longitude = "\(endLocation.location.coordinate.longitude)"
            let endLap = ["lat": latitude,
                "lon": longitude]
            
            let locationAPIFormat = ["start": startLap,
                "end": endLap]
            
            var order = "\(lap.order)"
            var duration = lap.durationLap
            var locality = self.startLocation.locality
            var country = self.startLocation.country
            
            var altitudeAux = "\(self.endLocation.location.altitude - self.startLocation.location.altitude)"
            var altitude = altitudeAux
            
            var horizontalAccuracyAux = "\(self.endLocation.location.horizontalAccuracy - self.startLocation.location.horizontalAccuracy)"
            var horizontalAccuracy = horizontalAccuracyAux
            
            var verticalAccuracyAux = "\(self.endLocation.location.verticalAccuracy - self.startLocation.location.verticalAccuracy)"
            var verticalAccuracy = verticalAccuracyAux
            
            var speedAux = "\(lap.endLocation.location.speed)"
            var speed = speedAux
            
            var courseAux = "\(lap.endLocation.location.course)"
            var course = courseAux
            var name = lap.endLocation.name
            var distance = distanceAPIFormat
            var location = locationAPIFormat
            
            let heightAPIFormat = ["gain": "\(lap.height.gain)",
                "lost": "\(lap.height.lost)"]
            
            let dictionary = ["order": order,
                "duration": duration,
                "locality": locality,
                "country": country,
                "altitude": altitude,
                "horizontalAccurancy": horizontalAccuracy,
                "verticalAccurancy": verticalAccuracy,
                "speed": speed,
                "course": course,
                "name": name,
                "distance": distanceAPIFormat,
                "location": locationAPIFormat,
                "height":heightAPIFormat]
            
            res.append(dictionary)
        }
        
        
        return res
    }
    
    var lapsAPIFormatString : String {
        var res = ""
        
        var lapsSortedArray = lapsSorted()
        var index = 0
        for lap in lapsSortedArray {
            
            var order = "\(lap.order)"
            var duration = "\(lap.duration.value)"
            var country = "\(lap.startLocation.country)"
            var altitude = "\(self.endLocation.location.altitude - self.startLocation.location.altitude)"
            var horizontalAccurancy = "\(self.endLocation.location.horizontalAccuracy - self.startLocation.location.horizontalAccuracy)"
            var verticalAccurancy = "\(self.endLocation.location.verticalAccuracy - self.startLocation.location.verticalAccuracy)"
            var speed = "\(lap.endLocation.location.speed)"
            var course = "\(lap.endLocation.location.course)"
            var name = lap.endLocation.name
            var unitDistance = "\(lap.distance.unit)"
            var valueDistance = lap.distance.value
            var startLat = "\(startLocation.location.coordinate.latitude)"
            var startLon = "\(startLocation.location.coordinate.longitude)"
            var endLat = "\(endLocation.location.coordinate.latitude)"
            var endLon = "\(endLocation.location.coordinate.longitude)"
            var gain = "\(lap.height.gain)"
            var lost = "\(lap.height.lost)"
            
            res = res + "{\"height\": {\"gain\": \"\(gain)\",\"lost\": \"\(lost)\"},\"order\": \"\(order)\",\"duration\": \"\(duration)\", \"locality\": \"\(duration)\",\"country\":\"\(country)\",\"altitude\": \"\(altitude)\",\"horizontalAccurancy\": \"\(horizontalAccurancy)\",\"verticalAccurancy\": \"\(verticalAccurancy)\",\"speed\": \"\(speed)\",\"course\": \"\(course)\",\"name\": \"\(name)\",\"distance\": {\"unit\": \"\(unitDistance)\",\"value\": \"\(valueDistance)\"},\"location\": {\"start\": {\"lat\": \"\(startLat)\",\"lon\": \"\(startLon)\"},\"end\": {\"lat\": \"\(endLat)\",\"lon\": \"\(endLon)\"}}}"
            
            if index == laps.count - 1 {
            
            }else{
                res = res + ","
            }
            index++
            
            
        }
        
        
        return "[" + res + "]"
    }
    
    var hasLaps : Bool {
        return laps.count > 0
    }
    
    var hasComments : Bool {
        return comments.count > 0
    }
    
    var distanceWithUnit : String {
        return self.distance + " " + self.distanceUnit
    }
    
    var paceWithUnit : String {
        return self.pace + " " + self.paceUnit
    }
    
    var ppm : String {
        return "151"
    }
    
    var calory : String {
        return "317"
    }
    
    
}
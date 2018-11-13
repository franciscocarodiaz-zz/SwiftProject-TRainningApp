//
//  LapMethods.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

extension KYLap{
    
    convenience init(listLapData: JSON) {
        self.init()
        var errors = [String]()
        var listLap = [KYLap]()
        
        for item in listLapData.arrayValue {
            var newLap = KYLap(item)
            
            listLap.append(newLap)
        }
        
        if(errors.count>0){
            
        }else{
            currentActivity.laps = listLap
        }
        
    }
    
    convenience init(_ dictionary: JSON) {
        self.init()
        var errors = [String]()
        
        for (key,value) in dictionary{
            switch key {
            case LAP_PARAMS_ID:
                self._id = dictionary[LAP_PARAMS_ID].string!
            case LAP_PARAMS_SORT:
                if let arraySort = dictionary[LAP_PARAMS_SORT].array {
                    if arraySort.count > 0 {
                        self.order = arraySort.first!.int!
                    }
                }
            case LAP_PARAMS_FIELDS:
                if let arrayLaps = value[LAP_PARAMS_FIELDS_LAP].array {
                    if arrayLaps.count > 0 {
                        if let item = arrayLaps.first?.dictionaryObject {
                            for (keyItem,valueItem) in item {
                                switch keyItem {
                                case LAP_PARAMS_FIELDS_LAP_TOTAL_ASC:
                                    self.totalAscent = valueItem as! Int
                                case LAP_PARAMS_FIELDS_LAP_TOTAL_DESC:
                                    self.totalDescent = valueItem as! Int
                                case LAP_PARAMS_FIELDS_LAP_AVG_HEART:
                                    self.avgHeartRate = valueItem as! Int
                                case LAP_PARAMS_FIELDS_LAP_TIME:
                                    self.totalTimerTime = valueItem as! Double
                                case LAP_PARAMS_FIELDS_LAP_DISTANCE:
                                    self.totalDistance = valueItem as! Double
                                case LAP_PARAMS_FIELDS_LAP_AVG_SPEED:
                                    self.avgSpeed = valueItem as! Double
                                case LAP_PARAMS_FIELDS_LAP_START_POSITION:
                                    var lat = valueItem["lat"] as! String
                                    //var latDouble = lat.toDouble()
                                    var latDouble = (lat as NSString).doubleValue
                                    var lng = valueItem["lon"] as! String
                                    var lngDouble = (lng as NSString).doubleValue
                                    
                                    var coord = CLLocationCoordinate2DMake(latDouble, lngDouble)
                                    var loc = CLLocation(latitude: latDouble, longitude: lngDouble)
                                    self.startLocation = KYLocation(location: loc, locality:"", country:"", state:"", duration: "", name:"")
                                    
                                case LAP_PARAMS_FIELDS_LAP_END_POSITION:
                                    var lat = valueItem["lat"] as! String
                                    var latDouble = (lat as NSString).doubleValue
                                    var lng = valueItem["lon"] as! String
                                    var lngDouble = (lng as NSString).doubleValue
                                    
                                    var coord = CLLocationCoordinate2DMake(latDouble, lngDouble)
                                    var loc = CLLocation(latitude: latDouble, longitude: lngDouble)
                                    self.endLocation = KYLocation(location: loc, locality:"", country:"", state:"", duration: "", name:"")
                                default:
                                    print("KYLap: No key " + keyItem)
                                }
                            }
                        }
                    }
                }
                
            default:
                print("KYLap: No key " + key + " recognized for user object model.")
            }
            
        }
        
    }
    
    var altimetry : Int {
    
        if totalAscent == 0 && totalDescent == 0 {
            return 0
        }
        
        if totalAscent != 0 && totalDescent == 0 {
            return totalAscent
        }
        
        if totalAscent == 0 && totalDescent != 0 {
            return -totalDescent
        }
        
        return totalAscent-totalDescent
        
    
    }
}
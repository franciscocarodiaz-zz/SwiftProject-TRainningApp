//
//  KYLap.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 27/08/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import CoreLocation

class KYLap{
    
    var order:Int = 0
    var _id : String = ""
    var totalTimerTime:Double = 0
    var totalDistance:Double = 0
    var avgSpeed:Double = 0
    
    var totalAscent : Int = 0
    var totalDescent : Int = 0
    var avgHeartRate : Int = 0
    
    var height = KYHeight(gain: 0,lost: 0)
    
    var startLocation: KYLocation
    var endLocation: KYLocation
    var distance : UnitValue{
        get{
            return UnitValue(unit:distanceUnit, value:distanceLap)
        }
        set{}
    }
    
    var distanceFormatted : String {
        
        var unit = "km"
        var value = distance.value
        
        return "\(value) \(unit)"
    }
    
    var duration : UnitValue{
        get{
            return UnitValue(unit:"sec", value:durationLap)
        }
        set{}
    }
    
    var durationFormatted : String{
        return "\(duration.value) \(duration.unit)"
    }
    
    var distanceUnit = "m"
    
    init(){
        self.order = 0
        let today = NSDate.today()
        var coord = CLLocationCoordinate2DMake(0, 0)
        var loc = CLLocation(coordinate: coord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: today)
        self.startLocation = KYLOC_DEFAULT
        self.endLocation = KYLOC_DEFAULT
        self.distance = UnitValue(unit:distanceUnit, value:"")
    }
    
    convenience init(order: Int, locality:String, country:String, altitude:Double, horizontalAccurancy:Double, verticalAccurancy:Double, speed:Double, course:Double, timestamp: NSDate, name:String, duration: String, distanceUnit dUnit: String, distanceValue dValue: String, locationStartLatitude locStartLat: Double, locationStartLongitude locStartLon: Double, locationEndLatitude locEndLat: Double, locationEndLongitude locEndLon: Double){
        
        self.init()
        
        self.order = order
        self.startLocation = KYLocation(location: CLLocation(), locality:locality, country:country, state:"", duration: duration, name:"")
        
        self.endLocation = KYLocation(location: CLLocation(), locality:locality, country:country, state:"", duration: duration, name:"")
        if locEndLat == 0.0 && locEndLon == 0.0 {
            var coord = CLLocationCoordinate2DMake(locStartLat, locStartLon)
            var loc = CLLocation(coordinate: coord, altitude: altitude, horizontalAccuracy: horizontalAccurancy, verticalAccuracy: verticalAccurancy, course: course, speed: speed, timestamp: timestamp)
            self.startLocation = KYLocation(location: loc, locality:locality, country:country, state:"", duration: duration, name:"")
            self.endLocation = KYLocation(location: CLLocation(), locality:locality, country:country, state:"", duration: duration, name:"")
        }else{
            var coord = CLLocationCoordinate2DMake(locStartLat, locStartLon)
            var loc = CLLocation(coordinate: coord, altitude: altitude, horizontalAccuracy: horizontalAccurancy, verticalAccuracy: verticalAccurancy, course: course, speed: speed, timestamp: timestamp)
            self.startLocation = KYLocation(location: loc, locality:locality, country:country, state:"", duration: duration, name:"")
            
            coord = CLLocationCoordinate2DMake(locEndLat, locEndLon)
            loc = CLLocation(coordinate: coord, altitude: altitude, horizontalAccuracy: horizontalAccurancy, verticalAccuracy: verticalAccurancy, course: course, speed: speed, timestamp: timestamp)
            self.endLocation = KYLocation(location: loc, locality:locality, country:country, state:"", duration: duration, name:"")
        }
        self.distance = UnitValue(unit:"km", value: distanceLap)
        
    }
    
    func calculateDistanceLap() -> String {
        var dst = "0.0"
        if endLocation.location.coordinate.latitude != 0.0 && endLocation.location.coordinate.longitude != 0.0 {
            dst = "\(startLocation.location.calculateDistanceBetweenTwoLocations(endLocation.location))"
        }
        return dst
    }
    
    var distanceLap: String { return calculateDistanceLap() }
    
    func customDescription() -> String {
        return self.startLocation.locality + ", " + self.startLocation.country
    }
    
    var description: String { return customDescription() }
    
    func generateLapDictionary() -> Dictionary<String,String>{
        var newLap: Dictionary<String,String> = Dictionary<String,String>()
        
        /*
        newLap["duration"] = self.duration.toString(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
        newLap["distanceUnit"] = self.distance.unit
        newLap["distanceValue"] = self.distance.value
        newLap["locationStartLatitude"] = "\(self.startLocation.coordinate.latitude)"
        newLap["locationStartLongitude"] = "\(self.startLocation.coordinate.longitude)"
        newLap["locationEndLatitude"] = "\(self.endLocation.coordinate.latitude)"
        newLap["locationEndLongitude"] = "\(self.endLocation.coordinate.latitude)"
        */
        
        return newLap
    }
    
    func lapFinish() -> Bool{
        return self.endLocation.location.coordinate.latitude == 0 && self.endLocation.location.coordinate.longitude == 0
    }
    
    func addLocationEnd(locality:String, country:String, altitude:Double, horizontalAccurancy:Double, verticalAccurancy:Double, speed:Double, course:Double, name:String, duration: String, timestamp: NSDate, latitude: Double, longitude: Double) -> KYLap{
        var coord = CLLocationCoordinate2DMake(latitude, longitude)
        var loc = CLLocation(coordinate: coord, altitude: altitude, horizontalAccuracy: horizontalAccurancy, verticalAccuracy: verticalAccurancy, course: course, speed: speed, timestamp: timestamp)
        self.endLocation = KYLocation(location: loc, locality:locality, country:country, state:"", duration: duration, name:"")
        return self
    }
    
    func addLocationStart(locality:String, country:String, altitude:Double, horizontalAccurancy:Double, verticalAccurancy:Double, speed:Double, course:Double, name:String, duration: String, timestamp: NSDate, latitude: Double, longitude: Double) -> KYLap{
        var coord = CLLocationCoordinate2DMake(latitude, longitude)
        var loc = CLLocation(coordinate: coord, altitude: altitude, horizontalAccuracy: horizontalAccurancy, verticalAccuracy: verticalAccurancy, course: course, speed: speed, timestamp: timestamp)
        self.startLocation = KYLocation(location: loc, locality:locality, country:country, state:"", duration: duration, name:"")
        return self
    }
    
    func differenceWithCurrentPosition(latitude: Double, longitude: Double) -> Double {
        var currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        var diff = self.startLocation.location.calculateDistanceBetweenTwoLocations(currentLocation)
        return diff
    }
    
    var durationLap : String {
        var res = ""
        
        let start = startLocation.location.timestamp
        let enddt = endLocation.location.timestamp
        let calendar = NSCalendar.currentCalendar()
        let datecomponenets = calendar.components(NSCalendarUnit.CalendarUnitSecond, fromDate: start, toDate: enddt, options: nil)
        let diffSeconds = datecomponenets.second
        
        return String(diffSeconds)
    }
    
    var averageSpeed : String {
        var sumSpeed = startLocation.location.speed + endLocation.location.speed
        var speed = (sumSpeed / 2.0)
        return "\(speed.roundedTwoDigit) km/h"
    }
    
}
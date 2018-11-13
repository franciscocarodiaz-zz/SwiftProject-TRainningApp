//
//  KYActivity.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import UIKit

class KYActivity : NSObject {
    
    var userId:String
    var activityId:String
    var activityName:String
    
    var userPicture:String
    var name:String
    var surname:String
    var date:String
    var sportType:SportType 
    var duration: String
    var distance:String
    var distanceUnit:String
    var pace: String
    var paceUnit: String
    var bpm: String
    var heightGain: String
    var heightLost: String
    var creator: String
    var created:String
    var time:String
    var velocity:String
    var altitude : Double = 0
    var height : KYHeight = KYHeight(gain:0, lost:0)
    
    var startLocation : KYLocation = KYLOC_DEFAULT
    var endLocation : KYLocation = KYLOC_DEFAULT
    
    var comments : Array<KYComment> = Array<KYComment>()
    
    var laps : Array<KYLap> = Array<KYLap>()
    func lapsSorted() -> Array<KYLap>{
        return self.laps.sorted({ $0.order < $1.order })
    }
    
    func velocityArrayLapsSorted() -> [Double]{
        var auxLaps = self.laps.sorted({ $0.order < $1.order })
        var res = [Double]()
        for item in auxLaps {
            res.append(item.avgSpeed)
        }
        return res
    }
    
    func altimetryArrayLapsSorted() -> [Int]{
        var auxLaps = self.laps.sorted({ $0.order < $1.order })
        var res = [Int]()
        for item in auxLaps {
            res.append(item.altimetry)
        }
        return res
    }
    
    func avgHeartRateArrayLapsSorted() -> [Int]{
        var auxLaps = self.laps.sorted({ $0.order < $1.order })
        var res = [Int]()
        for item in auxLaps {
            res.append(item.avgHeartRate)
        }
        return res
    }
    
    override init(){
        self.activityId = "0"
        let today = NSDate.today()
        self.activityName = today.toShortString()
        self.userPicture = ""
        self.userId = "0"
        self.name = ""
        self.surname = ""
        self.date = today.toString(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
        self.sportType = SportType.ND
        self.duration = "0"
        self.distance = "0"
        self.distanceUnit = "Km"
        self.pace = "0"
        self.paceUnit = "min/km"
        self.bpm = "0"
        self.heightGain = "0"
        self.heightLost = "0"
        self.creator = "0"
        self.time = "0"
        self.velocity = "0"
        self.created = today.toString(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
    }
    
    func customDescription() -> String {
        return self.date + ", " + self.name + " " + self.surname + ", " + self.time + ", " + self.distance + self.distanceUnit + ", " + self.velocity
    }
    
    override var description: String { return customDescription() }
    
    var userFullnameActivity: String {
        return self.name + " " + self.surname
    }
    
    var activityInfo: String {
        return "\(self.activityName), \(self.time), \(self.distance) \(self.distanceUnit), \(self.pace) \(self.paceUnit)"
    }
    
    var lastLap : KYLap {
        var lap = KYLap()
        if self.laps.count > 0 {
            var lapsSortedArray = Array<KYLap>()
            lapsSortedArray = lapsSorted()
            var lastLapSorted = lapsSortedArray.last!
            lap = lastLapSorted
        }
        return lap
    }
    
    var firstLap : KYLap {
        var lap = KYLap()
        if self.laps.count > 0 {
            var lapsSortedArray = Array<KYLap>()
            lapsSortedArray = lapsSorted()
            var lastLapSorted = lapsSortedArray.first!
            lap = lastLapSorted
        }
        return lap
    }
    
    func differenceBetweenCurrentPositionAndFirstLap(latitude: Double, longitude: Double) -> Double {
        var lap = KYLap()
        var diff = 0.0
        if self.laps.count > 0 {
            diff = firstLap.differenceWithCurrentPosition(latitude,longitude:longitude)
        }
        return diff
    }
    
    func differenceBetweenCurrentPositionAndStartLocationOfCurrentLap(latitude: Double, longitude: Double) -> Double {
        var lap = KYLap()
        var diff = 0.0
        if self.laps.count > 0 {
            diff = lastLap.differenceWithCurrentPosition(latitude,longitude:longitude)
        }
        return diff
    }
    
    func addEndLocationToLastLap(course: Double, locality: String, country: String, duration: String, dValue: String, altitude: Double, horizontalAccuracy: Double, verticalAccuracy: Double, speed: Double, timestamp: NSDate, name: String, locLat: Double, locLon: Double) -> KYLap{
        
        //var durationDate = duration.toDate(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))!
        var lastLapAux = lastLap.addLocationEnd(locality, country: country, altitude: altitude, horizontalAccurancy: horizontalAccuracy, verticalAccurancy: verticalAccuracy, speed: speed, course: course, name: name, duration: duration, timestamp:timestamp, latitude: locLat, longitude: locLon)
        return lastLapAux
        //self.refreshLap(lastLapAux)
    }
    
    func addStartLocation(course: Double, locality: String, country: String, duration: String, dValue: String, altitude: Double, horizontalAccuracy: Double, verticalAccuracy: Double, speed: Double, timestamp: NSDate, name: String, locLat: Double, locLon: Double) -> KYLap{
        
        //var durationDate = timestamp.toLongDateString().toDate(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))!
        var lastLapAux = lastLap.addLocationStart(locality, country: country, altitude: altitude, horizontalAccurancy: horizontalAccuracy, verticalAccurancy: verticalAccuracy, speed: speed, course: course, name: name, duration: duration, timestamp: timestamp, latitude: locLat, longitude: locLon)
        return lastLapAux
        //self.refreshLap(lastLapAux)
    }
    
    func refreshLap(lap: KYLap){
        var lapsAux : Array<KYLap> = Array<KYLap>()
        for lapItem in self.laps {
            if lap.order == lapItem.order {
                lapsAux.append(lap)
            }else{
                lapsAux.append(lapItem)
            }
        }
        self.laps = lapsAux
    }
    
    func addNewLap(lap: KYLap){
        lap.height = height
        height = KYHeight(gain:0, lost:0)
        laps.append(lap)
    }
    
    
    
}

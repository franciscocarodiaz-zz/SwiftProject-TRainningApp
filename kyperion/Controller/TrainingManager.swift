//
//  TrainingManager.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation

@objc protocol trainingManagerDelegate:NSObjectProtocol {
    
    optional func StartTracking()
    optional func StopTracking()
    
    optional func CurrentLocation(userInfo :[NSObject : AnyObject])
    
    optional func TraickingNotAuthorized(msgError: String)
}

class TrainingManager: NSObject, trainingManagerDelegate, CLLocationManagerDelegate {
    
    var delegate: trainingManagerDelegate?
    var manager: Manager?
    var managerUser: Manager?
    
    var locationManager:CLLocationManager = CLLocationManager()
    var tag : Int = 0
    var CORE_LOC_TAG_ONE_TIME = 0
    var CORE_LOC_TAG_ALWAYS = 1
    var stopTrackingManager = false
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.activityType = CLActivityType.Fitness
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            self.delegate?.TraickingNotAuthorized!("Status: NotDetermined")
            break
            
        case .AuthorizedWhenInUse:
            println(".AuthorizedWhenInUse")
            //self.locationManager.startUpdatingLocation()
            startTracking()
            break
            
        case .AuthorizedAlways:
            println(".AuthorizedAlways")
            //self.locationManager.startUpdatingLocation()
            startTracking()
            break
            
        case .Denied:
            self.delegate?.TraickingNotAuthorized!("Status: Denied")
            break
            
        default:
            self.delegate?.TraickingNotAuthorized!("Status: Unhandled authorization status")
            break
            
        }
    }
    
    func enableFilterNone(){
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startTracking(){
        stopTrackingManager = false
        self.locationManager.startUpdatingLocation()
    }
    
    func stopTracking(){
        stopTrackingManager = true
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.last as! CLLocation
        TrackManager.sharedManager.addLocation(location)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
            if let error = e {
                println("Error:  \(e.localizedDescription)")
            } else {
                
                let defaultDouble : Double = 0.0
                let defaultString : String = ""
                
                let placemark = placemarks.last as! CLPlacemark
                let locality = (placemark.locality != nil) ? placemark.locality : defaultString
                let state = (placemark.administrativeArea != nil) ? placemark.administrativeArea : defaultString
                let country = (placemark.country != nil) ? placemark.country : defaultString
                let altitude = placemark.location.altitude
                let latitude = placemark.location.coordinate.latitude
                let longitude = placemark.location.coordinate.longitude
                let horizontalAccuracy = placemark.location.horizontalAccuracy
                let verticalAccuracy = placemark.location.verticalAccuracy
                let speed = placemark.location.speed
                let timestamp = placemark.location.timestamp
                let course = placemark.location.course
                let name = (placemark.name != nil) ? placemark.name : ""
                
                let userInfo :[NSObject : AnyObject] = [
                    "locality": locality,
                    "state": state,
                    "country":  country,
                    "altitude":  altitude,
                    "latitude":  latitude,
                    "longitude":  longitude,
                    "horizontalAccuracy":  horizontalAccuracy,
                    "verticalAccuracy":  verticalAccuracy,
                    "speed":  speed,
                    "timestamp":  timestamp,
                    "course":  course,
                    "name":  name
                ]
                
                let today = NSDate.today()
                var coord = CLLocationCoordinate2DMake(latitude, longitude)
                var loc = CLLocation(coordinate: coord, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, speed: speed, timestamp: timestamp)
                let kylocation = KYLocation(location: loc, locality:locality, country:country, state:state, duration: "0", name: name)
                
                if !currentActivity.isInit {
                    
                    currentActivity.startLocation = kylocation
                    self.delegate?.StartTracking!()
                
                }else{
                    
                    if self.stopTrackingManager {
                        self.locationManager.stopUpdatingLocation()
                        currentActivity.endLocation = kylocation
                        self.delegate?.StopTracking!()
                    }else{
                        currentActivity.endLocation = kylocation
                        
                        var latitude = kylocation.location.coordinate.latitude
                        var longitude = kylocation.location.coordinate.longitude
                        var differenceBetweenCurrentPositionAndFirstLap = currentActivity.differenceBetweenCurrentPositionAndFirstLap(latitude, longitude: longitude)
                        var differenceBetweenCurrentPositionAndStartLocationOfCurrentLap = currentActivity.differenceBetweenCurrentPositionAndStartLocationOfCurrentLap(latitude, longitude: longitude)
                        var userInfo :[NSObject : AnyObject] = [
                            "differenceBetweenCurrentPositionAndFirstLap": differenceBetweenCurrentPositionAndFirstLap.roundedTwoDigit,
                            "differenceBetweenCurrentPositionAndStartLocationOfCurrentLap": differenceBetweenCurrentPositionAndStartLocationOfCurrentLap.roundedTwoDigit
                        ]
                        
                        self.delegate?.CurrentLocation!(userInfo)
                    }
                    
                }
                
                //NSNotificationCenter.defaultCenter().postNotificationName("LOCATION_AVAILABLE", object: nil, userInfo: userInfo)
            }
        })
        
        /*
        if tag == CORE_LOC_TAG_FINISH {
            var latitude = location.coordinate.latitude
            var longitude = location.coordinate.longitude
            var differenceBetweenCurrentPositionAndFirstLap = currentActivity.differenceBetweenCurrentPositionAndFirstLap(latitude, longitude: longitude)
            var differenceBetweenCurrentPositionAndStartLocationOfCurrentLap = currentActivity.differenceBetweenCurrentPositionAndStartLocationOfCurrentLap(latitude, longitude: longitude)
            var userInfo :[NSObject : AnyObject] = [
                "differenceBetweenCurrentPositionAndFirstLap": differenceBetweenCurrentPositionAndFirstLap.roundedTwoDigit,
                "differenceBetweenCurrentPositionAndStartLocationOfCurrentLap": differenceBetweenCurrentPositionAndStartLocationOfCurrentLap.roundedTwoDigit
            ]
            
            NSNotificationCenter.defaultCenter().postNotificationName("DATA_LOCATION_FINISH", object: nil, userInfo: userInfo)
            
        }else if tag == CORE_LOC_TAG_DATA {
            println("\n locationManager:  DATA INFO")
            var latitude = location.coordinate.latitude
            var longitude = location.coordinate.longitude
            var differenceBetweenCurrentPositionAndFirstLap = currentActivity.differenceBetweenCurrentPositionAndFirstLap(latitude, longitude: longitude)
            var differenceBetweenCurrentPositionAndStartLocationOfCurrentLap = currentActivity.differenceBetweenCurrentPositionAndStartLocationOfCurrentLap(latitude, longitude: longitude)
            var userInfo :[NSObject : AnyObject] = [
                "differenceBetweenCurrentPositionAndFirstLap": differenceBetweenCurrentPositionAndFirstLap.roundedTwoDigit,
                "differenceBetweenCurrentPositionAndStartLocationOfCurrentLap": differenceBetweenCurrentPositionAndStartLocationOfCurrentLap.roundedTwoDigit
            ]
            
            NSNotificationCenter.defaultCenter().postNotificationName("DATA_LOCATION_AVAILABLE", object: nil, userInfo: userInfo)
            
        }else if tag == CORE_LOC_TAG_FILTER {
            
            println("\n locationManager:  FILTER INFO")
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
                if let error = e {
                    println("Error:  \(e.localizedDescription)")
                } else {
                    
                    let defaultDouble : Double = 0.0
                    let defaultString : String = ""
                    
                    let placemark = placemarks.last as! CLPlacemark
                    let locality = (placemark.locality != nil) ? placemark.locality : defaultString
                    let state = (placemark.administrativeArea != nil) ? placemark.administrativeArea : defaultString
                    let country = (placemark.country != nil) ? placemark.country : defaultString
                    let altitude = placemark.location.altitude
                    let latitude = placemark.location.coordinate.latitude
                    let longitude = placemark.location.coordinate.longitude
                    let horizontalAccuracy = placemark.location.horizontalAccuracy
                    let verticalAccuracy = placemark.location.verticalAccuracy
                    let speed = placemark.location.speed
                    let timestamp = placemark.location.timestamp
                    let course = placemark.location.course
                    let name = (placemark.name != nil) ? placemark.name : ""
                    
                    var distanceAux = 0.0
                    var aLocations = TrackManager.sharedManager.arrayLocations
                    if aLocations.count > 1 {
                        let firstLocation = aLocations.first!
                        distanceAux = firstLocation.calculateDistanceBetweenTwoLocations(placemark.location)
                    }
                    let distance = distanceAux
                    
                    let userInfo :[NSObject : AnyObject] = [
                        "locality": locality,
                        "state": state,
                        "country":  country,
                        "altitude":  altitude,
                        "latitude":  latitude,
                        "longitude":  longitude,
                        "horizontalAccuracy":  horizontalAccuracy,
                        "verticalAccuracy":  verticalAccuracy,
                        "speed":  speed,
                        "timestamp":  timestamp,
                        "course":  course,
                        "name":  name,
                        "distance": distance
                    ]
                    
                    println("Location:  \(userInfo)")
                    NSNotificationCenter.defaultCenter().postNotificationName("LOCATION_AVAILABLE", object: nil, userInfo: userInfo)
                }
            })
        }
        */
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    
}

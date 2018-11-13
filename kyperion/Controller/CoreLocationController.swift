//
//  CoreLocationController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 26/08/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationController : NSObject, CLLocationManagerDelegate {
 
    var locationManager:CLLocationManager = CLLocationManager()
    var tag : Int = 0
    var CORE_LOC_TAG_DATA = 0
    var CORE_LOC_TAG_FILTER = 1
    var CORE_LOC_TAG_FINISH = 2
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.activityType = CLActivityType.Fitness
        
        //self.locationManager.distanceFilter  = 1000 // Must move at least 1km by default
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Accurate within a kilometer
    }
    
    func enableFilterNone(){
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            println(".NotDetermined")
            break
            
        case .AuthorizedWhenInUse:
            println(".AuthorizedWhenInUse")
            self.locationManager.startUpdatingLocation()
            break
            
        case .AuthorizedAlways:
            println(".AuthorizedAlways")
            self.locationManager.startUpdatingLocation()
            break
            
        case .Denied:
            println(".Denied")
            break
            
        default:
            println("Unhandled authorization status")
            break
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.last as! CLLocation
        TrackManager.sharedManager.addLocation(location)
        
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
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func finishTracking(){
        tag = CORE_LOC_TAG_FINISH
        self.locationManager.startUpdatingLocation()
    }
    
    
}
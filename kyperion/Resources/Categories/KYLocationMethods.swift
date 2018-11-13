//
//  KYLocationMethods.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 27/08/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    func calculateDistanceBetweenTwoLocations(destination:CLLocation) -> Double{
        var distanceMeters = self.distanceFromLocation(destination)
        var distanceKM = distanceMeters / 1000
        let roundedTwoDigit = distanceKM.roundedTwoDigit
        return roundedTwoDigit
    }
    
    func calculateDistanceBetweenTwoLocationsInMeters(destination:CLLocation) -> Double{
        var distanceMeters = self.distanceFromLocation(destination)
        let roundedTwoDigit = distanceMeters.roundedTwoDigit
        return roundedTwoDigit
    }
}
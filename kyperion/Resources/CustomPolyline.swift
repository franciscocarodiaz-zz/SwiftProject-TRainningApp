//
//  CustomPolyline.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import MapKit

class CustomPolyline : MKPolyline {
    var coordinates: UnsafeMutablePointer<CLLocationCoordinate2D>
    var count : Int = 0
    var color : String = "ff0000"
    init(coordinates: UnsafeMutablePointer<CLLocationCoordinate2D>, newCount: Int) {
        
        self.coordinates = coordinates
        
        self.count = newCount
    }
}

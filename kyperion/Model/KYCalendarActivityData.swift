//
//  KYCalendarActivityData.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import UIKit

class KYCalendarActivityData : NSObject {
    
    var id:String
    var activityName:String
    var pace:String
    var paceUnit:String
    var heightUnit:String
    var heightLost:String
    var heightGain:String
    var date:String
    var creator:String
    var bpm:String
    var created:String
    var duration:String
    var distance:String
    var distanceUnit:String
    var sportType:SportType
    
    override init(){
        self.id = ""
        self.activityName = ""
        self.pace = ""
        self.paceUnit = "min/km"
        self.heightUnit = "m"
        self.heightLost = ""
        self.heightGain = ""
        let today = NSDate.today()
        self.date = today.toString(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
        self.creator = ""
        self.bpm = ""
        self.created = today.toString(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY_EXTEND))
        self.duration = ""
        self.distance = ""
        self.distanceUnit = "Km"
        self.sportType = SportType.ND
    }
    
    func getDateCreated()->NSDate{
        return created.toDate(formatString: DATE_FORMAT_ACTIVITY_EXTEND)!
    }
    
    func getDate()->NSDate{
        return date.toDate(formatString: DATE_FORMAT_ACTIVITY)!
    }
    
    func customDescription() -> String {
        return self.id + ", " + self.activityName
    }
    
    override var description: String { return customDescription() }
    
    
}
//
//  KYCalendarEvent.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import UIKit


class KYCalendarEvent : NSObject {
    
    var id:String
    var assignedUser:KYUser
    var eventType:EventType
    var sportType:SportType
    var activityData:KYCalendarActivityData
    var completed:Bool
    var trainingPlanData:KYTrainingPlan
    var title:String
    var date:String
    var duration: String
    var distance:String
    var pace: String
    
    override init(){
        self.id = "0"
        self.assignedUser = KYUser()
        self.eventType = EventType.ND
        self.sportType = SportType.ND
        self.activityData = KYCalendarActivityData()
        self.completed = false
        self.trainingPlanData = KYTrainingPlan()
        self.title = "0"
        let today = NSDate.today()
        self.date = today.toString(format: DateFormat.Custom(DATE_FORMAT))
        self.duration = "0"
        self.distance = "0"
        self.pace = "0"
    }
    
    func getDate()->NSDate{
        return date.toDate(formatString: DATE_FORMAT)!
    }
    
    func customDescription() -> String {
        return self.id + ", " + self.title + ", " + self.date + ", " + self.duration + ", " + self.distance
    }
    
    override var description: String { return customDescription() }
    
}

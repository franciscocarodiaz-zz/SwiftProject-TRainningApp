//
//  KYCalendarEventMethods.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import SwiftyJSON

extension KYCalendarEvent{
    
    convenience init(_ dictionary: JSON) {
        self.init()
        //var errors = [String]()
        
        for (key,value) in dictionary{
            switch key {
                case CALENDAR_EVENT_PARAM_ID:
                    self.id = "\(dictionary[CALENDAR_EVENT_PARAM_ID])"
                case CALENDAR_EVENT_PARAM_ASSIGNED_USER:
                    self.assignedUser = KYUser(dictionary[CALENDAR_EVENT_PARAM_ASSIGNED_USER])
                case CALENDAR_EVENT_PARAM_EVENT_TYPE:
                    if value.string == EVENTTYPE_ACTIVITY {
                        self.eventType = EventType.ACTIVITY
                    }else{
                        self.eventType = EventType.TRAININGPLAN
                    }
                case CALENDAR_EVENT_PARAM_SPORT_TYPE:
                    if value.string == SPORT_TYPE_CYCLING {
                        self.sportType = SportType.CYCLING
                    }else if value.string == SPORT_TYPE_GYM {
                        self.sportType = SportType.GYM
                    }else if value.string == SPORT_TYPE_RUNNING {
                        self.sportType = SportType.RUNNING
                    }else if value.string == SPORT_TYPE_SWIMMING {
                        self.sportType = SportType.SWIMMING
                    }
                case CALENDAR_EVENT_PARAM_ACTIVITY_DATA:
                    self.activityData = KYCalendarActivityData(dictionary[CALENDAR_EVENT_PARAM_ACTIVITY_DATA])
                case CALENDAR_EVENT_PARAM_COMPLETED:
                    if let completed = dictionary[CALENDAR_EVENT_PARAM_COMPLETED].bool {
                        self.completed = completed
                    }
                case CALENDAR_EVENT_PARAM_TRAINING_PLAN_DATA:
                    self.trainingPlanData = KYTrainingPlan(dictionary[CALENDAR_EVENT_PARAM_TRAINING_PLAN_DATA])
                case CALENDAR_EVENT_PARAM_TITLE:
                    if let title = dictionary[CALENDAR_EVENT_PARAM_TITLE].string {
                        self.title = title
                    }
                case CALENDAR_EVENT_PARAM_DATE:
                    if let date = dictionary[CALENDAR_EVENT_PARAM_DATE].string {
                        self.date = date
                    }
                case CALENDAR_EVENT_PARAM_DURATION:
                    if let duration = dictionary[CALENDAR_EVENT_PARAM_DURATION].string {
                        self.duration = duration
                    }
                case CALENDAR_EVENT_PARAM_DISTANCE:
                    if let distance = dictionary[CALENDAR_EVENT_PARAM_DISTANCE].string {
                        self.distance = distance
                    }
                case CALENDAR_EVENT_PARAM_PACE:
                    if let pace = dictionary[CALENDAR_EVENT_PARAM_PACE].string {
                        self.pace = pace
                    }
            default:
                print("KYCalendarEvent: No key " + key + " recognized for user object model.")
            }
        
        }
    }
    
    func getTypeSport() -> String {
        if self.sportType != SportType.ND {
            return "\(self.sportType)"
        }
        return SPORT_TYPE_ND_DEFAULT_IMAGE
    }
    
    func getTypeSportImage() -> UIImage {
        switch(self.eventType){
        case EventType.ACTIVITY:
            return UIImage(named: self.getTypeSport())!
        case EventType.TRAININGPLAN:
            let srtNameOfImage = "\(self.eventType).\(self.getTypeSport())"
            return UIImage(named: srtNameOfImage)!
        default:
            return UIImage(named: self.getTypeSport())!
            
        }
        
    }
    
    func getIVFromTypeSportImage() -> UIImageView {
        return UIImageView(image: getTypeSportImage())
    }
    
    var calendarEventDetailInfo: String {
        switch self.eventType {
        case .TRAININGPLAN:
            return trainingPlanDetailInfo
        case EventType.ACTIVITY:
            return activityDataDetailInfo
        default:
            return ""
        }
    }
    
    var eventTitle: String {
        switch self.eventType {
        case .TRAININGPLAN:
            return trainingPlanData.name
        case EventType.ACTIVITY:
            return title
        default:
            return ""
        }
        
    }
    
    
    var trainingPlanDetailInfo: String {
        let separator = " "
        let detail = self.trainingPlanData.name + separator + self.trainingPlanData.time
        if detail.length > separator.length {
            return detail
        }
        return NSLocalizedString("No data info", comment: "No data info message when table view is empty")
    }
    
    var activityDataDetailInfo: String {
        let separator = " "
        let detail = self.activityData.duration + separator + self.activityData.distance + separator + self.activityData.pace
        if detail.length > separator.length*2 {
            return detail
        }
        return NSLocalizedString("No data info", comment: "No data info message when table view is empty")
    }
    
    func getCalendarEventDetailInfo() -> String {
        return self.id + ", " + self.title + ", " + self.date + ", " + self.duration + ", " + self.distance
    }
    
    var dateFormat : String {
        let date_custom = NSDate.date(fromString: self.date, format: DateFormat.Custom(DATE_FORMAT))
        let dateStr = date_custom!.toMediumDateString()
        
        if date_custom!.isToday() {
            return NSLocalizedString("Today", comment: "Today string")
        }else if date_custom!.isYesterday() {
            return NSLocalizedString("Yesterday", comment: "Yesterday string")
        }else{
            let weekdayName = date_custom!.weekdayName
            let day = date_custom!.day
            let monthName = date_custom!.monthName.lowercaseString
            let year = date_custom!.year
            let resDate = "\(weekdayName), \(day) \(monthName) \(year)"
            return resDate
        }
    }
    
    class func getEvent(day: String, numberOfSelection: Int) -> KYCalendarEvent{
        var calendarEvent = KYCalendarEvent()
        for (key, value) in currentUser.calendarEventsForDayCalendar {
            if key == day {
                if numberOfSelection < value.count {
                    calendarEvent = value[numberOfSelection]
                }
            }
        }
        return calendarEvent
    }
    
    class func getNumberOfEvents(day: String) -> Int{
        for (key, value) in currentUser.calendarEventsForDayCalendar {
            if key == day {
                return value.count
            }
        }
        return 0
    }
    
    var isTP : Bool {
        return self.trainingPlanData.isTP
    }
    
}
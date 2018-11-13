//
//  CalendarActivityDataMethods.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import SwiftyJSON

extension KYCalendarActivityData{
    
    convenience init(_ dictionary: JSON) {
        self.init()
        for(key, value) in dictionary {
            switch key {
                
            case ACTIVITY_DATA_PARAM_ID:
                self.id = "\(dictionary[ACTIVITY_DATA_PARAM_ID])"
            case ACTIVITY_DATA_PARAM_ACTIVITY_NAME:
                self.activityName = dictionary[ACTIVITY_DATA_PARAM_ACTIVITY_NAME].string!
            case ACTIVITY_DATA_PARAM_PACE:
                self.pace = value[PARAM_VALUE].string!
                self.paceUnit = value[PARAM_UNIT].string!
            case ACTIVITY_DATA_PARAM_HEIGHT:
                self.heightUnit = value[PARAM_UNIT].string!
                self.heightLost = value[ACTIVITY_DATA_PARAM_HEIGHT_LOST].string!
                self.heightGain = value[ACTIVITY_DATA_PARAM_HEIGHT_GAIN].string!
            case ACTIVITY_DATA_PARAM_DISTANCE:
                self.distance = value[PARAM_VALUE].string!
                self.distanceUnit = value[PARAM_UNIT].string!
            case ACTIVITY_DATA_PARAM_DATE:
                self.date = dictionary[ACTIVITY_DATA_PARAM_DATE].string!
            case ACTIVITY_DATA_PARAM_CREATOR:
                self.creator = "\(dictionary[ACTIVITY_DATA_PARAM_CREATOR])"
            case ACTIVITY_DATA_PARAM_BPM:
                if let bpm = dictionary[ACTIVITY_DATA_PARAM_BPM].string {
                    self.bpm = bpm
                }
            case ACTIVITY_DATA_PARAM_CREATED:
                self.created = dictionary[ACTIVITY_DATA_PARAM_CREATED].string!
            case ACTIVITY_DATA_PARAM_DURATION:
                self.duration = dictionary[ACTIVITY_DATA_PARAM_DURATION].string!
            case ACTIVITY_DATA_PARAM_SPORT_TYPE:
                if value.string == SPORT_TYPE_CYCLING {
                    self.sportType = SportType.CYCLING
                }else if value.string == SPORT_TYPE_GYM {
                    self.sportType = SportType.GYM
                }else if value.string == SPORT_TYPE_RUNNING {
                    self.sportType = SportType.RUNNING
                }else if value.string == SPORT_TYPE_SWIMMING {
                    self.sportType = SportType.SWIMMING
                }
            default:
                print("KYCalendarActivityData: No key " + key + " recognized for user object model.")
            
            }
        }
        
        
    }
    
    var activityInfo: String {
        return "\(self.duration)   \(self.distance) \(self.distanceUnit)   \(self.pace) \(self.paceUnit)"
    }
    
    func getTypeSport() -> String {
        if self.sportType != SportType.ND {
            return "\(self.sportType)"
        }
        return SPORT_TYPE_ND_DEFAULT_IMAGE
    }
    
    func getTypeSportImage() -> UIImage {
        return UIImage(named: self.getTypeSport())!
    }
    
    func getIVFromTypeSportImage() -> UIImageView {
        return UIImageView(image: getTypeSportImage())
    }
    
    var dateFormat : String {
        let date_custom = NSDate.date(fromString: self.date, format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
        let dateStr = date_custom!.toMediumDateString()
        
        if date_custom!.isToday() {
            return NSLocalizedString("Today", comment: "Today string")
        }else if date_custom!.isYesterday() {
            return NSLocalizedString("Yesterday", comment: "Yesterday string")
        }else if date_custom!.isThisWeek() {
            return dateStr
        }else{
            let weekdayName = date_custom!.weekdayName
            let day = date_custom!.day
            let monthName = date_custom!.monthName.lowercaseString
            let year = date_custom!.year
            let resDate = "\(weekdayName), \(day) \(monthName) \(year)"
            return resDate
        }
    }
    
}
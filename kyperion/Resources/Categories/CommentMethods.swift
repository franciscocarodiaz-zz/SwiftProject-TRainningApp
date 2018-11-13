//
//  CommentMethods.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import SwiftyJSON

extension KYComment{
    
    convenience init(listCommentData: JSON) {
        self.init()
        var errors = [String]()
        var listComment = [KYComment]()
        
        for item in listCommentData.arrayValue {
            var newComment = KYComment(item)
            
            listComment.append(newComment)
        }
        
        if(errors.count>0){
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }else{
            currentActivity.comments = listComment
        }
        
    }
    
    convenience init(_ dictionary: JSON) {
        self.init()
        var errors = [String]()
        
        for (key,value) in dictionary{
            
            switch key {
            case COMMENT_PARAMS_ID:
                self.id = dictionary[COMMENT_PARAMS_ID].int!
            case COMMENT_PARAMS_NAME:
                self.name = dictionary[COMMENT_PARAMS_NAME].string!
            case COMMENT_PARAMS_COMMENT:
                self.comment = dictionary[COMMENT_PARAMS_COMMENT].string!
            case COMMENT_PARAMS_DATE:
                self.date = dictionary[COMMENT_PARAMS_DATE].string!
            case COMMENT_PARAMS_USER:
                self.user = dictionary[COMMENT_PARAMS_USER].int!
            case COMMENT_PARAMS_ACTIVITY:
                self.activity = dictionary[COMMENT_PARAMS_ACTIVITY].int!
                
            default:
                print("KYComment: No key " + key + " recognized for user object model.")
            }
            
        }
        
    }
    
    var dateFormat : String {
        let date_custom = NSDate.date(fromString: self.date, format: DateFormat.Custom(DATE_FORMAT_ACTIVITY_EXTEND))
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
    
    var titleRow : String {
        return "\(self.name), \(self.dateFormat)"
    }
}

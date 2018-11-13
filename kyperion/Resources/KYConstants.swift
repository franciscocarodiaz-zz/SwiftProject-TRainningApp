//
//  Constants.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import CoreLocation

import UIKit

let DEBUG_MOD = true
let DEBUG_MOD_TEST = false

// Screen message
let MSG_LOADING_USER = NSLocalizedString("Loading user...", comment: "Message displayed to the user during the remote call to the API: login user.")
let MSG_LOADING_TP = NSLocalizedString("Loading training plan...", comment: "Loading training plan message.")
let MSG_CREATING_USER = NSLocalizedString("Creating user...", comment: "Message displayed to the user during the remote call to the API: register user.")
let MSG_LOADING_DATA_USER = NSLocalizedString("Loading recent activities...", comment: "Message displayed to the user during the remote call to the API: recent activity.")

// KEYCHAIN
let TAG_KEYCHAIN_KEYNAME_KEY = "kyperion_keychain_key"
let TAG_KEYCHAIN_USERNAME_KEY = "kyperion_keychain_key_username"
let TAG_KEYCHAIN_PASSWORD_KEY = "kyperion_keychain_key_password"

// Navigation items
let SEGUE_WELCOME_TO_REGISTER = "registerVC"
let SEGUE_WELCOME_TO_LOGIN = "loginVC"
let SEGUE_WELCOME_TO_WEB = "webVC"
let SEGUE_PLANNING_VC = "ShowPlanningSegue"
let SEGUE_ACTIVITY_DETAIL = "ShowActivityDetailSegue"
let SEGUE_MESSAGE_DETAIL = "ShowMessageDetailSegue"
let SEGUE_COMPOSE_MESSAGE = "ShowComposeMessageSegue"


// Register View Controller
let VC_REGISTER_TITLE = NSLocalizedString("Register", comment: "Register VC title")

// Login View Controller
let VC_LOGIN_VC_TITLE = NSLocalizedString("Login", comment: "Login VC title")
let KYPERION_WEB_TRN_LOGIN = "https://dev.kyperion.com:8003"

// Planning View Controller
let VC_TRAININGPLAN_VC_TITLE = NSLocalizedString("Training Plan", comment: "Training Plan VC title")

// KY Main View Controller
/** Direction of menu appearance */
enum KYMenuPlacement: Int {
    case Left = 0, Right, Top, Bottom
}

/** Visual style of the menu */
enum KYMenuBackgroundStyle: Int {
    case Light = 0, Dark = 1
    
    func toBarStyle() -> UIBarStyle {
        return UIBarStyle(rawValue: self.rawValue)!
    }
}

// Date format
let DATE_FORMAT = "YYYY-MM-dd"
let DATE_FORMAT_ACTIVITY_ROOT = "YYYY/MM/dd"
let DATE_FORMAT_ACTIVITY = "yyyy-MM-dd'T'HH:mm:ss'Z'"
let DATE_FORMAT_ACTIVITY_EXTEND = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
let DATE_FORMAT_DURATION = "HH:mm:ss"
let DATE_FORMAT_PAGINATOR = "dd MM"

// Enums

// User Params
let USERPARAMS_PK = "pk"
let USERPARAMS_USERNAME = "username"
let USERPARAMS_EMAIL = "email"
let USERPARAMS_USERPICTURE = "userPicture"
let USERPARAMS_FIRSTNAME = "first_name"
let USERPARAMS_LASTNAME = "last_name"
let USERPARAMS_GENDER = "gender"
let USERPARAMS_BIRTHDAY = "birthday"
let USERPARAMS_USERTYPE = "user_type"
let USERPARAMS_ALLERGIES = "allergies"
let USERPARAMS_MEDICATIONS = "medications"
let USERPARAMS_INJURIES = "injuries"
let USERPARAMS_SURGERIES = "surgeries"
let USERPARAMS_NOTES = "notes"
let USERPARAMS_TRAINING_SINCE = "training_since"
let USERPARAMS_WEEKLY_AVAILABILITY = "weekly_availability"
let USERPARAMS_TIME_AVAILABILITY = "time_availability"

// Message Params
let MESSAGE_PARAMS_PK = "pk"
let MESSAGE_PARAMS_SUBJECT = "subject"
let MESSAGE_PARAMS_BODY = "body"
let MESSAGE_PARAMS_SENDER = "sender"
let MESSAGE_PARAMS_RECIPIENT = "recipient"
let MESSAGE_PARAMS_PARENT_MSG = "parent_msg"
let MESSAGE_PARAMS_SENT_AT = "sent_at"
let MESSAGE_PARAMS_READ_AT = "read_at"
let MESSAGE_PARAMS_REPLIED_AT = "replied_at"
let MESSAGE_PARAMS_SENDER_DELETED_AT = "sender_deleted_at"
let MESSAGE_PARAMS_RECIPIENT_DELETED_AT = "recipient_deleted_at"

// Comments Params
let COMMENT_PARAMS_ID = "id"
let COMMENT_PARAMS_NAME = "name"
let COMMENT_PARAMS_COMMENT = "comment"
let COMMENT_PARAMS_DATE = "date"
let COMMENT_PARAMS_USER = "user"
let COMMENT_PARAMS_ACTIVITY = "activity"

// Lap Params
let LAP_PARAMS_ID = "_id"
let LAP_PARAMS_SORT = "sort"
let LAP_PARAMS_FIELDS = "fields"
let LAP_PARAMS_FIELDS_LAP = "lap"

let LAP_PARAMS_FIELDS_LAP_TIME = "total_timer_time"
let LAP_PARAMS_FIELDS_LAP_DISTANCE = "total_distance"
let LAP_PARAMS_FIELDS_LAP_AVG_SPEED = "avg_speed"
let LAP_PARAMS_FIELDS_LAP_START_POSITION = "start_position"
let LAP_PARAMS_FIELDS_LAP_END_POSITION = "end_position"

let LAP_PARAMS_FIELDS_LAP_TOTAL_ASC = "total_ascent"
let LAP_PARAMS_FIELDS_LAP_TOTAL_DESC = "total_descent"
let LAP_PARAMS_FIELDS_LAP_AVG_HEART = "avg_heart_rate"

// Activity Params
let ACTIVITYPARAMS_USERID = "userId"
let ACTIVITYPARAMS_ACTIVITYID = "activityId"
let ACTIVITYPARAMS_ACTIVITYNAME = "activity_name"
let ACTIVITYPARAMS_NAME = "name"
let ACTIVITYPARAMS_VELOCITY = "velocity"
let ACTIVITYPARAMS_SURNAME = "surname"
let ACTIVITYPARAMS_TIME = "time"
let ACTIVITYPARAMS_USERPICTURE = "userPicture"
let ACTIVITYPARAMS_DATE = "date"
let ACTIVITYPARAMS_SPORT = "sport"
let ACTIVITYPARAMS_DISTANCE = "distance"
let ACTIVITYPARAMS_PACE = "pace"
let PARAM_VALUE = "value"
let PARAM_UNIT = "unit"

// Calendar Event Params
let CALENDAR_EVENT_PARAM_ID = "id"
let CALENDAR_EVENT_PARAM_ASSIGNED_USER = "assignedUser"
let CALENDAR_EVENT_PARAM_EVENT_TYPE = "eventType"
let CALENDAR_EVENT_PARAM_SPORT_TYPE = "sportType"
let CALENDAR_EVENT_PARAM_ACTIVITY_DATA = "activityData"
let CALENDAR_EVENT_PARAM_COMPLETED = "completed"
let CALENDAR_EVENT_PARAM_TRAINING_PLAN_DATA = "trainingPlanData"
let CALENDAR_EVENT_PARAM_TITLE = "title"
let CALENDAR_EVENT_PARAM_DATE = "date"
let CALENDAR_EVENT_PARAM_DURATION = "duration"
let CALENDAR_EVENT_PARAM_DISTANCE = "distance"
let CALENDAR_EVENT_PARAM_PACE = "pace"

// TrainingPlan Params
let TRAINING_PLAN_PARAM_ID = "id"
let TRAINING_PLAN_PARAM_NAME = "name"
let TRAINING_PLAN_PARAM_DESCRIPTION = "description"
let TRAINING_PLAN_PARAM_TIME = "time"
let TRAINING_PLAN_PARAM_SPORT_TYPE = "sport_type"
let TRAINING_PLAN_PARAM_CHILDREN = "children"

// Calendar Activity Data Params
let ACTIVITY_DATA_PARAM_ID = "id"
let ACTIVITY_DATA_PARAM_ACTIVITY_NAME = "activity_name"
let ACTIVITY_DATA_PARAM_PACE = "pace"
let ACTIVITY_DATA_PARAM_HEIGHT = "height"
let ACTIVITY_DATA_PARAM_HEIGHT_LOST = "lost"
let ACTIVITY_DATA_PARAM_HEIGHT_GAIN = "gain"
let ACTIVITY_DATA_PARAM_DATE = "date"
let ACTIVITY_DATA_PARAM_CREATOR = "creator"
let ACTIVITY_DATA_PARAM_BPM = "bpm"
let ACTIVITY_DATA_PARAM_CREATED = "created"
let ACTIVITY_DATA_PARAM_DURATION = "duration"
let ACTIVITY_DATA_PARAM_DISTANCE = "distance"
let ACTIVITY_DATA_PARAM_SPORT_TYPE = "sport_type"

enum UserType : String, Printable {
    case TRN = "kyperion.UserType.TRN"
    case USR = "kyperion.UserType.USR"
    case NUSR = "kyperion.UserType.NUSR"
    var description: String {
        return rawValue
    }
}
let USERTYPE_TRAINER = "TRN"
let USERTYPE_USER = "USR"
let USERTYPE_NO_ACCOUNT_USER = "NUSR"

enum Gender : String, Printable {
    case MAL = "kyperion.Gender.MAL"
    case FEM = "kyperion.Gender.FEM"
    var description: String {
        get {
            switch(self) {
            case MAL:
                return "MAL"
            case FEM:
                return "FEM"
            }
        }
    }
}
let GENDER_MALE = "MAL"
let GENDER_FEMALE = "FEM"

enum EventType : String, Printable {
    case ACTIVITY = "kyperion.EventType.ACTIVITY"
    case TRAININGPLAN = "kyperion.EventType.TRAININGPLAN"
    case ND = "kyperion.EventType.ND"
    var description: String {
        return rawValue
    }
}
let EVENTTYPE_ACTIVITY = "ACTIVITY"
let EVENTTYPE_TRAININGPLAN = "TRAININGPLAN"
let EVENTTYPE_TRAININGPLAN_SWIMMING = "kyperion.EventType.TRAININGPLAN.SWIMMING"
let EVENTTYPE_TRAININGPLAN_CYCLING = "kyperion.EventType.TRAININGPLAN.CYCLING"
let EVENTTYPE_TRAININGPLAN_RUNNING = "kyperion.EventType.TRAININGPLAN.RUNNING"
let EVENTTYPE_NO_TYPE = "ND"

enum SportType : String, Printable{
    case RUNNING = "kyperion.SportType.RUNNING"
    case SWIMMING = "kyperion.SportType.SWIMMING"
    case CYCLING = "kyperion.SportType.CYCLING"
    case GYM = "kyperion.SportType.GYM"
    case ND = "kyperion.SportType.ND"
    var description: String {
        return rawValue
    }
}
let SPORT_TYPE_RUNNING = "RUNNING"
let SPORT_TYPE_SWIMMING = "SWIMMING"
let SPORT_TYPE_CYCLING = "CYCLING"
let SPORT_TYPE_GYM = "GYM"
let SPORT_TYPE_ND = "ND"
let SPORT_TYPE_ND_DEFAULT_IMAGE = "kyperion.SportType.RUNNING"

struct KYSound {
    var name: String
    var type: String
    var loop: Int
}
let playOneTime = 0
let playTwice = 1
let playForever = -1
var soundBeep = KYSound(name: "beep", type:".wav", loop:playOneTime)

struct KYInfoData {
    var name: String
    var date: String
    var description : String {
        var dateFormatted = date.toDate(formatString: DATE_FORMAT)!
        return "\(dateFormatted.monthName)-\(dateFormatted.year) \(name)"
    }
    var apiformat : String {
        return "\(name)=\(date)"
    }
}

struct KYWeekAvailability {
    var monday: KYDayAvailability = KYDayAvailability(dayname: LocalizedString_Day_Monday, availability: [])
    var tuesday: KYDayAvailability = KYDayAvailability(dayname: LocalizedString_Day_Tuesday, availability: [])
    var wednesday: KYDayAvailability = KYDayAvailability(dayname: LocalizedString_Day_Wednesday, availability: [])
    var thursday: KYDayAvailability = KYDayAvailability(dayname: LocalizedString_Day_Thursday, availability: [])
    var friday: KYDayAvailability = KYDayAvailability(dayname: LocalizedString_Day_Friday, availability: [])
    var saturday: KYDayAvailability = KYDayAvailability(dayname: LocalizedString_Day_Saturday, availability: [])
    var sunday: KYDayAvailability = KYDayAvailability(dayname: LocalizedString_Day_Sunday, availability: [])
}
struct KYTimeAvailability{
    var start : Double
    var end : Double
    var description : String {
        return "\(start.toTimeAvailabilityFormat()) - \(end.toTimeAvailabilityFormat())"
    }
    var arrayTimeAvailability : Array<Double> {
        var times = Array<Double>()
        var index = start
        while (index <= end){
            times.insert(index, atIndex: times.count)
            index = index + 0.5
        }
        return times
    }
    
    var arrayTimeAvailabilityFormatted : Array<Double> {
        var times = Array<Double>()
        var index = start
        while (index < end){
            times.insert(index, atIndex: times.count)
            index = index + 0.5
        }
        return times
    }
    
    var timeAvailabilityArray : [String] {
        var res = [String]()
        var arrayTimeAvailabilityAux = arrayTimeAvailability
        var index = 0
        for item in arrayTimeAvailabilityAux {
            res.insert("\(item)", atIndex: index)
            index++
        }
        return res
    }
    
    var arrayTimeAvailabilityString : String {
        var res = ""
        var arrayTimeAvailabilityAux = arrayTimeAvailability
        for item in arrayTimeAvailabilityAux {
            if res == "" {
                res = "\(item)"
            }else{
                res = "\(res),\(item) "
            }
        }
        return res
    }
}

var currentIndex = 0

let timeArrayString = ["00:00","00:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30"]

struct KYTPItem {
    var name: String
    var description: String
    var time : String
    var tpitemdescription : String {
        return "   " + description
    }
    var tpitemtitle : String {
        var timeAux = time
        if time != "" && time != "null" {
            var timeAux = time + " min."
            return timeAux + " " + name
        }
        return name
    }
}

struct KYDayAvailability {
    var dayname: String
    var availability: Array<Double>
    var hasAvailabilty : Bool {
        return availability.count > 0
    }
    
    func addArrayAvailability(newAvailability : Array<Double>) -> Array<Double> {
        if !hasAvailabilty {
            return newAvailability
        }else{
            var newArray = Array<Double>()
            var indexNewArray = 0
            var indexOldArray = 0
            var foundItem : Bool = false
            var firstItem = newAvailability.first
            var countTotal = availability.count + newAvailability.count
            
            for item in availability {
                newArray.append(item)
            }
            for item in newAvailability {
                newArray.append(item)
            }
            newArray.sort(<)
            
            return newArray
        }
    }
    
    var description : String {
        if hasAvailabilty {
            var arrayTimes = [String]()
            var index = 0
            while (index < availability.count){
                var time = "\(availability[index])pm"
                arrayTimes.insert(time, atIndex: index)
                index++
            }
            return "\(dayname), availabity: \(arrayTimes)"
        }
        return "\(dayname), no availabity."
    }
    
    var timeAvailabilityArrayString : [String] {
        var res = [String]()
        
        if hasAvailabilty {
            var index = 0
            var item = ""
            var numberOfTimesAvailability = availability.count
            while (index < numberOfTimesAvailability){
                item = "\(availability[index].toTimeAvailabilityFormat24())"
                res.insert(item, atIndex: index)
                index++
            }
        }
        
        return res
    }
    
    var timeHasAvailabilityArrayString : [String] {
        
        var timeAvailabilityArrayStringAux = timeAvailabilityArrayString
        var res = [String]()
        var index = 0
        var indexArray = 0
        var item = ""
        var numberOfTimesAvailability = timeArrayString.count
        while (index < numberOfTimesAvailability){
            item = timeArrayString[index]
            if !contains(timeAvailabilityArrayStringAux, item) {
                res.insert(item, atIndex: indexArray)
                indexArray++
            }
            index++
        }
        return res
    }
    
    var timeAvailabilityAPIFormat : String {
        var res = ""
        
        if hasAvailabilty {
            var index = 0
            var item = ""
            var numberOfTimesAvailability = availability.count
            while (index < numberOfTimesAvailability){
                item = "\(availability[index])"
                res = res + item
                index++
                if index != numberOfTimesAvailability {
                    res = res + ","
                }
            }
        }
        
        return res
    }
    
    var timeAvailability : (Int, [KYTimeAvailability]){
        var numberOfTimesAvailability = 0
        var listOfTimesAvailability = [KYTimeAvailability]()
        var index = 1
        
        if hasAvailabilty {
            
            var start = availability[0]
            var end = availability[0]
            var numberOfElement = availability.count
            
            if numberOfElement == 1 {
                // Case 1:  1 element
                numberOfTimesAvailability = 1
                end = availability[0] + 0.5
                var item = KYTimeAvailability(start: start, end: end)
                listOfTimesAvailability.insert(item, atIndex: 0)
            }else{
                // Case 2:  More than 1 element
                while (index < numberOfElement){
                    
                    if (availability[index] > availability[index-1] + 0.5){
                        
                        end = availability[index-1] + 0.5
                        
                        var item = KYTimeAvailability(start: start, end: end)
                        listOfTimesAvailability.insert(item, atIndex: numberOfTimesAvailability)
                        numberOfTimesAvailability++
                        
                        start = availability[index]
                        
                    }
                    
                    if index + 1 == numberOfElement {
                        end = availability[index] + 0.5
                        
                        var item = KYTimeAvailability(start: start, end: end)
                        listOfTimesAvailability.insert(item, atIndex: numberOfTimesAvailability)
                        numberOfTimesAvailability++
                    }
                    
                    index++
                }
            }
            
        }
        
        return (numberOfTimesAvailability, listOfTimesAvailability)
    }
}

struct Login {
    var username: String
    var password: String
    var token: String
}

struct UnitValue {
    var unit: String
    var value: String
}

struct KYLocation {
    var location: CLLocation
    var locality: String
    var country: String
    var state: String
    var duration: String
    var name: String
}

struct KYHeight {
    var gain : Double
    var lost : Double
}

let today = NSDate.today()
var coord = CLLocationCoordinate2DMake(0, 0)
var loc = CLLocation(coordinate: coord, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: today)
let KYLOC_DEFAULT = KYLocation(location: loc, locality:"", country:"", state:"", duration: "0", name:"")

// mark: API env conexion
// https://dev.kyperion.com:8005/api/v1/auth/login/"
//let API_ROOT = "https://dev.kyperion.com:8005"
let API_ROOT = "https://staging-api.kyperion.com"
let API_ENV = "api"
let API_VERSION = "v1"
let URL_SEPARATOR = "/"
let API_URL_BASE = API_ROOT + URL_SEPARATOR + API_ENV + URL_SEPARATOR + API_VERSION + URL_SEPARATOR

struct API_REQUEST {
    var item : String = "auth"
    var action: String = "login"
    
    var url :String{
        get{
            if  item != "" && action != "" {
                return API_URL_BASE + item + URL_SEPARATOR + action
            }else if action == "" {
                return API_URL_BASE + item
            }else if item == "" {
                return API_URL_BASE + action
            }else{
                return API_URL_BASE
            }
        }
    }
}

let CONST_API_MESSAGE_GET = "user_messages"
let CONST_API_MESSAGE_GET_PARAM_1 = "messages"
let CONST_API_MESSAGE_GET_PARAM_2 = "get"

let CONST_API_MESSAGE_ALL = "user_messages_all"
let CONST_API_MESSAGE_ALL_PARAM_1 = "messages"
let CONST_API_MESSAGE_ALL_PARAM_2 = ""

let CONST_API_AUTH_LOGIN = "auth_login"
let CONST_API_AUTH_LOGIN_PARAM_1 = "auth"
let CONST_API_AUTH_LOGIN_PARAM_2 = "login"

let CONST_API_USER_ACTIVITY = "mobile_activity"
let CONST_API_USER_ACTIVITY_PARAM_1 = "user"
let CONST_API_USER_ACTIVITY_PARAM_2 = "mobile_activity"

let CONST_API_USER_ACTIVITY_COMMENTS = "user_activity_comments"
let CONST_API_USER_ACTIVITY_COMMENTS_PARAM_1 = "user"
let CONST_API_USER_ACTIVITY_COMMENTS_PARAM_2 = "activity/comments"

let CONST_API_AUTH_USER = "auth_user"
let CONST_API_AUTH_USER_PARAM_1 = "auth"
let CONST_API_AUTH_USER_PARAM_2 = "user"

let CONST_API_PLAN_GET_PLAN = "get_plan"
let CONST_API_PLAN_GET_PLAN_PARAM_1 = "plan"
let CONST_API_AUTH_PLAN_GET_PLAN_PARAM_2 = ""

let CONST_API_PLAN_GET_LAPS_OF_ACTIVITY = "activity_laps"
let CONST_API_PLAN_GET_LAPS_OF_ACTIVITY_PARAM_1 = "user"
let CONST_API_PLAN_GET_LAPS_OF_ACTIVITY_PARAM_2 = "activity"
let CONST_API_PLAN_GET_LAPS_OF_ACTIVITY_PARAM_3 = "/laps"

let CONST_API_AUTH_ACTIVITY_USER = "activity_user"
let CONST_API_AUTH_ACTIVITY_USER_PARAM_1 = "user"
let CONST_API_AUTH_ACTIVITY_USER_PARAM_2 = "activity"

let CONST_API_AUTH_CHANGE_PASSWORD = "change_password"
let CONST_API_AUTH_CHANGE_PASSWORD_PARAM_1 = "auth"
let CONST_API_AUTH_CHANGE_PASSWORD_PARAM_2 = "password/change"

let CONST_API_USER_ACCESORIES = "user_accesories"
let CONST_API_USER_ACCESORIES_PARAM_1 = "user"
let CONST_API_USER_ACCESORIES_PARAM_2 = "accessories"

let CONST_API_RECENT_ACT_USER = "recent_activity_user"
let CONST_API_RECENT_ACT_USER_PARAM_1 = "user"
let CONST_API_RECENT_ACT_USER_PARAM_2 = "recent_acitvity"

let CONST_API_REGISTRATION = "registration"
let CONST_API_REGISTRATION_PARAM_1 = "registration"

struct API {
    var caseAPI: String
    
    var url :String{
        get{
            switch caseAPI {
                
            case CONST_API_PLAN_GET_LAPS_OF_ACTIVITY:
                var item = CONST_API_PLAN_GET_LAPS_OF_ACTIVITY_PARAM_1 + URL_SEPARATOR + currentUser.userId
                var action = CONST_API_PLAN_GET_LAPS_OF_ACTIVITY_PARAM_2 + URL_SEPARATOR + currentActivity.activityId + CONST_API_PLAN_GET_LAPS_OF_ACTIVITY_PARAM_3
                return API_REQUEST(item: item, action: action).url
                
            case CONST_API_USER_ACTIVITY_COMMENTS:
                var action = CONST_API_USER_ACTIVITY_COMMENTS_PARAM_2 + URL_SEPARATOR + currentActivity.activityId + URL_SEPARATOR
                if DEBUG_MOD {
                    action = CONST_API_USER_ACTIVITY_COMMENTS_PARAM_2 + URL_SEPARATOR + "1" + URL_SEPARATOR
                }
                return API_REQUEST(item: CONST_API_USER_ACTIVITY_COMMENTS_PARAM_1, action: action).url
                
                case CONST_API_AUTH_ACTIVITY_USER:
                    var action = currentUser.userId+"/"+CONST_API_AUTH_ACTIVITY_USER_PARAM_2
                    return API_REQUEST(item: CONST_API_AUTH_ACTIVITY_USER_PARAM_1, action: action).url
                
                case CONST_API_USER_ACCESORIES:
                    var action = currentUser.userId+"/"+CONST_API_USER_ACCESORIES_PARAM_2
                    return API_REQUEST(item: CONST_API_USER_ACCESORIES_PARAM_1, action: action).url
                
            case CONST_API_MESSAGE_GET:
                return API_REQUEST(item: CONST_API_MESSAGE_GET_PARAM_1, action: CONST_API_MESSAGE_GET_PARAM_2).url + URL_SEPARATOR
                
            case CONST_API_MESSAGE_ALL:
                return API_REQUEST(item: CONST_API_MESSAGE_ALL_PARAM_1, action: "").url + URL_SEPARATOR
                
                case CONST_API_AUTH_LOGIN:
                    return API_REQUEST(item: CONST_API_AUTH_LOGIN_PARAM_1, action: CONST_API_AUTH_LOGIN_PARAM_2).url + URL_SEPARATOR
                
                case CONST_API_AUTH_USER:
                    return API_REQUEST(item: CONST_API_AUTH_USER_PARAM_1, action: CONST_API_AUTH_USER_PARAM_2).url + URL_SEPARATOR
                
                case CONST_API_AUTH_CHANGE_PASSWORD:
                    return API_REQUEST(item: CONST_API_AUTH_CHANGE_PASSWORD_PARAM_1, action: CONST_API_AUTH_CHANGE_PASSWORD_PARAM_2).url + URL_SEPARATOR
                
                case CONST_API_USER_ACTIVITY:
                    return API_REQUEST(item: CONST_API_USER_ACTIVITY_PARAM_1, action: CONST_API_USER_ACTIVITY_PARAM_2).url
                
                case CONST_API_RECENT_ACT_USER:
                    return API_REQUEST(item: CONST_API_RECENT_ACT_USER_PARAM_1, action: CONST_API_RECENT_ACT_USER_PARAM_2).url
                
                case CONST_API_REGISTRATION:
                    return API_REQUEST(item: CONST_API_REGISTRATION_PARAM_1, action: "").url + URL_SEPARATOR
                
                case CONST_API_PLAN_GET_PLAN:
                    return API_REQUEST(item: CONST_API_PLAN_GET_PLAN_PARAM_1, action: "").url + URL_SEPARATOR
                
                default:
                    return API_REQUEST(item: CONST_API_AUTH_LOGIN_PARAM_1, action: CONST_API_AUTH_LOGIN_PARAM_2).url
            }
        }
    }
}

// CoreData
let CD_MODEL_NAME = "kyperion"
let CD_EXTENSION = "momd"
let CD_APPDOCDIR_PATH = "kyperion.sqlite"

// Fonts
let FONT_HELVETICA_NEUE = "HelveticaNeue"
let FONT_ROBOTO_MED = "Roboto-Medium"
let FONT_ROBOTO_REG = "Roboto-Regular"

let FONT_NAV_BAR = "AlternateGothicNo2BT.ttf"
let FONT_TEXT_BT = "HelveticaNeueLTStd-Bd.otf"
let FONT_TEXT_LT = "HelveticaNeueLTStd-Lt.otf"

// Prompts
let FONT_TEXT = FONT_HELVETICA_NEUE
let PROMPT_TITLE = "Kyperion"
let PROMPT_OK_MSG = "Ok"

// Global Vble
var CURRENT_USER : KYUser!

class UIConstants {
    class func screenWidth() -> CGFloat{
        return UIScreen.mainScreen().applicationFrame.size.width
    }
    class func screenHeight() -> CGFloat{
        return UIScreen.mainScreen().applicationFrame.size.height
    }
    class func isIpad() -> Bool{
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
    class func isPhone() -> Bool{
        return UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
}

var prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
let KEY_MEM_CACHE_CURRENT_USER = "CURRENT_USER"
let KEY_UD_CURRENT_USER = "CURRENT_USER"
let KEY_UD_TOKEN = "TOKEN"
let KEY_UD_USERNAME = "USERNAME"
let KEY_UD_PASSWORD = "PASSWORD"
var configCurrentUser : KYUser = KYUser()
var currentUser : KYUser{
get{
    if let user = prefs.objectForKey(KEY_UD_CURRENT_USER){
        return user as! KYUser
    }else{
        let existUser = KYMemCache.sharedInstance.exists(KEY_MEM_CACHE_CURRENT_USER)
        if existUser {
            let user = KYMemCache.sharedInstance.get(KEY_MEM_CACHE_CURRENT_USER)?.data as! KYUser
            return user
        }
    }
    return KYUser()
}
set{
    KYMemCache.sharedInstance.saveDataForKey(newValue, key: KEY_MEM_CACHE_CURRENT_USER)
}
}

var currentActivity : KYActivity = KYActivity()

var newAccesory : KYAccessory = KYAccessory()
var currentTrainingPlan : KYTrainingPlan = KYTrainingPlan()
var currentEmail : KYMessage = KYMessage()


var tokenUser : String{
get{
    if let token = prefs.stringForKey(KEY_UD_TOKEN){
        return token
    }
    /*
    if currentUser.login.token == "" {
        if let token = KYKeychain.get(TAG_KEYCHAIN_KEYNAME_KEY) {
            return token
        }
    }
    */
    return ""
}
set{
    prefs.setValue(newValue, forKey: KEY_UD_TOKEN)
    prefs.synchronize()
    //KYMemCache.sharedInstance.saveDataForKey(newValue, key: KEY_MEM_CACHE_CURRENT_USER)
}
}

var usernameLoggin : String{
get{
    if let username = prefs.stringForKey(KEY_UD_USERNAME){
        return username
    }
    return ""
}
set{
    prefs.setValue(newValue, forKey: KEY_UD_USERNAME)
    prefs.synchronize()
}
}

var passwordLoggin : String{
get{
    if let password = prefs.stringForKey(KEY_UD_PASSWORD){
        return password
    }
    return ""
}
set{
    prefs.setValue(newValue, forKey: KEY_UD_PASSWORD)
    prefs.synchronize()
}
}

// Observers
let updateProfileNotificationKey = "notify.updateProfileNotificationKey"
let updateCalendarDayNotificationKey = "notify.updateCalendarDayNotificationKey"
let updateTrainingPlanNotificationKey = "notify.updateTrainingPlanNotificationKey"
let updateCalendarWeekNotificationKey = "notify.updateCalendarWeekNotificationKey"
let updateModelControllerNotificationKey = "notify.updateModelControllerNotificationKey"
let updateTrainingPlanDayTableNotificationKey = "notify.updateTrainingPlanDayTableNotificationKey"
let updateTrainingPlanTVDayTableNotificationKey = "notify.updateTrainingPlanTVDayTableNotificationKey"

// : Profile

let updateListActivityTableViewNotificationKey = "notify.updateListActivityTableViewNotificationKey"
let updateListActivityNotificationKey = "notify.updateListActivityViewNotificationKey"

let updateProfileViewNotificationKey = "notify.updateProfileViewNotificationKey"
let updateProfileDataNotificationKey = "notify.updateProfileDataNotificationKey"

let updateListOutBoxMessageTableViewNotificationKey = "notify.updateListOutBoxMessageTableViewNotificationKey"


// NSLocalizedString
let LocalizedString_Day_M = NSLocalizedString("M", comment: "Label for monday title in the week calendar table")
let LocalizedString_Day_T = NSLocalizedString("T", comment: "Label for tuesday title in the week calendar table")
let LocalizedString_Day_W = NSLocalizedString("W", comment: "Label for wednesday title in the week calendar table")
let LocalizedString_Day_TH = NSLocalizedString("TH", comment: "Label for thursday title in the week calendar table")
let LocalizedString_Day_F = NSLocalizedString("F", comment: "Label for friday title in the week calendar table")
let LocalizedString_Day_Sa = NSLocalizedString("Sa", comment: "Label for saturday title in the week calendar table")
let LocalizedString_Day_S = NSLocalizedString("S", comment: "Label for sunday title in the week calendar table")
let LocalizedString_Total = NSLocalizedString("Total", comment: "Label for total title in the week calendar table")


let LocalizedString_Warmup = NSLocalizedString("Warm-up", comment: "Warmup label")
let LocalizedString_MainPart = NSLocalizedString("Main Part", comment: "Main part label")
let LocalizedString_Warmdown = NSLocalizedString("Warm-down", comment: "Warmdown label")

let days = [LocalizedString_Day_Monday, LocalizedString_Day_Tuesday, LocalizedString_Day_Wednesday, LocalizedString_Day_Thursday, LocalizedString_Day_Friday, LocalizedString_Day_Saturday, LocalizedString_Day_Sunday]
let LocalizedString_Day_Monday = NSLocalizedString("Monday", comment: "Label for monday title")
let LocalizedString_Day_Tuesday = NSLocalizedString("Tuesday", comment: "Label for tuesday title")
let LocalizedString_Day_Wednesday = NSLocalizedString("Wednesday", comment: "Label for wednesday title")
let LocalizedString_Day_Thursday = NSLocalizedString("Thursday", comment: "Label for thursday title")
let LocalizedString_Day_Friday = NSLocalizedString("Friday", comment: "Label for friday title")
let LocalizedString_Day_Saturday = NSLocalizedString("Saturday", comment: "Label for saturday title")
let LocalizedString_Day_Sunday = NSLocalizedString("Sunday", comment: "Label for sunday title")

let LocalizedString_Days = NSLocalizedString("days", comment: "Label days")

// : VC Titles

let LocalizedString_ProfileManager_ProfileVC = NSLocalizedString("Profile", comment: "Profile screen title")
let LocalizedString_ProfileManager_MessageVC = NSLocalizedString("Message", comment: "Message screen title")
let LocalizedString_ProfileManager_ListActivityVC = NSLocalizedString("Activities", comment: "List activity screen title")
let LocalizedString_ProfileManager_DiaryVC = NSLocalizedString("Diary", comment: "Diary screen title")
let LocalizedString_ProfileManager_DiaryVC_Msg = NSLocalizedString("This section is under construction. You can access in future updates.", comment: "Diary screen message")

let LocalizedString_ActManager_ResumeVC = NSLocalizedString("Resume", comment: "Resume screen title")
let LocalizedString_ActManager_MapVC = NSLocalizedString("Map", comment: "Map screen title")
//let LocalizedString_ActManager_GraphicVC = NSLocalizedString("Graphics", comment: "Graphics screen title")
let LocalizedString_ActManager_GraphicVC = NSLocalizedString("Graphics", comment: "Graphics screen title")
let LocalizedString_ActManager_TPActVC = NSLocalizedString("Training Plan", comment: "Training Plan in Activity screen title")

// : Profile
let listDataInfo = [LocalizedString_0, LocalizedString_1, LocalizedString_2, LocalizedString_3, LocalizedString_4, LocalizedString_5, LocalizedString_6]
let LocalizedString_0 = NSLocalizedString("Years training", comment: "Title Years training")
let LocalizedString_1 = NSLocalizedString("allergies", comment: "Title allergies")
let LocalizedString_2 = NSLocalizedString("medication", comment: "Title medication")
let LocalizedString_3 = NSLocalizedString("injuries", comment: "Title injuries")
let LocalizedString_4 = NSLocalizedString("operations", comment: "Title operations")
let LocalizedString_5 = NSLocalizedString("weekly workouts", comment: "Title weekly workouts")
let LocalizedString_6 = NSLocalizedString("availability", comment: "Title availability")

let listDataAccesory = [LocalizedString_Sport_Swim, LocalizedString_Sport_Cyc, LocalizedString_Sport_Run, LocalizedString_Sport_Gym]

// : Messages
let LocalizedString_From = NSLocalizedString("From:", comment: "From label")
let LocalizedString_To = NSLocalizedString("To:", comment: "To label")
let LocalizedString_Subject = NSLocalizedString("Subject:", comment: "Subject label")
let LocalizedString_Body = NSLocalizedString("Your message...", comment: "Subject label")


// : Resume
let LocalizedString_Resume_1 = NSLocalizedString("Duration", comment: "Duration label")
let LocalizedString_Resume_2 = NSLocalizedString("Distance", comment: "Distance label")
let LocalizedString_Resume_3 = NSLocalizedString("Pace", comment: "Pace label")
let LocalizedString_Resume_4 = NSLocalizedString("PPM", comment: "PPM label")
let LocalizedString_Resume_5 = NSLocalizedString("Height Gain", comment: "Height Gain label")
let LocalizedString_Resume_6 = NSLocalizedString("Calories", comment: "Calories label")

// : MAP columns
let LocalizedString_Column_1 = NSLocalizedString("Lap", comment: "Lap title")
let LocalizedString_Column_2 = NSLocalizedString("Time", comment: "Time title")
let LocalizedString_Column_3 = NSLocalizedString("Distance", comment: "Distance title")
let LocalizedString_Column_4 = NSLocalizedString("Speed", comment: "Average speed title")



let LocalizedString_DateOf = NSLocalizedString("date of ", comment: "Datel label")
let LocalizedString_Injury = NSLocalizedString("injury", comment: "Injury label")
let LocalizedString_Surgery = NSLocalizedString("surgery", comment: "Surgery label")
let LocalizedString_NewValue = NSLocalizedString("Type new value", comment: "Type new value label")
let LocalizedString_Cancel = NSLocalizedString("Cancel", comment: "Cancel label")
let LocalizedString_Save = NSLocalizedString("Save", comment: "Save label")
let LocalizedString_Done = NSLocalizedString("Done", comment: "Done label")
let LocalizedString_Edit = NSLocalizedString("Edit", comment: "Edit label")
let LocalizedString_Accesory = NSLocalizedString("Accesory", comment: "Accesory label")
let LocalizedString_Info = NSLocalizedString("Information", comment: "Information label")


let LocalizedString_SelectDay = NSLocalizedString("Select day", comment: "Select day label")
let LocalizedString_SelectStartTime = NSLocalizedString("Select start time:", comment: "Select start time label")
let LocalizedString_SelectEndTime = NSLocalizedString("Select end time:", comment: "Select end time label")

let LocalizedString_TrainingSince = NSLocalizedString("Training since date:", comment: "Training since date: label")

let LocalizedString_AddAllergy = NSLocalizedString("Add an allergy", comment: "Add an allergy label")
let LocalizedString_AddMedication = NSLocalizedString("Add a medication", comment: "Add a medication label")
let LocalizedString_NumberWorkoutsWeek = NSLocalizedString("number of workouts per week:", comment: "number of workouts per week: label")


// : Sports
let LocalizedString_Sport_Swim = NSLocalizedString("Swimming", comment: "Label for sport swimming")
let LocalizedString_Sport_Cyc = NSLocalizedString("Cycling", comment: "Label for sport cycling")
let LocalizedString_Sport_Run = NSLocalizedString("Running", comment: "Label for sport running")
let LocalizedString_Sport_Gym = NSLocalizedString("Gym", comment: "Label for sport Gym")
let LocalizedString_Sport_WithoutAutoLaps = NSLocalizedString("No autolaps", comment: "Sin autolaps label")
let LocalizedString_Sport_Training = NSLocalizedString("Training", comment: "Training label")
let LocalizedString_Select = NSLocalizedString("Select", comment: "Select label")


// : Buttons
let LocalizedString_Start = NSLocalizedString("Start", comment: "Start string")
let LocalizedString_Pause = NSLocalizedString("Pause", comment: "Pause string")
let LocalizedString_Stop = NSLocalizedString("Stop", comment: "Stop string")
let LocalizedString_Resume = NSLocalizedString("Resume", comment: "Resume string")

let LocalizedString_MinKm = NSLocalizedString("min/km", comment: "Pace min/km string")
let LocalizedString_KmH = NSLocalizedString("km/h", comment: "Pace km/h string")

let LocalizedString_UpdateData = NSLocalizedString("Update data", comment: "Update data string")
let LocalizedString_LogOut = NSLocalizedString("Logout", comment: "Logout string")

let LocalizedString_Configuration = NSLocalizedString("Configuration", comment: "Configuration string")

// : Prompts messages
let LocalizedString_USER_UPDATED = NSLocalizedString("User updated correctly", comment: "User updated correctly message")
let LocalizedString_USER_UPDATED_ERROR = NSLocalizedString("User not updated", comment: "User not updated message")
let LocalizedString_USER_UPDATED_PASSWORD = NSLocalizedString("User password updated correctly", comment: "User password updated message")
let LocalizedString_USER_UPDATED_PASSWORD_ERROR = NSLocalizedString("Error updating user password", comment: "Error updating user password message")
let LocalizedString_USER_UPDATED_AND_PASSWORD = NSLocalizedString("User info and password updated correctly", comment: "User info and password updated message")

let LocalizedString_EMPTY_LIST = NSLocalizedString("No data.", comment: "Empty list message")
let LocalizedString_EMPTY_LIST_INBOX = NSLocalizedString("Inbox is empty.", comment: "Empty list message")
let LocalizedString_EMPTY_LIST_OUTBOX = NSLocalizedString("Outbox is empty.", comment: "Empty list message")
let LocalizedString_EMPTY_LIST_TRASH = NSLocalizedString("Trash is empty.", comment: "Empty list message")

let LocalizedString_EMPTY_LIST_ACCESSORY_MSG = NSLocalizedString("You have not indicated any accessory.", comment: "Empty list message")
let LocalizedString_EMPTY_LIST_CALENDAR = NSLocalizedString("There is any training in your calendar.", comment: "Empty list message")
let LocalizedString_ACT_CREATED = NSLocalizedString("Activity registered correctly.", comment: "Activity added message")
let LocalizedString_ACT_NOT_CREATED = NSLocalizedString("Activity not registered.", comment: "Activity not added message")

let LocalizedString_ADD_BUTTON_TITLE = NSLocalizedString("Add", comment: "Add title")

// Images
let appImage = AssetsManager.appImage
let malePlaceholderImage = AssetsManager.malePlaceholderImage
let femalePlaceholderImage = AssetsManager.femalePlaceholderImage

// Data Lists
let LocalizedString_CONFIG_DATA_NAME = NSLocalizedString("Name", comment: "Name label displayed in configuration screen")
let LocalizedString_CONFIG_DATA_SURNAME = NSLocalizedString("Surname", comment: "Surname label displayed in configuration screen")
let LocalizedString_CONFIG_DATA_BIRTHDATE = NSLocalizedString("Birthdate", comment: "Birthdate label displayed in configuration screen")
let LocalizedString_CONFIG_DATA_GENDER = NSLocalizedString("Gender", comment: "Gender label displayed in configuration screen")
let LocalizedString_CONFIG_DATA_USERNAME = NSLocalizedString("Username", comment: "Username label displayed in configuration screen")
let LocalizedString_CONFIG_DATA_EMAIL = NSLocalizedString("Email", comment: "Email label displayed in configuration screen")
let LocalizedString_CONFIG_DATA_MODIFY_PASSWORD = NSLocalizedString("Modify password", comment: "Modify password label displayed in configuration screen")
let configuracionScreenDataList = [LocalizedString_CONFIG_DATA_NAME, LocalizedString_CONFIG_DATA_SURNAME, LocalizedString_CONFIG_DATA_BIRTHDATE, LocalizedString_CONFIG_DATA_GENDER, LocalizedString_CONFIG_DATA_USERNAME, LocalizedString_CONFIG_DATA_EMAIL, LocalizedString_CONFIG_DATA_MODIFY_PASSWORD]

// ACCESSORY LIST OPTIONS

let list_Run_Opt_1 = [listAcc_Run_Opt_1_SHOES, listAcc_Run_Opt_1_ACC]
let listAcc_Run_Opt_1_SHOES = NSLocalizedString("Sport shoes", comment: "shoes label")
let listAcc_Run_Opt_1_ACC = NSLocalizedString("Accessories", comment: "accessories label")

let list_Run_Opt_2 = [listAcc_Run_Opt_2_training, listAcc_Run_Opt_2_race, listAcc_Run_Opt_2_clock]
let listAcc_Run_Opt_2_training = NSLocalizedString("Training", comment: "training label")
let listAcc_Run_Opt_2_race = NSLocalizedString("Race", comment: "Race label")
let listAcc_Run_Opt_2_clock = NSLocalizedString("Clock", comment: "Clock label")

let list_Cyc_Opt_1 = [listAcc_Run_Opt_2_Bike, listAcc_Run_Opt_1_ACC]
let listAcc_Run_Opt_2_Bike = NSLocalizedString("Bike", comment: "training label")

let list_Cyc_Opt_2 = [listAcc_Cyc_Opt_2_Road, listAcc_Cyc_Opt_2_mountain, listAcc_Cyc_Opt_2_roller, listAcc_Cyc_Opt_2_GPS, listAcc_Cyc_Opt_2_potentiometer]
let listAcc_Cyc_Opt_2_Road = NSLocalizedString("Road", comment: "Road label")
let listAcc_Cyc_Opt_2_mountain = NSLocalizedString("mountain", comment: "mountain label")
let listAcc_Cyc_Opt_2_roller = NSLocalizedString("Roller", comment: "roller label")
let listAcc_Cyc_Opt_2_GPS = NSLocalizedString("GPS", comment: "GPS label")
let listAcc_Cyc_Opt_2_potentiometer = NSLocalizedString("Potentiometer", comment: "potentiometer label")

let list_Swim_Opt_1 = [listAcc_Run_Opt_1_ACC]
let list_Swim_Opt_2 = [listAcc_Run_Opt_2_clock, listAcc_Swim_Opt_2_Fins, listAcc_Cyc_Opt_2_Paddles , listAcc_Cyc_Opt_2_Tuba]
let listAcc_Swim_Opt_2_Fins = NSLocalizedString("Fins", comment: "Fins label")
let listAcc_Cyc_Opt_2_Paddles = NSLocalizedString("Paddles", comment: "Paddles label")
let listAcc_Cyc_Opt_2_Tuba = NSLocalizedString("Tuba", comment: "Tuba label")

let list_Gym_Opt_1 = [listAcc_Gym_Opt_1_Ava, listAcc_Run_Opt_1_ACC]
let listAcc_Gym_Opt_1_Ava = NSLocalizedString("Available", comment: "Available label")

let list_Gym_Opt_2 = [listAcc_Gym_Opt_2_weights, listAcc_Gym_Opt_2_trx]
let listAcc_Gym_Opt_2_weights = NSLocalizedString("Weights", comment: "Weights label")
let listAcc_Gym_Opt_2_trx = NSLocalizedString("TRX", comment: "TRX label")

let list_Gym_Opt_3 = [listAcc_Gym_Opt_3_y, listAcc_Gym_Opt_3_n]
let listAcc_Gym_Opt_3_y = NSLocalizedString("YES", comment: "Menu YES label")
let listAcc_Gym_Opt_3_n = NSLocalizedString("NO", comment: "Menu NO label")

var listAcc_Run_Opt_1 : [String] {
    return list_Run_Opt_1
}
var listAcc_Run_Opt_2 : [String] {
    return list_Run_Opt_2
}

var listAcc_Cyc_Opt_1 : [String] {
    return list_Cyc_Opt_1
}
var listAcc_Cyc_Opt_2 : [String] {
    return list_Cyc_Opt_2
}

var listAcc_Swim_Opt_1 : [String] {
    return list_Swim_Opt_1
}
var listAcc_Swim_Opt_2 : [String] {
    return list_Swim_Opt_2
}

var listAcc_Gym_Opt_1 : [String] {
    return list_Gym_Opt_1
}
var listAcc_Gym_Opt_2 : [String] {
    return list_Gym_Opt_2
}
var listAcc_Gym_Opt_3 : [String] {
    return list_Gym_Opt_3
}

let LocalizedString_SelectAccesoryName = NSLocalizedString("Select accesory name >", comment: "Select accesory name label")
let LocalizedString_SelectTypeName = NSLocalizedString("Select type of name >", comment: "Select type of name label")

// Segues

/* Helper function: count and return the screen's size */
func countScreenSize() -> CGSize {
    var screenWidth = UIScreen.mainScreen().bounds.size.width
    var screenHeight = UIScreen.mainScreen().bounds.size.height
    
    let interfaceOrientaion = UIApplication.sharedApplication().statusBarOrientation
    
    if UIInterfaceOrientationIsLandscape(interfaceOrientaion) {
        let tmp = screenWidth
        screenWidth = screenHeight
        screenHeight = tmp
    }
    
    return CGSizeMake(screenWidth, screenHeight)
}
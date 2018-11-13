//
//  KYUser.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import UIKit

class KYUser {
    
    var userPicture:String = "";
    var userId:String = "";
    var username:String = "";
    
    var usernameLogin:String = "";
    var passwordLogin:String = "";
    var tokenLogin:String = "";
    
    var email:String = "";
    var firstName:String = "";
    var lastName:String = "";
    var gender: Gender = Gender.MAL
    var birthdayStr:String
    //var birthday:NSDate
    var userType: UserType = UserType.USR
    var login: KYLogin = KYLogin()
    var listActivity = [KYCalendarActivityData]()
    var recentActivity = [Dictionary<String, [KYActivity]>]()
    var calendarEvents = [KYCalendarEvent]()
    var calendarEventsListByDay = Dictionary<String, [KYCalendarEvent]>()
    var calendarEventsListByWeekOfYear = Dictionary<Int, [KYCalendarEvent]>()
    
    var listMessage = [KYMessage]()
    var listMessageInbox = [KYMessage]()
    var listMessageOutbox = [KYMessage]()
    var listMessageTrash = [KYMessage]()
    
    
    var listAccSwim = [KYAccessory]()
    var listAccCyc = [KYAccessory]()
    var listAccRun = [KYAccessory]()
    var listAccGym = [KYAccessory]()
    
    var accesories = [String]()
    var allergies = [String]()
    
    var medications = [String]()
    //var injuries = Dictionary<String, String>()
    var injuries = [KYInfoData]()
    var surgeries = [KYInfoData]()
    var notes:String = ""
    var trainingSince:String = ""
    
    
    var weeklyAvailability:Int = 0
    var timeAvailability = KYWeekAvailability()
    
    init(){
        self.usernameLogin = "";
        self.passwordLogin = "";
        self.tokenLogin = "";
        
        self.userId = ""
        self.userPicture = ""
        self.username = ""
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.gender = Gender.MAL
        let defaultBirthday = NSDate.today()-18.year
        //self.birthday = defaultBirthday
        self.birthdayStr = defaultBirthday.toString(format: DateFormat.Custom(DATE_FORMAT))
        self.trainingSince = defaultBirthday.toString(format: DateFormat.Custom(DATE_FORMAT))
        self.userType = UserType.NUSR
        self.login = KYLogin(username: "", password: "", token: "")
    }
    
    init(username:String, email:String, firstName:String, lastName:String, gender: Gender, birthday:String, userType: UserType, login: KYLogin){
        self.userPicture = ""
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.birthdayStr = birthday
        //self.birthday = birthday.toDate(formatString: DATE_FORMAT)!
        self.userType = userType
        self.login = login
    }
    
    
    
}
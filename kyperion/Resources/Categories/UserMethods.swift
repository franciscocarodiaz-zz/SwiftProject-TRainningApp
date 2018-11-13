//
//  UserMethods.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import SwiftyJSON

extension KYUser{
	
	convenience init(listData: JSON) {
		self.init()
		var errors = [String]()
		var list = [KYUser]()
		
		for activityItem in listData.arrayValue {
			var newActivity = KYCalendarActivityData(activityItem)
			
			listActivity.append(newActivity)
		}
		
		if(errors.count>0){
			self.userId = ""
			print("Error creating user from JSON")
			for e in errors {
				print(e)
			}
		}else{
			currentUser.listActivity = listActivity
		}
		
	}
	
    convenience init(_ dictionary: JSON) {
        self.init()
        var errors = [String]()
		
        for (key,value) in dictionary{
            if let _ = dictionary[key].string {
                switch key {
                    case USERPARAMS_NOTES:
                        self.notes = dictionary[USERPARAMS_NOTES].string!
                    case USERPARAMS_TRAINING_SINCE:
                        self.trainingSince = dictionary[USERPARAMS_TRAINING_SINCE].string!
                    case USERPARAMS_USERPICTURE:
                        self.userPicture = dictionary[USERPARAMS_USERPICTURE].string!
                    case USERPARAMS_USERNAME:
                        self.username = dictionary[USERPARAMS_USERNAME].string!
                    case USERPARAMS_BIRTHDAY:
                        self.birthdayStr = dictionary[USERPARAMS_BIRTHDAY].string!
                    case USERPARAMS_EMAIL:
                        self.email = dictionary[USERPARAMS_EMAIL].string!
                    case USERPARAMS_FIRSTNAME:
                        self.firstName = dictionary[USERPARAMS_FIRSTNAME].string!
                    case USERPARAMS_LASTNAME:
                        self.lastName = dictionary[USERPARAMS_LASTNAME].string!
                    case USERPARAMS_USERTYPE:
                        if value.string == USERTYPE_TRAINER {
                            self.userType = UserType.TRN
                        }else{
                            self.userType = UserType.USR
                        }
                    case USERPARAMS_GENDER:
                        if value.string == GENDER_MALE {
                            self.gender = Gender.MAL
                        }else{
                            self.gender = Gender.FEM
                    }
                default:
                    print("KYUser: No key " + key + " recognized for user object model.")
                    
                }
            } else {
                if key == USERPARAMS_PK {
                    self.userId = "\(dictionary[USERPARAMS_PK])"
                }
                
                if key == USERPARAMS_ALLERGIES {
                    if let myAllergies: Array = value.array {
                        for item in myAllergies{
                            self.allergies.append("\(item)")
                        }
                    }
                }
                if key == USERPARAMS_MEDICATIONS {
                    if let myMedications: Array = value.array {
                        for item in myMedications{
                            self.medications.append("\(item)")
                        }
                    }
                }
                if key == USERPARAMS_INJURIES {
                    var injuryDic = Dictionary<String, String>()
                    for (keyItem,valueItem) in value {
                        self.injuries.append(KYInfoData(name:keyItem, date: "\(valueItem)"))
                    }
                }
                if key == USERPARAMS_SURGERIES {
                    var surgeryDic = Dictionary<String, String>()
                    for (keyItem,valueItem) in value {
                        self.surgeries.append(KYInfoData(name:keyItem, date: "\(valueItem)"))
                    }
                }
                if key == USERPARAMS_WEEKLY_AVAILABILITY {
                    self.weeklyAvailability = value.int!
                }
                if key == USERPARAMS_TIME_AVAILABILITY {
					
                    for (keyItem,valueItem) in value {
                        
                        var availabilityList = [Double]()
                        var index = 0
                        
                        if let myAvailabilty: Array = valueItem[keyItem].array {
                            availabilityList = [Double]()
                            index = 0
                            var time = 0.0
                            for item in myAvailabilty{
                                time = item.double!
                                availabilityList.insert(time, atIndex: index)
                                index++
                            }
                        }
                        
                        switch(keyItem){
                        case "0":
                            self.timeAvailability.monday.availability = availabilityList
                        case "1":
                            self.timeAvailability.tuesday.availability = availabilityList
                        case "2":
                            self.timeAvailability.wednesday.availability = availabilityList
                        case "3":
                            self.timeAvailability.thursday.availability = availabilityList
                        case "4":
                            self.timeAvailability.friday.availability = availabilityList
                        case "5":
                            self.timeAvailability.saturday.availability = availabilityList
                        case "6":
                            self.timeAvailability.sunday.availability = availabilityList
                        default:
                            print(valueItem)
                        }
                    }
                }
                
                //errors.append(key)
            }
        }
        
        if(errors.count>0){
            self.username = ""
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }
        
    }
    
    
    
    
    
    var numSectionsForDayCalendar : Int {
        return calendarEventsListByDay.keys.array.count
    }
    
    var calendarEventsForDayCalendar : Dictionary<String, [KYCalendarEvent]>{
        
        for eventItem in calendarEvents {
            let dateStr = eventItem.dateFormat
            
            if contains(calendarEventsListByDay.keys, dateStr) {
                var calEnvents = calendarEventsListByDay[dateStr]
                if (calEnvents!.filter { $0.id == eventItem.id }).isEmpty {
                    calEnvents?.append(eventItem)
                    calendarEventsListByDay.updateValue(calEnvents!, forKey: dateStr)
                }
                
            }else{
                var calEnvents = [KYCalendarEvent]()
                calEnvents.append(eventItem)
                calendarEventsListByDay[dateStr] = calEnvents
            }
            
            let weekOfYear = eventItem.getDate().weekOfYear
            if contains(calendarEventsListByWeekOfYear.keys, weekOfYear){
                var calEnvents = calendarEventsListByWeekOfYear[weekOfYear]!
                if (calEnvents.filter { $0.id == eventItem.id }).isEmpty {
                    calEnvents.append(eventItem)
                    calendarEventsListByWeekOfYear.updateValue(calEnvents, forKey: weekOfYear)
                }
                
            }else{
                var calEnvents = [KYCalendarEvent]()
                calEnvents.append(eventItem)
                calendarEventsListByWeekOfYear[weekOfYear] = calEnvents
            }
        }
        
        return calendarEventsListByDay
    }
    
    var calendarEventsForWeekCalendar : Dictionary<Int, [KYCalendarEvent]>{
        
        if calendarEventsListByWeekOfYear.count > 0 {
            return self.calendarEventsListByWeekOfYear
        }
        
        for eventItem in calendarEvents {
            let dateStr = eventItem.dateFormat
            if contains(calendarEventsListByDay.keys, dateStr) {
                var calEnvents = calendarEventsListByDay[dateStr]
                if (calEnvents!.filter { $0.id == eventItem.id }).isEmpty {
                    calEnvents?.append(eventItem)
                    calendarEventsListByDay.updateValue(calEnvents!, forKey: dateStr)
                }
                
            }else{
                var calEnvents = [KYCalendarEvent]()
                calEnvents.append(eventItem)
                calendarEventsListByDay[dateStr] = calEnvents
            }
            
            let weekOfYear = eventItem.getDate().weekOfYear
            if contains(calendarEventsListByWeekOfYear.keys, weekOfYear) {
                var calEnvents = calendarEventsListByWeekOfYear[weekOfYear]!
                if (calEnvents.filter { $0.id == eventItem.id }).isEmpty {
                    calEnvents.append(eventItem)
                    calendarEventsListByWeekOfYear.updateValue(calEnvents, forKey: weekOfYear)
                }
                
            }else{
                var calEnvents = [KYCalendarEvent]()
                calEnvents.append(eventItem)
                calendarEventsListByWeekOfYear[weekOfYear] = calEnvents
            }
        }
        
        return calendarEventsListByWeekOfYear
    }
    
    func totalNumberWorkoutByWeekDayAndDay(dayOfWeek: Int, weekOfYear: Int)-> (swimHourCounter:Float,cycHourCounter:Float,runHourCounter:Float) {
        
        var swimHourCounter : Float = 0
        var cycHourCounter : Float = 0
        var runHourCounter : Float = 0
        
        if contains(calendarEventsListByWeekOfYear.keys, weekOfYear) {
            let calEvents : [KYCalendarEvent] = calendarEventsListByWeekOfYear[weekOfYear]!.filter { $0.getDate().weekday == dayOfWeek }
            
            let calEvents_Swim = calEvents.filter { $0.sportType == SportType.SWIMMING }
            for eventItem_Swim in calEvents_Swim {
                let durationInHours : Float = eventItem_Swim.activityData.duration.getHoursFromDuration()
                swimHourCounter = swimHourCounter + durationInHours
            }
            
            let calEvents_Cyc = calEvents.filter { $0.sportType == SportType.CYCLING }
            for eventItem_Cyc in calEvents_Cyc {
                let durationInHours : Float = eventItem_Cyc.activityData.duration.getHoursFromDuration()
                cycHourCounter = cycHourCounter + durationInHours
            }
            
            let calEvents_Run = calEvents.filter { $0.sportType == SportType.RUNNING }
            for eventItem_Run in calEvents_Run {
				var cal = eventItem_Run.activityData
				var duration = cal.duration
				var durationInHours = duration.getHoursFromDuration()
                //let durationInHours : Float = eventItem_Run.activityData.duration.getHoursFromDuration()
                runHourCounter = runHourCounter + durationInHours
            }
        }
        
        return (swimHourCounter,cycHourCounter,runHourCounter)
        
    }
    
    func resumeWorkoutBySportWeekDayAndDay(sport: SportType, weekOfYear: Int)-> (timeResume:String,kmResume:String,velResume:String) {
        
        var timeResume : String = "-"
        var kmResume : String = "-"
        var velResume : String = "-"
        
        if contains(calendarEventsListByWeekOfYear.keys, weekOfYear) {
            let calEvents : [KYCalendarEvent] = calendarEventsListByWeekOfYear[weekOfYear]!.filter { $0.sportType == sport }
            
            var listDuration : [String] = []
            var listDistance : [String] = []
            var listPace : [String] = []
            for eventItem in calEvents {
                listDuration.append(eventItem.activityData.duration)
                listDistance.append(eventItem.distance)
                listPace.append(eventItem.pace)
            }
            if listDuration.count > 0 {
                var auxDate = NSDate.date(fromString: listDuration.first!, format: DateFormat.Custom(DATE_FORMAT_DURATION))
                listDuration.removeAtIndex(0)
                var hour : Int
                var min: Int
                var sec: Int
                for item in listDuration {
                    if item != "" {
                        (hour,min,sec) = item.getHourMinSec()
                        auxDate = auxDate!.add(years: nil, months: nil, weeks:nil, days:nil ,hours:hour, minutes: min, seconds: sec)
                        timeResume = (auxDate?.getHoursMinSec())!
                    }
                }
            }
            
        }
        
        return (timeResume,kmResume,velResume)
        
    }
    
	func calendarEventsForWeekDayCalendar(weekOfYear: Int) -> (mList:[UIImageView],tuList:[UIImageView],wList:[UIImageView],thList:[UIImageView],fList:[UIImageView],saList:[UIImageView],sList:[UIImageView]) {
		
        var mListSport : [UIImageView] = []
        var tuListSport : [UIImageView] = []
        var wListSport : [UIImageView] = []
        var thListSport : [UIImageView] = []
        var fListSport : [UIImageView] = []
        var saListSport : [UIImageView] = []
        var sListSport : [UIImageView] = []
        
        let mListSportForWeekDay : [KYCalendarEvent] = getListOfSportFor(weekOfYear, dayOfWeek:1)
        for item in mListSportForWeekDay {
            mListSport.append(item.getIVFromTypeSportImage())
        }
        
        let tuListSportForWeekDay : [KYCalendarEvent] = getListOfSportFor(weekOfYear, dayOfWeek:2)
        for item in tuListSportForWeekDay {
            tuListSport.append(item.getIVFromTypeSportImage())
        }
        
        let wListSportForWeekDay : [KYCalendarEvent] = getListOfSportFor(weekOfYear, dayOfWeek:3)
        for item in wListSportForWeekDay {
            wListSport.append(item.getIVFromTypeSportImage())
        }
        
        let thListSportForWeekDay : [KYCalendarEvent] = getListOfSportFor(weekOfYear, dayOfWeek:4)
        for item in thListSportForWeekDay {
            thListSport.append(item.getIVFromTypeSportImage())
        }
        
        let fListSportForWeekDay : [KYCalendarEvent] = getListOfSportFor(weekOfYear, dayOfWeek:5)
        for item in fListSportForWeekDay {
            fListSport.append(item.getIVFromTypeSportImage())
        }
        
        let saListSportForWeekDay : [KYCalendarEvent] = getListOfSportFor(weekOfYear, dayOfWeek:6)
        for item in saListSportForWeekDay {
            saListSport.append(item.getIVFromTypeSportImage())
        }
        
        let sListSportForWeekDay : [KYCalendarEvent] = getListOfSportFor(weekOfYear, dayOfWeek:7)
        for item in sListSportForWeekDay {
            sListSport.append(item.getIVFromTypeSportImage())
        }
        
        return (mListSport,tuListSport,wListSport,thListSport,fListSport,saListSport,sListSport)
    }
    
    func calendarEventsForWeekDayCalendar(weekOfYear: Int, dayOfWeek: Int) -> [UIImageView] {
        var listSport : [UIImageView] = []
        
        let listSportForWeekDay : [KYCalendarEvent] = getListOfSportFor(weekOfYear, dayOfWeek:dayOfWeek)
        
        for item in listSportForWeekDay {
            listSport.append(item.getIVFromTypeSportImage())
        }
        
        return listSport
    }
    
    func getListOfSportFor(weekOfYear: Int, dayOfWeek: Int) -> [KYCalendarEvent] {
        var calendarEventsListByWeekOfYearAndDayOfWeek : [KYCalendarEvent] = []
        
        if contains(calendarEventsListByWeekOfYear.keys, weekOfYear) {
            let calEnvents : [KYCalendarEvent] = calendarEventsListByWeekOfYear[weekOfYear]!
			for item in calEnvents {
				var d = item.getDate()
				var day = d.weekday
				if day == dayOfWeek {
					calendarEventsListByWeekOfYearAndDayOfWeek.append(item)
				}
			}
            //calendarEventsListByWeekOfYearAndDayOfWeek = calEnvents.filter { $0.getDate().day == dayOfWeek }
            return calendarEventsListByWeekOfYearAndDayOfWeek
        }
        
        return calendarEventsListByWeekOfYearAndDayOfWeek
    }
    
    // MARK: Aux functions
    
    var hasAllergies : Bool {
        return allergies.count > 0
    }
    
    func addAllergy(newAllergy: String) {
        var numberOfAllergies = allergies.count
        allergies.insert(newAllergy, atIndex: numberOfAllergies)
    }
    
    func addMedication(newMedication: String) {
        var numberOfMedications = medications.count
        medications.insert(newMedication, atIndex: numberOfMedications)
    }
    
    func addInjury(newInjury: KYInfoData) {
        var numberOfInjuries = injuries.count
        injuries.insert(newInjury, atIndex: numberOfInjuries)
    }
    
    func addSurgery(newSurgery: KYInfoData) {
        var numberOfSurgeries = surgeries.count
        surgeries.insert(newSurgery, atIndex: numberOfSurgeries)
    }
    
    func addTimeAvailability(time: KYDayAvailability){
        print("addTimeAvailability: \(time.dayname)")
        switch (time.dayname){
        case days[0]:
            var newAvailability = timeAvailability.monday.addArrayAvailability(time.availability)
            timeAvailability.monday.availability = newAvailability
        case days[1]:
            var newAvailability = timeAvailability.tuesday.addArrayAvailability(time.availability)
            timeAvailability.tuesday.availability = newAvailability
        case days[2]:
            var newAvailability = timeAvailability.wednesday.addArrayAvailability(time.availability)
            timeAvailability.wednesday.availability = newAvailability
        case days[3]:
            var newAvailability = timeAvailability.thursday.addArrayAvailability(time.availability)
            timeAvailability.thursday.availability = newAvailability
        case days[4]:
            var newAvailability = timeAvailability.friday.addArrayAvailability(time.availability)
            timeAvailability.friday.availability = newAvailability
        case days[5]:
            var newAvailability = timeAvailability.saturday.addArrayAvailability(time.availability)
            timeAvailability.saturday.availability = newAvailability
        case days[6]:
            var newAvailability = timeAvailability.sunday.addArrayAvailability(time.availability)
            timeAvailability.sunday.availability = newAvailability
        default:
            print("No day.")
        }
    }
    
    var hasMedications : Bool {
        return medications.count > 0
    }
    
    var hasInjuries : Bool {
        return injuries.count > 0
    }
    
    var hasSurgeries : Bool {
        return surgeries.count > 0
    }
	
	var allergiesAPIFormat : String {
		if hasAllergies {
			return applyAPIFormat(allergies)
		}
		return ""
	}
	
	var medicationsAPIFormat : String {
		if hasMedications {
			return applyAPIFormat(medications)
		}
		return ""
	}
	
	var injuriesAPIFormat : String {
		if hasInjuries {
			return applyAPIFormat(injuries)
		}
		return ""
	}
	
	var surgeriesAPIFormat : String {
		if hasSurgeries {
			return applyAPIFormat(surgeries)
		}
		return ""
	}
	
	var timeAvailabilityAPIFormat : String {
		var originalString = "[{\"0\":[\(self.timeAvailability.monday.timeAvailabilityAPIFormat)]},{\"1\":[\(self.timeAvailability.tuesday.timeAvailabilityAPIFormat)]},{\"2\":[\(self.timeAvailability.wednesday.timeAvailabilityAPIFormat)]},{\"3\":[\(self.timeAvailability.thursday.timeAvailabilityAPIFormat)]},{\"4\":[\(self.timeAvailability.friday.timeAvailabilityAPIFormat)]},{\"5\":[\(self.timeAvailability.saturday.timeAvailabilityAPIFormat)]},{\"6\":[\(self.timeAvailability.sunday.timeAvailabilityAPIFormat)]}]"
		//var originalString = "[{0:[\(self.timeAvailability.monday.timeAvailabilityAPIFormat)]},{1:[\(self.timeAvailability.tuesday.timeAvailabilityAPIFormat)]},{2:[\(self.timeAvailability.wednesday.timeAvailabilityAPIFormat)]},{3:[\(self.timeAvailability.thursday.timeAvailabilityAPIFormat)]},{4:[\(self.timeAvailability.friday.timeAvailabilityAPIFormat)]},{5:[\(self.timeAvailability.saturday.timeAvailabilityAPIFormat)]},{6:[\(self.timeAvailability.sunday.timeAvailabilityAPIFormat)]}]"
		
		var escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())

		return escapedString!
	}
	
	func applyAPIFormat(array: [KYInfoData]) -> String{
		var arrayToString = ""
		
		var index = 0
		var counter = array.count
		
		for item in array {
			arrayToString = arrayToString + item.apiformat
			index++
			if index != counter{
				arrayToString = arrayToString + ","
			}
		}
		
		return arrayToString
	}
	
	func applyAPIFormat(array: [String]) -> String{
		var arrayToString = ""
		
		var index = 0
		var counter = array.count
		
		for item in array {
			arrayToString = arrayToString + item
			index++
			if index != counter{
				arrayToString = arrayToString + ","
			}
		}
		
		return arrayToString
	}
	
	func arrayToString(array: [String]) -> String{
		let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
		let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
		return String(string!)
	}
	
    var weekTimeAvailability : Int {
        var weekTimeAvailabilityCounter = 0
        if (timeAvailability.monday.hasAvailabilty){
            var res = 1
            (res, _) = timeAvailability.monday.timeAvailability
            weekTimeAvailabilityCounter = res
        }
        if (timeAvailability.tuesday.hasAvailabilty){
            var res = 1
            (res, _) = timeAvailability.tuesday.timeAvailability
            weekTimeAvailabilityCounter = weekTimeAvailabilityCounter + res
        }
        if (timeAvailability.wednesday.hasAvailabilty){
            var res = 1
            (res, _) = timeAvailability.wednesday.timeAvailability
            weekTimeAvailabilityCounter = weekTimeAvailabilityCounter + res
        }
        if (timeAvailability.thursday.hasAvailabilty){
            var res = 1
            (res, _) = timeAvailability.thursday.timeAvailability
            weekTimeAvailabilityCounter = weekTimeAvailabilityCounter + res
        }
        if (timeAvailability.friday.hasAvailabilty){
            var res = 1
            (res, _) = timeAvailability.friday.timeAvailability
            weekTimeAvailabilityCounter = weekTimeAvailabilityCounter + res
        }
        if (timeAvailability.saturday.hasAvailabilty){
            var res = 1
            (res, _) = timeAvailability.saturday.timeAvailability
            weekTimeAvailabilityCounter = weekTimeAvailabilityCounter + res
        }
        if (timeAvailability.sunday.hasAvailabilty){
            var res = 1
            (res, _) = timeAvailability.sunday.timeAvailability
            weekTimeAvailabilityCounter = weekTimeAvailabilityCounter + res
        }
        
        return weekTimeAvailabilityCounter
    }
    
    var weekTimeAvailabilityItems : [KYTimeAvailability] {
        var weekTimeAvailabilities = [KYTimeAvailability]()
        if (timeAvailability.monday.hasAvailabilty){
            var res = [KYTimeAvailability]()
            (_, res) = timeAvailability.monday.timeAvailability
            weekTimeAvailabilities = res
        }
        if (timeAvailability.tuesday.hasAvailabilty){
            var res = [KYTimeAvailability]()
            (_, res) = timeAvailability.tuesday.timeAvailability
            weekTimeAvailabilities = weekTimeAvailabilities + res
        }
        if (timeAvailability.wednesday.hasAvailabilty){
            var res = [KYTimeAvailability]()
            (_, res) = timeAvailability.wednesday.timeAvailability
            weekTimeAvailabilities = weekTimeAvailabilities + res
        }
        if (timeAvailability.thursday.hasAvailabilty){
            var res = [KYTimeAvailability]()
            (_, res) = timeAvailability.thursday.timeAvailability
            weekTimeAvailabilities = weekTimeAvailabilities + res
        }
        if (timeAvailability.friday.hasAvailabilty){
            var res = [KYTimeAvailability]()
            (_, res) = timeAvailability.friday.timeAvailability
            weekTimeAvailabilities = weekTimeAvailabilities + res
        }
        if (timeAvailability.saturday.hasAvailabilty){
            var res = [KYTimeAvailability]()
            (_, res) = timeAvailability.saturday.timeAvailability
            weekTimeAvailabilities = weekTimeAvailabilities + res
        }
        if (timeAvailability.sunday.hasAvailabilty){
            var res = [KYTimeAvailability]()
            (_, res) = timeAvailability.sunday.timeAvailability
            weekTimeAvailabilities = weekTimeAvailabilities + res
        }
        
        return weekTimeAvailabilities
    }
    
    var dataForTimeAvailability : String {
        var title = dayForCurrentTimeAvailability
        //var descrip = weekTimeAvailabilityItems[currentIndex].description
        return "\(title)"
    }
    
    var dayForCurrentTimeAvailability : String {
        let defaultString = ""
        var dayForCurrentTimeAvailabilityLabel = defaultString
        var counterItems = 0
        let point = (1, -1)
        var res = 1
        var start = 0
        var end = 0
        
        if (currentUser.timeAvailability.monday.hasAvailabilty){
            (end, _) = currentUser.timeAvailability.monday.timeAvailability
            counterItems = end
            var range = Range<Int>(start:start, end: end)
            var index = currentIndex
            switch point {
            case let (x, y) where range ~= index:
                var descrip = weekTimeAvailabilityItems[currentIndex].description
                dayForCurrentTimeAvailabilityLabel = "\(LocalizedString_Day_Monday), \(descrip)"
            default:
                print("Point in range.")
            }
        }
        
        if (currentUser.timeAvailability.tuesday.hasAvailabilty && dayForCurrentTimeAvailabilityLabel == defaultString){
            start = counterItems
            (end, _) = currentUser.timeAvailability.tuesday.timeAvailability
            counterItems = counterItems + end
            end = start + end
            var range = Range<Int>(start:start, end: end)
            switch point {
            case let (x, y) where range ~= currentIndex:
                var descrip = weekTimeAvailabilityItems[currentIndex].description
                dayForCurrentTimeAvailabilityLabel = "\(LocalizedString_Day_Tuesday), \(descrip)"
            default:
                print("Point in range.")
            }
        }
        if (currentUser.timeAvailability.wednesday.hasAvailabilty && dayForCurrentTimeAvailabilityLabel == defaultString){
            start = counterItems
            (end, _) = currentUser.timeAvailability.wednesday.timeAvailability
            counterItems = counterItems + end
            end = start + end
            var range = Range<Int>(start:start, end: end)
            switch point {
            case let (x, y) where range ~= currentIndex:
                var descrip = weekTimeAvailabilityItems[currentIndex].description
                dayForCurrentTimeAvailabilityLabel = "\(LocalizedString_Day_Wednesday), \(descrip)"
            default:
                print("Point in range.")
            }
        }
        if (currentUser.timeAvailability.thursday.hasAvailabilty && dayForCurrentTimeAvailabilityLabel == defaultString){
            start = counterItems
            (end, _) = currentUser.timeAvailability.thursday.timeAvailability
            counterItems = counterItems + end
            end = start + end
            var range = Range<Int>(start:start, end: end)
            switch point {
            case let (x, y) where range ~= currentIndex:
                var descrip = weekTimeAvailabilityItems[currentIndex].description
                dayForCurrentTimeAvailabilityLabel = "\(LocalizedString_Day_Thursday), \(descrip)"
            default:
                print("Point in range.")
            }
        }
        if (currentUser.timeAvailability.friday.hasAvailabilty && dayForCurrentTimeAvailabilityLabel == defaultString){
            start = counterItems
            (end, _) = currentUser.timeAvailability.friday.timeAvailability
            counterItems = counterItems + end
            end = start + end
            var range = Range<Int>(start:start, end: end)
            switch point {
            case let (x, y) where range ~= currentIndex:
                var descrip = weekTimeAvailabilityItems[currentIndex].description
                dayForCurrentTimeAvailabilityLabel = "\(LocalizedString_Day_Friday), \(descrip)"
            default:
                print("Point in range.")
            }
        }
        if (currentUser.timeAvailability.saturday.hasAvailabilty && dayForCurrentTimeAvailabilityLabel == defaultString){
            start = counterItems
            (end, _) = currentUser.timeAvailability.saturday.timeAvailability
            counterItems = counterItems + end
            end = start + end
            var range = Range<Int>(start:start, end: end)
            switch point {
            case let (x, y) where range ~= currentIndex:
                var descrip = weekTimeAvailabilityItems[currentIndex].description
                dayForCurrentTimeAvailabilityLabel = "\(LocalizedString_Day_Saturday), \(descrip)"
            default:
                print("Point in range.")
            }
        }
        if (currentUser.timeAvailability.sunday.hasAvailabilty && dayForCurrentTimeAvailabilityLabel == defaultString){
            start = counterItems
            (end, _) = currentUser.timeAvailability.sunday.timeAvailability
            counterItems = counterItems + end
            end = start + end
            var range = Range<Int>(start:start, end: end)
            switch point {
            case let (x, y) where range ~= currentIndex:
                var descrip = weekTimeAvailabilityItems[currentIndex].description
                dayForCurrentTimeAvailabilityLabel = "\(LocalizedString_Day_Sunday), \(descrip)"
            default:
                print("Point in range.")
            }
        }
        
        return dayForCurrentTimeAvailabilityLabel
    }
    
    var mondayTimeAvailability : Int {
        if (timeAvailability.monday.hasAvailabilty){
            var res = 1
            
            (res, _) = timeAvailability.monday.timeAvailability
            
            return res
        }
        return 0
    }
    
    var mondayTimeAvailabilityItems : [KYTimeAvailability] {
        var res = [KYTimeAvailability]()
        if (timeAvailability.monday.hasAvailabilty){
            (_, res) = timeAvailability.monday.timeAvailability
        }
        return res
    }
    
    var hasWeekAvailability : Bool {
        if (timeAvailability.monday.hasAvailabilty || timeAvailability.tuesday.hasAvailabilty || timeAvailability.wednesday.hasAvailabilty || timeAvailability.thursday.hasAvailabilty || timeAvailability.friday.hasAvailabilty || timeAvailability.saturday.hasAvailabilty || timeAvailability.sunday.hasAvailabilty ){
            return true
        }
        return false
    }
    
    var weeklyAvailabilityDescription : String{
        if weeklyAvailability > 1 {
            return "\(weeklyAvailability) \(LocalizedString_Days)"
		}else if weeklyAvailability == 0 {
			return "No"
		}
        return "\(weeklyAvailability) \(LocalizedString_Days.singular)"
    }
    
    var trainingSinceMonthAndYear : (Int, Int) {
        var date = NSDate()
        if hasTrainingSince {
            date = getTrainingsince()
        }
        return (date.month, date.year)
    }
    
    var trainingSinceMonthAndYearString : String {
        var month = 1
        var year = 1990
        (month, year) = currentUser.trainingSinceMonthAndYear
        return "\(month.monthInString().capitalizeFirst) - \(year)"
    }
    
    var hasTrainingSince : Bool {
        return trainingSince != ""
    }
	
	var senderIsValid : Bool {
		return (firstName != "")
	}
	
    var fullName: String {
        var fullName = self.firstName + " " + self.lastName
        if fullName == " " {
            fullName = username
        }
        if fullName == " " {
            fullName = "User without name"
        }
        return fullName
    }
    
    var isValid: Bool {
        return (username != "")
    }
    
    var isCoach: Bool {
        return (userType == UserType.TRN)
    }
    
    func setLogin(username un:String, password p: String, token t:String){
        self.usernameLogin = un
        self.passwordLogin = p
        self.tokenLogin = t
    }
    
    func getTrainingsince()->NSDate{
        return trainingSince.toDate(formatString: DATE_FORMAT)!
    }
    
    func getBirthday()->NSDate{
        return birthdayStr.toDate(formatString: DATE_FORMAT)!
    }
    
    func existCalendarEvents()->Bool{
        return calendarEvents.count>0
    }
    
    func existRecentActivity()->Bool{
        return recentActivity.count>0
    }
    
    var description: String {
        return "Username: \(username), email: \(email), firstName: \(firstName), birthday: \(birthdayStr)\n"
    }
    
    func updateValue(idx:Int, value:String){
        switch(idx){
        case 0:
            self.firstName = value
        case 1:
            self.lastName = value
        case 2:
            self.birthdayStr = value
        case 3:
            self.gender = Gender.MAL
            if value == GENDER_FEMALE{
                self.gender = Gender.FEM
            }
        case 4:
            self.login.username = value
        case 5:
            self.email = value
        case 6:
            self.login.password = value
        default:
            print("Error updating value in current user.")
            
        }
    }
    
    var hasAccesories : Bool {
        return accesories.count>0
    }
	
	var hasMessages : Bool {
		return listMessage.count>0
	}
	
	var hasMessagesInbox : Bool {
		return listMessageInbox.count>0
	}
	
	var hasMessagesOutbox : Bool {
		return listMessageOutbox.count>0
	}
	
	var hasMessagesTrash : Bool {
		return listMessageTrash.count>0
	}
	
	var hasAccessories : Bool {
		return listAccSwim.count>0 || listAccCyc.count>0 || listAccRun.count>0 || listAccGym.count>0
	}
	
}
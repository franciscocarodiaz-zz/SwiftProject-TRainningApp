//
//  StringMethods.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 24/07/15.
//  Copyright © 2015 kyperion. All rights reserved.
//

import UIKit

extension String {
    
    var dateFormat : String {
        let date_custom = NSDate.date(fromString: self, format: DateFormat.Custom(DATE_FORMAT))
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
    
    var dateFormatActivity : String {
        let date_custom = NSDate.date(fromString: self, format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
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
    
    var singular:String{
        return self.substringToIndex(self.endIndex.predecessor())
    }
    
    var capitalizeFirst:String {
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).capitalizedString)
        return result
    }
    
    var length: Int {
        return count(self)
    }
    
    func isEmail() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    func getHoursFromDuration() -> Float {
        // Str ex => "6:47:26"
        if self == "" {
            return 0
        }
        let MIN_IN_HOURS = Float(60)
        let SEC_IN_HOURS = Float(3600)
        
        let date_custom = NSDate.date(fromString: self, format: DateFormat.Custom(DATE_FORMAT_DURATION))
        let hour: Float = Float((date_custom?.hour)!)
        let hMinute: Float = Float((date_custom?.minute)!) / MIN_IN_HOURS
        let hSeconds: Float = Float((date_custom?.second)!) / SEC_IN_HOURS
        let hours: Float = hour + hMinute + hSeconds
        
        print("Event>> \(self) >> In hours: \(hours)")
        
        return hours
    }
    
    func getHourMinSec() -> (hour: Int,min: Int,sec: Int) {
        // Str ex => "6:47:26"
        
        var hour: Int = 0
        var min: Int = 0
        var sec: Int = 0
        if self != "" {
            let date_custom = NSDate.date(fromString: self, format: DateFormat.Custom(DATE_FORMAT_DURATION))
            hour = (date_custom?.hour)!
            min = (date_custom?.minute)!
            sec = (date_custom?.second)!
            
        }
        
        return (hour, min, sec)
    }
    
    func getMinutes() -> (hour: Int,min: Int,sec: Int) {
        // Str ex => "6:47:26"
        
        var hour: Int = 0
        var min: Int = 0
        var sec: Int = 0
        if self != "" {
            let date_custom = NSDate.date(fromString: self, format: DateFormat.Custom(DATE_FORMAT_DURATION))
            hour = (date_custom?.hour)!
            min = (date_custom?.minute)!
            sec = (date_custom?.second)!
            
        }
        
        return (hour, min, sec)
    }
    
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    
    func toDoubleTimeAvailabilityFormat() -> Double? {
        if self.length > 2 {
            var firstPart = split(self) {$0 == "."}[0]
            return firstPart.toDouble()! + 0.5
        }
        return self.toDouble()!
    }
    
    func toDoubleTimeAvailabilityFormat24() -> Double? {
        let newString = self.stringByReplacingOccurrencesOfString(":", withString: ".")
        if self.length > 2 {
            var firstPart = split(newString) {$0 == "."}[0]
            var secondPart = split(newString) {$0 == "."}[1]
            if secondPart == "00" {
                return firstPart.toDouble()!
            }else{
                return firstPart.toDouble()! + 0.5
            }
        }
        return self.toDouble()!
    }
    
}

extension Int {
    
    func monthInString() -> String{
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        
        let months = dateFormatter.monthSymbols
        let monthSymbol = months[self-1] as! String
        return monthSymbol
    }
    
    func formattedTime() -> String
    {
        var totalSeconds = self
        var seconds : Int = totalSeconds % 60;
        var minutes : Int  = (totalSeconds / 60) % 60;
        var hours : Int  = totalSeconds / 3600;
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formattedTimeInseconds() -> Int
    {
        var totalSeconds = self
        return totalSeconds
    }
    
    func formattedTimeInMinutes() -> Int
    {
        var totalSeconds = self
        var minutes : Int  = totalSeconds / 60;
        return minutes
    }
    
    func formattedTimeInHours() -> Int
    {
        var totalSeconds = self
        var seconds : Int = (totalSeconds % 60) / 3600;
        var hour : Int  = totalSeconds / 3600;
        var minutes : Int  = ((totalSeconds / 60) % 60) / 60;
        
        var hours : Int  = seconds + minutes + hour;
        return hours
    }
}

extension Double{
    
    func formattedTime() -> String
    {
        var totalSeconds = Int(self)
        var seconds : Int = totalSeconds % 60;
        var minutes : Int  = (totalSeconds / 60) % 60;
        var hours : Int  = totalSeconds / 3600;
        var res = ""
        var formatMin = "%02d"
        if minutes < 10 {
            formatMin = "%01d"
        }
        if hours < 10 {
            formatMin = "%01d"
        }
        if hours > 1 {
            res = String(format:"\(formatMin):\(formatMin):%02d", hours, minutes, seconds)
        }else{
            res = String(format:"\(formatMin):%02d", minutes, seconds)
        }
        return res
    }
    
    func formattedCounter() -> String
    {
        if self == 0.0 {
            return String(format:"%01d", self)
        }
        if self.isNaN {
            return "0"
        }
        return String(format:"%02d", self)
    }
    
    var roundedTwoDigit:Double{
        return Double(round(100*self)/100)
        
    }
    
    func toTimeAvailabilityFormat() -> String {
        
        if (self == 0 || self == 24){
            return "12 a.m."
        }else if (self == 0.5){
            return "12.30 a.m."
        }else if (self == 1){
            return "1 a.m."
        }else if (self == 1.5){
            return "1.30 a.m."
        }else if (self == 2){
            return "2 a.m."
        }else if (self == 2.5){
            return "2.30 a.m."
        }else if (self == 3){
            return "3 a.m."
        }else if (self == 3.5){
            return "3.30 a.m."
        }else if (self == 4){
            return "4 a.m."
        }else if (self == 4.5){
            return "4.30 a.m."
        }else if (self == 5){
            return "5 a.m."
        }else if (self == 5.5){
            return "5.30 a.m."
        }else if (self == 6){
            return "6 a.m."
        }else if (self == 6.5){
            return "6.30 a.m."
        }else if (self == 7){
            return "7 a.m."
        }else if (self == 7.5){
            return "7.30 a.m."
        }else if (self == 8){
            return "8 a.m."
        }else if (self == 8.5){
            return "8.30 a.m."
        }else if (self == 9){
            return "9 a.m."
        }else if (self == 9.5){
            return "9.30 a.m."
        }else if (self == 10){
            return "10 a.m."
        }else if (self == 10.5){
            return "10.30 a.m."
        }else if (self == 11){
            return "11 a.m."
        }else if (self == 11.5){
            return "11.30 a.m."
        }else if (self == 12){
            return "12 p.m."
        }else if (self == 12.5){
            return "12.30 p.m."
        }else if (self == 13){
            return "13h"
        }else if (self == 13.5){
            return "13.30h"
        }else if (self == 14){
            return "14h"
        }else if (self == 14.5){
            return "14.30h"
        }else if (self == 15){
            return "15h"
        }else if (self == 15.5){
            return "15.30h"
        }else if (self == 16){
            return "16h"
        }else if (self == 16.5){
            return "16.30h"
        }else if (self == 17){
            return "17h"
        }else if (self == 17.5){
            return "17.30h"
        }else if (self == 18){
            return "18h"
        }else if (self == 18.5){
            return "18.30h"
        }else if (self == 19){
            return "19h"
        }else if (self == 19.5){
            return "19.30h"
        }else if (self == 20){
            return "20h"
        }else if (self == 20.5){
            return "20.30h"
        }else if (self == 21){
            return "21h"
        }else if (self == 21.5){
            return "21.30h"
        }else if (self == 22){
            return "22h"
        }else if (self == 22.5){
            return "22.30h"
        }else if (self == 23){
            return "23h"
        }else if (self == 23.5){
            return "23.30h"
        }
        return ""
    }
    
    func toTimeAvailabilityFormat24() -> String {
        
        if (self == 0){
            return "00:00"
        }else if (self == 0.5){
            return "00:30"
        }else if (self == 1){
            return "1:00"
        }else if (self == 1.5){
            return "1:30"
        }else if (self == 2){
            return "2:00"
        }else if (self == 2.5){
            return "2:30"
        }else if (self == 3){
            return "3:00"
        }else if (self == 3.5){
            return "3:30"
        }else if (self == 4){
            return "4:00"
        }else if (self == 4.5){
            return "4:30"
        }else if (self == 5){
            return "5:00"
        }else if (self == 5.5){
            return "5:30"
        }else if (self == 6){
            return "6:00"
        }else if (self == 6.5){
            return "6:30"
        }else if (self == 7){
            return "7:00"
        }else if (self == 7.5){
            return "7:30"
        }else if (self == 8){
            return "8:00"
        }else if (self == 8.5){
            return "8:30"
        }else if (self == 9){
            return "9:00"
        }else if (self == 9.5){
            return "9:30"
        }else if (self == 10){
            return "10:00"
        }else if (self == 10.5){
            return "10:30"
        }else if (self == 11){
            return "11:00"
        }else if (self == 11.5){
            return "11:30"
        }else if (self == 12){
            return "12:00"
        }else if (self == 12.5){
            return "12:30"
        }else if (self == 13){
            return "13:00"
        }else if (self == 13.5){
            return "13:30"
        }else if (self == 14){
            return "14:00"
        }else if (self == 14.5){
            return "14:30"
        }else if (self == 15){
            return "15:00"
        }else if (self == 15.5){
            return "15:30"
        }else if (self == 16){
            return "16:00"
        }else if (self == 16.5){
            return "16:30"
        }else if (self == 17){
            return "17:00"
        }else if (self == 17.5){
            return "17:30"
        }else if (self == 18){
            return "18:00"
        }else if (self == 18.5){
            return "18:30"
        }else if (self == 19){
            return "19:00"
        }else if (self == 19.5){
            return "19:30"
        }else if (self == 20){
            return "20:00"
        }else if (self == 20.5){
            return "20:30"
        }else if (self == 21){
            return "21:00"
        }else if (self == 21.5){
            return "21:30"
        }else if (self == 22){
            return "22:00"
        }else if (self == 22.5){
            return "22:30"
        }else if (self == 23){
            return "23:00"
        }else if (self == 23.5){
            return "23:30"
        }
        return ""
    }
    
}

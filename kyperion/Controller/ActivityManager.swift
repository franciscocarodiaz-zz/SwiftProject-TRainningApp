//
//  ActivityManager.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 02/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire

@objc protocol activityManagerDelegate:NSObjectProtocol {
    
    // MARK: Login,Register methods
    optional func ActivityManagerRespond(activityData: AnyObject)
    optional func ActivityManagerRespondFailure(msgError: String)
    
    optional func ActivityManagerRespondTP(trainingPlanData: KYTrainingPlan)
    
    // Laps
    optional func ActivityManagerRespondLapsReceived()
    
    // Calendar
    optional func ActivityManagerRespondCalendarReceived()
}

class ActivityManager: NSObject, activityManagerDelegate {
    
    // MARK: Activity properties
    
    var delegate: activityManagerDelegate?
    var manager: Manager?
    var managerActivity: Manager?
    
    var request: NSURLRequest?
    var response: NSHTTPURLResponse?
    var data: AnyObject?
    var error: NSError?
    var JSON: AnyObject?
    
    override init() {
        self.manager = Alamofire.Manager()
        self.manager!.startRequestsImmediately = true
    }
    
    // MARK: Activity methods
    
    
    func getListActivity(){
        
        let urlString = API(caseAPI:CONST_API_AUTH_ACTIVITY_USER).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            
            if(error == nil){
                var activity = KYActivity(listActivityData: data)
                self.delegate?.ActivityManagerRespond!(activity)
            }else{
                self.delegate?.ActivityManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
        
    }
    
    func getTrainingPlan(){
        
        var urlString = API(caseAPI:CONST_API_PLAN_GET_PLAN).url + currentTrainingPlan.id + URL_SEPARATOR
        if DEBUG_MOD {
            urlString = API(caseAPI:CONST_API_PLAN_GET_PLAN).url + "165" + URL_SEPARATOR
        }
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            
            if(error == nil){
                var trainingPlan = KYTrainingPlan(data)
                self.delegate?.ActivityManagerRespondTP!(trainingPlan)
            }else{
                //self.delegate?.ActivityManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
        
    }
    
    func getLaps(){
        
        var urlString = API(caseAPI:CONST_API_PLAN_GET_LAPS_OF_ACTIVITY).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            
            if(error == nil){
                var laps = KYLap(listLapData:data)
                
                self.delegate?.ActivityManagerRespondLapsReceived!()
            }else{
                //self.delegate?.ActivityManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
        
    }
    
    func getDayCalendar(currentMonth: Int){
        
        let userId = currentUser.userId
        let currentDate = NSDate()
        let currentMonthStr = "\(currentMonth)"
        let currentDay = "\(currentDate.day)"
        let currentYear = "\(currentDate.year)"
        
        //let urlCalendarDay = API_ROOT+"/api/v1/calendar/events/y"+currentYear+"/m"+currentMonth+"/d"+currentDay+"/?user="+userId
        let urlCalendarDay = API_ROOT+"/api/v1/calendar/events/y"+currentYear+"/m"+currentMonthStr+"/?user="+userId
        let mutableURLRequestDay = NSMutableURLRequest(URL: NSURL(string: urlCalendarDay)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequestDay.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequestDay).responseJSON {
            (request, response, data, error) -> Void in
            
            if(error == nil){
                if let info = data!["detail"] as? String {
                    /*
                    let urlString = API(caseAPI:CONST_API_AUTH_USER).url
                    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
                    let keyStr = "Token \(tokenUser)"
                    mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
                    self.request = Alamofire.request(mutableURLRequest)
                    */
                }else{
                    NSNotificationCenter.defaultCenter().postNotificationName(updateCalendarDayNotificationKey, object: data)
                    var cMonth = currentMonth - 1
                    if cMonth > 0 {
                        self.getDayCalendar(cMonth)
                    }
                }
            }
        }
        
    }
    
    func getWeekCalendar(dates: [NSDate]){
        
        for item in dates {
            let userId = currentUser.userId
            let currentDate = NSDate()
            let currentMonth = "\(currentDate.month)"
            let currentYear = "\(currentDate.year)"
            let currentDay = "\(currentDate.day)"
            
            let urlCalendarWeek = API_ROOT+"/api/v1/calendar/events/weekly/y"+currentYear+"/m"+currentMonth+"/d"+currentDay+"/?user="+userId
            let mutableURLRequestWeek = NSMutableURLRequest(URL: NSURL(string: urlCalendarWeek)!)
            let keyStr = "Token \(tokenUser)"
            mutableURLRequestWeek.setValue(keyStr, forHTTPHeaderField: "authorization")
            
            self.manager!.request(mutableURLRequestWeek).responseJSON {
                (request, response, data, error) -> Void in
                
                if(error == nil){
                    if let info = data!["detail"] as? String {
                        /*
                        let urlString = API(caseAPI:CONST_API_AUTH_USER).url
                        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
                        let keyStr = "Token \(tokenUser)"
                        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
                        self.request = Alamofire.request(mutableURLRequest)
                        */
                    }else{
                        NSNotificationCenter.defaultCenter().postNotificationName(updateCalendarWeekNotificationKey, object: data)
                    }
                }
            }
        }
        
        
        
        
    }
    
}

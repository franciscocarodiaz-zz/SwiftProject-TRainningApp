//
//  ModelController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Alamofire

/*
A controller object that manages a simple model -- a collection of month names.

The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.

There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
*/


class ModelController: NSObject, UIPageViewControllerDataSource, activityManagerDelegate {
    
    var pageCalendarTitle: [String] = []
    var pageCalendarDates: [NSDate] = []
    var weekIndex: [Int] = []
    
    var mondayDataObject: [UIImageView] = []
    var tuesdayDataObject: [UIImageView] = []
    var wednesdayDataObject: [UIImageView] = []
    var thursdayDataObject: [UIImageView] = []
    var fridayDataObject: [UIImageView] = []
    var saturdayDataObject: [UIImageView] = []
    var sundayDataObject: [UIImageView] = []
    var daysDataObject : [[UIImageView]] = []
    var weekDataObject : [[UIImageView]] = []
    
    var activityApiManager: ActivityManager?
    
    override init() {
        super.init()
        // Create the data model.
        
        self.activityApiManager = ActivityManager()
        self.activityApiManager?.delegate = self
        
        mondayDataObject = [AssetsManager.cyclingImageVw,AssetsManager.gymImageVw, AssetsManager.runningImageVw, AssetsManager.swimmingImageVw, AssetsManager.cyclingImageVw]
        tuesdayDataObject = [AssetsManager.gymImageVw, AssetsManager.runningImageVw, AssetsManager.swimmingImageVw]
        wednesdayDataObject = [AssetsManager.cyclingImageVw,AssetsManager.gymImageVw, AssetsManager.swimmingImageVw]
        thursdayDataObject = [AssetsManager.cyclingImageVw]
        fridayDataObject = [AssetsManager.cyclingImageVw,AssetsManager.runningImageVw, AssetsManager.swimmingImageVw]
        saturdayDataObject = [AssetsManager.cyclingImageVw]
        sundayDataObject = [AssetsManager.gymImageVw, AssetsManager.runningImageVw, AssetsManager.swimmingImageVw]
        
        daysDataObject = [mondayDataObject, tuesdayDataObject, wednesdayDataObject, thursdayDataObject, fridayDataObject, saturdayDataObject, sundayDataObject]
        //weekDataObject.append(daysDataObject)
        
        daysDataObject = [fridayDataObject, saturdayDataObject, sundayDataObject, mondayDataObject, tuesdayDataObject, wednesdayDataObject, thursdayDataObject]
        //weekDataObject.append(daysDataObject)
        
        let paginator = currentUser.calendarEventsForWeekCalendar.keys.array
        let pages = paginator.sorted({ $0 < $1 })
        var count : Int  = 0
        for weekNumber in pages {
            weekIndex.append(weekNumber)
            let eventDate : NSDate = (Array(currentUser.calendarEventsForWeekCalendar.values)[count][0]).getDate()
            pageCalendarTitle.append("\(eventDate.firstDayOfWeekString) - \(eventDate.lastDayOfWeekString)")
            pageCalendarDates.append(eventDate)
            
            /*
            let userId = currentUser.userId
            let currentDate = eventDate
            let currentMonth = "\(currentDate.month)"
            let currentDay = "\(currentDate.day)"
            let currentYear = "\(currentDate.year)"
            let keyStr = "Token \(tokenUser)"
            
            let urlCalendarWeek = API_ROOT+"/api/v1/calendar/events/weekly/y"+currentYear+"/m"+currentMonth+"/d"+currentDay+"/?user="+userId
            let mutableURLRequestWeek = NSMutableURLRequest(URL: NSURL(string: urlCalendarWeek)!)
            mutableURLRequestWeek.setValue(keyStr, forHTTPHeaderField: "authorization")
            
            Alamofire.request(mutableURLRequestWeek).responseJSON {
                (request, response, data, error) -> Void in
                
                if(error == nil){
                    NSNotificationCenter.defaultCenter().postNotificationName(updateCalendarWeekNotificationKey, object: data)
                }
            }
            */
            
            count++
        }
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> WeekDataViewController? {
        // Return the data view controller for the given index.
        if (self.pageCalendarTitle.count == 0) || (index >= self.pageCalendarTitle.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("WeekDataViewController") as! WeekDataViewController
        dataViewController.dataObject = self.pageCalendarTitle[index]
        dataViewController.weekIndex = self.weekIndex[index]
        
        /*
        let userId = currentUser.userId
        var currentDate = self.pageCalendarDates[index]
        let currentMonth = "\(currentDate.month)"
        let currentDay = "\(currentDate.day)"
        let currentYear = "\(currentDate.year)"
        let keyStr = "Token \(tokenUser)"
        
        let urlCalendarWeek = API_ROOT+"/api/v1/calendar/events/weekly/y"+currentYear+"/m"+currentMonth+"/d"+currentDay+"/?user="+userId
        let mutableURLRequestWeek = NSMutableURLRequest(URL: NSURL(string: urlCalendarWeek)!)
        mutableURLRequestWeek.setValue(keyStr, forHTTPHeaderField: "authorization")
        dataViewController.requestCalendarWeek = Alamofire.request(mutableURLRequestWeek)
        */
        
        let (mList,tuList,wList,thList,fList,saList,sList) = currentUser.calendarEventsForWeekDayCalendar(self.weekIndex[index])
        self.weekDataObject = [mList,tuList,wList,thList,fList,saList,sList]
        
        dataViewController.weekDataObject = weekDataObject
        let lastIndex = self.pageCalendarTitle.count - 1
        dataViewController.hasPreviousWeek = index > 0
        dataViewController.hasNextWeek = index < lastIndex
        dataViewController.numColumn = 7
        
        return dataViewController
    }
    
    func indexOfViewController(viewController: WeekDataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        var index : Int = 0
        for item in pageCalendarTitle {
            if item == viewController.dataObject {
                return index
            }
            index = index + 1
        }
        return index
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! WeekDataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! WeekDataViewController)
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == self.pageCalendarTitle.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
}


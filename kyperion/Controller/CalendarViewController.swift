//
//  SecondExampleVC.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CalendarViewController: UIViewController {

    @IBOutlet var swiftPagesView: SwiftPages!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTrainingPlanDayNotification:", name: updateCalendarDayNotificationKey, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTrainingPlanWeekNotification:", name: updateCalendarWeekNotificationKey, object: nil)
        
        //Sample customization
        swiftPagesView.setOriginY(0.0)
        swiftPagesView.setOriginY(0.0)
        swiftPagesView.setTopBarHeight(30)
        swiftPagesView.enableAeroEffectInTopBar(false)
        swiftPagesView.setButtonsTextColor(UIColor.mainAppColor())
        swiftPagesView.setAnimatedBarColor(UIColor.mainAppColor())
        
        // Init
        let VCIDs : [String] = ["DayCalendar", "WeekCalendarViewController"]
        let buttonTitles : [String] = ["Day", "Week"]
        swiftPagesView.section = swiftPagesView.VC_CALENDAR
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
     
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification Center
    
    func updateTrainingPlanDayNotification(notification: NSNotification) {
        
        let data = SwiftyJSON.JSON(notification.object!)
        
        if let calendarEventArray = data.array {
            let tomorrowDate = NSDate.tomorrow()
            for calendarEventItem in calendarEventArray {
                let event : KYCalendarEvent = KYCalendarEvent(calendarEventItem)
                if event.getDate() < tomorrowDate {
                    if (currentUser.calendarEvents.filter { $0.id == event.id }).isEmpty {
                        currentUser.calendarEvents.append(event)
                    }
                }
            }
            currentUser.calendarEvents.sort({ $0.getDate().compare($1.getDate()) == NSComparisonResult.OrderedDescending })
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(updateTrainingPlanDayTableNotificationKey, object: nil)
        
    }
    
    // MARK: Auxiliar functions
    
    // MARK: - Notification Center
    
    func updateTrainingPlanWeekNotification(notification: NSNotification) {
        
        let data = SwiftyJSON.JSON(notification.object!)
        print(data)
        
        if let calendarEventArray = data.array {
            for calendarEventItem in calendarEventArray {
                let event : KYCalendarEvent = KYCalendarEvent(calendarEventItem)
                if (currentUser.calendarEvents.filter { $0.id == event.id }).isEmpty {
                    currentUser.calendarEvents.append(event)
                }
            }
            currentUser.calendarEvents.sort({ $0.getDate().compare($1.getDate()) == NSComparisonResult.OrderedDescending })
        }
        NSNotificationCenter.defaultCenter().postNotificationName(updateModelControllerNotificationKey, object: nil)
    }
    
    // MARK: - Loader
    
    func displayLoaderWithMessage(textMessage: String){
        KYHUD.sharedHUD.contentView = KYHUDSubtitleView(subtitle: textMessage)
        KYHUD.sharedHUD.show()
    }
    
    func hideLoader(delay: NSTimeInterval = 1.0){
        KYHUD.sharedHUD.hide(afterDelay: delay)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

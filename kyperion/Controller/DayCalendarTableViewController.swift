//
//  DayCalendarTableViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DayCalendarTableViewController: UITableViewController, activityManagerDelegate {

    var activityApiManager: ActivityManager?
    
    var currentMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.activityApiManager = ActivityManager()
        self.activityApiManager?.delegate = self
        
        if currentUser.calendarEventsListByDay.count == 0 {
            let currentDate = NSDate()
            let currentMonth = currentDate.month - 1
            self.activityApiManager?.getDayCalendar(currentMonth)
        }
        
        //currentUser.calendarEvents.sort({ $0.getDate().compare($1.getDate()) == NSComparisonResult.OrderedDescending })
        UIDatePickerMode.Date
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTrainingPlanDayTableNotification:", name: updateTrainingPlanDayTableNotificationKey, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTrainingPlanDayTableNotification:", name: updateModelControllerNotificationKey, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTrainingPlanTVDayTableNotification:", name: updateTrainingPlanTVDayTableNotificationKey, object: nil)
        
        
        //self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //assuming some_table_data respresent the table data
        let numberOfSectionsInTableView : Int = currentUser.calendarEventsForDayCalendar.count
        
        if (numberOfSectionsInTableView == 0) {
            createLabelNoData()
        }else{
            self.tableView.backgroundView = nil
        }
        
        //number of sections in this table
        return numberOfSectionsInTableView;
    }
    
    func createLabelNoData(){
        var messageLbl :UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
        
        //set the message
        messageLbl.text = LocalizedString_EMPTY_LIST_CALENDAR
        //center the text
        messageLbl.textAlignment = NSTextAlignment.Center;
        //auto size the text
        messageLbl .sizeToFit()
        messageLbl.textColor = UIColor.grayColor()
        
        //set back to label view
        self.tableView.backgroundView = messageLbl;
        //no separator
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let days = currentUser.calendarEventsForDayCalendar.keys.array
        let numberOfRowsInSection : Int = KYCalendarEvent.getNumberOfEvents(days[section])
        
        return numberOfRowsInSection
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CalendarEventCell", forIndexPath: indexPath) as! UITableViewCell
        
        // 1. Get calendar activity
        let numberOfSectionInTableView : Int = indexPath.section
        let numberOfIndexInSectionInTableView : Int = indexPath.row
        
        let days = currentUser.calendarEventsForDayCalendar.keys.array
        let calendarEvent : KYCalendarEvent = KYCalendarEvent.getEvent(days[numberOfSectionInTableView], numberOfSelection: numberOfIndexInSectionInTableView)
        
        // 2. Set name
        cell.textLabel?.text = calendarEvent.eventTitle
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        
        // 3. set detail -> if (type==TRAININGACTIVITY) Display: trainer name + estimate date
        //                  else if (type==ACTIVITY) Display: time +  km + velocity
        cell.detailTextLabel?.text = calendarEvent.calendarEventDetailInfo
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
        
        // 4. Set icon
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.imageView?.image = calendarEvent.getTypeSportImage()
        
        // Configure the cell...

        return cell
    }
    
    override func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        let days = currentUser.calendarEventsForDayCalendar.keys.array
        let dateStr : String = days[section]
        return dateStr
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.mainAppColor()
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        header.textLabel.font = UIFont.boldSystemFontOfSize(18.0)
        
        header.alpha = 0.8 //make the header transparent
    }

    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 1. Get calendar activity
        let numberOfSectionInTableView : Int = indexPath.section
        let numberOfIndexInSectionInTableView : Int = indexPath.row
        let days = currentUser.calendarEventsForDayCalendar.keys.array
        let calendarEvent : KYCalendarEvent = KYCalendarEvent.getEvent(days[numberOfSectionInTableView], numberOfSelection: numberOfIndexInSectionInTableView)
        
        calendarEvent.trainingPlanData.date = calendarEvent.date
        var trainingPlanDataSelected = calendarEvent.trainingPlanData
        currentTrainingPlan = trainingPlanDataSelected
        
        performSegueWithIdentifier(seguePlanningViewController, sender: nil)
        
        
        // 2. Configure cell
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        //selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PlanningViewController") as! PlanningViewController
        vc.trainingPlan = trainingPlanDataSelected
        
        self.presentViewController(vc, animated: true) { () -> Void in
            let urlGetPlan = API(caseAPI:CONST_API_AUTH_ACTIVITY_USER).url + trainingPlanDataSelected.id
            let mutableURLRequestDay = NSMutableURLRequest(URL: NSURL(string: urlGetPlan)!)
            let keyStr = "Token \(tokenUser)"
            mutableURLRequestDay.setValue(keyStr, forHTTPHeaderField: "authorization")
            vc.request = Alamofire.request(mutableURLRequestDay)
        }

    }
    */
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    func mainNavigationController() -> KYNavigationController {
        return self.storyboard?.instantiateViewControllerWithIdentifier("kyNavigationViewController") as! KYNavigationController
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_PLANNING_VC {
            if let destination = segue.destinationViewController as? PlanningViewController {
                if let row = tableView.indexPathForSelectedRow()?.row {
                    if let section = tableView.indexPathForSelectedRow()?.section {
                        
                        displayLoaderWithMessage(MSG_LOADING_TP)
                        
                        let numberOfSectionInTableView : Int = section
                        let numberOfIndexInSectionInTableView : Int = row
                        let days = currentUser.calendarEventsForDayCalendar.keys.array
                        let calendarEvent : KYCalendarEvent = KYCalendarEvent.getEvent(days[numberOfSectionInTableView], numberOfSelection: numberOfIndexInSectionInTableView)
                        
                        calendarEvent.trainingPlanData.date = calendarEvent.date
                        var trainingPlanDataSelected = calendarEvent.trainingPlanData
                        currentTrainingPlan = trainingPlanDataSelected
                        
                        /*
                        let urlGetPlan = API(caseAPI:CONST_API_PLAN_GET_PLAN).url + currentTrainingPlan.id + URL_SEPARATOR
                        let mutableURLRequestDay = NSMutableURLRequest(URL: NSURL(string: urlGetPlan)!)
                        let keyStr = "Token \(tokenUser)"
                        mutableURLRequestDay.setValue(keyStr, forHTTPHeaderField: "authorization")
                        
                        let manager = Alamofire.Manager.sharedInstance
                        manager.session.configuration.HTTPAdditionalHeaders = ["authorization": "Token \(tokenUser)"]
                        destination.request = manager.request(.POST, mutableURLRequestDay, parameters: nil, encoding: .JSON)
                        */
                        
                        /*
                        let manager = Alamofire.Manager.sharedInstance
                        manager.session.configuration.HTTPAdditionalHeaders = ["authorization": "Token \(tokenUser)"]
                        
                        let urlString = API(caseAPI:CONST_API_PLAN_GET_PLAN).url + currentTrainingPlan.id + URL_SEPARATOR
                        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
                        
                        mutableURLRequest.setValue("Token \(tokenUser)", forHTTPHeaderField: "authorization")
                        
                        destination.request = manager.request(.POST, urlString, parameters: ["authorization": "Token \(tokenUser)"], encoding: .JSON)
                        */
                        
                    }
                }
            }
        }
    }
    
    // MARK: - Notification Center
    
    func updateTrainingPlanDayTableNotification(notification: NSNotification) {
        hideLoader()
        self.tableView.reloadData()
    }
    
    func updateTrainingPlanTVDayTableNotification(notification: NSNotification) {
        self.tableView.reloadData()
        self.view.reloadInputViews()
    }
    
    // MARK: - Loader
    
    func displayLoaderWithMessage(textMessage: String){
        KYHUD.sharedHUD.contentView = KYHUDSubtitleView(subtitle: textMessage)
        KYHUD.sharedHUD.show()
    }
    
    func hideLoader(delay: NSTimeInterval = 0.3){
        KYHUD.sharedHUD.hide(afterDelay: delay)
    }

}

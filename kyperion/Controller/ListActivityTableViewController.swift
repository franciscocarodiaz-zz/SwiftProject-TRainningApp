//
//  ListActivityTableViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class ListActivityTableViewController: UITableViewController, activityManagerDelegate {

    var activityApiManager: ActivityManager?
    
    func reloadScreen() {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadScreen", name: UIApplicationWillEnterForegroundNotification, object: nil )
        
        self.title = LocalizedString_ProfileManager_ListActivityVC
        
        self.activityApiManager = ActivityManager()
        self.activityApiManager?.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if currentUser.listActivity.count == 0 {
            self.activityApiManager?.getListActivity()
        }
        
        self.navigationController?.navigationBarHidden = true
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.activityApiManager = nil
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return (currentUser.listActivity.count + 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityProfileCell", forIndexPath: indexPath) as! UITableViewCell
        /*
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
            cell.imageView!.image = nil
        }else{
        */
        let event : KYCalendarActivityData = currentUser.listActivity[indexPath.row]
            
            // Configure the cell...
            
            cell.textLabel!.text = "\(event.activityName), \(event.dateFormat)"
            cell.textLabel!.font = UIFont.systemFontOfSize(12)
            // 2. Image
            cell.imageView!.image = event.getTypeSportImage()
            
            // 3. Username
            cell.detailTextLabel!.text = "\(event.activityInfo)"
            
            // 4. Data
            //cell.dataActivity.text = event.activityInfo
            
        //}
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
        let event : KYCalendarActivityData = currentUser.listActivity[indexPath.row]
        
        var activity = KYActivity()
        activity.activityId = event.id
        activity.activityName = event.activityName
        activity.pace = event.pace
        activity.paceUnit = event.paceUnit
        activity.height = KYHeight(gain: 87, lost: 0)
        activity.date = event.date
        activity.creator = event.creator
        activity.bpm = event.bpm
        activity.created = event.created
        activity.duration = event.duration
        activity.distance = event.distance
        activity.distanceUnit = event.distanceUnit
        activity.sportType = event.sportType
        
        currentActivity = activity
        
        /*
        let nvc = self.mainNavigationController()
        if let kyViewController = self.findkyViewController() {
        kyViewController.hideMenuViewControllerWithCompletion({ () -> Void in
        nvc.visibleViewController!.performSegueWithIdentifier(self.segues[indexPath.row], sender: nil)
        kyViewController.contentViewController = nvc
        })
        }
        */
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Activity api manager delegate
    
    func ActivityManagerRespond(user: AnyObject) {
        print("ActivityManagerRespond")
        self.tableView.reloadData()
    }
    func ActivityManagerRespondFailure(msgError: String) {
        print("ActivityManagerRespondFailure")
    }

}

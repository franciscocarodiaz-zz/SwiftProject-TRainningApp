//
//  TrainingPlanActivityViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TrainingPlanActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, activityManagerDelegate {
    
    var activityApiManager: ActivityManager?
    var headerView = UIView()
    @IBOutlet weak var tableView: UITableView!

    var planningDate: UILabel!
    var planningName: UILabel!
    
    var planningIcon: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.estimatedRowHeight = 70 // for example. Set your average height
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.activityApiManager = ActivityManager()
        self.activityApiManager?.delegate = self
        
        self.activityApiManager?.getTrainingPlan()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTrainingPlanNotification:", name: updateTrainingPlanNotificationKey, object: nil)
        
        
        // MARK: Create Header view
        var xHeaderView = CGFloat(0.0)
        var yHeaderView = CGFloat(0)
        var widthHeaderView = self.view.frame.width
        var heightHeaderView = CGFloat(70.0)
        headerView = UIView(frame: CGRectMake(xHeaderView, yHeaderView, widthHeaderView, heightHeaderView))
        
        var xPlanningIcon = CGFloat(0.0)
        var yPlanningIcon = CGFloat(0.0)
        var widthPlanningIcon = headerView.frame.height
        var heightPlanningIcon = widthPlanningIcon
        planningIcon = UIImageView(frame: CGRectMake(xPlanningIcon, yPlanningIcon, widthPlanningIcon, heightPlanningIcon))
        planningIcon.contentMode = .Center
        planningIcon.image = currentTrainingPlan.getSportImage()
        headerView.addSubview(planningIcon)
        
        
        var xPlanningDate = widthPlanningIcon + 5.0
        var yPlanningDate = CGFloat(0.0)
        var widthPlanningDate = headerView.frame.width - headerView.frame.height - 5.0
        var heightPlanningDate = headerView.frame.height/2
        planningDate = UILabel(frame: CGRectMake(xPlanningDate, yPlanningDate, widthPlanningDate, heightPlanningDate))
        planningDate.textAlignment = NSTextAlignment.Left
        planningDate.font = UIFont.boldSystemFontOfSize(17)
        headerView.addSubview(planningDate)
        
        var xPlanningName = widthPlanningIcon + 5.0
        var yPlanningName = heightPlanningDate
        var widthPlanningName = headerView.frame.width - headerView.frame.height - 5.0
        var heightPlanningName = headerView.frame.height/2
        planningName = UILabel(frame: CGRectMake(xPlanningName, yPlanningName, widthPlanningName, heightPlanningName))
        planningName.textAlignment = NSTextAlignment.Left
        planningName.font = UIFont.boldSystemFontOfSize(15)
        planningName.text = currentTrainingPlan.planningTitle
        headerView.addSubview(planningName)
        
        self.view.addSubview(headerView)
        
        var heightTV = self.view.frame.height - (headerView.frame.origin.y + headerView.frame.size.height)
        tableView.frame = CGRectMake(0, 0, self.view.frame.width, heightTV)
        
        self.view.frame.size.height = headerView.frame.height + tableView.frame.height
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.activityApiManager = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification Center
    
    func updateTrainingPlanNotification(notification: NSNotification) {
        let data = SwiftyJSON.JSON(notification.object!)
        /*
        let name : String = data["name"].stringValue
        let description = data["description"].stringValue
        let time = data["time"]
        let timeStr = "\(time)"
        
        planningDate.animate("Lunes 1 de junio 2015")
        planningName.animate(name)
        planningTrainerName.animate("Nombre entrenador")
        planningEstimatedTime.animate(timeStr)
        */
    }
    
    // MARK: - Loader
    
    func displayLoaderWithMessage(textMessage: String){
        KYHUD.sharedHUD.contentView = KYHUDSubtitleView(subtitle: textMessage)
        KYHUD.sharedHUD.show()
    }
    
    func hideLoader(delay: NSTimeInterval = 0.2){
        KYHUD.sharedHUD.hide(afterDelay: delay)
    }
    
    // MARK: UITableViewDelegate&DataSource methods
    
    // var arraySectionsTitle = currentTrainingPlan.parts //["Calentamiento", "Entrenamiento", "Relajar"]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentTrainingPlan.warmup.count
        case 1:
            return currentTrainingPlan.mainpart.count
        case 2:
            return currentTrainingPlan.warmdown.count
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        cell = tableView.dequeueReusableCellWithIdentifier("TPCell", forIndexPath: indexPath) as! UITableViewCell
        
        var title = ""
        var subtitle = ""
        (title, subtitle) = currentTrainingPlan.dataForIndexPath(indexPath)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //minimum size of your cell, it should be single line of label if you are not clear min. then return UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderTPCell") as! UITableViewCell
        headerCell.backgroundColor = UIColor.headerCell()
        headerCell.textLabel?.text = currentTrainingPlan.titleForSection(section)
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
    }
    
    func createLabelNoDataTP(){
        var messageLbl :UILabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
        
        //set the message
        messageLbl.text = LocalizedString_EMPTY_LIST
        //center the text
        messageLbl.textAlignment = NSTextAlignment.Center;
        //auto size the text
        messageLbl .sizeToFit()
        messageLbl.textColor = UIColor.grayColor()
        
        //set back to label view
        tableView.backgroundView = messageLbl;
        //no separator
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
    }
    
    // MARK: - Activity api manager delegate
    
    func ActivityManagerRespondTP(trainingPlanData: KYTrainingPlan) {
        trainingPlanData.date = currentActivity.date
        currentTrainingPlan = trainingPlanData
        
        planningIcon.image = currentTrainingPlan.getSportImage()
        planningName.text = currentTrainingPlan.planningTitle
        planningDate.text = currentTrainingPlan.date.dateFormatActivity
        
        tableView.reloadData()
        self.hideLoader()
    }
    func ActivityManagerRespondFailure(msgError: String) {
        createLabelNoDataTP()
    }
    
}
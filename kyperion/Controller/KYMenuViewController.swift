//
//  KYMenuViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Alamofire

class KYMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bannerLateralMenu: UIImageView!
    
    // data
    
    var segues : [String] = []
    var seguesIcons : [String] = []
    
    //let homeMenuOptions : String = NSLocalizedString("Recent Avtivity", comment: "Inicio menu title")
    let profileMenuOptions : String = NSLocalizedString("Profile", comment: "Perfil menu title")
    let calendarMenuOptions = NSLocalizedString("Calendar", comment: "Inicio menu title")
    let connectMenuOptions = NSLocalizedString("Connect", comment: "Inicio menu title")
    let messagesMenuOptions = NSLocalizedString("Messages", comment: "Inicio menu title")
    let trainingMenuOptions = NSLocalizedString("Training", comment: "Training menu title")
    let configurationMenuOptions = NSLocalizedString("Configuration", comment: "Inicio menu title")
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //segues = [homeMenuOptions, profileMenuOptions, calendarMenuOptions, connectMenuOptions, messagesMenuOptions, trainingMenuOptions, configurationMenuOptions]
        
        segues = [profileMenuOptions, calendarMenuOptions, messagesMenuOptions, trainingMenuOptions, configurationMenuOptions]
        
        seguesIcons = ["profile", "calendar", "messages", "training", "configuration"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure items
        
        // 1. Icon image
        
        // Rounded profile icon image and adding border
        userIcon.applyRoundAndBorder()
        
        // Add observer
        if currentUser.isValid == false{
            
        }else{
            self.updateProfileFromNotification()
        }
        addObservers()
        
        // Do any additional setup after loading the view.
    }
    
    func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfileFromNotification", name: updateProfileNotificationKey, object: nil)
    }
    
    func updateProfileFromNotification() {
        usernameLabel.text = currentUser.fullName
        userIcon.loadImage(currentUser.userPicture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate&DataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = segues[indexPath.row]
        
        let imageName = UIImage(named: seguesIcons[indexPath.row])
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.imageView?.image = imageName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
        
        let nvc = self.mainNavigationController()
        if let kyViewController = self.findkyViewController() {
            kyViewController.hideMenuViewControllerWithCompletion({ () -> Void in
                
                let identifier = self.segues[indexPath.row]
                
                nvc.visibleViewController!.performSegueWithIdentifier(identifier, sender: nil)
                kyViewController.contentViewController = nvc
                
                if identifier == self.calendarMenuOptions {
                    if currentUser.calendarEventsListByDay.count == 0 {
                        
                        let userId = currentUser.userId
                        let currentDate = NSDate()
                        let currentMonth = "\(currentDate.month)"
                        let currentDay = "\(currentDate.day)"
                        let currentYear = "\(currentDate.year)"
                    
                        //let urlCalendarDay = API_ROOT+"/api/v1/calendar/events/y"+currentYear+"/m"+currentMonth+"/d"+currentDay+"/?user="+userId
                        let urlCalendarDay = API_ROOT+"/api/v1/calendar/events/y"+currentYear+"/m"+currentMonth+"/?user="+userId
                        let mutableURLRequestDay = NSMutableURLRequest(URL: NSURL(string: urlCalendarDay)!)
                        let keyStr = "Token \(tokenUser)"
                        mutableURLRequestDay.setValue(keyStr, forHTTPHeaderField: "authorization")
                        nvc.requestCalendarDay = Alamofire.request(mutableURLRequestDay)
                        
                        let urlCalendarWeek = API_ROOT+"/api/v1/calendar/events/weekly/y"+currentYear+"/m"+currentMonth+"/d"+currentDay+"/?user="+userId
                        let mutableURLRequestWeek = NSMutableURLRequest(URL: NSURL(string: urlCalendarWeek)!)
                        mutableURLRequestWeek.setValue(keyStr, forHTTPHeaderField: "authorization")
                        nvc.requestCalendarWeek = Alamofire.request(mutableURLRequestWeek)
                        
                        let msg = NSLocalizedString("Loading calendar", comment: "Message displayed to the user when the calendar is loading from the server")
                        self.displayLoaderWithMessage(msg)
                    }
                }
            })
        }
        
    }
    
    // MARK: - Navigation
    
    func mainNavigationController() -> KYNavigationController {
        return self.storyboard?.instantiateViewControllerWithIdentifier("kyNavigationViewController") as! KYNavigationController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Loader
    
    func displayLoaderWithMessage(textMessage: String){
        KYHUD.sharedHUD.contentView = KYHUDSubtitleView(subtitle: textMessage)
        KYHUD.sharedHUD.show()
    }

}

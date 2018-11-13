//
//  MainContentViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Alamofire

class MainContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, userManagerDelegate, KYPromptsProtocol {

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - General methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !currentUser.isValid && tokenUser != "" {
            let urlString = API(caseAPI:CONST_API_AUTH_USER).url
            let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            let keyStr = "Token \(tokenUser)"
            mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            self.request = Alamofire.request(mutableURLRequest)
        } else if currentUser.isValid  && tokenUser != "" && !currentUser.existRecentActivity(){
            updateData()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.title = NSLocalizedString("Historial", comment: "Title of the screen history")
        
        self.userApiManager = UserManager()
        self.userApiManager?.delegate = self
        
        KYHUD.sharedHUD.dimsBackground = false
        KYHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.userApiManager = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Global variables
    
    var listActivity = [KYActivity]()
    
    var userApiManager: UserManager?
    var prompt = KYPromptsView()
    
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            displayLoaderWithMessage(MSG_LOADING_USER)
            
            self.request?.responseSwiftyJSON ({
                (request, response, data, error) -> Void in
                
                var user = KYUser()
                if(error == nil){
                    user = KYUser(data)
                }
                
                if user.isValid {
                    if user.userType == UserType.USR {
                        user.login = KYLogin(username: user.username, password: passwordLoggin, token:tokenUser)
                        currentUser = user
                        self.updateData()
                    }else{
                        let msg = NSLocalizedString("Invalid user credentials", comment: "Invalid user")
                        self.createPrompt(msg)
                    }
                }else{
                    
                    if let message = data["detail"].string {
                        self.hideLoader()
                        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
                        let vc = storyboard.instantiateViewControllerWithIdentifier("loginController") as! LoginController
                        self.presentViewController(vc, animated: true, completion: nil)
                    }else{
                        if usernameLoggin != "" {
                            if passwordLoggin != "" {
                                self.userApiManager?.loginWithUserPass(usernameLoggin, pass: passwordLoggin)
                            }else{
                                let msg = NSLocalizedString("Server connection error", comment: "Server error")
                                self.createPrompt(msg)
                            }
                        }else{
                            let msg = NSLocalizedString("Server connection error", comment: "Server error")
                            self.createPrompt(msg)
                        }
                    }
                }
            })
        }
    }
    
    var requestData: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            displayLoaderWithMessage(MSG_LOADING_DATA_USER)
            
            self.requestData?.responseSwiftyJSON ({
                (request, response, data, error) -> Void in
                
                var activity = KYActivity()
                if(error == nil){
                    activity = KYActivity(data)
                }
            
                self.tableView.reloadData()
                self.hideLoader(delay: 0.2)
            })
        }
    }
    
    // MARK: - Aux methods
    
    func updateData(){
        addObservers()
        /* GET
        let urlDataString = "https://dev.kyperion.com:8005/api/v1/user/recent_acitvity"
        self.requestData = Alamofire.request(.GET, URLString: urlDataString)
        */
        
        // .POST
        let urlString = API(caseAPI:CONST_API_RECENT_ACT_USER).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        self.requestData = Alamofire.request(mutableURLRequest)
        
    }
    
    func addObservers(){
        NSNotificationCenter.defaultCenter().postNotificationName(updateProfileNotificationKey, object: self)
    }
    
    // MARK: - User api manager delegate
    
    func UserManagerRespond(user: AnyObject) {
        currentUser = user as! KYUser
        updateData()
    }
    
    func UserManagerRespondFailure(msgError: String) {
        createPrompt(msgError)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func menuButtonTouched(sender: AnyObject) {
        self.findkyViewController()?.showMenuViewController()
    }
    
    // MARK: UITableViewDelegate&DataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return currentUser.recentActivity.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser.recentActivity[section].values.array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Data
        let dateString : String = Array(currentUser.recentActivity[indexPath.section].keys)[indexPath.row]
        let event : KYActivity = Array(currentUser.recentActivity[indexPath.section].values)[indexPath.row][0]
        //let events : [KYActivity] = Array(currentUser.recentActivity[indexPath.section].values)[indexPath.row]
        
        // Configure cell

        /* Default cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = date
        cell.detailTextLabel?.text = event.description
        */
        
        // Custom cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        
        // 1. Date
        cell.dateActivity.text = event.dateFormat
        
        // 2. Image
        cell.imageActivity.image = event.getTypeSportImage()
        
        // 3. Username
        cell.usernameActivity.text = event.userFullnameActivity
        
        // 4. Data
        cell.dataActivity.text = event.activityInfo
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
        let dateString : String = Array(currentUser.recentActivity[indexPath.section].keys)[indexPath.row]
        let event : KYActivity = Array(currentUser.recentActivity[indexPath.section].values)[indexPath.row][0]
        currentActivity = event
        
    }
    
    // MARK: - Delegate functions for the prompt
    
    func createPrompt(textToDisplay: String){
        
        hideLoader()
        prompt = KYPromptsView .createPromptWithMessageAndBounds(textToDisplay, bounds: self.view.bounds)
        prompt.delegate = self
        prompt.isActive = true
        
        self.view.addSubview(prompt)
        
    }
    
    func clickedOnTheMainButton() {
        prompt.dismissPrompt()
    }
    
    func clickedOnTheSecondButton() {
        prompt.dismissPrompt()
    }
    
    func promptWasDismissed() {
        prompt.isActive = false
    }
    
    // MARK: - Orientation functions
    
    override func shouldAutorotate() -> Bool {
        return !prompt.isActive
    }
    
    // MARK: - Remove Observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Loader
    
    func displayLoaderWithMessage(textMessage: String){
        KYHUD.sharedHUD.contentView = KYHUDSubtitleView(subtitle: textMessage)
        KYHUD.sharedHUD.show()
    }
    
    func hideLoader(delay: NSTimeInterval = 1.0){
        KYHUD.sharedHUD.hide(afterDelay: delay)
    }

}

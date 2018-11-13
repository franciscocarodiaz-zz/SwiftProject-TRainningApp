//
//  ConfigurationViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit
import Alamofire

class ConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, userManagerDelegate, KYPromptsProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    
    var alertController:UIAlertController?
    var action : UIAlertAction = UIAlertAction()
    var userData = []
    var userIsUpdated = false
    var oldPassword : String = ""
    
    var userApiManager: UserManager?
    var prompt = KYPromptsView()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = LocalizedString_Configuration
        self.navigationItem.rightBarButtonItem = logOutButtonItem
        
        refreshLabel.text = LocalizedString_UpdateData
        
        userNameLabel.text = currentUser.fullName
        userNameLabel.font.bold()
        
    }
    
    var logOutButtonItem: UIBarButtonItem {
        //var button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "logOutButtonPressed:")
        var button = UIBarButtonItem(title: LocalizedString_LogOut, style:.Plain, target: self, action: "logOutButtonPressed:")
        button.title = LocalizedString_LogOut
        return button
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if userIsUpdated {
            var firstName = currentUser.firstName
            var lastName = currentUser.lastName
            var gender = currentUser.gender.description
            var birthday = currentUser.birthdayStr
            var password = currentUser.login.password
            self.userApiManager?.updateUser(oldPassword, newPassword: password, firstName:firstName, lastName:lastName, gender:gender, birthday:birthday)
        }
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.userApiManager = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateDataAndView()
        
        userIcon.loadImage(currentUser.userPicture)
        
        self.userApiManager = UserManager()
        self.userApiManager?.delegate = self
        
        KYHUD.sharedHUD.dimsBackground = false
        KYHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "editButtonPushed:")
        refreshLabel.addGestureRecognizer(gestureRecognizer)
        refreshLabel.userInteractionEnabled = true
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsZero
        
        addObservers()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        configCurrentUser = currentUser
    }
    
    var editMode = false
    func editButtonPushed(sender: UIPanGestureRecognizer!) {
        editMode = !editMode
        refreshLabel.addUnderLine(editMode)
        if editMode{
            //refreshLabel.backgroundColor = UIColor.mainAppColor(0.5)
        }else{
            //refreshLabel.backgroundColor = UIColor.clearColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UITableViewDelegate&DataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuracionScreenDataList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell
        cell = tableView.dequeueReusableCellWithIdentifier("ConfigurationCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = configuracionScreenDataList[indexPath.row]
        cell.detailTextLabel?.text = self.userData[indexPath.row] as? String
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
        var title = configuracionScreenDataList[indexPath.row]
        var value = self.userData[indexPath.row] as! String
        
        if editMode {
            
            if indexPath.row == 2 {
                
                alertController = UIAlertController(title: title, message: "Select your birthdate!", preferredStyle: .ActionSheet)
                
                var datePicker = UIDatePicker()
                datePicker.datePickerMode = UIDatePickerMode.Date
                datePicker.date = value.toDate(format: DateFormat.Custom(DATE_FORMAT))!
                datePicker.backgroundColor = UIColor.whiteColor()
                
                var aboveBlurLayer :UIView = alertController!.view.subviews[0] as! UIView
                aboveBlurLayer.addSubview(datePicker)
                aboveBlurLayer.frame.size = CGSize(width: self.view.frame.width - 16, height: aboveBlurLayer.frame.height)
                datePicker.frame.size = CGSize(width: self.view.frame.width - 16, height: datePicker.frame.height)
                alertController?.view.frame.size = CGSize(width: self.view.frame.width - 16, height: alertController!.view.frame.height)
                alertController?.view.backgroundColor = UIColor.whiteColor()
                
                
                let alertAction: UIAlertAction = UIAlertAction(title: "", style: UIAlertActionStyle.Default, handler: nil)
                alertController!.addAction(alertAction)
                alertController!.addAction(alertAction)
                alertController!.addAction(alertAction)
                alertController!.addAction(alertAction)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                    //Just dismiss the action sheet
                }
                alertController!.addAction(cancelAction)
                
                let saveAction: UIAlertAction = UIAlertAction(title: "Save", style: .Default) { action -> Void in
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = DATE_FORMAT
                    var strDate = dateFormatter.stringFromDate(datePicker.date)
                    
                    currentUser.updateValue(indexPath.row, value: strDate)
                    selectedCell.detailTextLabel?.text = strDate
                    self.callObservers()
                }
                alertController!.addAction(saveAction)
                
                datePicker.backgroundColor = UIColor.whiteColor()
                aboveBlurLayer.addSubview(datePicker)
                
                alertController!.view.addSubview(aboveBlurLayer)
                
                self.view .bringSubviewToFront(aboveBlurLayer)
                //Present the AlertController
                self.presentViewController(alertController!, animated: true, completion: nil)
                
            }else if indexPath.row == 3 {
                alertController = UIAlertController(title: title, message: "Choose an option!", preferredStyle: .ActionSheet)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                    //Just dismiss the action sheet
                }
                alertController!.addAction(cancelAction)
                
                var actionMaleTitle = "\(Gender.MAL)"
                let maleAction: UIAlertAction = UIAlertAction(title: actionMaleTitle, style: .Default) { action -> Void in
                    currentUser.updateValue(indexPath.row, value: actionMaleTitle)
                    selectedCell.detailTextLabel?.text = currentUser.gender.description
                    self.callObservers()
                }
                alertController!.addAction(maleAction)
                
                var actionFemaleTitle = "\(Gender.FEM)"
                let femaleAction: UIAlertAction = UIAlertAction(title: actionFemaleTitle, style: .Default) { action -> Void in
                    currentUser.updateValue(indexPath.row, value: actionFemaleTitle)
                    selectedCell.detailTextLabel?.text = currentUser.gender.description
                    self.callObservers()
                }
                alertController!.addAction(femaleAction)
                
                //We need to provide a popover sourceView when using it on iPad
                alertController!.popoverPresentationController?.sourceView = selectedCell as UIView;
                
                //Present the AlertController
                self.presentViewController(alertController!, animated: true, completion: nil)
            }else if indexPath.row != 1 && indexPath.row != 5 {
                
                alertController = UIAlertController(title: title,
                    message: value,
                    preferredStyle: .Alert)
                alertController!.addTextFieldWithConfigurationHandler(
                    {(textField: UITextField!) in
                        textField.placeholder = "New value"
                })
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                    //Do some stuff
                }
                action = UIAlertAction(title: "Save",
                    style: UIAlertActionStyle.Default,
                    handler: {[weak self]
                        (paramAction:UIAlertAction!) in
                        if let textFields = self!.alertController?.textFields{
                            let theTextFields = textFields as! [UITextField]
                            let enteredText = theTextFields[0].text
                            if enteredText != "" {
                                self!.oldPassword = currentUser.login.password
                                currentUser.updateValue(indexPath.row, value: enteredText)
                                selectedCell.detailTextLabel!.text = enteredText
                                if indexPath.row == configuracionScreenDataList.count-1 {
                                    selectedCell.detailTextLabel!.text = currentUser.login.encryptPwd
                                }
                                self!.callObservers()
                            }
                        }
                    })
                alertController?.addAction(action)
                alertController?.addAction(cancelAction)
                self.presentViewController(alertController!,
                    animated: true,
                    completion: nil)
            }
            
            
        }
        
        
        
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
    
    // MARK: - Loader
    
    func displayLoaderWithMessage(textMessage: String){
        KYHUD.sharedHUD.contentView = KYHUDSubtitleView(subtitle: textMessage)
        KYHUD.sharedHUD.show()
    }
    
    func hideLoader(delay: NSTimeInterval = 1.0){
        KYHUD.sharedHUD.hide(afterDelay: delay)
    }
    
    // MARK: - Notifications
    
    func callObservers(){
        userIsUpdated = true
        NSNotificationCenter.defaultCenter().postNotificationName(updateProfileNotificationKey, object: self)
    }
    
    func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfileFromNotification", name: updateProfileNotificationKey, object: nil)
    }
    
    func updateProfileFromNotification() {
        updateDataAndView()
        userIcon.loadImage(currentUser.userPicture)
        userNameLabel.text = currentUser.fullName
    }
    
    func updateDataAndView(){
        let name = currentUser.firstName
        let surname = currentUser.lastName
        let birthday = currentUser.birthdayStr
        var gender = currentUser.gender.description
        let username = currentUser.login.username
        let email = currentUser.email
        let passwordLogin = currentUser.login.encryptPwd
        
        userData = [name, surname, birthday, gender, username, email, passwordLogin]
        
        userIcon.loadImage(currentUser.userPicture)
        userNameLabel.text = currentUser.fullName
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - User api manager delegate
    
    func UserManagerRespond(user: AnyObject) {
        currentUser = user as! KYUser
    }
    
    func UserManagerRespondLogOut(){
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("welcomeController") as! WelcomeController
        currentUser = KYUser()
        tokenUser = ""
        usernameLoggin = ""
        passwordLoggin = ""
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func UserManagerRespondFailure(msgError: String) {
        createPrompt(msgError)
    }
    
    @IBAction func logOutButtonPressed(sender: UIBarButtonItem) {
        
        alertController = UIAlertController(title: LocalizedString_LogOut,
            message: "Are you sure?",
            preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            print("Cancel")
        }
        alertController?.addAction(cancelAction)
        
        let saveAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            self.userApiManager?.logout()
        }
        alertController!.addAction(saveAction)
        
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
    }
}

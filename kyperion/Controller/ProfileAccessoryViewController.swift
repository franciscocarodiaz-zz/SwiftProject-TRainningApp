//
//  ProfileAccessoryViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class ProfileAccessoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, userManagerDelegate, SBPickerSelectorDelegate {

    var accesoriesTableView: UITableView!
    
    @IBOutlet weak var headerAccesory: UIView!
    var scrollView: UIScrollView!
    var actionButton: [UIButton]!
    var headerTitleLabels: [UILabel]!
    
    var userApiManager: UserManager?
    
    var alertController:UIAlertController?
    let dayPicker: SBPickerSelector = SBPickerSelector.picker()
    let startTimePicker: SBPickerSelector = SBPickerSelector.picker()
    let endTimePicker: SBPickerSelector = SBPickerSelector.picker()
    let daysData = ["1", "2", "3", "4", "5", "6", "7"]
    
    
    let nameAccPicker: SBPickerSelector = SBPickerSelector.picker()
    let typeAccPicker: SBPickerSelector = SBPickerSelector.picker()
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if userModified{
            self.userApiManager?.updateCurrentUser()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !currentUser.hasAccessories {
            self.userApiManager?.getAccesories()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = LocalizedString_ProfileManager_ProfileVC
        
        self.userApiManager = UserManager()
        self.userApiManager?.delegate = self
        accesoriesTableView.tag = 1
        accesoriesTableView.delegate = self
        accesoriesTableView.dataSource = self
        
        scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
        
        setHeaders()
        
        newAccesory = KYAccessory()
        
        configCurrentUser = currentUser
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.userApiManager = nil
    }
    
    func setHeaders(){
        actionButton[0].setTitle(LocalizedString_Edit, forState: UIControlState.Normal)
        
        headerTitleLabels[0].text = LocalizedString_Accesory
    }

    @IBAction func actionButtonPressed(sender: UIButton) {
        
        if sender.tag == 1 {
            print("Accesory edit button pressed")
        }else if sender.tag == 2 {
            print("Ficha edit button pressed")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func createLabelNoDataInAccesoryTV(){
        var messageLbl :UILabel = UILabel(frame: CGRectMake(0, 0, accesoriesTableView.bounds.size.width, accesoriesTableView.bounds.size.height))
        
        //set the message
        messageLbl.text = LocalizedString_EMPTY_LIST_ACCESSORY_MSG
        //center the text
        messageLbl.textAlignment = NSTextAlignment.Center;
        //auto size the text
        messageLbl .sizeToFit()
        messageLbl.textColor = UIColor.grayColor()
        
        //set back to label view
        accesoriesTableView.backgroundView = messageLbl;
        //no separator
        accesoriesTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
        case 0:
            return currentUser.listAccSwim.count
        case 1:
            return currentUser.listAccCyc.count
        case 2:
            return currentUser.listAccRun.count
        case 3:
            return currentUser.listAccGym.count
        default:
            return 0
        }
    }
    
    var currentSection = 0
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataAccesoryCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        var data = KYAccessory()
        currentIndex = indexPath.row
        currentSection = indexPath.section
        
        switch currentSection {
        case 0:
            data = currentUser.listAccSwim[currentIndex]
        case 1:
            data = currentUser.listAccCyc[currentIndex]
        case 2:
            data = currentUser.listAccRun[currentIndex]
        case 3:
            data = currentUser.listAccGym[currentIndex]
        default:
            print(data)
        }
        cell.textLabel!.text = data.name
        cell.detailTextLabel!.text = data.descripRow
        
        return cell
    }

    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! ProfileCustomHeaderTableViewCell
        
        if tableView.tag == 1 {
            headerCell.backgroundColor = UIColor.headerCell()
            headerCell.titleLabel.text = listDataAccesory[section].capitalizeFirst
            var buttonTitle = "\(LocalizedString_ADD_BUTTON_TITLE) (+)"
            headerCell.actionButton.setTitle(buttonTitle, forState: UIControlState.Normal)
            headerCell.actionButton.configureButtonWithHightlightedShadowAndZoom(true)
            headerCell.actionButton.tag = section
            currentSection = section
            headerCell.actionButton.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        return headerCell
    }
    
    var userModified = false
    func buttonTapped(sender: UIButton!) {
        var section = sender.tag
        
        currentSection = section
        
        presentAccNameDialog()
        
    }
    
    
    
    func presentAccNameDialog() {
        var nameArray = [String]()
        newAccesory = KYAccessory()
        
            switch (currentSection) {
            case 0:
                nameArray = listAcc_Swim_Opt_1
                newAccesory.sport = SPORT_TYPE_SWIMMING
            case 1:
                nameArray = listAcc_Cyc_Opt_1
                newAccesory.sport = SPORT_TYPE_CYCLING
            case 2:
                nameArray = listAcc_Run_Opt_1
                newAccesory.sport = SPORT_TYPE_RUNNING
            case 3:
                nameArray = listAcc_Gym_Opt_1
                newAccesory.sport = SPORT_TYPE_GYM
            default:
                print("No data")
            }

        
        nameAccPicker.pickerData = nameArray
        nameAccPicker.tag = 2
        nameAccPicker.delegate = self
        nameAccPicker.pickerType = SBPickerSelectorType.Text
        nameAccPicker.cancelButtonTitle = LocalizedString_Cancel
        nameAccPicker.doneButtonTitle = LocalizedString_Done
        nameAccPicker.pickerView.backgroundColor = UIColor.whiteColor()
        nameAccPicker.doneButton.tintColor = UIColor.mainAppColor()
        nameAccPicker.cancelButton.tintColor = UIColor.mainAppColor()
        let point: CGPoint = view.convertPoint(self.view.frame.origin, fromView: self.view.superview)
        var frame: CGRect = self.view.frame
        frame.origin = point
        nameAccPicker.showPickerIpadFromRect(frame, inView: view)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - User api manager delegate
    func UserManagerAccesoryRespond() {
        print("UserManagerAccesoryRespond")
        switch (currentSection) {
        case 0:
            currentUser.listAccSwim.append(newAccesory)
        case 1:
            currentUser.listAccCyc.append(newAccesory)
        case 2:
            currentUser.listAccRun.append(newAccesory)
        case 3:
            currentUser.listAccGym.append(newAccesory)
        default:
            print("No data")
        }
        accesoriesTableView.reloadData()
    }
    func UserManagerRespond(user: AnyObject) {
        print("UserManagerRespond")
    }
    func UserManagerRespondFailure(msgError: String) {
        print("UserManagerRespondFailure")
    }
    
    var auxWeekTimeAvailabilityItems = [KYTimeAvailability]()
    
    var weekTimeAvailabilityItems : [KYTimeAvailability] {
        if auxWeekTimeAvailabilityItems.count == 0 {
            auxWeekTimeAvailabilityItems = currentUser.weekTimeAvailabilityItems
        }
        return auxWeekTimeAvailabilityItems
    }
    
    func presentDialogWithDateAndText(section: Int){
        var title = listDataInfo[section].capitalizeFirst
        var message = LocalizedString_DateOf
        if section == 4 {
            message = LocalizedString_Injury
        }else if section == 5 {
            message = LocalizedString_Surgery
        }
        displayDialogDateAndText(message: message, section: section)
    
    }
    
    func displayDialogDateAndText(message: String = "", section: Int){
        
        alertController = UIAlertController(title: listDataInfo[section].capitalizeFirst, message: message, preferredStyle: .ActionSheet)
        
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.date = NSDate.today()
        if section == 0 {
            datePicker.date = currentUser.getTrainingsince()
        }
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
            if section == 0 {
                if strDate != currentUser.trainingSince {
                    self.userModified = true
                    currentUser.trainingSince = strDate
                }
            }else if section == 3 || section == 4 {
                self.presentDialog(message: "Date \(strDate)", section: section, extraEnteredMessage:strDate)
            }
            
            /*
            currentUser.updateValue(indexPath.row, value: strDate)
            selectedCell.detailTextLabel?.text = strDate
            self.callObservers()
            */
        }
        alertController!.addAction(saveAction)
        
        datePicker.backgroundColor = UIColor.whiteColor()
        aboveBlurLayer.addSubview(datePicker)
        
        alertController!.view.addSubview(aboveBlurLayer)
        
        self.view .bringSubviewToFront(aboveBlurLayer)
        //Present the AlertController
        self.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    
    func presentDialog(message: String = "", section: Int, extraEnteredMessage: String = ""){
        
        alertController = UIAlertController(title: listDataInfo[section].capitalizeFirst,
            message: message,
            preferredStyle: .Alert)
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = LocalizedString_NewValue
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: LocalizedString_Cancel, style: .Cancel) { action -> Void in
            //Do some stuff
        }
        var action = UIAlertAction(title: LocalizedString_Save,
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = self!.alertController?.textFields{
                    let theTextFields = textFields as! [UITextField]
                    let enteredText = theTextFields[0].text
                    if enteredText != "" {
                        switch section {
                        case 1:
                            currentUser.addAllergy(enteredText)
                        case 2:
                            currentUser.addMedication(enteredText)
                        case 3:
                            var newInjury = KYInfoData(name:enteredText, date:extraEnteredMessage)
                            currentUser.addInjury(newInjury)
                        case 4:
                            var newSurgery = KYInfoData(name:enteredText, date:extraEnteredMessage)
                            currentUser.addSurgery(newSurgery)
                        default:
                            print(enteredText)
                        }
                        self!.userModified = true
                        var indxesPath:[NSIndexPath] = [NSIndexPath]()
                        indxesPath.append(NSIndexPath(forRow:0,inSection:section))
                        /*
                        self!.dataInfoTableView.insertRowsAtIndexPaths(indxesPath, withRowAnimation: UITableViewRowAnimation.Fade)
                        self!.dataInfoTableView.reloadData()
                        */
                    }
                }
            })
        alertController?.addAction(action)
        alertController?.addAction(cancelAction)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
    }
    
    //MARK: SBPickerSelectorDelegate
    
    func createPicker(message: String, data: [String]){
        dayPicker.pickerData = data
        dayPicker.tag = 1
        dayPicker.delegate = self
        dayPicker.pickerType = SBPickerSelectorType.Text
        dayPicker.doneButtonTitle = message
        dayPicker.pickerView.backgroundColor = UIColor.whiteColor()
        dayPicker.cancelButtonTitle = ""
        dayPicker.doneButton.tintColor = UIColor.mainAppColor()
        
        let point: CGPoint = view.convertPoint(self.view.frame.origin, fromView: self.view.superview)
        var frame: CGRect = self.view.frame
        frame.origin = point
        dayPicker.showPickerIpadFromRect(frame, inView: view)
    }
    
    func presentAvailabilityDialog() {
        dayPicker.pickerData = days
        dayPicker.tag = 2
        dayPicker.delegate = self
        dayPicker.pickerType = SBPickerSelectorType.Text
        dayPicker.cancelButtonTitle = LocalizedString_SelectDay
        dayPicker.doneButtonTitle = ">"
        dayPicker.pickerView.backgroundColor = UIColor.whiteColor()
        dayPicker.doneButton.tintColor = UIColor.mainAppColor()
        dayPicker.cancelButton.tintColor = UIColor.mainAppColor()
        let point: CGPoint = view.convertPoint(self.view.frame.origin, fromView: self.view.superview)
        var frame: CGRect = self.view.frame
        frame.origin = point
        dayPicker.showPickerIpadFromRect(frame, inView: view)
    }

    var timeArray = [String]()
    var selectedStartTime = false
    var currentAvailableTime: KYDayAvailability = KYDayAvailability(dayname: "", availability: [])
    var currentTime = KYTimeAvailability(start:0.0, end:0.0)
    
    func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int) {
        var typeArray = [String]()
        
        if newAccesory.name == "" {
            switch (currentSection) {
            case 0:
                typeArray = listAcc_Swim_Opt_2
            case 1:
                typeArray = listAcc_Cyc_Opt_2
            case 2:
                typeArray = listAcc_Run_Opt_2
            case 3:
                if value == list_Gym_Opt_1[0] {
                    typeArray = list_Gym_Opt_3
                }else{
                    typeArray = listAcc_Gym_Opt_2
                }
            default:
                print("No data")
            }
            
            newAccesory.name = value
            
            typeAccPicker.pickerData = typeArray
            typeAccPicker.tag = 3
            typeAccPicker.delegate = self
            typeAccPicker.pickerType = SBPickerSelectorType.Text
            typeAccPicker.cancelButtonTitle = LocalizedString_SelectTypeName
            typeAccPicker.doneButtonTitle = LocalizedString_Done
            typeAccPicker.pickerView.backgroundColor = UIColor.whiteColor()
            typeAccPicker.doneButton.tintColor = UIColor.mainAppColor()
            typeAccPicker.cancelButton.tintColor = UIColor.mainAppColor()
            newAccesory.name = value
            let point: CGPoint = view.convertPoint(self.view.frame.origin, fromView: self.view.superview)
            var frame: CGRect = self.view.frame
            frame.origin = point
            typeAccPicker.showPickerIpadFromRect(frame, inView: view)
        }else if newAccesory.type == "" {
            newAccesory.type = value
            
            if currentSection == 3 {
                print("\n Save accesory")
                self.userApiManager?.saveAccesory()
            }else{
                presentDialogBrand()
            }
            
        }
            
        
        
        
    }
    
    
    func pickerSelector(selector: SBPickerSelector!, cancelPicker cancel: Bool) {
        print("Cancel option pressed.")
    }
    
    func pickerSelector(selector: SBPickerSelector!, intermediatelySelectedValue value: AnyObject!, atIndex idx: Int) {
        //pickerSelector(selector, selectedValue: value as! String, index: idx)
    }
    
    func presentDialogBrand(){
        
        alertController = UIAlertController(title: listDataAccesory[currentSection].capitalizeFirst,
            message: "Type here the brand... ",
            preferredStyle: .Alert)
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = LocalizedString_NewValue
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: LocalizedString_Cancel, style: .Cancel) { action -> Void in
            //Do some stuff
        }
        var action = UIAlertAction(title: LocalizedString_Save,
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = self!.alertController?.textFields{
                    let theTextFields = textFields as! [UITextField]
                    let enteredText = theTextFields[0].text
                    if enteredText != "" {
                        newAccesory.brand = enteredText
                        self!.presentDialogOther()
                    }
                }
            })
        alertController?.addAction(action)
        alertController?.addAction(cancelAction)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
    }
    
    func presentDialogOther(){
        
        alertController = UIAlertController(title: listDataAccesory[currentSection].capitalizeFirst,
            message: "Type here any comment...",
            preferredStyle: .Alert)
        alertController!.addTextFieldWithConfigurationHandler(
            {(textField: UITextField!) in
                textField.placeholder = LocalizedString_NewValue
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: LocalizedString_Cancel, style: .Cancel) { action -> Void in
            //Do some stuff
        }
        var action = UIAlertAction(title: LocalizedString_Save,
            style: UIAlertActionStyle.Default,
            handler: {[weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = self!.alertController?.textFields{
                    let theTextFields = textFields as! [UITextField]
                    let enteredText = theTextFields[0].text
                    if enteredText != "" {
                        newAccesory.category = enteredText
                        
                        print("\n Save accesory")
                        self!.userApiManager?.saveAccesory()
                    }
                }
            })
        alertController?.addAction(action)
        alertController?.addAction(cancelAction)
        self.presentViewController(alertController!,
            animated: true,
            completion: nil)
    }
    
    // Aux
    
    func filterArrayFrom(value: String) -> Array<String> {
        var array = Array<String>()
        var index = 0
        var inserting = false
        for item in timeArray {
            if inserting {
                array.insert(item, atIndex: index)
                index++
            }else{
                if item == value {
                    inserting = true
                }
            }
            
        }
        
        return array
    }

}

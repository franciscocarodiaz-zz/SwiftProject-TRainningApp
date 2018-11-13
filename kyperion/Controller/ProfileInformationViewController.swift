//
//  ProfileInformationViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 07/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class ProfileInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, userManagerDelegate, SBPickerSelectorDelegate {
    
    var dataInfoTableView: UITableView!
    
    @IBOutlet weak var headerAccesory: UIView!
    @IBOutlet weak var headerInfo: UIView!
    var scrollView: UIScrollView!
    
    var actionButton: [UIButton]!
    var headerTitleLabels: [UILabel]!
    
    var userApiManager: UserManager?
    
    var alertController:UIAlertController?
    let dayPicker: SBPickerSelector = SBPickerSelector.picker()
    let startTimePicker: SBPickerSelector = SBPickerSelector.picker()
    let endTimePicker: SBPickerSelector = SBPickerSelector.picker()
    let daysData = ["1", "2", "3", "4", "5", "6", "7"]
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if userModified{
            self.userApiManager?.updateCurrentUser()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = LocalizedString_ProfileManager_ProfileVC
        
        self.userApiManager = UserManager()
        self.userApiManager?.delegate = self
        
        dataInfoTableView.tag = 2
        dataInfoTableView.delegate = self
        dataInfoTableView.dataSource = self
        
        scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
        /*
        scrollView = UIScrollView(frame: CGRectMake(xScrollView, yScrollView, widthScrollView, heightScrollView))
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.scrollEnabled = true
        scrollView.alwaysBounceVertical = true
        */
        
        setHeaders()
        
        configCurrentUser = currentUser
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.userApiManager = nil
    }
    
    func setHeaders(){
        actionButton[0].setTitle(LocalizedString_Edit, forState: UIControlState.Normal)
        
        headerTitleLabels[0].text = LocalizedString_Info
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //assuming some_table_data respresent the table data
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        //accesoriesTableView.frame         =   CGRectMake(0, 0, self.view.frame.width, accesoriesTableView.rowHeight*50);
        //dataInfoTableView.frame         =   CGRectMake(0, accesoriesTableView.frame.height, self.view.frame.width, dataInfoTableView.frame.height*50);
        if section == 0 && currentUser.hasTrainingSince {
            return 1
        }else if section == 1 && currentUser.hasAllergies {
            return currentUser.allergies.count
        }else if section == 2 && currentUser.hasMedications {
            return currentUser.medications.count
        }else if section == 3 && currentUser.hasInjuries {
            return currentUser.injuries.count
        }else if section == 4 && currentUser.hasSurgeries {
            return currentUser.surgeries.count
        }else if section == 5 {
            return 1
        }else if section == 6 && currentUser.hasWeekAvailability {
            return currentUser.weekTimeAvailability
        }
        return 0
    }
    
    var currentSection = 0
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataInfoCell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        var data = "title \(indexPath.row)"
        currentIndex = indexPath.row
        currentSection = indexPath.section
        
        switch currentSection {
        case 0:
            data = currentUser.trainingSinceMonthAndYearString
        case 1:
            data = currentUser.allergies[currentIndex]
        case 2:
            data = currentUser.medications[currentIndex]
        case 3:
            data = currentUser.injuries[currentIndex].description
        case 4:
            data = currentUser.surgeries[currentIndex].description
        case 5:
            data = currentUser.weeklyAvailabilityDescription
        case 6:
            data = currentUser.dataForTimeAvailability
        default:
            print(data)
        }
        cell.textLabel!.text = data
        
        // 4. Data
        //cell.dataActivity.text = event.activityInfo
        
        //}
        /*
        if indexPath.row == 7 {
        //Defining the content size of the scrollview
        dataInfoTableView.contentSize = CGSize(width: dataInfoTableView.frame.size.width,
        height: dataInfoTableView.rowHeight*7)
        let totalHeight = accesoriesTableView.frame.size.height + dataInfoTableView.frame.size.height + 50
        let scrollHeight = scrollView.frame.size.height>totalHeight ? scrollView.frame.size.height : totalHeight
        scrollView.contentSize = CGSize(width: self.view.frame.size.width,
        height: scrollHeight)
        }
        */
        return cell
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! ProfileCustomHeaderTableViewCell
        
        if tableView.tag == 2 {
            headerCell.backgroundColor = UIColor.headerCell()
            headerCell.titleLabel.text = listDataInfo[section].capitalizeFirst
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
        
        if section == 0 {
            var message = LocalizedString_TrainingSince
            displayDialogDateAndText(message: message, section: section)
        } else if sender.tag == 1 {
            var message = LocalizedString_AddAllergy
            self.presentDialog(message: message, section: sender.tag)
        } else if sender.tag == 2 {
            var message = LocalizedString_AddMedication
            self.presentDialog(message: message, section: sender.tag)
        } else if sender.tag == 3 {
            self.presentDialogWithDateAndText(sender.tag)
        } else if sender.tag == 4 {
            self.presentDialogWithDateAndText(sender.tag)
        } else if sender.tag == 5 {
            var message = LocalizedString_NumberWorkoutsWeek
            createPicker(message, data: daysData)
        } else if sender.tag == 6 {
            print(listDataInfo[section].capitalizeFirst)
            presentAvailabilityDialog()
        }
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
    func UserManagerAccesoryRespond(data: AnyObject) {
        print("UserManagerAccesoryRespond")
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
                textField.autocorrectionType = UITextAutocorrectionType.Yes
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
                        self!.dataInfoTableView.insertRowsAtIndexPaths(indxesPath, withRowAnimation: UITableViewRowAnimation.Fade)
                        self!.dataInfoTableView.reloadData()
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
        if contains(days, value) {
            
            switch idx {
            case 0:
                timeArray = currentUser.timeAvailability.monday.timeHasAvailabilityArrayString
            case 1:
                timeArray = currentUser.timeAvailability.tuesday.timeHasAvailabilityArrayString
            case 2:
                timeArray = currentUser.timeAvailability.wednesday.timeHasAvailabilityArrayString
            case 3:
                timeArray = currentUser.timeAvailability.thursday.timeHasAvailabilityArrayString
            case 4:
                timeArray = currentUser.timeAvailability.friday.timeHasAvailabilityArrayString
            case 5:
                timeArray = currentUser.timeAvailability.saturday.timeHasAvailabilityArrayString
            case 6:
                timeArray = currentUser.timeAvailability.sunday.timeHasAvailabilityArrayString
            default:
                print("No day")
            }
            
            startTimePicker.pickerData = timeArray
            startTimePicker.tag = 3
            startTimePicker.delegate = self
            startTimePicker.pickerType = SBPickerSelectorType.Text
            startTimePicker.cancelButtonTitle = LocalizedString_SelectStartTime
            startTimePicker.doneButtonTitle = ">"
            startTimePicker.pickerView.backgroundColor = UIColor.whiteColor()
            startTimePicker.doneButton.tintColor = UIColor.mainAppColor()
            startTimePicker.cancelButton.tintColor = UIColor.mainAppColor()
            currentAvailableTime.dayname = value
            let point: CGPoint = view.convertPoint(self.view.frame.origin, fromView: self.view.superview)
            var frame: CGRect = self.view.frame
            frame.origin = point
            startTimePicker.showPickerIpadFromRect(frame, inView: view)
        }else if contains(timeArray, value) {
            if !selectedStartTime {
                endTimePicker.pickerData = filterArrayFrom(value)
                endTimePicker.tag = 4
                endTimePicker.delegate = self
                endTimePicker.pickerType = SBPickerSelectorType.Text
                endTimePicker.cancelButtonTitle = LocalizedString_SelectEndTime
                
                endTimePicker.doneButtonTitle = LocalizedString_Done
                endTimePicker.pickerView.backgroundColor = UIColor.whiteColor()
                endTimePicker.doneButton.tintColor = UIColor.mainAppColor()
                endTimePicker.cancelButton.tintColor = UIColor.mainAppColor()
                selectedStartTime = true
                currentTime.start = value.toDoubleTimeAvailabilityFormat24()!
                let point: CGPoint = view.convertPoint(self.view.frame.origin, fromView: self.view.superview)
                var frame: CGRect = self.view.frame
                frame.origin = point
                endTimePicker.showPickerIpadFromRect(frame, inView: view)
            }else{
                selectedStartTime = false
                currentTime.end = value.toDoubleTimeAvailabilityFormat24()!
                currentAvailableTime.availability = currentTime.arrayTimeAvailabilityFormatted
                currentUser.addTimeAvailability(currentAvailableTime)
                
                self.userModified = true
                var indxesPath:[NSIndexPath] = [NSIndexPath]()
                indxesPath.append(NSIndexPath(forRow:0,inSection:6))
                //self.dataInfoTableView.insertRowsAtIndexPaths(indxesPath, withRowAnimation: UITableViewRowAnimation.Fade)
                self.dataInfoTableView.reloadData()
            }
            
        }else{
            self.userModified = true
            currentUser.weeklyAvailability = idx + 1
            
            //var indxesPath:[NSIndexPath] = [NSIndexPath]()
            //indxesPath.append(NSIndexPath(forRow:0,inSection:5))
            
            self.dataInfoTableView.reloadData()
            
        }
        
    }
    
    func pickerSelector(selector: SBPickerSelector!, cancelPicker cancel: Bool) {
        print("Cancel option pressed.")
    }
    
    func pickerSelector(selector: SBPickerSelector!, intermediatelySelectedValue value: AnyObject!, atIndex idx: Int) {
        //pickerSelector(selector, selectedValue: value as! String, index: idx)
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

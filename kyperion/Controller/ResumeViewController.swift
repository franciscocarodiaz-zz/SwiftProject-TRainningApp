//
//  ResumeViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 10/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class ResumeViewController: UIViewController, userManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{

    // MARK: Header view
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var activityDate: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var sportIcon: UIImageView!
    
    // MARK: Main part view
    @IBOutlet weak var trainerFeedback: UITextView!
    @IBOutlet weak var sendFeedBackButton: KYButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dataView: UIView!
    var userApiManager: UserManager?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setData()
        dataView.animate()
        
        trainerFeedback.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsZero
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.userApiManager = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sendFeedBackButton.configureButtonWithHightlightedShadowAndZoom(true)
        
        self.userApiManager = UserManager()
        self.userApiManager?.delegate = self
        
        if !currentActivity.hasComments {
            self.userApiManager?.getComments()
        }
        
        createDataView()
        
        trainerFeedback?.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonSendMessagePressed(sender: KYButton) {
        var message = trainerFeedback.text
        if message == "" {
            displayMessage(true, message: "Message is empty.")
        }
        self.userApiManager?.sendComment(message)
    }
    
    func displayMessage(updated: Bool, message: String){
        var title = updated ? "Success" : "Error"
        var image = updated ? AssetsManager.checkmarkImage : AssetsManager.crossImage
        KYHUD.sharedHUD.contentView = KYHUDStatusView(title: title, subtitle: message, image: image)
        KYHUD.sharedHUD.show()
        KYHUD.sharedHUD.hide(afterDelay: 3.0)
    }
    
    func setData(){
        activityName.text = currentActivity.activityName
        activityDate.text = currentActivity.dateFormat
        userIcon.applyRoundAndBorder()
        userIcon.loadImage(currentUser.userPicture)
        sportIcon.image = currentActivity.getTypeSportImage()
        trainerFeedback.textColor = UIColor.lightGrayColor()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: - User api manager delegate
    
    func UserManagerRespondWithComments() {
        tableView.reloadData()
    }
    
    func MessageManagerRespondFailure(msgError: String) {
        print("msgError: \(msgError)")
    }
    
    func UserManagerRespondAddComment(success: Bool, message: String){
        displayMessage(success, message: message)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return currentActivity.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! UITableViewCell
        
        let comment : KYComment = currentActivity.comments[indexPath.row]
        
        // Configure the cell...
        
        cell.textLabel!.text = comment.titleRow
        cell.textLabel!.font = UIFont.systemFontOfSize(12)
        
        cell.detailTextLabel!.text = "  \(comment.comment)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
    }
    
    func createDataView(){
    
        var widthItem = self.view.frame.size.width / 3
        var heighItem = CGFloat(20)
        var yFirstRow = CGFloat(8)
        
        // MARK: 1
        let x1: CGFloat = 0
        let y1: CGFloat = yFirstRow
        let width1: CGFloat = widthItem
        let height1: CGFloat = heighItem
        var label1 = UILabel(frame: CGRectMake(x1, y1, width1, height1))
        label1.tag = 1
        label1.text = currentActivity.duration
        label1.textColor = UIColor.grayColor()
        label1.font = UIFont.boldSystemFontOfSize(16.0)
        label1.textAlignment = NSTextAlignment.Center
        label1.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(label1)
        
        var labelTitle1 = UILabel(frame: CGRectMake(x1, y1+height1, width1, height1))
        labelTitle1.tag = 1
        labelTitle1.text = LocalizedString_Resume_1
        labelTitle1.textColor = UIColor.grayColor()
        labelTitle1.font = UIFont.boldSystemFontOfSize(12.0)
        labelTitle1.textAlignment = NSTextAlignment.Center
        labelTitle1.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(labelTitle1)
        
        // MARK: 2
        let x2: CGFloat = widthItem
        let y2: CGFloat = yFirstRow
        let width2: CGFloat = widthItem
        let height2: CGFloat = heighItem
        var label2 = UILabel(frame: CGRectMake(x2, y2, width2, height2))
        label2.tag = 2
        label2.text = currentActivity.distanceWithUnit
        label2.textColor = UIColor.grayColor()
        label2.font = UIFont.boldSystemFontOfSize(16.0)
        label2.textAlignment = NSTextAlignment.Center
        label2.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(label2)
        
        var labelTitle2 = UILabel(frame: CGRectMake(x2, y2+height2, width2, height2))
        labelTitle2.tag = 2
        labelTitle2.text = LocalizedString_Resume_2
        labelTitle2.textColor = UIColor.grayColor()
        labelTitle2.font = UIFont.boldSystemFontOfSize(12.0)
        labelTitle2.textAlignment = NSTextAlignment.Center
        labelTitle2.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(labelTitle2)
        
        // MARK: 3
        let x3: CGFloat = widthItem*2
        let y3: CGFloat = yFirstRow
        let width3: CGFloat = widthItem
        let height3: CGFloat = heighItem
        var label3 = UILabel(frame: CGRectMake(x3, y3, width3, height3))
        label3.tag = 3
        label3.text = currentActivity.paceWithUnit
        label3.textColor = UIColor.grayColor()
        label3.font = UIFont.boldSystemFontOfSize(16.0)
        label3.textAlignment = NSTextAlignment.Center
        label3.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(label3)
        
        var labelTitle3 = UILabel(frame: CGRectMake(x3, y3+height3, width3, height3))
        labelTitle3.tag = 3
        labelTitle3.text = LocalizedString_Resume_3
        labelTitle3.textColor = UIColor.grayColor()
        labelTitle3.font = UIFont.boldSystemFontOfSize(12.0)
        labelTitle3.textAlignment = NSTextAlignment.Center
        labelTitle3.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(labelTitle3)
        
        
        var ySecondRowRow = CGFloat(yFirstRow+(heighItem*2))
        
        // MARK: 4
        let x4: CGFloat = 0
        let y4: CGFloat = ySecondRowRow
        let width4: CGFloat = widthItem
        let height4: CGFloat = heighItem
        var label4 = UILabel(frame: CGRectMake(x4, y4, width4, height4))
        label4.tag = 4
        label4.text = currentActivity.ppm
        label4.textColor = UIColor.grayColor()
        label4.font = UIFont.boldSystemFontOfSize(16.0)
        label4.textAlignment = NSTextAlignment.Center
        label4.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(label4)
        
        var labelTitle4 = UILabel(frame: CGRectMake(x4, y4+height4, width4, height4))
        labelTitle4.tag = 4
        labelTitle4.text = LocalizedString_Resume_4
        labelTitle4.textColor = UIColor.grayColor()
        labelTitle4.font = UIFont.boldSystemFontOfSize(12.0)
        labelTitle4.textAlignment = NSTextAlignment.Center
        labelTitle4.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(labelTitle4)
        
        // MARK: 5
        let x5: CGFloat = widthItem
        let y5: CGFloat = ySecondRowRow
        let width5: CGFloat = widthItem
        let height5: CGFloat = heighItem
        var label5 = UILabel(frame: CGRectMake(x5, y5, width5, height5))
        label5.tag = 5
        label5.text = "\(currentActivity.height.gain)"
        label5.textColor = UIColor.grayColor()
        label5.font = UIFont.boldSystemFontOfSize(16.0)
        label5.textAlignment = NSTextAlignment.Center
        label5.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(label5)
        
        var labelTitle5 = UILabel(frame: CGRectMake(x5, y5+height5, width5, height5))
        labelTitle5.tag = 5
        labelTitle5.text = LocalizedString_Resume_5
        labelTitle5.textColor = UIColor.grayColor()
        labelTitle5.font = UIFont.boldSystemFontOfSize(12.0)
        labelTitle5.textAlignment = NSTextAlignment.Center
        labelTitle5.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(labelTitle5)
        
        // MARK: 6
        let x6: CGFloat = widthItem*2
        let y6: CGFloat = ySecondRowRow
        let width6: CGFloat = widthItem
        let height6: CGFloat = heighItem
        var label6 = UILabel(frame: CGRectMake(x6, y6, width6, height6))
        label6.tag = 6
        label6.text = currentActivity.calory
        label6.textColor = UIColor.grayColor()
        label6.font = UIFont.boldSystemFontOfSize(16.0)
        label6.textAlignment = NSTextAlignment.Center
        label6.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(label6)
        
        var labelTitle6 = UILabel(frame: CGRectMake(x6, y6+height6, width6, height6))
        labelTitle6.tag = 6
        labelTitle6.text = LocalizedString_Resume_6
        labelTitle6.textColor = UIColor.grayColor()
        labelTitle6.font = UIFont.boldSystemFontOfSize(12.0)
        labelTitle6.textAlignment = NSTextAlignment.Center
        labelTitle6.backgroundColor = UIColor.whiteColor()
        dataView.addSubview(labelTitle6)
        
    }
}

//
//  TrashTableViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 13/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class TrashTableViewController: UITableViewController, messageManagerDelegate{
    
    var tableData : [Chat] = []
    
    var messageApiManager: MessageManager?
    
    func reloadScreen() {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadScreen", name: UIApplicationWillEnterForegroundNotification, object: nil )
        
        self.messageApiManager = MessageManager()
        self.messageApiManager?.delegate = self
        
        if !currentUser.hasMessagesTrash {
            createLabelNoData()
            self.messageApiManager?.getTrash()
        }else{
            setTableView()
        }
    }
    
    func setTableView(){
        self.tableData = [Chat]()
        if currentUser.hasMessagesTrash {
            
            for item in currentUser.listMessageTrash {
                var chat : Chat = Chat()
                chat.sender_name = "\(item.sender.fullName)"
                chat.receiver_id = "\(item.recipient.userId)"
                chat.sender_id = "\(item.sender.userId)"
                
                var texts : Array = ["\(item.subject)"]
                
                var last_message : Message = Message();
                
                for text in texts {
                    var message : Message = Message()
                    message.text = text;
                    message.sender = MessageSender.Someone
                    message.status = MessageStatus.Received;
                    message.chat_id = chat.identifier();
                    message.date = NSDate.date(fromString: item.readAt, format: DateFormat.Custom(DATE_FORMAT_ACTIVITY_EXTEND))
                    LocalStorage.sharedInstance().storeMessage(message)
                    
                    last_message = message;
                }
                
                chat.numberOfUnreadMessages = texts.count;
                chat.last_message = last_message;
                
                tableData.append(chat)
            }
            
            tableView.backgroundView = nil
            
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.messageApiManager = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
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
        return self.tableData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        var CellIdentifier = "ChatListCell"
        var cell : ChatCell
        cell = tableView.dequeueReusableCellWithIdentifier("ChatListCell", forIndexPath: indexPath) as! ChatCell
        
        cell.chat = tableData[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
        let chat : Chat = tableData[indexPath.row]
        let email : KYMessage = currentUser.listMessageTrash[indexPath.row]
        
        
        currentEmail = email
    }
    
    func createLabelNoData(){
        var messageLbl :UILabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
        
        //set the message
        messageLbl.text = LocalizedString_EMPTY_LIST_TRASH
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
    
    // MARK: - User api manager delegate
    
    
    func MessageManagerRespondFailure(msgError: String) {
        print("msgError: \(msgError)")
    }
    
    func MessageManagerTrash(){
        setTableView()
    }
    
    // MARK: - Prompt
    
    func displayMessage(updated: Bool, message: String){
        var title = updated ? "Success" : "Error"
        var image = updated ? AssetsManager.checkmarkImage : AssetsManager.crossImage
        KYHUD.sharedHUD.contentView = KYHUDStatusView(title: title, subtitle: message, image: image)
        KYHUD.sharedHUD.show()
        KYHUD.sharedHUD.hide(afterDelay: 3.0)
    }
    
}

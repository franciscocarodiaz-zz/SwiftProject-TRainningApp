//
//  MessagesTableViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class InboxMessagesTableViewController: UITableViewController, messageManagerDelegate{

    var tableData : [Chat] = []
    
    var messageApiManager: MessageManager?
    
    func reloadScreen() {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadScreen", name: UIApplicationWillEnterForegroundNotification, object: nil )

        //self.title = NSLocalizedString("Messages", comment: "Title of the screen messages")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //self.setTest()
        
        self.messageApiManager = MessageManager()
        self.messageApiManager?.delegate = self
        
        if !currentUser.hasMessagesInbox {
            createLabelNoData()
            self.messageApiManager?.getInbox()
        }else{
            self.setTableView()
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
    
    func setTableView(){
        self.tableData = [Chat]()
        if currentUser.hasMessagesInbox {
            
            for item in currentUser.listMessageInbox {
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

    var CellIdentifier = "ChatListCell"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
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
        let email : KYMessage = currentUser.listMessageInbox[indexPath.row]
        
        var sender = email.sender
        var recipient = email.recipient
        
        email.sendTo = sender
        
        currentEmail = email
        
        /*
        var controller : MessageController = [self.storyboard instantiateViewControllerWithIdentifier:@"Message"];
        controller.chat = [self.tableData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
        */
    }
    
    func createLabelNoData(){
        var messageLbl :UILabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
        
        //set the message
        messageLbl.text = LocalizedString_EMPTY_LIST_INBOX
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
    
    func setTest(){
    
        // 1
        var chat : Chat = Chat()
        chat.sender_name = "Entrenador 1";
        chat.receiver_id = "12345";
        chat.sender_id = "54321";
        
        var texts : Array = ["Hello!",
        "How are you today?",
        "Ready?"]
        
        var last_message : Message = Message();
        
        for text in texts {
            var message : Message = Message()
            message.text = text;
            message.sender = MessageSender.Someone
            message.status = MessageStatus.Received;
            message.chat_id = chat.identifier();
            LocalStorage.sharedInstance().storeMessage(message)
            
            last_message = message;
        }
        
        chat.numberOfUnreadMessages = texts.count;
        chat.last_message = last_message;
        
        self.tableData.append(chat)
        
        // 2
        
        var chat2 : Chat = Chat()
        chat2.sender_name = "Entrenador 2";
        chat2.receiver_id = "12345";
        chat2.sender_id = "54322";
        
        var texts2 : Array = ["Hello!",
            "How are you today?",
            "I'm ready."]
        
        var last_message2 : Message = Message();
        
        for text in texts2 {
            var message : Message = Message()
            message.text = text;
            message.sender = MessageSender.Someone
            message.status = MessageStatus.Received;
            message.chat_id = chat.identifier();
            LocalStorage.sharedInstance().storeMessage(message)
            
            last_message2 = message;
        }
        
        chat2.numberOfUnreadMessages = texts2.count;
        chat2.last_message = last_message2;
        
        self.tableData.append(chat2)
        
        // 3
        
        var chat3 : Chat = Chat()
        chat3.sender_name = "Entrenador 3";
        chat3.receiver_id = "12345";
        chat3.sender_id = "54321";
        
        var texts3 : Array = ["Hello!",
            "I'm ready.",
            "How are you today?"]
        
        var last_message3 : Message = Message();
        
        for text in texts3 {
            var message : Message = Message()
            message.text = text;
            message.sender = MessageSender.Someone
            message.status = MessageStatus.Received;
            message.chat_id = chat.identifier();
            LocalStorage.sharedInstance().storeMessage(message)
            
            last_message3 = message;
        }
        
        chat3.numberOfUnreadMessages = texts3.count;
        chat3.last_message = last_message3;
        
        
        
        self.tableData.append(chat3)
        self.tableView.reloadData()
        
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
    
    // MARK: - User api manager delegate
    
    
    func MessageManagerRespondFailure(msgError: String) {
        print("msgError: \(msgError)")
    }
    
    func MessageManagerInbox(){
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

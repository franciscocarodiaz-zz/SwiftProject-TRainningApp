//
//  MessageManagerViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 13/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class MessageManagerViewController: UIViewController {

    @IBOutlet weak var messagePages: SwiftPages!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizedString_ProfileManager_MessageVC
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        // Init
        //let buttonTitles : [String] = [LocalizedString_ProfileManager_ListActivityVC, LocalizedString_ProfileManager_ProfileVC, LocalizedString_ProfileManager_DiaryVC]
        
        messagePages.setOriginY(0.0)
        messagePages.setOriginY(0.0)
        messagePages.setTopBarHeight(30)
        messagePages.enableAeroEffectInTopBar(false)
        messagePages.setButtonsTextColor(UIColor.mainAppColor())
        messagePages.setAnimatedBarColor(UIColor.mainAppColor())
        
        let VCIDs : [String] = ["InboxMessagesTableViewController", "OutboxTableViewController", "TrashTableViewController"]
        let buttonTitles : [String] = ["Inbox", "Outbox", "Trash"]
        messagePages.section = messagePages.VC_MESSAGE
        messagePages.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = composeButtonItem
        
        currentEmail = KYMessage()
        
        
    }
    
    var composeButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "composeButtonPressed:")
    }
    
    func composeButtonPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SEGUE_COMPOSE_MESSAGE, sender: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

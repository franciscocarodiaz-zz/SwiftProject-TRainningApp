//
//  KYMessage.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class KYMessage: NSObject {
    var id:Int = 0;
    var subject:String = "";
    var body:String = "";
    var sender: KYUser = KYUser()
    var sendTo: KYUser = KYUser()
    var recipient: KYUser = KYUser()
    var parentMsg:String = "";
    var sentAt:String = "";
    var readAt:String = "";
    var repliedAt:String = "";
    var senderDeletedAt:String = "";
    var recipientDeletedAt:String = "";
    
    override init(){
        self.id = 0
        let today = NSDate.today()
        self.subject = ""
        self.body = ""
        self.sender = KYUser()
        self.recipient = KYUser()
        self.parentMsg = ""
        self.sentAt = today.toString(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
        self.repliedAt = today.toString(format: DateFormat.Custom(DATE_FORMAT_ACTIVITY))
    }
    
    func customDescription() -> String {
        return "\(self.sender) : \(self.subject) > \(self.body)"
    }
    
    override var description: String { return customDescription() }
}

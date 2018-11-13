//
//  MessageMethods.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import SwiftyJSON

extension KYMessage{
    
    convenience init(listMessageData: JSON) {
        self.init()
        var errors = [String]()
        var listMessage = [KYMessage]()
        
        for item in listMessageData.arrayValue {
            var newmessage = KYMessage(item)
            
            listMessage.append(newmessage)
        }
        
        if(errors.count>0){
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }else{
            currentUser.listMessage = listMessage
        }
        
    }
    
    convenience init(listMessageInboxData: JSON) {
        self.init()
        var errors = [String]()
        var listMessage = [KYMessage]()
        
        for item in listMessageInboxData.arrayValue {
            var newmessage = KYMessage(item)
            
            listMessage.append(newmessage)
        }
        
        if(errors.count>0){
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }else{
            currentUser.listMessageInbox = listMessage
        }
        
    }
    
    convenience init(listMessageOutboxData: JSON) {
        self.init()
        var errors = [String]()
        var listMessage = [KYMessage]()
        
        for item in listMessageOutboxData.arrayValue {
            var newmessage = KYMessage(item)
            
            listMessage.append(newmessage)
        }
        
        if(errors.count>0){
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }else{
            currentUser.listMessageOutbox = listMessage
        }
        
    }
    
    convenience init(listMessageTrashData: JSON) {
        self.init()
        var errors = [String]()
        var listMessage = [KYMessage]()
        
        for item in listMessageTrashData.arrayValue {
            var newmessage = KYMessage(item)
            
            listMessage.append(newmessage)
        }
        
        if(errors.count>0){
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }else{
            currentUser.listMessageTrash = listMessage
        }
        
    }
    
    convenience init(_ dictionary: JSON) {
        self.init()
        var errors = [String]()
        
        for (key,value) in dictionary{
            
            switch key {
            case MESSAGE_PARAMS_PK:
                self.id = dictionary[MESSAGE_PARAMS_PK].int!
            case MESSAGE_PARAMS_SUBJECT:
                self.subject = dictionary[MESSAGE_PARAMS_SUBJECT].string!
            case MESSAGE_PARAMS_BODY:
                self.body = dictionary[MESSAGE_PARAMS_BODY].string!
            case MESSAGE_PARAMS_SENDER:
                self.sender = KYUser(dictionary[MESSAGE_PARAMS_SENDER])
            case MESSAGE_PARAMS_RECIPIENT:
                self.recipient = KYUser(dictionary[MESSAGE_PARAMS_RECIPIENT])
            case MESSAGE_PARAMS_SENT_AT:
                if let send = dictionary[MESSAGE_PARAMS_SENT_AT].string {
                    self.sentAt = send
                }
            case MESSAGE_PARAMS_READ_AT:
                if let read = dictionary[MESSAGE_PARAMS_READ_AT].string {
                    self.readAt = read
                }
                
            default:
                print("KYMEssage: No key " + key + " recognized for user object model.")
            }
        
        }
        
    }
    
    var composeTo : KYUser {
        if currentUser.userId == sender.userId {
            return recipient
        }
        return sender
    }
}
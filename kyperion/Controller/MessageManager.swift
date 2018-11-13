//
//  MessageManager.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
// Messages : https://staging-api.kyperion.com/docs/#!/messages

@objc protocol messageManagerDelegate:NSObjectProtocol {
    
    // MARK: Login,Register methods
    optional func MessageManagerRespond(message: KYMessage)
    optional func MessageManagerRespondFailure(msgError: String)
    
    // MARK: User accessory methods
    optional func MessageManagerAll()
    optional func MessageManagerInbox()
    optional func MessageManagerOutbox()
    optional func MessageManagerTrash()
    
    optional func MessageManagerRespondSendSuccess()
    
}

class MessageManager: NSObject {
    var delegate: messageManagerDelegate?
    var manager: Manager?
    var managerInbox: Manager?
    var managerOutbox: Manager?
    var managerTrash: Manager?
    var managerUser: Manager?
    
    var request: NSURLRequest?
    var response: NSHTTPURLResponse?
    var data: AnyObject?
    var error: NSError?
    var JSON: AnyObject?
    
    override init() {
        self.manager = Alamofire.Manager()
        self.manager!.startRequestsImmediately = true
        
        self.managerInbox = Alamofire.Manager()
        self.managerInbox!.startRequestsImmediately = true
        
        self.managerOutbox = Alamofire.Manager()
        self.managerOutbox!.startRequestsImmediately = true
        
        self.managerTrash = Alamofire.Manager()
        self.managerTrash!.startRequestsImmediately = true
    }
    
    // MARK: User methods
    
    func getMessage(idMessage: Int){
        let parameters = [
            "message_id": idMessage
        ]
        
        var messageIdentifier = "\(idMessage)"
        let urlString = API(caseAPI:CONST_API_MESSAGE_GET).url + messageIdentifier + URL_SEPARATOR
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            
            if(error == nil){
                var message = KYMessage(data)
                self.delegate?.MessageManagerRespond!(message)
            }else{
                //self.delegate?.ActivityManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
    }
    
    func createMessage(subject: String, body: String, recipient: Int){
        var message = KYMessage()
        message.subject = subject
        message.body = body
        //message.recipient = recipient
    }
    
    func sendMessage(){
        
        var subject = currentEmail.subject
        var body = currentEmail.body
        var recipient = currentEmail.recipient.userId.toInt()!
        
        currentEmail.sender = currentUser
        
        let parameters = [
            "subject": subject,
            "body": body,
            "recipient": recipient
        ]
        
        let urlString = "https://staging-api.kyperion.com:443/api/v1/messages/new/"
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        /*
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            if(error == nil){
                self.delegate?.MessageManagerRespondSendSuccess!()
            }else{
                self.delegate?.MessageManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
        */
        
        Alamofire.request(.POST, mutableURLRequest, parameters: parameters as? [String : AnyObject], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            let keyStr = "Token \(tokenUser)"
            mutableRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            mutableRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            var myBodyString = "subject=\(subject)&body=\(body)&recipient=\(recipient)"
            mutableRequest.HTTPBody = myBodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON {
            (request, response, data, error) -> Void in
            
            if(error == nil){
                
                var id: Int = data!.objectForKey("id") as! Int
                currentEmail.id = id
                currentUser.listMessageOutbox.append(currentEmail)
                self.delegate?.MessageManagerRespondSendSuccess!()
                
            }else{
                self.delegate?.MessageManagerRespondFailure!(error!.localizedDescription)
            }
        }
    }
    
    func getAllMessages(){
        let urlString = API(caseAPI:CONST_API_MESSAGE_ALL).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            if(error == nil){
                KYMessage(listMessageData:data)
                self.delegate?.MessageManagerAll!()
            }else{
                self.delegate?.MessageManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
    }
    
    func getInbox(){
        let urlString = "https://staging-api.kyperion.com/api/v1/messages/?folder=" + "inbox"
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.managerInbox!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            if(error == nil){
                KYMessage(listMessageInboxData:data)
                self.delegate?.MessageManagerInbox!()
            }else{
                //self.delegate?.ActivityManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
    }
    
    func getOutbox(){
        let urlString = "https://staging-api.kyperion.com/api/v1/messages/?folder=" + "outbox"
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.managerOutbox!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            if(error == nil){
                KYMessage(listMessageOutboxData:data)
                self.delegate?.MessageManagerOutbox!()
            }else{
                //self.delegate?.ActivityManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
    }
    
    func getTrash(){
        let urlString = "https://staging-api.kyperion.com/api/v1/messages/?folder=" + "trash"
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.managerTrash!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            if(error == nil){
                KYMessage(listMessageTrashData:data)
                self.delegate?.MessageManagerTrash!()
            }else{
                //self.delegate?.ActivityManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
    }
}

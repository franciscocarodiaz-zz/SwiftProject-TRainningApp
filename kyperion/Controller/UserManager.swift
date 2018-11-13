//
//  UserManager.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
// User : https://dev.kyperion.com:8005/docs/#!/user

@objc protocol userManagerDelegate:NSObjectProtocol {
    
    // MARK: Login,Register methods
    optional func UserManagerRespond(user: AnyObject)
    optional func UserManagerRespondFailure(msgError: String)
    optional func UserManagerRespondLogOut()
    
    // MARK: User accessory methods
    optional func UserManagerAccesoryRespond()
    
    // MARK: User comment methods
    optional func UserManagerRespondAddComment(success: Bool, message: String)
    optional func UserManagerRespondWithComments()
    
}

class UserManager: NSObject,userManagerDelegate{
    
    var delegate: userManagerDelegate?
    var manager: Manager?
    var managerUser: Manager?
    
    var request: NSURLRequest?
    var response: NSHTTPURLResponse?
    var data: AnyObject?
    var error: NSError?
    var JSON: AnyObject?
    
    override init() {
        self.manager = Alamofire.Manager()
        self.manager!.startRequestsImmediately = true
    }
    
    // MARK: User methods
    
    func updateCurrentUser(){
        
        var firstName = currentUser.firstName
        var lastName = currentUser.lastName
        var gender = currentUser.gender.description
        var birthday = currentUser.birthdayStr
        var password = currentUser.login.password
        
        var allergies = currentUser.allergiesAPIFormat
        var medications = currentUser.medicationsAPIFormat
        var injuries = currentUser.injuriesAPIFormat
        var surgeries = currentUser.surgeriesAPIFormat
        var notes = currentUser.notes
        var training_since = currentUser.trainingSince
        var weekly_availability = "\(currentUser.weeklyAvailability)"
        var time_availability = currentUser.timeAvailabilityAPIFormat
        
        let parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender,
            "birthday": birthday,
            "allergies":allergies,
            "medications":medications,
            "injuries":injuries,
            "surgeries":surgeries,
            "notes":notes,
            "training_since":training_since,
            "weekly_availability":weekly_availability,
            "time_availability":time_availability
        ]

        
        let urlString = API(caseAPI:CONST_API_AUTH_USER).url // https://staging-api.kyperion.com:443/api/v1/auth/user/
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        Alamofire.request(.PATCH, mutableURLRequest, parameters: parameters, encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            let keyStr = "Token \(tokenUser)"
            mutableRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            mutableRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            var myBodyString = "allergies=\(allergies)&medications=\(medications)&injuries=\(injuries)&surgeries=\(surgeries)&notes=\(notes)&training_since=\(training_since)&weekly_availability=\(weekly_availability)&time_availability=\(time_availability)"
            mutableRequest.HTTPBody = myBodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON {
            (request, response, data, error) -> Void in
            var updated = false
            if(error == nil){
                updated = true
            }else{
                currentUser = configCurrentUser
            }
        }
    }
    
    func updateUser(oldPassword: String, newPassword: String, firstName: String, lastName:String, gender:String, birthday:String){
        
        var passwordIsTheSame = (oldPassword==newPassword)
        
        let parameters = [
            "first_name": firstName,
            "last_name": lastName,
            "gender": gender,
            "birthday": birthday
        ]
        
        let urlString = API(caseAPI:CONST_API_AUTH_USER).url // https://staging-api.kyperion.com:443/api/v1/auth/user/
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        Alamofire.request(.PATCH, mutableURLRequest, parameters: parameters, encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            let keyStr = "Token \(tokenUser)"
            mutableRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            mutableRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            var myBodyString = "first_name=\(firstName)&last_name=\(lastName)&gender=\(gender)&birthday=\(birthday)"
            mutableRequest.HTTPBody = myBodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON {
            (request, response, data, error) -> Void in
            var updated = false
            if(error == nil){
                updated = true
            }else{
                currentUser = configCurrentUser
            }
            if !passwordIsTheSame {
                self.updateUserPassword(oldPassword, newPassword: newPassword, updated: updated)
            }else{
                self.displayMessage(updated, message:LocalizedString_USER_UPDATED)
            }
        }
    }
    
    func displayMessage(updated: Bool, message: String){
        var title = updated ? "Success" : "Error"
        var image = updated ? AssetsManager.checkmarkImage : AssetsManager.crossImage
        KYHUD.sharedHUD.contentView = KYHUDStatusView(title: title, subtitle: message, image: image)
        KYHUD.sharedHUD.show()
        KYHUD.sharedHUD.hide(afterDelay: 3.0)
    }
    
    func updateUserPassword(oldPassword: String, newPassword: String, updated: Bool){
        
        let parameters = [
            "old_password":oldPassword,
            "new_password1": newPassword,
            "new_password2": newPassword
        ]
        
        let urlString = API(caseAPI:CONST_API_AUTH_CHANGE_PASSWORD).url // https://staging-api.kyperion.com:443/api/v1/auth/password/change/
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        Alamofire.request(.POST, mutableURLRequest, parameters: parameters, encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            let keyStr = "Token \(tokenUser)"
            mutableRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            mutableRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            var myBodyString = "old_password=\(oldPassword)&new_password1=\(newPassword)&new_password2=\(newPassword)"
            mutableRequest.HTTPBody = myBodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON {
            (request, response, data, error) -> Void in
            
            if(error == nil){
                var message = updated ? LocalizedString_USER_UPDATED_AND_PASSWORD : LocalizedString_USER_UPDATED_PASSWORD
                self.displayMessage(true, message:message)
            }else{
                var message = LocalizedString_USER_UPDATED_PASSWORD_ERROR
                if updated {
                    message = message + "\n " + LocalizedString_USER_UPDATED
                }else{
                    message = message + "\n " + LocalizedString_USER_UPDATED_ERROR
                }
                self.displayMessage(false, message:message)
            }
        }
        
    }
    
    // MARK: Login methods
    
    func tokenWithUserPass(username: String, password: String){
        
        let parameters = [
            "username": username,
            "password": password
        ]
        
        let urlString = API(caseAPI:CONST_API_AUTH_LOGIN).url
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON {
            (request, response, data, error) -> Void in
            
            if(error == nil){
                if let key = (data?.valueForKey("key")){
                    
                    let token : String = key as! String
                    currentUser.login = KYLogin(username: username, password: password, token:token)
                    
                    // Save user data in Keychain
                    KYKeychain.set(token, forKey: TAG_KEYCHAIN_KEYNAME_KEY)
                    
                    if DEBUG_MOD {
                        print("Token for user: \(token)")
                    }
                }
            }else{
                if DEBUG_MOD {
                    print("Error getting token for user: \(username)-\(password)")
                }
            }
        }
    }
    
    func loginWithUserPass(username: String, pass: String){
        
        let parameters = [
            "username": username,
            "password": pass
        ]
        
        let urlString = API(caseAPI:CONST_API_AUTH_LOGIN).url
        
        self.manager!.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON {
            (request, response, data, error) -> Void in
            
            if(error == nil){
                if let key = (data?.valueForKey("key")){
                    self.getUser(key as! String,username: username, pass: pass)
                }else{
                    self.delegate?.UserManagerRespondFailure!("Error getting user credentials")
                }
            }else{
                self.delegate?.UserManagerRespondFailure!(error!.localizedDescription)
            }
        }
    }
    
    func getUser(key: String, username: String, pass: String){
        
        let urlString = API(caseAPI:CONST_API_AUTH_USER).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(key)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            self.manageUserData(data, username: username, password: pass, token:key)
        })
        
    }
    
    // MARK: Register methods
    
    func registerNewUser(name: String, email: String, password: String){
        
        if name == "" || email == "" || password == "" {
            
            let msgError = NSLocalizedString("Wrong credential", comment: "Register incorrect")
            self.delegate?.UserManagerRespondFailure!(msgError)
            
        }else{
            
            let parameters = [
                "username": name,
                "email": email,
                "password1": password
            ]
            
            let urlString = API(caseAPI:CONST_API_REGISTRATION).url
            let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            let keyStr = "Token \(tokenUser)"
            mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            
            self.manager!.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseSwiftyJSON( {
                (request, response, data, error) -> Void in
                
                
                if(error == nil){
                    self.manageUserData(data, username: name, password: password, token:"")
                }else{
                    let msgError = NSLocalizedString("Wrong credential from server.", comment: "Register incorrect")
                    self.delegate?.UserManagerRespondFailure!(msgError)
                }
                
            })
        
        }
    }
    
    private func manageUserData(data: SwiftyJSON.JSON, username: String, password: String, token: String) {
    
        var user = KYUser()
        if(self.error == nil){
            user = KYUser(data)
        }
        
        if user.isValid && user.userType == UserType.USR {
            user.login = KYLogin(username: username, password: password, token:token)
            
            // Save user data in Keychain
            /*
            KYKeychain.set(token, forKey: TAG_KEYCHAIN_KEYNAME_KEY)
            KYKeychain.set(username, forKey: TAG_KEYCHAIN_USERNAME_KEY)
            KYKeychain.set(password, forKey: TAG_KEYCHAIN_PASSWORD_KEY)
            */
            
            // Save user data in NSUserDefault
            tokenUser = token
            usernameLoggin = username
            passwordLoggin = password
            
            // Valid Navigate to Main screen
            self.delegate?.UserManagerRespond!(user)
        }else{
            var errorMessage = NSLocalizedString("Error getting user data from kyperion server.", comment: "API data error")
            if user.userType == UserType.TRN {
                errorMessage = NSLocalizedString("A trainer should access the web app", comment: "Only USR should use the app")
            }
            if DEBUG_MOD {
                print(data)
            }
            self.delegate?.UserManagerRespondFailure!(errorMessage)
        }
        
    }
    
    // MARK: get /api/v1/user/{user_id}/accessories
    func getAccesories(){
        
        let urlString = API(caseAPI:CONST_API_USER_ACCESORIES).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            if(error == nil){
                KYAccessory(listAccessoryData: data)
                self.delegate?.UserManagerAccesoryRespond!()
            }else{
                print(error)
                self.delegate?.UserManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
        
    }
    
    func saveAccesory(){
        
        var pk = currentUser.userId
        var name = newAccesory.name
        var brand = newAccesory.brand
        var type = newAccesory.sport
        var publicAcc = newAccesory.publicAccessory
        
        let parameters = [
            "pk":pk,
            "name": name,
            "brand": brand,
            "type":type,
            "public":publicAcc
        ]
        
        let urlString = API(caseAPI:CONST_API_USER_ACCESORIES).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        Alamofire.request(.POST, mutableURLRequest, parameters: parameters as? [String : AnyObject], encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            let keyStr = "Token \(tokenUser)"
            mutableRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            mutableRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            var myBodyString = "pk=\(pk)&name=\(name)&brand=\(brand)&type=\(type)&public=\(publicAcc)"
            mutableRequest.HTTPBody = myBodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON {
            (request, response, data, error) -> Void in
            
            if(error == nil){
                self.delegate?.UserManagerAccesoryRespond!()
            }else{
                self.delegate?.UserManagerRespondFailure!(error!.localizedDescription)
            }
        }
        
    }
    
    /*
    func getAccessories(){
    
    let urlString = "https://staging-api.kyperion.com:443/api/v1/user/\(currentUser.userId)/accessories"
    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
    let keyStr = "Token \(tokenUser)"
    mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
    
    self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
    (request, response, data, error) -> Void in
    
    if(error == nil){
    KYAccessory(listAccessoryData: data)
    self.delegate?.UserManagerRespondWithAccessories!()
    }else{
    print(error)
    self.delegate?.UserManagerRespondFailure!(error!.localizedDescription)
    }
    
    })
    
    }
    */
    
    // MARK: COMMENTS
    
    func sendComment(comment: String){
        
        let parameters = [
            "pk": currentActivity.activityId,
            "comment": comment
        ]
        
        let urlString = API(caseAPI:CONST_API_USER_ACTIVITY_COMMENTS).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        Alamofire.request(.POST, mutableURLRequest, parameters: parameters, encoding: .Custom({
            (convertible, params) in
            var mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            let keyStr = "Token \(tokenUser)"
            mutableRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
            mutableRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            var myBodyString = "comment=\(comment)"
            mutableRequest.HTTPBody = myBodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        })).responseJSON {
            (request, response, data, error) -> Void in
            
            if(error == nil){
                self.delegate?.UserManagerRespondAddComment!(true, message: "Message sent.")
            }else{
                self.delegate?.UserManagerRespondAddComment!(false, message: "Message not sent.")
            }
        }
    }
    
    func getComments(){
        
        let urlString = API(caseAPI:CONST_API_USER_ACTIVITY_COMMENTS).url
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(mutableURLRequest).responseSwiftyJSON ({
            (request, response, data, error) -> Void in
            
            if(error == nil){
                KYComment(listCommentData: data)
                self.delegate?.UserManagerRespondWithComments!()
            }else{
                print(error)
                self.delegate?.UserManagerRespondFailure!(error!.localizedDescription)
            }
            
        })
        
    }
    
    func logout(){
    
        let parameters = [
            "pk": currentUser.userId
        ]
        
        let urlString = "https://staging-api.kyperion.com:443/api/v1/auth/logout/"
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let keyStr = "Token \(tokenUser)"
        mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
        
        self.manager!.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseSwiftyJSON( {
            (request, response, data, error) -> Void in
            
            
            if(error == nil){
                
                if let message = data["success"].string {
                    if message == "Successfully logged out." {
                        self.delegate?.UserManagerRespondLogOut!()
                    }else{
                        let msgError = NSLocalizedString("Error: "+message, comment: "Register incorrect")
                        self.delegate?.UserManagerRespondFailure!(msgError)
                    }
                    
                }
                let msgError = NSLocalizedString("Error from server.", comment: "Register incorrect")
                self.delegate?.UserManagerRespondFailure!(msgError)
                
            }else{
                let msgError = NSLocalizedString("Error from server.", comment: "Register incorrect")
                self.delegate?.UserManagerRespondFailure!(msgError)
            }
            
        })
    
    }
    
    
}
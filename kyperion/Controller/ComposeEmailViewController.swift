//
//  ComposeEmailViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 13/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ComposeEmailViewController: UIViewController, UITextViewDelegate, messageManagerDelegate {

    var messageApiManager: MessageManager?
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var emailTo: AutoCompleteTextField!
    var emailToUserSelected = KYUser()
    var usersSuggestion = [KYUser]()
    
    @IBOutlet weak var emailFromLabel: UILabel!
    //@IBOutlet weak var emailToLabel: AutoCompleteTextField!
    @IBOutlet weak var emailSubjectLabel: UITextField!
    @IBOutlet weak var emailBodyLabel: UITextView!
    
    var manager: Manager?
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.keyboardHeightLayoutConstraint?.constant = 5.0
        self.view.layoutIfNeeded()
        tap.enabled = false
    }
    
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        tap.enabled = true
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        tap = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        tap.enabled = false
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Compose"
        
        self.messageApiManager = MessageManager()
        self.messageApiManager?.delegate = self
        
        configureTextField()
        handleTextFieldInterfaces()
        
        setEmailLabels()
        emailBodyLabel?.delegate = self
        
        configureScreenLabels()
        
        self.manager = Alamofire.Manager()
        self.manager!.startRequestsImmediately = true
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.messageApiManager = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            print("Back")
        })
    }

    @IBAction func sendEmailButtonPressed(sender: UIBarButtonItem) {
        print("Send Message")
        
        if body != "" && recipient != 0 && subject != "" {
            currentEmail.body = body
            currentEmail.subject = subject
            currentEmail.recipient = emailToUserSelected
            self.messageApiManager?.sendMessage()
        }else{
            displayMessage(false, message:"Please, you should fill all the parameter: recopient, subject and body")
        }
        
        
        
    }
    
    var subject : String {
        return emailSubjectLabel.text
    }
    
    var recipient : Int {
        return emailToUserSelected.userId.toInt()!
    }
    
    var body : String {
        return emailBodyLabel.text
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LocalizedString_Body
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    
    // MARK: - Configure screen
    
    func configureScreenLabels(){
        fromLabel.text = LocalizedString_From
        toLabel.text = LocalizedString_To
        subjectLabel.text = LocalizedString_Subject
        emailBodyLabel.textColor = UIColor.lightGrayColor()
    }
    
    func setEmailLabels(){
        emailFromLabel.text = currentUser.fullName
        emailTo.text = currentEmail.sendTo.fullName
        emailToUserSelected = currentEmail.sendTo
        
        //emailSubjectLabel.text = LocalizedString_Subject
        emailBodyLabel.text = LocalizedString_Body
        emailTo.autoCompleteStrings = nil
        /*
        if currentEmail.sendTo.senderIsValid {
            emailBodyLabel.becomeFirstResponder()
        }else{
            emailTo.becomeFirstResponder()
        }
        */
    }
    
    private func configureTextField(){
        emailTo.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        emailTo.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        emailTo.autoCompleteCellHeight = 35.0
        emailTo.maximumAutoCompleteCount = 20
        emailTo.hidesWhenSelected = true
        emailTo.hidesWhenEmpty = true
        emailTo.enableAttributedText = true
        // emailToLabel?.delegate = self
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        emailTo.autoCompleteAttributes = attributes
        
        emailTo.setupAutocompleteTable(self.view)
    }
    
    private func handleTextFieldInterfaces(){
        emailTo.onTextChange = {[weak self] text in
            if !text.isEmpty{
                print("onTextChange" + text)
                let newText = text.stringByReplacingOccurrencesOfString(" ", withString: "")
                let urlString = "https://staging-api.kyperion.com:443/api/v1/user/search/\(newText)/"
                let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
                let keyStr = "Token \(tokenUser)"
                mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
                
                self!.manager!.request(mutableURLRequest).responseSwiftyJSON ({
                    (request, response, data, error) -> Void in
                    
                    if(error == nil){
                        self!.usersSuggestion = [KYUser]()
                        if data["count"] > 0 {
                            var users = [String]()
                            
                            for item in data["results"].arrayValue {
                                var newUser = KYUser(item)
                                self!.usersSuggestion.append(newUser)
                                users.append(newUser.fullName)
                            }
                            self?.emailTo.autoCompleteStrings = users
                            print(users)
                        }else{
                            self?.emailTo.autoCompleteStrings = nil
                        }
                    }else{
                        self?.emailTo.autoCompleteStrings = nil
                    }
                    
                })
                
                /*
                let urlString = "https://staging-api.kyperion.com:443/api/v1/user/search/\(text)/"
                let url = NSURL(string: urlString.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!)
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
                */
            }
        }
        
        emailTo.onSelect = {[weak self] text, indexpath in
            if !text.isEmpty{
                print("onSelect" + text)
                self!.emailToUserSelected = self!.usersSuggestion[indexpath.row]
                self!.emailTo.text = self!.emailToUserSelected.fullName
            }
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
    
    // MARK: - Prompt
    
    func displayMessage(updated: Bool, message: String){
        var title = updated ? "Success" : "Error"
        var image = updated ? AssetsManager.checkmarkImage : AssetsManager.crossImage
        KYHUD.sharedHUD.contentView = KYHUDStatusView(title: title, subtitle: message, image: image)
        KYHUD.sharedHUD.show()
        KYHUD.sharedHUD.hide(afterDelay: 3.0)
    }
    
    // MARK: - Message api manager delegate
    
    func MessageManagerRespondFailure(msgError: String) {
        displayMessage(false, message:"Please, error sending your email.")
    }
    
    func MessageManagerRespondSendSuccess(){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.displayMessage(true, message:"Message sent.")
            NSNotificationCenter.defaultCenter().postNotificationName(updateListOutBoxMessageTableViewNotificationKey, object: nil)
        })
        
    }
    
    

}

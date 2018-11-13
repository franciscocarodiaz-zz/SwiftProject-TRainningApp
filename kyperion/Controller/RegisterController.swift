//
//  RegisterViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, userManagerDelegate, KYPromptsProtocol {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    // MARK: Input text
    
    @IBOutlet weak var registerName: KYTextField!
    @IBOutlet weak var registerEmail: KYTextField!
    @IBOutlet weak var registerPassword: KYTextField!
    
    @IBOutlet weak var conditionAndTermLabel: UILabel!
    @IBOutlet weak var conditionAndTermSwitch: UISwitch!
    
    
    var userApiManager: UserManager?
    var prompt = KYPromptsView()
    
    var nameTextField : String = ""
    var emailTextField : String = ""
    var passwordTextField : String = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navBar.title = titleNavBar
        conditionAndTermLabel.text = NSLocalizedString("Accept term and conditions", comment: "Label for accept conditions in register screen")
        
        buildForm()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userApiManager = UserManager()
        self.userApiManager?.delegate = self
        
        if(DEBUG_MOD){
            registerName.text = "franciscotest14"
            registerEmail.text = "franciscocaro14@gmail.com"
            registerPassword.text = "123456"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.userApiManager = nil
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func acceptRegisterButtonPressed(sender: KYButton) {
        nameTextField = self.registerName.text!
        emailTextField = self.registerEmail.text!
        passwordTextField = self.registerPassword.text!
        
        var error : Bool = false
        buildForm()
        
        if nameTextField == "" || nameTextField.length > 30 {
            error = true
            registerName.placeholder = NSLocalizedString("Enter a valid name. 30 characters or fewer. Letters, digits and @/./+/-/_ only", comment: "Error lenght in user register field: Name")
            registerName.placeholderColor = UIColor.redColor()
        }
        
        if emailTextField == "" || !emailTextField.isEmail() {
            error = true
            registerEmail.placeholder = NSLocalizedString("Enter a valid email address.", comment: "Error lenght in user register field: Name")
            registerEmail.placeholderColor = UIColor.redColor()
        }
        if passwordTextField == "" && passwordTextField.length>6 {
            error = true
            registerPassword.placeholder = NSLocalizedString("Password must be a minimum of 6 characters.", comment: "Error lenght in user register field: Name")
            registerPassword.placeholderColor = UIColor.redColor()
        }
        
        let errorMsg = NSLocalizedString("Wrong credential", comment: "Register incorrect")
        if error {
            createPrompt(errorMsg)
        }else{
            var errorMsg = NSLocalizedString("It's ok", comment: "Register incorrect")
            if !conditionAndTermSwitch.on {
                errorMsg = NSLocalizedString("You must accept conditions and term to continue.", comment: "Register incorrect")
                createPrompt(errorMsg)
            }else{
                displayLoaderWithMessage(MSG_CREATING_USER)
                self.userApiManager?.registerNewUser(nameTextField, email: emailTextField, password: passwordTextField)
            }
            
        }
    }
    
    
    
    // MARK: - Auxiliar variable
    
    var titleNavBar: String  {
        get {
            let register = NSLocalizedString("Register", comment: "Register title")
            var userType = ""
            if currentUser.isCoach {
                userType = NSLocalizedString("Coach", comment: "Secondary title for type of coach user")
            }else{
                userType = NSLocalizedString("User", comment: "Secondary title for type of general user")
            }
            let resultStr = "\(register) \(userType)"
            return resultStr
        }
    }
    
    // MARK: - Auxiliar funcions
    
    func buildForm(){
    
        registerName.placeholder = NSLocalizedString("Name*", comment: "User register field: Name")
        registerEmail.placeholder = NSLocalizedString("Email*", comment: "User register field: Email")
        registerPassword.placeholder = NSLocalizedString("Password*", comment: "User register field: Password")
        
        registerName.placeholderColor = UIColor.whiteColor()
        registerEmail.placeholderColor = UIColor.whiteColor()
        registerPassword.placeholderColor = UIColor.whiteColor()
    
    }

    // MARK: - Delegate functions for the prompt
    
    func createPrompt(textToDisplay: String){
        hideLoader(delay: 0.0)
        
        prompt = KYPromptsView .createPromptWithMessageAndBounds(textToDisplay, bounds: self.view.bounds)
        prompt.delegate = self
        prompt.isActive = true
        
        self.view.addSubview(prompt)
        
    }
    
    func clickedOnTheMainButton() {
        prompt.dismissPrompt()
    }
    
    func clickedOnTheSecondButton() {
        prompt.dismissPrompt()
    }
    
    func promptWasDismissed() {
        prompt.isActive = false
    }
    
    // MARK: - Orientation functions
    
    override func shouldAutorotate() -> Bool {
        return !prompt.isActive
    }
    
    // MARK: - User api manager delegate
    func UserManagerRespond(user: AnyObject) {
        currentUser = user as! KYUser
        
        self.userApiManager?.request = nil
        self.userApiManager?.tokenWithUserPass(currentUser.login.username, password: currentUser.login.password)
        
        hideLoader()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("rootViewController") as! RootViewController
        /*
        if DEBUG_MOD_TEST{
        storyboard = UIStoryboard(name: "MainTest", bundle: nil)
        vc = storyboard.instantiateViewControllerWithIdentifier("mainTestViewController") as! MainTestViewController
        }
        */
        self.presentViewController(vc, animated: true, completion: nil)
    }
    func UserManagerRespondFailure(msgError: String) {
        hideLoader(delay: 0.0)
        createPrompt(msgError)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Loader
    
    func displayLoaderWithMessage(textMessage: String){
        KYHUD.sharedHUD.contentView = KYHUDSubtitleView(subtitle: textMessage)
        KYHUD.sharedHUD.show()
    }
    
    func hideLoader(delay: NSTimeInterval = 1.0){
        KYHUD.sharedHUD.hide(afterDelay: delay)
    }

}

//
//  LoginController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit


class LoginController: UIViewController, userManagerDelegate, KYPromptsProtocol, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var userMailLoginTextField: KYTextField!
    @IBOutlet weak var passwordLoginTextField: KYTextField!
    
    var userTextField : String = ""
    var passwordTextField : String = ""
    
    @IBOutlet weak var noAccountQuestionButton: KYButton!
    
    var userApiManager: UserManager?
    
    var prompt = KYPromptsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = titleNavBar
        
        noAccountQuestionButton.setupSpacialLayer()
        
        self.userApiManager = UserManager()
        self.userApiManager?.delegate = self
        
        userMailLoginTextField.delegate = self
        passwordLoginTextField.delegate = self
        
        if(DEBUG_MOD){
            userMailLoginTextField.text = "andres"
            passwordLoginTextField.text = "123"
        }
        
        KYHUD.sharedHUD.dimsBackground = false
        KYHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.userApiManager = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterButtonPressed(sender: KYButton) {
        userTextField = self.userMailLoginTextField.text!
        passwordTextField = self.passwordLoginTextField.text!
        
        if userTextField != "" && passwordTextField != "" {
            displayLoaderWithMessage(MSG_LOADING_USER)
            self.userApiManager?.loginWithUserPass(userTextField ,pass: passwordTextField)
        }else{
            let errorMsg = NSLocalizedString("You need to enter a valid user/email and password", comment: "Login incorrect")
            createPrompt(errorMsg)
        }
        
    }
    
    @IBAction func testWithOutAccountButtonPressed(sender: KYButton) {
        performSegueWithIdentifier("registerVC", sender: nil)
    }
    
    // MARK: - User api manager delegate
    func UserManagerRespond(user: AnyObject) {
        currentUser = user as! KYUser
        
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
        createPrompt(msgError)
    }
    
    
    // MARK: - Auxiliar variable
    
    var titleNavBar: String  {
        get {
            let resultStr = NSLocalizedString("Login", comment: "Login screen title")
            return resultStr
        }
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registerVC"{
            if let destinationVC = segue.destinationViewController as? RegisterController{
                destinationVC.navigationItem.title = "Register"
            }
        }
        
        
        
    }
    
    // MARK: - Loader
    
    func displayLoaderWithMessage(textMessage: String){
        KYHUD.sharedHUD.contentView = KYHUDSubtitleView(subtitle: textMessage)
        KYHUD.sharedHUD.show()
    }
    
    func hideLoader(delay: NSTimeInterval = 1.0){
        KYHUD.sharedHUD.hide(afterDelay: delay)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
}
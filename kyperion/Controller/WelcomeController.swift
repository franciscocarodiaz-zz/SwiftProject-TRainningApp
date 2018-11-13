//
//  LoginController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import QuartzCore

class WelcomeController: UIViewController, KYPromptsProtocol {
    
    @IBOutlet weak var createAccountButton: KYButton!
    @IBOutlet weak var initSessionButton: KYButton!
    @IBOutlet weak var testWithoutAccountButton: KYButton!
    
    var prompt = KYPromptsView()
    
    var questionText = NSLocalizedString("Are you a coach?", comment: "Question to create new user account");
    var questionOpenWebText = NSLocalizedString("Trainer registration must be made in the web, do you want to open the web app?", comment: "Question to create open the web app");
    
    var secondBotonText = NSLocalizedString("No", comment: "Negative answer to question");
    var mainBotonText = NSLocalizedString("Yes", comment: "Affirmative answer to question");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createAccountButton.alpha = 0;
        initSessionButton.alpha = 0;
        testWithoutAccountButton.setupSpacialLayer()
        
        createAccountButton.fadeIn()
        initSessionButton.fadeIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountButtonPressed(sender: KYButton) {
        prompt = createQuestionPrompt(TYPE_QUESTION.TRAINER, messageText:questionText)
        prompt.delegate = self
        self.view.addSubview(prompt)
        NSNotificationCenter.defaultCenter().addObserver(prompt, selector: "orientationChanged:", name: "orientationWillChange", object: nil)
    }
    
    @IBAction func testWithOutAccountButtonPressed(sender: KYButton) {
        performSegueWithIdentifier("registerVC", sender: nil)
    }
    @IBAction func initSesionButtonPressed(sender: KYButton) {
        performSegueWithIdentifier("loginVC", sender: nil)
    }
    
    // MARK: - Delegate functions for the prompt
    
    func createQuestionPrompt(typeQuestion: TYPE_QUESTION, messageText: String) -> KYPromptsView{
        let newPrompt = KYPromptsView.createQuestionPrompt(typeQuestion, questionText: messageText, bounds: self.view.bounds)
        return newPrompt
    }
    
    func clickedOnTheMainButton() {
        prompt.dismissPrompt()
        switch prompt.typeQuestion {
        case TYPE_QUESTION.TRAINER:
            let newPrompt = createQuestionPrompt(TYPE_QUESTION.GOTOWEB, messageText: questionOpenWebText)
            prompt = newPrompt
            prompt.delegate = self
            self.view.addSubview(prompt)
            
        case TYPE_QUESTION.GOTOWEB:
            print("GoWeb")
            performSegueWithIdentifier("webVC", sender: nil)
        }
    }
    
    func clickedOnTheSecondButton() {
        print("Clicked on the second button", appendNewline: false)
        prompt.dismissPrompt()
        
        switch prompt.typeQuestion {
        case TYPE_QUESTION.TRAINER:
            performSegueWithIdentifier("registerVC", sender: nil)
        case TYPE_QUESTION.GOTOWEB:
            print("NoGoWeb")
        }
        
    }
    
    func promptWasDismissed() {
        print("Dismissed the prompt", appendNewline: false)
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
        }else if segue.identifier == "loginVC"{
            if let destinationVC = segue.destinationViewController as? LoginController{
                destinationVC.navigationItem.title = "Login"
            }
        }else if segue.identifier == "webVC"{
            let url = NSURL(string: KYPERION_WEB_TRN_LOGIN)!
            if let destinationVC = segue.destinationViewController as? WebViewController{
                destinationVC.urlRequest = NSURLRequest(URL: url)
            }
        }
        
        
        
    }
    
}


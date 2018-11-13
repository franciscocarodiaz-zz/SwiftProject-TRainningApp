//
//  MessageDetailViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 13/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    
    @IBOutlet weak var emailFromLabel: UILabel!
    @IBOutlet weak var emailToLabel: UILabel!
    @IBOutlet weak var emailSubjectLabel: UILabel!
    @IBOutlet weak var emailBodyLabel: UITextView!
    
    override func viewWillDisappear(animated: Bool) {
        currentEmail = KYMessage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setEmailLabels()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureScreenLabels()
        
        if contains(currentUser.listMessageTrash, currentEmail) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            print("Back")
        })
    }

    @IBAction func sendMessageButtonPressed(sender: UIBarButtonItem) {
        print("Send Message")
    }
    // MARK: - Configure screen
    
    func configureScreenLabels(){
        fromLabel.text = LocalizedString_From
        toLabel.text = LocalizedString_To
        subjectLabel.text = LocalizedString_Subject
    }
    
    func setEmailLabels(){
        emailFromLabel.text = currentEmail.sender.fullName
        emailToLabel.text = currentEmail.recipient.fullName
        emailSubjectLabel.text = currentEmail.subject
        emailBodyLabel.text = currentEmail.body
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

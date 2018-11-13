//
//  MainTestViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Alamofire

class MainTestViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            self.request?.responseSwiftyJSON ({
                (request, response, data, error) -> Void in
                
                var user = KYUser()
                if(error == nil){
                    user = KYUser(data)
                }
                
                if user.isValid && user.userType == UserType.USR {
                    user.login = KYLogin(username: user.username, password: "", token:tokenUser)
                    currentUser = user
                    self.updateScreen()
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    private func updateScreen() {
        testLabel.fadeOut()
        testLabel.text = "Welcome \(currentUser.username)"
        testLabel.fadeIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

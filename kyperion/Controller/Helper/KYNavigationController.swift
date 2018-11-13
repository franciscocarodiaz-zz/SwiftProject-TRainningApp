//
//  DLHamburguerNavigationController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Alamofire

class KYNavigationController: UINavigationController {

    var viewOfGesture : UIView = UIView()
    
    var requestTrainingPlan: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            self.requestCalendarDay?.responseJSON {
                (request, response, data, error) -> Void in
                
                if(error == nil){
                    NSNotificationCenter.defaultCenter().postNotificationName(updateTrainingPlanNotificationKey, object: data)
                }
            }
        }
    }
    
    var requestCalendarDay: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            self.requestCalendarDay?.responseJSON {
                    (request, response, data, error) -> Void in
                    
                    if(error == nil){
                        
                        if let info = data!["detail"] as? String {
                            /*
                            let urlString = API(caseAPI:CONST_API_AUTH_USER).url
                            let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
                            let keyStr = "Token \(tokenUser)"
                            mutableURLRequest.setValue(keyStr, forHTTPHeaderField: "authorization")
                            self.request = Alamofire.request(mutableURLRequest)
                            */
                        }else{
                            NSNotificationCenter.defaultCenter().postNotificationName(updateCalendarDayNotificationKey, object: data)
                        }
                        
                        
                    }
            }
        }
    }
    
    var requestCalendarWeek: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            self.requestCalendarWeek?.responseJSON {
                (request, response, data, error) -> Void in
                
                if(error == nil){
                    NSNotificationCenter.defaultCenter().postNotificationName(updateCalendarWeekNotificationKey, object: data)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOfGesture = UIView(frame: rectView3())
        //viewOfGesture.backgroundColor = UIColor.mainAppColor()
        let uiPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGestureRecognized:")
        self.viewOfGesture.addGestureRecognizer(uiPanGestureRecognizer)
        self.view.addSubview(viewOfGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panGestureRecognized(sender: UIPanGestureRecognizer!) {
        
        // dismiss keyboard
        self.view.endEditing(true)
        self.findkyViewController()?.view.endEditing(true)
        
        // pass gesture to hamburguer view controller.
        self.findkyViewController()?.panGestureRecognized(sender)
    }
    
    func rectView3() -> CGRect {
        let init_X_3 : CGFloat = 0
        let init_Y_3 : CGFloat = self.navigationBar.frame.height + 20
        let init_width_3 : CGFloat = self.view.frame.width/10
        let init_height_3 : CGFloat = self.view.frame.height
        return CGRect(x: init_X_3, y: init_Y_3, width: init_width_3, height: init_height_3)
    }
    
}

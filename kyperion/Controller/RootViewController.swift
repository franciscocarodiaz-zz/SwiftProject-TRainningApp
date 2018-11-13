//
//  RootViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

class RootViewController: KYViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func awakeFromNib() {
        // Instanciate the content and menu view controller.
        self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("kyNavigationViewController") as! UIViewController
        self.menuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("kyMenuViewController") as! UIViewController
        
        //self.contentViewController = self.storyboard.instantiateViewControllerWithIdentifier("kyNavigationViewController")
        //self.menuViewController = self.storyboard.instantiateViewControllerWithIdentifier("kyMenuViewController")
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

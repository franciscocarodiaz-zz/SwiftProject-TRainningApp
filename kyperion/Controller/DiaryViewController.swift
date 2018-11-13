//
//  DiaryViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 01/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class DiaryViewController: UIViewController {

    @IBOutlet weak var messageInScreen: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = LocalizedString_ProfileManager_DiaryVC
        
        messageInScreen.text = LocalizedString_ProfileManager_DiaryVC_Msg
        messageInScreen.textAlignment = NSTextAlignment.Center;
        messageInScreen.textColor = UIColor.grayColor()
        messageInScreen .sizeToFit()
        messageInScreen.font.bold()
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

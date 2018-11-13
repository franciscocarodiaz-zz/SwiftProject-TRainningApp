//
//  ProfileInformationManagerViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class ProfileInformationManagerViewController: UIViewController {

    
    @IBOutlet weak var profileInformationManager: SwiftPages!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Sample customization
        profileInformationManager.setOriginY(0.0)
        profileInformationManager.setOriginY(0.0)
        profileInformationManager.setTopBarHeight(30)
        profileInformationManager.enableAeroEffectInTopBar(false)
        profileInformationManager.setButtonsTextColor(UIColor.mainAppColor())
        profileInformationManager.setAnimatedBarColor(UIColor.mainAppColor())
        
        // Init
        let VCIDs : [String] = ["ProfileAccessoryViewController", "ProfileInformationViewController"]
        let buttonTitles : [String] = ["Accessory", "Information"]
        profileInformationManager.section = profileInformationManager.VC_PROFILE_INFO
        profileInformationManager.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
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

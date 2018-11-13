//
//  GraphActivityManagerViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class GraphActivityManagerViewController: UIViewController {

    @IBOutlet weak var graphicPages: SwiftPages!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        graphicPages.setOriginY(0.0)
        //graphicPages.setOriginY(0.0)
        graphicPages.setTopBarHeight(30)
        graphicPages.enableAeroEffectInTopBar(false)
        graphicPages.setButtonsTextColor(UIColor.mainAppColor())
        graphicPages.setAnimatedBarColor(UIColor.mainAppColor())
        
        // Init
        let VCIDs : [String] = ["GraphicVelocityViewController", "GraphicBeatViewController"]
        let buttonTitles : [String] = ["Velocity", "Beats"]
        graphicPages.section = graphicPages.VC_ACTIVITY_GRAPHIC
        graphicPages.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
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

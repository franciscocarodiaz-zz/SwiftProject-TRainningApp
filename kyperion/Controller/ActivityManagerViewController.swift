//
//  ActivityManagerViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 10/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class ActivityManagerViewController: UIViewController {

    @IBOutlet weak var activityPages: SwiftPages!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizedString_ProfileManager_ListActivityVC
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var buttonImages : [UIImage] = [AssetsManager.resumeImage,AssetsManager.lapsImage,
            AssetsManager.graphicImage,
            AssetsManager.tpImage]
        
        // Init
        let VCIDs : [String] = ["ResumeViewController", "MapActivityViewController", "GraphActivityManagerViewController", "TrainingPlanActivityViewController"]
        let buttonTitles : [String] = [LocalizedString_ActManager_ResumeVC, LocalizedString_ActManager_MapVC, LocalizedString_ActManager_GraphicVC, LocalizedString_ActManager_TPActVC]
        
        activityPages.setOriginY(0)
        activityPages.setMarginTop(false)
        activityPages.enableAeroEffectInTopBar(false)
        activityPages.setButtonsTextColor(UIColor.mainAppColor())
        activityPages.setAnimatedBarColor(UIColor.mainAppColor())
        activityPages.section = activityPages.VC_ACTIVITY
        activityPages.initializeWithVCIDsArrayAndButtonImagesArrayWithTitle(VCIDs, buttonImagesArray: buttonImages, buttonTitlesArray: buttonTitles)
        
        addObservers()
    }
    
    func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateListActivityTableViewNotification:", name: updateListActivityNotificationKey, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProfileViewNotification:", name: updateProfileDataNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Notification Center
    
    func updateListActivityTableViewNotification(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(updateListActivityTableViewNotificationKey, object: nil)
    }
    
    func updateProfileViewNotification(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(updateProfileViewNotificationKey, object: nil)
    }

    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            print("dismissViewControllerAnimated")
        })
    }
}

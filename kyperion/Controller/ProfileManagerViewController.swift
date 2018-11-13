//
//  ProfileManagerViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class ProfileManagerViewController: UIViewController {

    @IBOutlet weak var profilePages: SwiftPages!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizedString_ProfileManager_ProfileVC
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        var buttonImages : [UIImage] = [AssetsManager.listadoImage,
            AssetsManager.profileImage,
            AssetsManager.diaryImage]
        
        // Init
        let VCIDs : [String] = ["ListActivityTableViewController", "ProfileInformationManagerViewController", "DiaryViewController"]
        let buttonTitles : [String] = [LocalizedString_ProfileManager_ListActivityVC, LocalizedString_ProfileManager_ProfileVC, LocalizedString_ProfileManager_DiaryVC]
        profilePages.section = profilePages.VC_PROFILE
        profilePages.setOriginY(0)
        profilePages.enableAeroEffectInTopBar(false)
        profilePages.setButtonsTextColor(UIColor.mainAppColor())
        profilePages.setAnimatedBarColor(UIColor.mainAppColor())
        profilePages.initializeWithVCIDsArrayAndButtonImagesArrayWithTitle(VCIDs, buttonImagesArray: buttonImages, buttonTitlesArray: buttonTitles)
        
        profilePages.enableAeroEffectInTopBar(false)
        profilePages.setButtonsTextColor(UIColor.mainAppColor())
        profilePages.setAnimatedBarColor(UIColor.mainAppColor())
        
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

}

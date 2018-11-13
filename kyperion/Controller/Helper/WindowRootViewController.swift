//
//  PKHUD.WindowRootViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

import UIKit

/// Serves as a configuration relay controller, tapping into the main window's rootViewController settings.
internal class WindowRootViewController: UIViewController {
    
    internal override func supportedInterfaceOrientations() -> Int {
        if let rootViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController {
            return rootViewController.supportedInterfaceOrientations()
        } else {
            return 0
        }
    }
    
    internal override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let rootViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController {
            return rootViewController.preferredStatusBarStyle()
        } else {
            return .Default
        }
    }
    
    internal override func prefersStatusBarHidden() -> Bool {
        if let rootViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController {
            return rootViewController.prefersStatusBarHidden()
        } else {
            return false
        }
    }
    
    internal override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        if let rootViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController {
            return rootViewController.preferredStatusBarUpdateAnimation()
        } else {
            return .None
        }
    }
    
    internal override func shouldAutorotate() -> Bool {
        if let rootViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController {
            return rootViewController.shouldAutorotate()
        } else {
            return false
        }
    }
}

//
//  AssetsManager.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

@objc public class AssetsManager {
    
    public class var listadoImage: UIImage { return bundledImage(named: "listado") }
    public class var diaryImage: UIImage { return bundledImage(named: "diary") }
    public class var profileImage: UIImage { return bundledImage(named: "profile") }
    
    public class var resumeImage: UIImage { return bundledImage(named: "resume") }
    public class var lapsImage: UIImage { return bundledImage(named: "laps") }
    public class var graphicImage: UIImage { return bundledImage(named: "graphic") }
    public class var tpImage: UIImage { return bundledImage(named: "tp") }
    
    
    
    // MARK: Lateral Menu assets
    public class var homeImage: UIImage { return bundledImage(named: "home") }
    public class var appImage: UIImage { return bundledImage(named: "lateralMenu_icon") }
    public class var lapImage: UIImage { return bundledImage(named: "tapLap") }
    
    // MARK: Sport assets
    public class var cyclingImage: UIImage { return bundledImage(named: "kyperion.SportType.CYCLING") }
    public class var runningImage: UIImage { return bundledImage(named: "kyperion.SportType.RUNNING") }
    public class var swimmingImage: UIImage { return bundledImage(named: "kyperion.SportType.SWIMMING") }
    public class var gymImage: UIImage { return bundledImage(named: "kyperion.SportType.GYM") }
    
    public class var cyclingTPImage: UIImage { return bundledImage(named: "kyperion.EventType.TRAININGPLAN.kyperion.SportType.CYCLING") }
    public class var runningTPImage: UIImage { return bundledImage(named: "kyperion.EventType.TRAININGPLAN.kyperion.SportType.RUNNING") }
    public class var swimmingTPImage: UIImage { return bundledImage(named: "kyperion.EventType.TRAININGPLAN.kyperion.SportType.SWIMMING") }
    
    public class var cyclingImageVw: UIImageView { return UIImageView(image: cyclingImage) }
    public class var runningImageVw: UIImageView { return UIImageView(image: runningImage) }
    public class var swimmingImageVw: UIImageView { return UIImageView(image: swimmingImage) }
    public class var gymImageVw: UIImageView { return UIImageView(image: gymImage) }
    
    // MARK: Loader images
    public class var progressImage: UIImage { return bundledImage(named: "progress") }
    public class var malePlaceholderImage: UIImage { return bundledImage(named: "malePlaceholder") }
    public class var femalePlaceholderImage: UIImage { return bundledImage(named: "femalePlaceholder") }
    
    public class var checkmarkImage: UIImage { return bundledImage(named: "checkmark") }
    public class var crossImage: UIImage { return bundledImage(named: "cross") }
    
    internal class func bundledImage(named name: String) -> UIImage {
        let bundle = NSBundle(forClass: self)
        return UIImage(named: name, inBundle:bundle, compatibleWithTraitCollection:nil)!
    }
}
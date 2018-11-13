//
//  UIViewExtentsions.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

extension UIView {
    /*
    func centerHorizontally(parentWidth: CGFloat) {
        let centerX = CGFloat(floor(Double(CGFloat(parentWidth - frame.size.width) / CGFloat(2.0))))
        self.frame = CGRect(x:centerX, y:frame.origin.y, width:frame.size.width, height:frame.size.height)
    }
    */
    
    // Fade In / Out Animations
    func fadeIn(duration: NSTimeInterval = 0.5, delay: NSTimeInterval = 0.3, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 0.2, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
    
    func animate(rect: CGRect = CGRect(), duration: NSTimeInterval = 0.2, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        
        self.fadeOut()
        self.fadeIn()
        
    }
    
    func animate(object: AnyObject, duration: NSTimeInterval = 0.2, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        
        self.fadeOut()
        if self.isKindOfClass(UILabel){
            let lbl = self as! UILabel
            let text = object as! String
            lbl.text = text
        }
        self.fadeIn()
        
    }
    
    func fade(duration: NSTimeInterval = 0.2, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.5
            self.fadeOut()
            self.fadeIn()
            }, completion: completion)
    }
    
    
    func addShadow(){
        var shadowView = UIView(frame: CGRectMake(0, self.frame.size.height-5, self.frame.size.width, 4))
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = shadowView.bounds
        gradient.colors = [UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.28).CGColor, UIColor.clearColor().CGColor]
        shadowView.layer.insertSublayer(gradient, atIndex: 0)
        self.addSubview(shadowView)
    }
    
    
}
//
//  KYHUD.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

/**
  HUDController controls showing and hiding of the HUD, as well as its contents and touch response behavior.
*/
@objc public class KYHUD {
    private struct Constants {
        static let sharedHUD = KYHUD()
    }
    
    private let window = Window()
    
    public class var sharedHUD: KYHUD {
        return Constants.sharedHUD
    }
    
    public init () {
        userInteractionOnUnderlyingViewsEnabled = false
        window.frameView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
    }
    
    public var dimsBackground = true
    public var userInteractionOnUnderlyingViewsEnabled: Bool {
        get {
            return !window.userInteractionEnabled
        }
        set {
            window.userInteractionEnabled = !newValue
        }
    }
    
    public var contentView: UIView {
        get {
            return window.frameView.content
        }
        set {
            window.frameView.content = newValue
        }
    }
    
    public func show() {
        window.showFrameView()
        if dimsBackground {
            window.showBackground(animated: true)
        }
    }
    
    public func hide(animated anim: Bool = true) {
        window.hideFrameView(animated: anim)
        if dimsBackground {
            window.hideBackground(animated: true)
        }
    }
    
    private var hideTimer: NSTimer?
    public func hide(afterDelay delay: NSTimeInterval = 2.0) {
        hideTimer?.invalidate()
        hideTimer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: Selector("hideAnimated"), userInfo: nil, repeats: false)
    }
    
    // MARK: Helper
    
    internal func hideAnimated() -> Void {
        hide(animated: true)
    }
}

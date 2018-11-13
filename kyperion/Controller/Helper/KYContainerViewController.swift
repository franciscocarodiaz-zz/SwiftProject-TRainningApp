//
//  DLHamburguerContainerViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

private let kKYInitialContainerViewWidth: CGFloat = 250

/**
 * This class contains the container view for the hamburguer main elements: the menu and the content.
 */
class KYContainerViewController: UIViewController {
    // structure
    weak var kyViewController: KYViewController!      // root hamburguer view controller
    var containerView: UIView!                                          // view containing the main content
    var containerOrigin = CGPointZero                                   // origin of container view
    var shouldAnimatePresentation = false                               // true if menu presentation should be animated.
    var backgroundFadingView: UIView!                                   // background view that fades content when menu shows up
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare background fading view
        backgroundFadingView = UIView(frame: CGRectNull)
        backgroundFadingView.backgroundColor = UIColor.blackColor()
        backgroundFadingView.alpha = 0.0
        view.addSubview(backgroundFadingView)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureRecognized:")
        backgroundFadingView.addGestureRecognizer(gestureRecognizer)

        // prepare container view
        containerView = UIView(frame: CGRectMake(0, 0, kKYInitialContainerViewWidth, view.frame.size.height))
        containerView.clipsToBounds = true
        self.view.addSubview(containerView)
        
        // We need to set a toolbar so the menu controller's content won't overlap the topbar.
        let toolbar = UIToolbar(frame: self.view.bounds)
        //toolbar.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        toolbar.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        toolbar.barStyle = self.kyViewController.menuBackgroundStyle.toBarStyle()
        self.containerView.addSubview(toolbar)
        
        // add menu view controller
        if self.kyViewController.menuViewController != nil {
            self.addChildViewController(self.kyViewController.menuViewController)
            self.kyViewController.menuViewController.view.frame = self.containerView.bounds
            self.containerView.addSubview(self.kyViewController.menuViewController.view)
            self.kyViewController.menuViewController.didMoveToParentViewController(self)
        }
        self.view.addGestureRecognizer(self.kyViewController.gestureRecognizer!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !kyViewController.menuVisible {
            kyViewController.menuViewController.view.frame = containerView.bounds
            switch (kyViewController.menuDirection) {
            case .Left:
                self.setContainerFrame(CGRectMake(-self.kyViewController.actualMenuViewSize.width, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height))
            case .Right:
                self.setContainerFrame(CGRectMake(self.view.frame.size.width, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height))
            case .Top:
                self.setContainerFrame(CGRectMake(0, -self.kyViewController.actualMenuViewSize.height, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height))
            case .Bottom:
                self.setContainerFrame(CGRectMake(0, self.view.frame.size.height, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height))
            }
        }
        // If we should animate the presentation, show it now.
        if self.shouldAnimatePresentation { self.show() }
    }
    
    
    // MARK: - Frame, appearance and size adjustments
    
    func setContainerFrame(frame: CGRect) {
        var x:CGFloat = 0
        var y:CGFloat = 0
        var w:CGFloat = 0
        var h:CGFloat = 0

        // calculate overlay alpha background view frame
        switch (kyViewController.menuDirection) {
        case .Left:
            x = frame.origin.x + frame.size.width
            y = 0
            w = self.view.frame.width - frame.size.width - frame.origin.x
            h = self.view.frame.size.height
        case .Right:
            x = 0
            y = 0
            w = frame.origin.x
            h = self.view.frame.size.height
        case .Top:
            x = frame.origin.x
            y = frame.origin.y + frame.size.height
            w = frame.size.width
            h = self.view.frame.size.height
        case .Bottom:
            x = frame.origin.x
            y = 0
            w = frame.size.width
            h = frame.origin.y
        }

        // assign overlay and container view
        let shadowFrame = CGRectMake(x, y, w, h)
        self.backgroundFadingView.frame = shadowFrame
        self.containerView.frame = frame
    }
    
    func resizeToSize(size: CGSize) {
        var newFrame = CGRectZero
        // adjust size depending on menu direction.
        switch (self.kyViewController.menuDirection) {
        case .Left:
            newFrame = CGRectMake(0, 0, size.width, size.height)
        case .Right:
            newFrame = CGRectMake(self.view.frame.size.width - size.width, 0, size.width, size.height)
        case .Top:
            newFrame = CGRectMake(0, 0, size.width, size.height)
        case .Bottom:
            newFrame = CGRectMake(0, self.view.frame.size.height - size.height, size.width, size.height)
        }
        
        // animated resizing.
        UIView.animateWithDuration(self.kyViewController.animationDuration, animations: { () -> Void in
            self.setContainerFrame(newFrame)
            self.backgroundFadingView.alpha = self.kyViewController.overlayAlpha
        })
    }
    
    // MARK: - Show and Hide the menu.

    /** Shows the menu. */
    func show() {
        // calculate the final frame for the menu
        var finalFrame = CGRectZero
        switch (self.kyViewController.menuDirection) {
        case .Left:
            finalFrame = CGRectMake(0, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Right:
            finalFrame = CGRectMake(self.view.frame.size.width - self.kyViewController.actualMenuViewSize.width, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Top:
            finalFrame = CGRectMake(0, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Bottom:
            finalFrame = CGRectMake(0, self.view.frame.size.height - self.kyViewController.actualMenuViewSize.height, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        }
        
        // set final frame animated
        UIView.animateWithDuration(self.kyViewController.animationDuration, animations: { () -> Void in
            self.setContainerFrame(finalFrame)
            self.backgroundFadingView.alpha = self.kyViewController.overlayAlpha
        }) { (success) -> Void in
            // inform the delegate.
            if self.kyViewController.delegate != nil {
                self.kyViewController.delegate?.kyViewController?(self.kyViewController, didShowMenuViewController: self.kyViewController.menuViewController)
            }
        }
    }
    
    /** Hides the menu. */
    func hide() {
        hideWithCompletion(nil)
    }
    
    /** Hides the menu with a completion closure. */
    func hideWithCompletion(completion: ((Void) -> Void)?) {
        // inform the delegate that the menu will hide
        self.kyViewController.delegate?.kyViewController?(self.kyViewController, willHideMenuViewController: self.kyViewController.menuViewController)
        
        // calculate new frame depending on menu direction
        var newFrame = CGRectZero
        switch (kyViewController.menuDirection) {
        case .Left:
            newFrame = CGRectMake(-self.kyViewController.actualMenuViewSize.width, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Right:
            newFrame = CGRectMake(self.view.frame.size.width, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Top:
            newFrame = CGRectMake(0, -self.kyViewController.actualMenuViewSize.height, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Bottom:
            newFrame = CGRectMake(0, self.view.frame.size.height, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        }
        
        // animate hiding.
        UIView.animateWithDuration(self.kyViewController.animationDuration, animations: { () -> Void in
            self.setContainerFrame(newFrame)
            self.backgroundFadingView.alpha = 0
        }) { (success) -> Void in
            self.kyViewController.menuVisible = false
            self.kyViewController.kyHideController(self)
            self.kyViewController.delegate?.kyViewController?(self.kyViewController, didHideMenuViewController: self.kyViewController.menuViewController)
            completion?()
        }
    }
    
    // MARK: - Gesture recognizer
    // TAP: hide the menu
    func tapGestureRecognized(recognizer: UITapGestureRecognizer) {
        self.hide()
    }
    
    // PAN: animate menu appearance/dissapearace with the menu.
    func panGestureRecognized(recognizer: UIPanGestureRecognizer) {
        // inform the delegate
        self.kyViewController.delegate?.kyViewController?(self.kyViewController, didPerformPanGesture: recognizer)
        // is the gesture recognizer enabled?
        if !self.kyViewController.gestureEnabled { return }
        
        // React to recognizer
        let point = recognizer.translationInView(self.view)
        
        // start: set initial container origin
        if recognizer.state == .Began { self.containerOrigin = self.containerView.frame.origin }
        // changed: adjust frame
        else if recognizer.state == .Changed {
            var frame = self.containerView.frame
            
            switch (kyViewController.menuDirection) {
            case .Left:
                frame.origin.x = self.containerOrigin.x + point.x
                if frame.origin.x > 0 {
                    frame.origin.x = 0
                    if self.kyViewController.desiredMenuViewSize == nil {
                        frame.size.width = self.kyViewController.actualMenuViewSize.width + self.containerOrigin.x + point.x
                        if frame.size.width > self.view.frame.size.width { frame.size.width = self.view.frame.size.width }
                    }
                }
            case .Right:
                frame.origin.x = self.containerOrigin.x + point.x
                if frame.origin.x < self.view.frame.size.width - self.kyViewController.actualMenuViewSize.width {
                    frame.origin.x = self.view.frame.size.width - self.kyViewController.actualMenuViewSize.width
                    if self.kyViewController.desiredMenuViewSize == nil {
                        frame.origin.x = self.containerOrigin.x + point.x
                        if frame.origin.x < 0 { frame.origin.x = 0 }
                        frame.size.width = self.view.frame.size.width - frame.origin.x
                    }
                }
            case .Top:
                frame.origin.y = self.containerOrigin.y + point.y
                if frame.origin.y > 0 {
                    frame.origin.y = 0
                    
                    if self.kyViewController.desiredMenuViewSize == nil {
                        frame.size.height = self.kyViewController.actualMenuViewSize.height + self.containerOrigin.y + point.y
                        if frame.size.height > self.view.frame.size.height { frame.size.height = self.view.frame.size.height }
                    }
                }
            case .Bottom:
                frame.origin.y = self.containerOrigin.y + point.y
                if frame.origin.y < self.view.frame.size.height - self.kyViewController.actualMenuViewSize.height {
                    frame.origin.y = self.view.frame.size.height - self.kyViewController.actualMenuViewSize.height
                    
                    if self.kyViewController.desiredMenuViewSize == nil {
                        frame.origin.y = self.containerOrigin.y + point.y
                        if frame.origin.y < 0 { frame.origin.y = 0 }
                        frame.size.height = self.view.frame.size.height - frame.origin.y
                    }
                }
            }
            self.setContainerFrame(frame)
        }
        
        // end: decide whether to open or close the menu based on the position
        else if recognizer.state == .Ended {
            switch (kyViewController.menuDirection) {
            case .Left:
                if recognizer.velocityInView(self.view).x < 0 { self.hide() }
                else { self.show() }
            case .Right:
                if recognizer.velocityInView(self.view).x < 0 { self.show() }
                else { self.hide() }
            case .Top:
                if recognizer.velocityInView(self.view).y < 0 { self.hide() }
                else { self.show() }
            case .Bottom:
                if recognizer.velocityInView(self.view).y < 0 { self.show() }
                else { self.hide() }
            }
        }
    }
    
    // MARK: - Rotation and transition reacting.
    
    func fixLayoutWithDuration(duration: NSTimeInterval) {
        var newFrame = CGRectZero
        switch (kyViewController.menuDirection) {
        case .Left:
            newFrame = CGRectMake(0, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Right:
            newFrame = CGRectMake(self.view.frame.size.width - self.kyViewController.actualMenuViewSize.width, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Top:
            newFrame = CGRectMake(0, 0, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        case .Bottom:
            newFrame = CGRectMake(0, self.view.frame.size.height - self.kyViewController.actualMenuViewSize.height, self.kyViewController.actualMenuViewSize.width, self.kyViewController.actualMenuViewSize.height)
        }
        self.setContainerFrame(newFrame)
        backgroundFadingView.alpha = kyViewController.overlayAlpha
    }
    
    // iOS7 Rotation legacy support.
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        self.fixLayoutWithDuration(duration)
    }
    
    // iOS 8 Transition.
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.fixLayoutWithDuration(coordinator.transitionDuration())
    }
    
    
}










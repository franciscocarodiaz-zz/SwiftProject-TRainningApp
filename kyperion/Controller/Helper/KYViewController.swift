//
//  KYViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

// Constants
private let kKYMenuSpan: CGFloat = 50.0

/**
 * The KYViewController is the main VC managing the content view controller and the menu view controller.
 * These view controllers will be contained in the main container view controller.
 * The menuViewController will be shown when panning or invoking the showMenuViewController method.
 * The contentViewController will contain the application main content VC, probably a UINavigationController.
 */
class KYViewController: UIViewController {
    // pan gesture recognizer.
    var gestureRecognizer: UIPanGestureRecognizer?
    var gestureEnabled = true
    
    // appearance
    var overlayAlpha: CGFloat = 0.3                                // % of dark fading of the background (0.0 - 1.0)
    var animationDuration: NSTimeInterval = 0.25                    // duration of the menu animation.
    var desiredMenuViewSize: CGSize?                                // if set, menu view size will try to adhere to these limits
    var actualMenuViewSize: CGSize = CGSizeZero                     // Actual size of the menu view
    var menuVisible = false                                         // Is the ky menu currently visible?
    
    // delegate
    var delegate: KYViewControllerDelegate?
    
    // settings
    var menuDirection: KYMenuPlacement = .Left
    var menuBackgroundStyle: KYMenuBackgroundStyle = .Dark
    
    // structure & hierarchy
    var containerViewController: KYContainerViewController!
    private var _contentViewController: UIViewController!
    var contentViewController: UIViewController! {
        get {
            return _contentViewController
        }
        set {
            if _contentViewController == nil {
                _contentViewController = newValue
                return
            }
            // remove old links to previous hierarchy
            _contentViewController.removeFromParentViewController()
            _contentViewController.view.removeFromSuperview()
            
            // update hierarchy
            if newValue != nil {
                self.addChildViewController(newValue)
                newValue.view.frame = self.containerViewController.view.frame
                self.view.insertSubview(newValue.view, atIndex: 0)
                newValue.didMoveToParentViewController(self)
            }
            _contentViewController = newValue
            
            // update status bar appearance
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private var _menuViewController: UIViewController!
    var menuViewController: UIViewController! {
        get {
            return _menuViewController
        }
        set {
            // remove old links to previous hierarchy
            if _menuViewController != nil {
                _menuViewController.view.removeFromSuperview()
                _menuViewController.removeFromParentViewController()
            }
            _menuViewController = newValue
            
            // update hierarchy
            let frame = _menuViewController.view.frame
            _menuViewController.willMoveToParentViewController(nil)
            _menuViewController.removeFromParentViewController()
            _menuViewController.view.removeFromSuperview()
            _menuViewController = newValue
            if _menuViewController == nil { return }
            
            // add menu to container view hierarchy
            self.containerViewController.addChildViewController(newValue)
            newValue.view.frame = frame
            self.containerViewController?.containerView?.addSubview(newValue.view)
            newValue.didMoveToParentViewController(self)
        }
    }
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupKYViewController()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupKYViewController()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupKYViewController()
    }
    
    convenience init(contentViewController: UIViewController, menuViewController: UIViewController) {
        self.init()
        self.contentViewController = contentViewController
        self.menuViewController = menuViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kyDisplayController(contentViewController, inFrame: self.view.bounds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - VC management
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.contentViewController
    }
    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.contentViewController
    }
    
    // MARK: - Setup KYViewController
    
    internal func setupKYViewController() {
        // initialize container view controller
        containerViewController = KYContainerViewController()
        containerViewController.kyViewController = self
        
        // initialize gesture recognizer
        gestureRecognizer = UIPanGestureRecognizer(target: containerViewController!, action: "panGestureRecognized:")
        
    }
    
    // MARK: - Presenting and managing menu.
    /** Main function for presenting the menu */
    func showMenuViewController() { self.showMenuViewControllerAnimated(true, completion: nil) }
    
    /** Detailed function for presenting the menu, with options */
    func showMenuViewControllerAnimated(animated: Bool, completion: ((Void) -> Void)? = nil) {
        // inform that the menu will show
        delegate?.kyViewController?(self, willShowMenuViewController: self.menuViewController)
        
        self.containerViewController.shouldAnimatePresentation = animated
        // calculate menu size
        adjustMenuSize()
        
        // present menu controller
        self.kyDisplayController(self.containerViewController, inFrame: self.contentViewController.view.frame)
        self.menuVisible = true
        
        // call completion handler.
        completion?()
    }
    
    func adjustMenuSize(forRotation: Bool = false) {
        var w: CGFloat = 0.0
        var h: CGFloat = 0.0
        
        if desiredMenuViewSize != nil { // Try to adjust to desired values
            w = desiredMenuViewSize!.width > 0 ? desiredMenuViewSize!.width : contentViewController.view.frame.size.width
            h = desiredMenuViewSize!.height > 0 ? desiredMenuViewSize!.height : contentViewController.view.frame.size.height
        } else { // Calculate menu size based on direction.
            var span: CGFloat = 0.0
            if self.menuDirection == .Left || self.menuDirection == .Right {
                span = kKYMenuSpan
            }
            if forRotation { w = self.contentViewController.view.frame.size.height - span; h = self.contentViewController.view.frame.size.width }
            else { w = self.contentViewController.view.frame.size.width - span; h = self.contentViewController.view.frame.size.height }

        }
        self.actualMenuViewSize = CGSizeMake(w, h)
        
    }

    /** Hides the menu controller */
    func hideMenuViewControllerWithCompletion(completion: ((Void) -> Void)?) {
        if !self.menuVisible { completion?(); return }
        self.containerViewController.hideWithCompletion(completion)
    }

    func resizeMenuViewControllerToSize(size: CGSize) {
        self.containerViewController.resizeToSize(size)
    }
    
    // MARK: - Gesture recognizer
    
    func panGestureRecognized (recognizer: UIPanGestureRecognizer) {
        self.delegate?.kyViewController?(self, didPerformPanGesture: recognizer)
        if self.gestureEnabled {
            if recognizer.state == .Began { self.showMenuViewControllerAnimated(true, completion: nil) }
            self.containerViewController.panGestureRecognized(recognizer)
        }
    }
    
    // MARK: - Rotation legacy support (iOS 7)
    
    override func shouldAutorotate() -> Bool { return self.contentViewController.shouldAutorotate() }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // call super and inform delegate
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        self.delegate?.kyViewController?(self, willAnimateRotationToInterfaceOrientation: toInterfaceOrientation, duration: duration)
        // adjust size of menu if visible only.
        self.containerViewController.setContainerFrame(self.menuViewController.view.frame)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        if !self.menuVisible { self.actualMenuViewSize = CGSizeZero }
        adjustMenuSize(forRotation: true)
    }
    
    // MARK: - Rotation (iOS 8)
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // call super and inform delegate
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        delegate?.kyViewController!(self, willTransitionToSize: size, withTransitionCoordinator: coordinator)
        // adjust menu size if visible
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.containerViewController.setContainerFrame(self.menuViewController.view.frame)
            }, completion: {(finalContext) -> Void in
                if !self.menuVisible { self.actualMenuViewSize = CGSizeZero }
                self.adjustMenuSize(forRotation: true)
        })
    }

}


/** Extension for presenting and hiding view controllers from the KY container. */
extension UIViewController {
    func kyDisplayController(controller: UIViewController, inFrame frame: CGRect) {
        self.addChildViewController(controller)
        controller.view.frame = frame
        self.view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
    }
    
    func kyHideController(controller: UIViewController) {
        controller.willMoveToParentViewController(nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    func findkyViewController() -> KYViewController? {
        var vc = self.parentViewController
        while vc != nil {
            if let dlhvc = vc as? KYViewController { return dlhvc }
            else if vc != nil && vc?.parentViewController != vc { vc = vc!.parentViewController }
            else { vc = nil }
        }
        return nil
    }
}

@objc protocol KYViewControllerDelegate {
    optional func kyViewController(kyViewController: KYViewController, didPerformPanGesture gestureRecognizer: UIPanGestureRecognizer)
    optional func kyViewController(kyViewController: KYViewController, willShowMenuViewController menuViewController: UIViewController)
    optional func kyViewController(kyViewController: KYViewController, didShowMenuViewController menuViewController: UIViewController)
    optional func kyViewController(kyViewController: KYViewController, willHideMenuViewController menuViewController: UIViewController)
    optional func kyViewController(kyViewController: KYViewController, didHideMenuViewController menuViewController: UIViewController)
    optional func kyViewController(kyViewController: KYViewController, willTransitionToSize size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    // Support for legacy iOS 7 rotation.
    optional func kyViewController(kyViewController: KYViewController, willAnimateRotationToInterfaceOrientation toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
}
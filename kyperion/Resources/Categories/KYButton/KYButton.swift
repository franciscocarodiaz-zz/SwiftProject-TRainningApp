//
//  KYButton.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
public class KYButton : UIButton
{
    @IBInspectable public var maskEnabled: Bool = true {
        didSet {
            mkLayer.enableMask(enable: maskEnabled)
        }
    }
    @IBInspectable public var rippleLocation: MKRippleLocation = .TapLocation {
        didSet {
            mkLayer.rippleLocation = rippleLocation
        }
    }
    @IBInspectable public var ripplePercent: Float = 0.9 {
        didSet {
            mkLayer.ripplePercent = ripplePercent
        }
    }
    @IBInspectable public var backgroundLayerCornerRadius: CGFloat = 0.0 {
        didSet {
            mkLayer.setBackgroundLayerCornerRadius(backgroundLayerCornerRadius)
        }
    }
    // animations
    @IBInspectable public var shadowAniEnabled: Bool = true
    @IBInspectable public var backgroundAniEnabled: Bool = true {
        didSet {
            if !backgroundAniEnabled {
                mkLayer.enableOnlyCircleLayer()
            }
        }
    }
    @IBInspectable public var rippleAniDuration: Float = 0.75
    @IBInspectable public var backgroundAniDuration: Float = 1.0
    @IBInspectable public var shadowAniDuration: Float = 0.65
    
    @IBInspectable public var rippleAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable public var backgroundAniTimingFunction: MKTimingFunction = .Linear
    @IBInspectable public var shadowAniTimingFunction: MKTimingFunction = .EaseOut
    
    @IBInspectable public var cornerRadius: CGFloat = 2.5 {
        didSet {
            layer.cornerRadius = cornerRadius
            mkLayer.setMaskLayerCornerRadius(cornerRadius)
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 2.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: CGColor = UIColor.whiteColor().CGColor {
        didSet {
            layer.borderColor = borderColor
        }
    }
    
    @IBInspectable public var bgdColor: CGColor = UIColor.whiteColor().CGColor {
        didSet {
            layer.backgroundColor = bgdColor
        }
    }
    
    // color
    @IBInspectable public var rippleLayerColor: UIColor = UIColor(white: 0.45, alpha: 0.5) {
        didSet {
            mkLayer.setCircleLayerColor(rippleLayerColor)
        }
    }
    @IBInspectable public var backgroundLayerColor: UIColor = UIColor(white: 0.75, alpha: 0.25) {
        didSet {
            mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        }
    }
    override public var bounds: CGRect {
        didSet {
            mkLayer.superLayerDidResize()
        }
    }
    
    private lazy var mkLayer: MKLayer = MKLayer(superLayer: self.layer)
    
    // MARK - initilization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    // MARK - setup methods
    private func setupLayer() {
        adjustsImageWhenHighlighted = false
        cornerRadius = 2.5
        bgdColor = UIColor.mainAppColor(0.5).CGColor
        mkLayer.setBackgroundLayerColor(backgroundLayerColor)
        mkLayer.setCircleLayerColor(rippleLayerColor)
        borderWidth = 3.0
        borderColor = UIColor.buttonBorderButtonColor().CGColor
        
        layer.shadowOpacity = 0.55
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        //self.titleLabel!.font = UIFont(name: FONT_NAV_BAR, size: 16)
    }
    
    public func setupSpacialLayer() {
        backgroundColor = nil
        borderColor = UIColor.clearColor().CGColor
    }
    
    
    // MARK - location tracking methods
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if rippleLocation == .TapLocation {
            mkLayer.didChangeTapLocation(touch.locationInView(self))
        }
        
        // rippleLayer animation
        mkLayer.animateScaleForCircleLayer(0.45, toScale: 1.0, timingFunction: rippleAniTimingFunction, duration: CFTimeInterval(self.rippleAniDuration))
        
        // backgroundLayer animation
        if backgroundAniEnabled {
            mkLayer.animateAlphaForBackgroundLayer(backgroundAniTimingFunction, duration: CFTimeInterval(self.backgroundAniDuration))
        }
        
        // shadow animation for self
        if shadowAniEnabled {
            let shadowRadius = layer.shadowRadius
            let shadowOpacity = layer.shadowOpacity
            let duration = CFTimeInterval(shadowAniDuration)
            mkLayer.animateSuperLayerShadow(10, toRadius: shadowRadius, fromOpacity: 0, toOpacity: shadowOpacity, timingFunction: shadowAniTimingFunction, duration: duration)
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event!)
    }
}

let ANIMATION_DURATION = 0.2


var zShadow:Bool?
var zZoom:Bool?
var zKeepHighlighted:Bool?

public extension UIButton  {
    
    
    // MARK : Helpers
    
    func centerLabelVerticallyWithPadding(spacing:CGFloat) {
        // update positioning of image and title
        let imageSize = self.imageView!.frame.size
        self.titleEdgeInsets = UIEdgeInsets(top:0,
            left:-imageSize.width,
            bottom:-(imageSize.height + spacing),
            right:0)
        let titleSize = self.titleLabel!.frame.size
        self.imageEdgeInsets = UIEdgeInsets(top:-(titleSize.height + spacing),
            left:0,
            bottom: 0,
            right:-titleSize.width)
        
        // reset contentInset, so intrinsicContentSize() is still accurate
        let trueContentSize = CGRectUnion(self.titleLabel!.frame, self.imageView!.frame).size
        let oldContentSize = self.intrinsicContentSize()
        let heightDelta = trueContentSize.height - oldContentSize.height
        let widthDelta = trueContentSize.width - oldContentSize.width
        self.contentEdgeInsets = UIEdgeInsets(top:heightDelta/2.0,
            left:widthDelta/2.0,
            bottom:heightDelta/2.0,
            right:widthDelta/2.0)
    }
    
    func configureButtonWithHightlightedShadowAndZoom(zShadowAndZoom:Bool){
        zShadow = zShadowAndZoom
        zZoom = zShadowAndZoom
        configureToSelected(false)
    }
    
    // MARK : Button states
    
    override var highlighted: Bool {
        didSet {
            
            configureToSelected(highlighted)
            
        }
    }
    
    func configureToSelected( selected: Bool){
        
        if(zKeepHighlighted == true || selected == true) {
            alpha = 1.0
            if(zShadow == true){
                UIView.animateWithDuration(ANIMATION_DURATION, animations: { () -> Void in
                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    if(zShadow == true){
                        self.layer.shadowOpacity = 1
                    }
                })
            }
            
            if(zShadow == true){
                //layer.shadowColor = UIColor.blackColor()
                layer.shadowOffset = CGSizeMake(1.0, 1.0)
                layer.shadowOpacity = 1
                layer.shadowRadius = 3
            }
        } else {
            if(zZoom == true){
                UIView.animateWithDuration(ANIMATION_DURATION, animations: { () -> Void in
                    self.transform=CGAffineTransformMakeScale(0.85 , 0.85)
                })
            }
            if(zShadow == true){
                layer.shadowOpacity = 0
            }
        }
        
    }
}
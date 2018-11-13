//
//  TextFieldEffects.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import UIKit

protocol TextFieldsEffectsProtocol {
    func drawViewsForRect(rect: CGRect)
    func updateViewsForBoundsChange(bounds: CGRect)
    func animateViewsForTextEntry()
    func animateViewsForTextDisplay()
}

public class TextFieldEffects : UITextField, TextFieldsEffectsProtocol {
    
    let placeholderLabel = UILabel()
    
    func animateViewsForTextEntry() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    func animateViewsForTextDisplay() {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    func drawViewsForRect(rect: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    func updateViewsForBoundsChange(bounds: CGRect) {
        fatalError("\(__FUNCTION__) must be overridden")
    }
    
    override public func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    // MARK: - Overrides
    
    override public func drawRect(rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override public func drawPlaceholderInRect(rect: CGRect) {
        // Don't draw any placeholders
    }
    
    // MARK: - UITextField Observing
    
    override public func willMoveToSuperview(newSuperview: UIView!) {
        if newSuperview != nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidEndEditing", name:UITextFieldTextDidEndEditingNotification, object: self)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidBeginEditing", name:UITextFieldTextDidBeginEditingNotification, object: self)
        } else {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    public func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    public func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
}
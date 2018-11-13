//
//  UILabelMethods.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(frame: CGRect, textLabel: String, textColor: UIColor, textSize: CGFloat, textBackgroundColor: UIColor) {
        self.init()
        self.frame = frame
        self.text = textLabel
        self.textColor = textColor
        self.font = UIFont.boldSystemFontOfSize(textSize)
        self.textAlignment = NSTextAlignment.Center
        self.backgroundColor = textBackgroundColor
    }
    
    convenience init(frame: CGRect, textLabel: String, textColor: UIColor, textSize: CGFloat, textBackgroundColor: UIColor, textAlignment: NSTextAlignment) {
        self.init()
        self.frame = frame
        self.text = textLabel
        self.textColor = textColor
        self.font = UIFont.boldSystemFontOfSize(textSize)
        self.textAlignment = textAlignment
        self.backgroundColor = textBackgroundColor
    }
    
    convenience init(frame: CGRect, textLabel: String, textColor: UIColor, textSize: CGFloat, textBackgroundColor: UIColor, textAlignment: NSTextAlignment, bold: Bool) {
        self.init()
        self.frame = frame
        self.text = textLabel
        self.textColor = textColor
        self.font = UIFont.systemFontOfSize(textSize)
        if bold {
            self.font = UIFont.boldSystemFontOfSize(textSize)
        }
        self.textAlignment = textAlignment
        self.backgroundColor = textBackgroundColor
    }
    
    func addUnderLine(underLine: Bool){
        let underlineAttriString = NSAttributedString(string:self.text!, attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
        
        let notUnderlineAttriString = NSAttributedString(string:self.text!, attributes:
            [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue])
        
        if underLine {
            self.attributedText = underlineAttriString
        }else{
            self.attributedText = notUnderlineAttriString
        }
        
    }
    
    
    
}

extension UIFont {
    func bold() -> UIFont {
        let descriptor = self.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
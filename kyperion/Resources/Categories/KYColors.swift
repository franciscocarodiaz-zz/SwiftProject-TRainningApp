//
//  appuicolors.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorWithHex(hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let r = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00ff00) >>  8) / 255.0
        let b = CGFloat((hex & 0x0000ff) >>  0) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience public init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    public struct KYColor {
        public static let KYOrange = UIColor.colorWithHex(0xE07F29)
        public static let Red = UIColor(hex: 0xF44336)
        public static let Pink = UIColor(hex: 0xE91E63)
        public static let Purple = UIColor(hex: 0x9C27B0)
        public static let DeepPurple = UIColor(hex: 0x67AB7)
        public static let Indigo = UIColor(hex: 0x3F51B5)
        public static let Blue = UIColor(hex: 0x2196F3)
        public static let LightBlue = UIColor(hex: 0x03A9F4)
        public static let Cyan = UIColor(hex: 0x00BCD4)
        public static let Teal = UIColor(hex: 0x009688)
        public static let Green = UIColor(hex: 0x4CAF50)
        public static let LightGreen = UIColor(hex: 0x8BC34A)
        public static let Lime = UIColor(hex: 0xCDDC39)
        public static let Yellow = UIColor(hex: 0xFFEB3B)
        public static let Amber = UIColor(hex: 0xFFC107)
        public static let Orange = UIColor(hex: 0xFF9800)
        public static let DeepOrange = UIColor(hex: 0xFF5722)
        public static let Brown = UIColor(hex: 0x795548)
        public static let Grey = UIColor(hex: 0x9E9E9E)
        public static let BlueGrey = UIColor(hex: 0x607D8B)
    }
    
    // ky colours
    //class func mainAppColor()    -> UIColor { return UIColor.colorWithHex(0xE07F29) }
    class func mainAppColor()    -> UIColor { return UIColor.colorWithHex(0xFF9900) }
    class func buttonBorderButtonColor()    -> UIColor { return UIColor.colorWithHex(0xE18901) }
    class func textNavigationBar()    -> UIColor { return UIColor.whiteColor() }
    class func mainAppColor(alpha: CGFloat)    -> UIColor { return UIColor.colorWithHex(0xFF9900,alpha: alpha) }
    class func headerCell()    -> UIColor { return UIColor.colorWithHex(0xE9E9E9) }
    class func rowCell()    -> UIColor { return UIColor.colorWithHex(0xF9F9F9) }
    
    
    // VC
    class func bgdTrainingVC()    -> UIColor { return UIColor.colorWithHex(0x595959) }
    
    // Sports
    class func runningColor()    -> UIColor { return UIColor.colorWithHex(0x2c3e50) }
    class func cyclingColor()    -> UIColor { return UIColor.colorWithHex(0x2ecc71) }
    class func swimmingColor()    -> UIColor { return UIColor.colorWithHex(0x3498db) }
    class func gymColor()    -> UIColor { return UIColor.colorWithHex(0x7f8c8d) }
    
    // green sea
    class func turquoiseColor()    -> UIColor { return UIColor.colorWithHex(0x1abc9c) }
    class func greenSeaColor()     -> UIColor { return UIColor.colorWithHex(0x16a085) }
    // green
    class func emeraldColor()      -> UIColor { return UIColor.colorWithHex(0x2ecc71) }
    class func nephritisColor()    -> UIColor { return UIColor.colorWithHex(0x27ae60) }
    // blue
    class func peterRiverColor()   -> UIColor { return UIColor.colorWithHex(0x3498db) }
    class func belizeHoleColor()   -> UIColor { return UIColor.colorWithHex(0x2980b9) }
    // purple
    class func amethystColor()     -> UIColor { return UIColor.colorWithHex(0x9b59b6) }
    class func wisteriaColor()     -> UIColor { return UIColor.colorWithHex(0x8e44ad) }
    // dark blue
    class func wetAsphaltColor()   -> UIColor { return UIColor.colorWithHex(0x34495e) }
    class func midnightBlueColor() -> UIColor { return UIColor.colorWithHex(0x2c3e50) }
    // yellow
    class func sunFlowerColor()    -> UIColor { return UIColor.colorWithHex(0xf1c40f) }
    class func flatOrangeColor()   -> UIColor { return UIColor.colorWithHex(0xf39c12) }
    // orange
    class func carrotColor()       -> UIColor { return UIColor.colorWithHex(0xe67e22) }
    class func pumkinColor()       -> UIColor { return UIColor.colorWithHex(0xd35400) }
    // red
    class func alizarinColor()     -> UIColor { return UIColor.colorWithHex(0xe74c3c) }
    class func pomegranateColor()  -> UIColor { return UIColor.colorWithHex(0xc0392b) }
    // white
    class func cloudsColor()       -> UIColor { return UIColor.colorWithHex(0xecf0f1) }
    class func silverColor()       -> UIColor { return UIColor.colorWithHex(0xbdc3c7) }
    // gray
    class func asbestosColor()     -> UIColor { return UIColor.colorWithHex(0x7f8c8d) }
    class func concerteColor()     -> UIColor { return UIColor.colorWithHex(0x95a5a6) }
    
}
//
//  KYAccessory.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class KYAccessory: NSObject {
    
    var name:String = "";
    var model:String = "";
    var brand:String = "";
    var category:String = "";
    var type: String = "";
    var sport: String = SPORT_TYPE_RUNNING;
    var publicAccessory:Bool = true;
    
    override init(){
        name = "";
        type = "";
        category = "";
        publicAccessory = true
    }
    
    func customDescription() -> String {
        return "\(self.name) : \(self.model) > \(self.brand)"
    }
    
    override var description: String { return customDescription() }
}

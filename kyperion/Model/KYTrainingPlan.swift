//
//  KYTrainingPlan.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import UIKit

class KYTrainingPlan : NSObject {
    
    var id:String
    var name:String
    var descriptionTP:String
    var time:String
    var sportType:SportType
    var date : String
    
    var parts = [String]()
    var warmup = [KYTPItem]()
    var mainpart = [KYTPItem]()
    var warmdown = [KYTPItem]()
    
    override init(){
        self.id = "0"
        self.name = ""
        self.descriptionTP = ""
        self.time = ""
        self.sportType = SportType.ND
        self.date = ""
    }
    
    func toString() -> String {
        return self.id + ", " + self.name + " " + self.descriptionTP + ", " + self.time
    }
    
}
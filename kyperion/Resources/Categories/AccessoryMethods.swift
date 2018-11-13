//
//  AccessoryMethods.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import Foundation
import SwiftyJSON

extension KYAccessory{
    
    convenience init(listAccessoryData: JSON) {
        self.init()
        var errors = [String]()
        var listAccSwim = [KYAccessory]()
        var listAccCyc = [KYAccessory]()
        var listAccRun = [KYAccessory]()
        var listAccGym = [KYAccessory]()
        
        for item in listAccessoryData.arrayValue {
            var newItem = KYAccessory(item)
            
            switch newItem.type {
            case SPORT_TYPE_SWIMMING:
                listAccSwim.append(newItem)
            case SPORT_TYPE_CYCLING:
                listAccCyc.append(newItem)
            case SPORT_TYPE_RUNNING:
                listAccRun.append(newItem)
            case SPORT_TYPE_GYM:
                listAccGym.append(newItem)
            default:
                print("No type.")
            }
        }
        
        if(errors.count>0){
            print("Error creating user from JSON")
            for e in errors {
                print(e)
            }
        }else{
            currentUser.listAccSwim = listAccSwim
            currentUser.listAccCyc = listAccCyc
            currentUser.listAccRun = listAccRun
            currentUser.listAccGym = listAccGym
        }
        
    }
    
    convenience init(_ dictionary: JSON) {
        self.init()
        var errors = [String]()
        
        for (key,value) in dictionary{
            
            switch key {
            case "name":
                self.name = dictionary["name"].string!
            case "model":
                self.model = dictionary["model"].string!
            case "brand":
                self.brand = dictionary["brand"].string!
            case "category":
                self.category = dictionary["category"].string!
            case "type":
                self.type = dictionary["type"].string!
            case "public":
                self.publicAccessory = dictionary["public"].bool!
                
            default:
                print("KYAccessory: No key " + key + " recognized for user object model.")
            }
            
        }
        
    }
    
    var descripRow : String {
    
        var res = ""
        
        if model.isEmpty {
            res = brand
        }else{
            res = model+", "+brand
        }
        
        return res
        
    }
    
}
//
//  TrainingPlanMethods.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import SwiftyJSON

extension KYTrainingPlan{
    
    convenience init(_ dictionary: JSON) {
        self.init()
        
        for (key,value) in dictionary{
                switch key {
                case TRAINING_PLAN_PARAM_ID:
                    self.id = "\(dictionary[TRAINING_PLAN_PARAM_ID])"
                case TRAINING_PLAN_PARAM_NAME:
                    self.name = dictionary[TRAINING_PLAN_PARAM_NAME].string!
                case TRAINING_PLAN_PARAM_DESCRIPTION:
                    if let descriptionTPAux = dictionary[TRAINING_PLAN_PARAM_DESCRIPTION].string {
                        self.descriptionTP = descriptionTPAux
                    }
                case TRAINING_PLAN_PARAM_TIME:
                    if let timeAux = dictionary[TRAINING_PLAN_PARAM_TIME].int {
                        self.time = "\(timeAux)"
                    }
                case TRAINING_PLAN_PARAM_SPORT_TYPE:
                    if value.string == SPORT_TYPE_CYCLING {
                        self.sportType = SportType.CYCLING
                    }else if value.string == SPORT_TYPE_GYM {
                        self.sportType = SportType.GYM
                    }else if value.string == SPORT_TYPE_RUNNING {
                        self.sportType = SportType.RUNNING
                    }else if value.string == SPORT_TYPE_SWIMMING {
                        self.sportType = SportType.SWIMMING
                    }
                case TRAINING_PLAN_PARAM_CHILDREN:
                    if let childrens = value.array {
                        for children in childrens {
                            var namePart = children["name"]
                            if namePart == "calentamiento" {
                                if let childrensWarmUp = children["children"].array {
                                    for childrenItem in childrensWarmUp {
                                        var childrenItemName = childrenItem["name"]
                                        var childrenItemDesc = childrenItem["description"]
                                        var childrenItemTime = childrenItem["time"]
                                        var name = "\(childrenItemName)"
                                        var desc = "\(childrenItemDesc)"
                                        var time = "\(childrenItemTime)"
                                        var item = KYTPItem(name:name, description: desc, time: time)
                                        
                                        var index = warmup.count
                                        warmup.insert(item, atIndex: index)
                                    }
                                }
                            }else if namePart == "parte principal" {
                                if let childrensWarmUp = children["children"].array {
                                    for childrenItem in childrensWarmUp {
                                        var childrenItemName = childrenItem["name"]
                                        var childrenItemDesc = childrenItem["description"]
                                        var childrenItemTime = childrenItem["time"]
                                        var name = "\(childrenItemName)"
                                        var desc = "\(childrenItemDesc)"
                                        var time = "\(childrenItemTime)"
                                        var item = KYTPItem(name:name, description: desc, time: time)
                                        
                                        var index = mainpart.count
                                        mainpart.insert(item, atIndex: index)
                                    }
                                }
                            }else if namePart == "vuelta a la calma" {
                                if let childrensWarmUp = children["children"].array {
                                    for childrenItem in childrensWarmUp {
                                        var childrenItemName = childrenItem["name"]
                                        var childrenItemDesc = childrenItem["description"]
                                        var childrenItemTime = childrenItem["time"]
                                        var name = "\(childrenItemName)"
                                        var desc = "\(childrenItemDesc)"
                                        var time = "\(childrenItemTime)"
                                        var item = KYTPItem(name:name, description: desc, time: time)
                                        
                                        var index = warmdown.count
                                        warmdown.insert(item, atIndex: index)
                                    }
                                }
                            }
                            
                            
                        }
                    }
                default:
                    print("KYTrainingPlan: No key " + key + " recognized for user object model.")
                }
            
        }
        
    }
    
    var isTP : Bool {
        return id != "0"
    }
    
    func getSportImage() -> UIImage {
        switch(sportType){
        case .SWIMMING:
            return AssetsManager.swimmingTPImage
        case .CYCLING:
            return AssetsManager.cyclingTPImage
        case .RUNNING:
            return AssetsManager.runningTPImage
        default:
            return AssetsManager.runningTPImage
        }
    }
    
    var planningTitle : String {
        return name + " " + time + " min."
    }
    
    var numberOfRows : Int {
        return warmup.count + mainpart.count + warmdown.count
    }
    
    var hasWarmUpSection : Bool {
        return warmup.count > 0
    }
    
    var hasMainPartSection : Bool {
        return mainpart.count > 0
    }
    
    var hasWarmDownSection : Bool {
        return warmdown.count > 0
    }
    
    func titleForSection(section: Int) -> String {
        var res = ""
        
        switch section {
        case 0:
            return LocalizedString_Warmup
        case 1:
            return LocalizedString_MainPart
        case 2:
            return LocalizedString_Warmdown
        default:
            return LocalizedString_Warmup
        }
        
        /*
        if section == 1 && hasWarmUpSection {
            res = LocalizedString_Warmup
        }else if section == 1 && !hasWarmUpSection && hasMainPartSection {
            res = LocalizedString_MainPart
        }else if section == 1 && !hasWarmUpSection && !hasMainPartSection && hasWarmDownSection {
            res = LocalizedString_Warmdown
        }
        
        if section == 2 && hasWarmUpSection && hasMainPartSection {
            res = LocalizedString_Warmup
        }else if section == 2 && hasWarmUpSection && !hasMainPartSection && hasWarmDownSection {
            res = LocalizedString_Warmdown
        }
        
        if section == 3 && hasWarmUpSection && hasMainPartSection && hasWarmDownSection {
            res = LocalizedString_Warmdown
        }
        */
        
        return res
    }
    
    func dataForIndexPath(indexPath: NSIndexPath) -> (String, String) {
    
        var res = ""
        
        var row = indexPath.row
        var section = indexPath.section
        
        if section == 0 && hasWarmUpSection {
            var index = 0
            for item in warmup {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
                index++
            }
        }
        
        if section == 1 && hasMainPartSection {
            var index = 0
            for item in mainpart {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
                index++
            }
        }
        
        if section == 2 && hasWarmDownSection {
            var index = 0
            for item in warmdown {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
                index++
            }
        }
        
        /*
        
        // MARK: DATA WARM UP SECTION
        if section == 1 && hasWarmUpSection {
            var index = 0
            for item in warmup {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
            }
        }
        
        if section == 1 && !hasWarmUpSection && hasMainPartSection {
            var index = 0
            for item in mainpart {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
            }
        }
        
        if section == 1 && !hasWarmUpSection && !hasMainPartSection && hasWarmDownSection {
            var index = 0
            for item in warmdown {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
            }
        }
        
        // MARK: DATA MAIN PART SECTION
        if section == 2 && hasMainPartSection {
            var index = 0
            for item in mainpart {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
            }
        }
        
        if section == 2 && !hasMainPartSection && hasWarmDownSection {
            var index = 0
            for item in warmdown {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
            }
        }
        
        // MARK: DATA WARM DOWN SECTION
        if section == 3 && hasWarmDownSection {
            var index = 0
            for item in warmdown {
                if index == row {
                    return (item.tpitemtitle,item.tpitemdescription)
                }
            }
        }
        
        */
        
        return (res,res)
        
    }
    
}
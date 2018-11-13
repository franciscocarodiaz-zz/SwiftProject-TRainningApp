//
//  CoreDataConfiguration.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation

class CoreDataConfiguration {
    
    // MARK: Properties
    //var info = nil;
    
    class var sharedManager: CoreDataConfiguration {
        struct Singleton {
            //static let info = Dic
            static let gInstance = CoreDataConfiguration()
        }
        
        //NSString *theFile = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        //gInstance.info = [NSMutableDictionary dictionaryWithContentsOfFile:theFile];
        
        let thefile = (NSBundle .mainBundle()).pathForResource("CoreDataConfiguration", ofType: "plist")
        //Singleton.gInstance.info = NSMutableDictionary dic
        return Singleton.gInstance
    }
    
    lazy var appDocDirPath: String = {
        return "" as String
        }()
    
    lazy var extensionCoreData: String = {
        return "" as String
        }()
    
    lazy var model: String = {
        return "" as String
        }()
}
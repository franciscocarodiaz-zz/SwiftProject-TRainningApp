//
//  KYKeychain.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Security


/**

A collection of helper functions for saving text and data in the keychain.

*/
public class KYKeychain {
  
  static var lastQueryParameters: [String: NSObject]? // Used by unit tests
  
  /**
  
  Stores the text value in the keychain item under the given key.
  
  - parameter key: Key under which the text value is stored in the keychain.
  - parameter value: Text string to be written to the keychain.
  - parameter withAccess: Value that indicates when your app needs access to the text in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.

  */
  public class func set(value: String, forKey key: String,
    withAccess access: KYKeychainAccessOptions? = nil) -> Bool {
    
    if let value = value.dataUsingEncoding(NSUTF8StringEncoding) {
      return set(value, forKey: key, withAccess: access)
    }
    
    return false
  }

  /**
  
  Stores the data in the keychain item under the given key.
  
  - parameter key: Key under which the data is stored in the keychain.
  - parameter value: Data to be written to the keychain.
  - parameter withAccess: Value that indicates when your app needs access to the text in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
  
  - returns: True if the text was successfully written to the keychain.
  
  */
  public class func set(value: NSData, forKey key: String,
    withAccess access: KYKeychainAccessOptions? = nil) -> Bool {

    let accessible = access?.value ?? KYKeychainAccessOptions.defaultOption.value
      
    let query = [
      KYKeychainConstants.klass       : KYKeychainConstants.classGenericPassword,
      KYKeychainConstants.attrAccount : key,
      KYKeychainConstants.valueData   : value,
      KYKeychainConstants.accessible  : accessible
    ]
      
    lastQueryParameters = query
          
    SecItemDelete(query as CFDictionaryRef)
    
    let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)
    
    return status == noErr
  }

  /**
  
  Retrieves the text value from the keychain that corresponds to the given key.
  
  - parameter key: The key that is used to read the keychain item.
  - returns: The text value from the keychain. Returns nil if unable to read the item.
  
  */
  public class func get(key: String) -> String? {
    if let data = getData(key),
      let currentString = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {

      return currentString
    }

    return nil
  }

  /**
  
  Retrieves the data from the keychain that corresponds to the given key.
  
  - parameter key: The key that is used to read the keychain item.
  - returns: The text value from the keychain. Returns nil if unable to read the item.
  
  */
  public class func getData(key: String) -> NSData? {
    let query = [
      KYKeychainConstants.klass       : kSecClassGenericPassword,
      KYKeychainConstants.attrAccount : key,
      KYKeychainConstants.returnData  : kCFBooleanTrue,
      KYKeychainConstants.matchLimit  : kSecMatchLimitOne ]
    
    var result: AnyObject?
    
    let status = withUnsafeMutablePointer(&result) {
      SecItemCopyMatching(query, UnsafeMutablePointer($0))
    }
    
    if status == noErr { return result as? NSData }
    
    return nil
  }

  /**
  
  Deletes the single keychain item specified by the key.
  
  - parameter key: The key that is used to delete the keychain item.
  - returns: True if the item was successfully deleted.
  
  */
  public class func delete(key: String) -> Bool {
    let query = [
      KYKeychainConstants.klass       : kSecClassGenericPassword,
      KYKeychainConstants.attrAccount : key ]
    
    let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
    
    return status == noErr
  }

  /**
  
  Deletes all keychain items used by the app.
  
  - returns: True if the keychain items were successfully deleted.
  
  */
  public class func clear() -> Bool {
    let query = [ kSecClass as String : kSecClassGenericPassword ]
    
    let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
    
    return status == noErr
  }
}
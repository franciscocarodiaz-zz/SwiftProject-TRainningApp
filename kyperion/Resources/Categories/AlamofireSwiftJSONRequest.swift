//
//  AlamofireSwiftJSONRequest.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// MARK: - Request for Swift JSON

extension Request {
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(completionHandler: (NSURLRequest, NSHTTPURLResponse?, SwiftyJSON.JSON, NSError?) -> Void) -> Self {
        return responseSwiftyJSON(queue:nil, options:NSJSONReadingOptions.AllowFragments, completionHandler:completionHandler)
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: queue The queue on which the completion handler is dispatched.
    :param: options The JSON serialization reading options. `.AllowFragments` by default.
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the SwiftyJSON enum, if one could be created from the URL response and data, and any error produced while creating the SwiftyJSON enum.
    
    :returns: The request.
    */
    public func responseSwiftyJSON(queue: dispatch_queue_t? = nil, options: NSJSONReadingOptions = .AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, JSON, NSError?) -> Void) -> Self {
        
        return response(queue: queue, responseSerializer: Request.JSONResponseSerializer(options: options), completionHandler: { (request, response, object, error) -> Void in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                var responseJSON: JSON
                if error != nil || object == nil{
                    responseJSON = JSON.nullJSON
                } else {
                    responseJSON = SwiftyJSON.JSON(object!)
                }
                
                dispatch_async(queue ?? dispatch_get_main_queue(), {
                    completionHandler(self.request, self.response, responseJSON, error)
                })
            })
        })
    }
    
    class func imageResponseSerializer() -> GenericResponseSerializer<UIImage> {
        return GenericResponseSerializer { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            
            return (image, nil)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the UIImage object, if one could be created from the URL response and data, and any error produced while creating the UIImage object.
    
    :returns: The request.
    */
    public func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
        return response(responseSerializer: Request.imageResponseSerializer(), completionHandler:completionHandler)
    }
}
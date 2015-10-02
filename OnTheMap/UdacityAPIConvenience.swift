//
//  UdacityAPIConvenience.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 01/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation

extension UdacityAPIClient{
    
    func authenticateOnUdacity(email: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let jsonBody =  "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        taskForPOSTMethod(Method.newSession, jsonBody: jsonBody){ JSONResult, error in
            if let error = error {
                completionHandler(success: false, errorString: error)
            } else {
                guard let parsedJSON = JSONResult as? [String: AnyObject] else{
                    completionHandler(success: false, errorString: "Could not parse session method response")
                    return
                }
                
                guard let account = parsedJSON["account"] as? [String : AnyObject] else{
                    completionHandler(success: false, errorString: "Could not parse session method response")
                    return
                }
                
                guard let registered = account["registered"] as? Bool where registered == true else{
                    completionHandler(success: false, errorString: "Could not parse session method response")
                    return
                }
                
                guard let key = (account["key"] as? String) else{
                    completionHandler(success: false, errorString: "Could not parse session method response")
                    return
                }
                
                self.keyFromNewSession = key
                completionHandler(success: true, errorString: nil)
            }
        }
    }
}
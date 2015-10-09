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
        
        taskForPOSTMethod(Method.newSession, jsonBody: jsonBody){ JSONResult, error, statusCode in
            if let error = error {
                if statusCode == 403 {
                    completionHandler(success: false, errorString: ErrorString.wrongCredentials)
                }
                else{
                    completionHandler(success: false, errorString: error)
                }
            } else {
                guard let parsedJSON = JSONResult as? [String: AnyObject] else{
                    completionHandler(success: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let account = parsedJSON["account"] as? [String : AnyObject] else{
                    completionHandler(success: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let registered = account["registered"] as? Bool where registered == true else{
                    completionHandler(success: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let key = (account["key"] as? String) else{
                    completionHandler(success: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                self.keyFromNewSession = key
                completionHandler(success: true, errorString: nil)
            }
        }
    }
    
    func authenticateOnUdacityWithFacebook(accessToken: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let jsonBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}"
        
        taskForPOSTMethod(Method.newSession, jsonBody: jsonBody){ JSONResult, error, statusCode in
            if let error = error {
                completionHandler(success: false, errorString: error)
            } else {
                guard let parsedJSON = JSONResult as? [String: AnyObject] else{
                    completionHandler(success: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let account = parsedJSON["account"] as? [String : AnyObject] else{
                    completionHandler(success: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let registered = account["registered"] as? Bool where registered == true else{
                    completionHandler(success: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let key = (account["key"] as? String) else{
                    completionHandler(success: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                self.keyFromNewSession = key
                completionHandler(success: true, errorString: nil)
            }
            
        }
    }
}
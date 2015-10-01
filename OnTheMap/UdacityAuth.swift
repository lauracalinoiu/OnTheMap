//
//  UdacityAuth.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 30/09/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation

class UdacityAuth{
    
    let BaseUdacitySecureURL = "https://www.udacity.com/api/"
    let newSession = "session"
    let session = NSURLSession.sharedSession()
    
    func makeRequestToUdacity(email: String, password: String){
        
        let stringUrl = BaseUdacitySecureURL+newSession
        let request = NSMutableURLRequest(URL: NSURL(string: stringUrl)!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else{
                return
            }
            
            if let dataUnwrapped = data {
                let newData = dataUnwrapped.subdataWithRange(NSMakeRange(5, dataUnwrapped.length - 5))
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> UdacityAuth {
        
        struct Singleton {
            static var sharedInstance = UdacityAuth()
        }
        
        return Singleton.sharedInstance
    }

}

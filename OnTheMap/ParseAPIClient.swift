//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 09/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation

class ParseAPIClient: NSObject{
    
    var session: NSURLSession
    var keyFromNewSession: String = ""
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGetMethod(completionHandler: (result: AnyObject!, errorString: String?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constant.ParseStudentLocationMethod
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constant.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constant.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, errorString: ErrorString.failedNetworkConnection)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    completionHandler(result: nil, errorString: ErrorString.invalidResponse+"\(response.statusCode)")
                    
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    completionHandler(result: nil, errorString: ErrorString.invalidResponse+" \(response)")
                } else {
                    print("Your request returned an invalid response!")
                    completionHandler(result: nil, errorString: ErrorString.invalidResponse)
                }
                
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, errorString: ErrorString.somethingWentWrong)
                return
            }
            ParseAPIClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        return task
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, errorString: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print(parsedResult)
        } catch {
            completionHandler(result: nil, errorString: "Could not parse the data as JSON: '\(data)'")
        }
        
        completionHandler(result: parsedResult, errorString: nil)
    }
    
    class func sharedInstance() -> ParseAPIClient{
        struct Singleton{
            static let sharedInstance = ParseAPIClient()
        }
        
        return Singleton.sharedInstance
    }
}
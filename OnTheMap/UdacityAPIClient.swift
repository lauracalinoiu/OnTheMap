//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 01/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation

enum Err: ErrorType{
    case Invalid_Request
    case Invalid_Response
}

class UdacityAPIClient: NSObject{
    
    var session: NSURLSession
    var keyFromNewSession: String = ""
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForPOSTMethod(method: String, jsonBody: String, completionHandler: (result: AnyObject!, errorString: String?, statusCode: Int?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constant.BaseUdacitySecureURL + method
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, errorString: ErrorString.failedNetworkConnection, statusCode: nil)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    completionHandler(result: nil, errorString: ErrorString.invalidResponse+"\(response.statusCode)", statusCode: response.statusCode)
                    
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    completionHandler(result: nil, errorString: ErrorString.invalidResponse+" \(response)", statusCode: nil)
                } else {
                    print("Your request returned an invalid response!")
                    completionHandler(result: nil, errorString: ErrorString.invalidResponse, statusCode: nil)
                }
                
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(result: nil, errorString: ErrorString.somethingWentWrong, statusCode: nil)
                return
            }
            UdacityAPIClient.parseJSONWithCompletionHandler(data){ result, error in
                completionHandler(result: result, errorString: error, statusCode: nil)
            }
        }
        task.resume()
        return task
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, errorString: String?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            print(parsedResult)
        } catch {
            completionHandler(result: nil, errorString: "Could not parse the data as JSON: '\(data)'")
        }
        
        completionHandler(result: parsedResult, errorString: nil)
    }
    
    class func getError(domain: String, errDescription: String) -> NSError{
        let userInfo = [NSLocalizedDescriptionKey : errDescription]
        return NSError(domain: domain, code: 1, userInfo: userInfo)
    }
    
    class func sharedInstance() -> UdacityAPIClient{
        struct Singleton{
            static let sharedInstance = UdacityAPIClient()
        }
        
        return Singleton.sharedInstance
    }
}

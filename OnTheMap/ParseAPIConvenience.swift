//
//  ParseAPIConvenience.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 09/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation

extension ParseAPIClient{
    
    func getLast100StudentLocation(completionHandler: (studentLocations: [DBStudentLocation]?, errorString: String?) -> Void){
        taskForGetMethod([ParseAPIClient.Keys.paramLimit: 100]){ JSONResult, error in
            if let error = error {
                completionHandler(studentLocations: nil, errorString: error)
            } else {
                guard let parsedJSON = JSONResult as? [String: AnyObject] else{
                    completionHandler(studentLocations: nil, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let results = parsedJSON["results"] as? [[String : AnyObject]] else{
                    completionHandler(studentLocations: nil, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                let studentLocations = DBStudentLocation.studentLocationsFrom(results)
                completionHandler(studentLocations: studentLocations, errorString: nil)
            }
        }
    }
    
    func studentAlreadyOnTheMap(completionHandler: (userAlreadyOnMap: Bool, errorString: String?) -> Void){
        taskForGetMethod([ParseAPIClient.Keys.paramWhere: "{\"uniqueKey\":\"\(UdacityAPIClient.sharedInstance().keyFromNewSession)\"}"]){ JSONResult, error in
            if let error = error {
                completionHandler(userAlreadyOnMap: false, errorString: error)
            } else {
                guard let parsedJSON = JSONResult as? [String: AnyObject] else{
                    completionHandler(userAlreadyOnMap: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let results = parsedJSON["results"] as? [[String : AnyObject]] else{
                    completionHandler(userAlreadyOnMap: false, errorString: ErrorString.somethingWentWrong)
                    return
                }
                
                let studentLocations = DBStudentLocation.studentLocationsFrom(results)
                
                if studentLocations.count >= 1 {
                    ParseAPIClient.sharedInstance().studentLocation = studentLocations[0]
                    completionHandler(userAlreadyOnMap: true, errorString: nil)
                } else {
                    completionHandler(userAlreadyOnMap: false, errorString: nil)
                }
            }
        }
    }
    
    func updateStudentLocation(studentLocation: DBStudentLocation, completionHandler: (success: Bool, error: String!) -> Void){
        
        taskForPutMethod(studentLocation){ JSONResult, error in
            if error != nil {
                completionHandler(success: false, error: error)
            } else {
                guard let parsedJSON = JSONResult as? [String: AnyObject] else{
                    completionHandler(success: false, error: ErrorString.somethingWentWrong)
                    return
                }
                guard let date = parsedJSON["updatedAt"] as? String else{
                    completionHandler(success: false, error: ErrorString.somethingWentWrong)
                    return
                }
                print(date)
                completionHandler(success: true, error: nil)
            }
        }
    }
    
    func postStudentLocation(studentLocation: DBStudentLocation, completionHandler: (success: Bool, error: String!) -> Void){
        taskForPostMethod(studentLocation.serialize()){ JSONResult, error in
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                guard let parsedJSON = JSONResult as? [String: AnyObject] else{
                    completionHandler(success: false, error: ErrorString.somethingWentWrong)
                    return
                }
                guard let createdAt = parsedJSON["createdAt"] as? String else{
                    completionHandler(success: false, error: ErrorString.somethingWentWrong)
                    return
                }
                
                guard let objectId = parsedJSON["objectId"] as? String else{
                    completionHandler(success: false, error: ErrorString.somethingWentWrong)
                    return
                }
                print(objectId + "  created at    " + createdAt)
                completionHandler(success: true, error: nil)
            }
        }
    }
}
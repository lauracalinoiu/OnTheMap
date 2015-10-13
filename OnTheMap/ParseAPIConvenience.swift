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
        taskForGetMethod(){ JSONResult, error in
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
}
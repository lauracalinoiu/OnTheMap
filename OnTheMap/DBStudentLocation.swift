//
//  DBStudentLocation.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 09/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation
struct DBStudentLocation{
    let latitude: Double
    let longitude: Double
    let firstName: String
    let lastName: String
    let mediaURL: String
    
    init(dictionary: [String: AnyObject]){
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mediaURL = dictionary["mediaURL"] as! String
    }
    
    static func studentLocationsFrom(results: [[String: AnyObject]]) -> [DBStudentLocation]{
        var studentLocation = [DBStudentLocation]()
        for result in results {
            studentLocation.append(DBStudentLocation(dictionary: result))
        }
        return studentLocation
    }
}

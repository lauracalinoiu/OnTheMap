//
//  DBStudentLocation.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 09/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation
class DBStudentLocation: NSObject{
    var latitude: Double
    var longitude: Double
    var firstName: String
    var lastName: String
    var mediaURL: String
    var key: String
    var mapString: String
    var objectId: String

    init(fromParseAPI dictionary: [String: AnyObject]){
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectId = dictionary["objectId"] as! String
        key = ""
        mapString = ""
    }
    
    init(fromUdacityAPI dictionary: [String: AnyObject]){
        lastName = dictionary["last_name"] as! String
        firstName = dictionary["first_name"] as! String
        key = dictionary["key"] as! String
        latitude = 0.0
        longitude = 0.0
        mediaURL = ""
        mapString = ""
        objectId = ""
    }
    
    static func studentLocationsFrom(results: [[String: AnyObject]]) -> [DBStudentLocation]{
        var studentLocation = [DBStudentLocation]()
        for result in results {
            studentLocation.append(DBStudentLocation(fromParseAPI: result))
        }
        return studentLocation
    }
    
    func serialize() -> [String:AnyObject]{
        var studentLocationDict = [String: AnyObject]()
        studentLocationDict["uniqueKey"] = self.key
        studentLocationDict["firstName"] = self.firstName
        studentLocationDict["lastName"] = self.lastName
        studentLocationDict["mapString"] = self.mapString
        studentLocationDict["mediaURL"] = self.mediaURL
        studentLocationDict["latitude"] = self.latitude
        studentLocationDict["longitude"] = self.longitude
        
        return studentLocationDict
    }
}

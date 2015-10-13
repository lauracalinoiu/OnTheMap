//
//  ParseAPIConstants.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 09/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

extension ParseAPIClient{
    
    struct Constant{
        static let ParseStudentLocationMethod = "https://api.parse.com/1/classes/StudentLocation"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    
    struct ErrorString{
        static let failedNetworkConnection = "Failed network connection"
        static let invalidResponseWithStatus = "Invalid Response with status code = "
        static let invalidResponse = "Invalid Response"
        static let somethingWentWrong = "Something went wrong!"
    }
}


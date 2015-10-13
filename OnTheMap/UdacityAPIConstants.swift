//
//  UdacityAPIConstants.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 01/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation

extension UdacityAPIClient{
    
    struct Constant{
        static let BaseUdacitySecureURL = "https://www.udacity.com/api/"
        static let SignInUdacityURL = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&usg=AFQjCNHOjlXo3QS15TqT0Bp_TKoR9Dvypw"
    }
    
    struct Method{
        static let newSession = "session"
    }
    
    struct ErrorString{
        static let failedNetworkConnection = "Failed network connection"
        static let invalidResponseWithStatus = "Invalid Response with status code = "
        static let invalidResponse = "Invalid Response"
        static let wrongCredentials = "Wrong user/password. Try other credentials!"
        static let somethingWentWrong = "Something is wrong with Udacity server"
    }
}

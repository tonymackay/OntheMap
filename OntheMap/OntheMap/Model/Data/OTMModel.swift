//
//  OTMModel.swift
//  OntheMap
//
//  Created by Tony Mackay on 27/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import Foundation

struct Location
{
    let address: String
    let link: String
    let latitude: Double
    let longitude: Double
}

class OTMModel {
    static var studentLocations = [StudentInformation]()
    static var isAuthenticated = false
}

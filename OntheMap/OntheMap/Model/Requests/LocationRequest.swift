//
//  LocationRequest.swift
//  OntheMap
//
//  Created by Tony Mackay on 29/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import Foundation

struct LocationRequest: Codable
{
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

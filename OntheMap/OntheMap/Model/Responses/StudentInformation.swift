//
//  StudentInformation.swift
//  OntheMap
//
//  Created by Tony Mackay on 27/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import Foundation

struct StudentInformation: Codable
{
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: Date
}

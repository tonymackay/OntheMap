//
//  UserDataResponse.swift
//  OntheMap
//
//  Created by Tony Mackay on 29/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import Foundation

struct UserData: Codable
{
    let firstName: String
    let lastName: String
}

struct UserDataResponse: Codable
{
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

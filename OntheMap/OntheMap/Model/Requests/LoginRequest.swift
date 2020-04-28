//
//  LoginRequest.swift
//  OntheMap
//
//  Created by Tony Mackay on 28/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import Foundation

struct Credentials: Codable
{
    let username: String
    let password: String
}

struct LoginRequest: Codable
{
    let udacity: Credentials
    
    init(email: String, password: String) {
        udacity = Credentials(username: email, password: password)
    }
}

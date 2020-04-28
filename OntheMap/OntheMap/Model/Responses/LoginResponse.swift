//
//  LoginResponse.swift
//  OntheMap
//
//  Created by Tony Mackay on 28/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import Foundation

struct Account: Codable
{
    let registered: Bool
    let key: String
}

struct Session: Codable
{
    let id: String
    let expiration: String
}

struct LoginResponse: Codable
{
    let account: Account
    let session: Session
}

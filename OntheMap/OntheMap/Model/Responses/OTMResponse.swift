//
//  Error.swift
//  OntheMap
//
//  Created by Tony Mackay on 27/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import Foundation

struct OTMResponse: Codable
{
    //let status: String
    let error: String
}

extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}

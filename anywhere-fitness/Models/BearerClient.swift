//
//  BearerClient.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/27/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct BearerClient: Codable, Equatable {
    let token: String
    let client: [Detail]
    
    struct Detail: Codable, Equatable {
        let id: Int
    }
}

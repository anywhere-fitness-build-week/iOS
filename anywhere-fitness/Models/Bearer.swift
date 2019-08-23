//
//  Bearer.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/21/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//
import Foundation

struct Bearer: Codable, Equatable {
    let token: String
    let instructor: [Detail]
    
    struct Detail: Codable, Equatable {
        let id: Int
    }
}


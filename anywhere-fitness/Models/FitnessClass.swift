//
//  FitnessClass.swift
//  anywhere-fitness
//
//  Created by Dongwoo Pae on 8/21/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct FitnessClass: Codable, Equatable {
    let id: Int?
    var name: String
    var description: String?
    var time: String?
    let instructorId: Int
    let categoryId: Int
    //make an optional array of let punchPass:Int? and use this after fitnessClass gets fetchedinto the device.
    //since it is an optional, we do not need to have that when fetching the classes
}



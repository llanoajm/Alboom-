//
//  UserData.swift
//  albumapp
//
//  Created by Antonio Llano on 26/11/20.
//

import Foundation
struct UserData: Codable{
    
    let data: Data
}
struct Data: Codable{
    let id : Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}

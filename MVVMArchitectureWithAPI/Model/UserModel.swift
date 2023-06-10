//
//  UserModel.swift
//  MVVMArchitectureWithAPI
//
//  Created by satheesh kumar on 10/06/23.
//

import Foundation

struct UserModel:Codable,Identifiable{
    let id:Int
    let username:String
    let email:String
    let company:Company
}
struct Company:Codable{
    let name:String
    let catchPhrase:String
}

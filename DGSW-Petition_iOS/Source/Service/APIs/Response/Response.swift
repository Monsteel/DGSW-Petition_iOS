//
//  Response.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation

class Response<T: Decodable>: Decodable {
    var status: Int
    var message : String
    var data: T
}

class MessageResponse: Decodable {
    var status: Int
    var message : String
}

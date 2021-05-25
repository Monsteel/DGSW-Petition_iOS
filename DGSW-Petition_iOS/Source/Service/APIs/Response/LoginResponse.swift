//
//  LoginResponse.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation

class LoginResponse: Decodable {
    var accessToken: String?
    var refreshToken: String?
    
    enum Key : String, CodingKey{
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: Key.self)
        
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
    }
}

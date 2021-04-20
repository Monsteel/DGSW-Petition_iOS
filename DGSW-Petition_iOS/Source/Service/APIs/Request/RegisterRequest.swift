//
//  RegisterRequest.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation

class RegisterRequest:Encodable {
    var permissionKey: String
    var userID: String
    var googleToken: String
    
    init(permissionKey: String,
         userID: String,
         googleToken: String) {
        self.permissionKey  = permissionKey
        self.userID = userID
        self.googleToken = googleToken
    }
}

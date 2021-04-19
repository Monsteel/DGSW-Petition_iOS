//
//  LoginRequest.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

class LoginRequest: Encodable {
    var userID: String
    var googleToken: String
    
    init(userID: String,
         googleToken: String){
        self.userID = userID
        self.googleToken = googleToken
    }
}

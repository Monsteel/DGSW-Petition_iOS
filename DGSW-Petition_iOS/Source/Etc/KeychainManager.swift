//
//  KeychainManager.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import Foundation
import Security
import KeychainAccess

/**
 민감한 정보를 저장하기 위해서 사용합니다
 */
public class KeychainManager: NSObject {
    
    static let shared = KeychainManager()
    
    private let accessTokenKey = "accessTokenKey"
    private let refreshTokenKey = "refreshTokenKey"
    private let keychain = Keychain(service: "io.github.monsteel.petition.DGSW-Petition-iOS")
    
    var isLoged: Bool {
        get {
            return accessToken?.isNotEmpty ?? false
        }
    }
    
    var accessToken: String? {
        get {
            return keychain[accessTokenKey]
        }
        set {
            keychain[accessTokenKey] = newValue
        }
    }
    
    var refreshToken: String? {
        get {
            return keychain[refreshTokenKey]
        }
        set {
            keychain[refreshTokenKey] = newValue
        }
    }
    
    func login(_ accessToken: String?, _ refreshToken: String?){
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func logout(){
        self.accessToken = nil
        self.refreshToken = nil
    }
    
    func refreshAccessToken(_ accessToken: String?){
        self.accessToken = accessToken
    }
}

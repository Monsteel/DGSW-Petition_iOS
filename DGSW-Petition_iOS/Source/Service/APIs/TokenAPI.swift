//
//  TokenAPI.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation
import Moya

enum TokenAPI {
    case refreshToken
}

extension TokenAPI: TargetType {

    var baseURL: URL {
        return URL(string: Constants.SERVER_IP+"token")!
    }
    
    var path: String {
        switch self {
            case .refreshToken:
                return "/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .refreshToken:
                return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .refreshToken:
                return .requestPlain
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        var headers = [String:String]()
        headers["Content-Type"] = "application/json"
        headers["refreshToken"] = KeychainManager.shared.refreshToken
        return headers
    }
}

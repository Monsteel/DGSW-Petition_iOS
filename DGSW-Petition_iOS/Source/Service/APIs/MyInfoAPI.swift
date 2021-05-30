//
//  MyInfoAPI.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import Foundation
import Moya

enum MyInfoAPI {
    case getMyInfo
}

extension MyInfoAPI: TargetType {

    var baseURL: URL {
        return URL(string: Constants.SERVER_IP+"myinfo")!
    }
    
    var path: String {
        switch self {
            case .getMyInfo:
                return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getMyInfo:
                return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .getMyInfo:
                return .requestPlain
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        var headers = [String:String]()
        headers["Content-Type"] = "application/json"
        headers["x-access-token"] = KeychainManager.shared.accessToken
        return headers
    }
}

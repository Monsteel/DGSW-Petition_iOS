//
//  CategoryAPI.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/26.
//

import Foundation
import Moya

enum CategoryAPI {
    case getCategories
    case getCategory(_ idx: Int)
}

extension CategoryAPI: TargetType {

    var baseURL: URL {
        return URL(string: Constants.SERVER_IP+"category")!
    }
    
    var path: String {
        switch self {
            case .getCategories:
                return ""
            case .getCategory(let idx):
                return "/\(idx)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getCategories:
                return .get
            case .getCategory:
                return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .getCategories:
                return .requestPlain
            case .getCategory:
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

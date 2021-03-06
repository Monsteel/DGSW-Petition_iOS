//
//  AgreeAPI.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation
import Moya

enum AgreeAPI {
    case getAgree(_ petitionIdx: Int, _ page: Int, _ size: Int)
    case agree(_ request: AgreeRequest)
}

extension AgreeAPI: TargetType {

    var baseURL: URL {
        return URL(string: Constants.SERVER_IP+"agree")!
    }
    
    var path: String {
        switch self {
            case .getAgree(_,_,_):
                return ""
            case .agree(_):
                return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getAgree(_,_,_):
                return .get
            case .agree(_):
                return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case let .getAgree(petitionIdx, page, size):
                return .requestParameters(parameters:["petitionIdx": petitionIdx, "page": page, "size": size], encoding: URLEncoding.queryString)
            case .agree(let request):
                return .requestData(try! JSONEncoder().encode(request))
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

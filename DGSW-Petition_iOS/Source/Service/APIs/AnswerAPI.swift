//
//  AnswerAPI.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/20.
//

import Foundation
import Moya

enum AnswerAPI {
    case getAnswers(_ petitionIdx: Int)
    case addAnswer(_ request: AnswerRequest)
}

extension AnswerAPI: TargetType {

    var baseURL: URL {
        return URL(string: Constants.SERVER_IP+"answer")!
    }
    
    var path: String {
        switch self {
            case .getAnswers(_):
                return ""
            case .addAnswer(_):
                return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getAnswers(_):
                return .get
            case .addAnswer(_):
                return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .getAnswers(let petitionIdx):
                return .requestParameters(parameters:["petitionIdx": petitionIdx], encoding: URLEncoding.queryString)
            case .addAnswer(let request):
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

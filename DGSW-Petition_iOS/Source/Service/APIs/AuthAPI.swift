//
//  AuthAPI.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation
import Moya

enum AuthAPI {
    case checkRegisteredUser(_ userId: String)
    case login(_ request: LoginRequest)
    case register(_ request: RegisterRequest)
}

extension AuthAPI: TargetType {

    var baseURL: URL {
        return URL(string: Constants.SERVER_IP+"auth")!
    }
    
    var path: String {
        switch self {
            case .checkRegisteredUser(_):
                return "/register/check"
            case .login:
                return "/login"
            case .register:
                return "/register"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .checkRegisteredUser:
                return .get
            case .login:
                return .post
            case .register:
                return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            case .checkRegisteredUser(let userId):
                return .requestParameters(parameters:["userId": userId], encoding: URLEncoding.queryString)
            case .login(let request):
                return .requestData(try! JSONEncoder().encode(request))
            case .register(let request):
                return .requestData(try! JSONEncoder().encode(request))
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

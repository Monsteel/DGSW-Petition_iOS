//
//  RegisterError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/30.
//

import Foundation

enum RegisterError: LocalizedError {
    case FailRegister
    case UnAuthorized
    case NetworkError
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .FailRegister:
                return "회원가입 실패"
            case .UnAuthorized:
                return "토큰 만료됨"
            case .NetworkError:
                return "서버에 접속할 수 없음"
            case .InternalServerError:
                return "서버 오류"
            case .UnhandledError(let msg):
                return msg
        }
    }
}

extension Error {
    func toRegisterError(_ defaultError: RegisterError) -> RegisterError? {
        if let self = self as? PTNetworkError {
            switch self.statusCode {
                case 408:
                    return .NetworkError
                case 401:
                    return .UnAuthorized
                case 500:
                    return .InternalServerError
                default:
                    return defaultError
            }
        }
        
        return .UnhandledError(msg: self.localizedDescription)
    }
}

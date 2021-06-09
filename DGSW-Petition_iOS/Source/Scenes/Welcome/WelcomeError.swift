//
//  WelcomeError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/29.
//

import Foundation

enum WelcomeError: LocalizedError {
    case FailCheckRegisteredUser
    case FailLogin
    
    case NetworkError
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .FailCheckRegisteredUser:
                return "가입여부 확인 실패"
            case .FailLogin:
                return "로그인 실패"
            case .InternalServerError:
                return "서버 오류"
            case .NetworkError:
                return "서버에 접속할 수 없음"
            case .UnhandledError(let msg):
                return msg
        }
    }
}

extension Error {
    func toWelcomeError(_ error: WelcomeError? = nil) -> WelcomeError? {
        if let self = self as? PTNetworkError {
            switch self.statusCode! {
                case 408:
                    return .NetworkError
                case 500:
                    return .InternalServerError
                default:
                    return .UnhandledError(msg: self.localizedDescription)
            }
        }
        
        return error
    }
}

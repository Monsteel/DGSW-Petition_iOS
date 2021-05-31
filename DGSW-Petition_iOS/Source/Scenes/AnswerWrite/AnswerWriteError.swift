//
//  AnswerWriteError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import Foundation

enum AnswerWriteError: LocalizedError {
    case NotEnteredContent
    
    case FailWritePetition
    
    case TokenExpiration
    case UnAuthorized
    case NetworkError
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .NotEnteredContent:
                return "카테고리 조회실패"
            
            case .FailWritePetition:
                return "카테고리 조회실패"
                
            case .TokenExpiration:
                return "토큰 만료"
            case .UnAuthorized:
                return "권한 없음"
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
    func toAnswerWriteError(_ defaultError: AnswerWriteError) -> AnswerWriteError? {
        if let self = self as? PTNetworkError {
            switch self.statusCode {
                case 410:
                    return .TokenExpiration
                case 401:
                    return .UnAuthorized
                case 408:
                    return .NetworkError
                case 500:
                    return .InternalServerError
                default:
                    return defaultError
            }
        }
        
        return .UnhandledError(msg: self.localizedDescription)
    }
}

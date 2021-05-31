//
//  AwaitingError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/30.
//

import Foundation

enum AwaitingError: LocalizedError {
    case FailAwaitingPetition
    
    case UnAuthorized
    case NetworkError
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .FailAwaitingPetition:
                return "답변 대기중인 청원 조회 실패"
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
    func toAwaitingError(_ defaultError: AwaitingError) -> AwaitingError? {
        if let self = self as? PTNetworkError {
            switch self.statusCode {
                case 410:
                    return .UnAuthorized
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

//
//  OngoingError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/30.
//

import Foundation

enum OngoingError: Error {
    case FailOngoingPetition
//    case EmptyOngoingPetition
    
    case UnAuthorized
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .FailOngoingPetition:
                return "진행중인 청원 조회 실패"
//            case .EmptyOngoingPetition:
//                return "진행중인 청원이 없습니다."
            case .UnAuthorized:
                return "토큰 만료됨"
            case .InternalServerError:
                return "서버 오류"
            case .UnhandledError(let msg):
                return msg
        }
    }
}

extension Error {
    func toOngoingError(_ defaultError: OngoingError) -> OngoingError? {
        if let self = self as? PTNetworkError {
            switch self.statusCode! {
                case 410:
                    return .UnAuthorized
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

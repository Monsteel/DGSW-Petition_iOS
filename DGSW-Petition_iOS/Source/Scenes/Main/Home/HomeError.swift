//
//  HomeError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/18.
//

import Foundation

enum HomeError: LocalizedError {
    case FailPetitionSituation
    case FailTopTenPetition
    
    case UnAuthorized
    case NetworkError
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .FailPetitionSituation:
                return "청원 현황 조회 실패"
            case .FailTopTenPetition:
                return "추천순 TOP 10 조회 실패"
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
    func toHomeError(_ defaultError: HomeError) -> HomeError? {
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

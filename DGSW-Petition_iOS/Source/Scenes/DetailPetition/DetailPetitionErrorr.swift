//
//  DetailPetitionErrorr.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//


import Foundation

enum DetailPetitionError: LocalizedError {
    case FailFetchPetition
    case InvalidAccessError
    case FailFetchAgree
    case FailWriteAgree
    case FailWriteAnswer
    case FailDeletePetition
    case EmptyAgreement
    
    case TokenExpiration
    case UnAuthorized
    case NetworkError
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .FailFetchPetition:
                return "청원 조회 실패"
            case .InvalidAccessError:
                return "잘못된 접근"
            case .FailWriteAgree:
                return "동의 실패"
            case .FailWriteAnswer:
                return "답변 작성 실패"
            case .FailFetchAgree:
                return "동의 조회 실패"
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
            case .EmptyAgreement:
                return "동의 내용을 입력해 주세요."
            case .FailDeletePetition:
                return "청원 삭제 실패"
        }
    }
}

extension Error {
    func toDetailPetitionError(_ defaultError: DetailPetitionError) -> DetailPetitionError? {
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

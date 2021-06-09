//
//  PetitionWriteError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import Foundation

enum PetitionWriteError: LocalizedError {
    case NotSelectedCategory
    case NotEnteredTitle
    case NotEnteredContent
    
    case FailModifyPetition
    case FailWritePetition
    case FailFetchPetition
    
    case TokenExpiration
    case UnAuthorized
    case NetworkError
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .NotSelectedCategory:
                return "카테고리 선택안됨"
            case .NotEnteredTitle:
                return "제목 입력안됨"
            case .NotEnteredContent:
                return "내용 입력안됨"
                
            case .TokenExpiration:
                return "토큰 만료"
            case .FailModifyPetition:
                return "청원 수정 실패"
            case .FailWritePetition:
                return "청원 작성 실패"
            case .FailFetchPetition:
                return "청원 조회 실패"
                
                
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
    func toPetitionWriteError(_ defaultError: PetitionWriteError) -> PetitionWriteError? {
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

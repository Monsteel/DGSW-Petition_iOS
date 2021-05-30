//
//  SplashError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/29.
//

import Foundation

enum SplashError: Error {
    case FailFetchMyInfo
    case FailCategoryInfo
    case FailSaveMyInfo
    case FailSaveCategoryInfo
    
    case UnAuthorized
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .FailFetchMyInfo:
                return "사용자 조회 실패"
            case .FailCategoryInfo:
                return "카테고리 조회 실패"
            case .FailSaveMyInfo:
                return "사용자 저장 실패"
            case .FailSaveCategoryInfo:
                return "카테고리 저장 실패"
                
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
    func toSplashError(_ defaultError: SplashError) -> SplashError? {
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
        
        if let self = self as? DGSW_Petition_iOS.PTCoreDataError {
            switch self.tableName {
                case UserEntity.tableName:
                    return .FailSaveMyInfo
                case CategoryEntity.tableName:
                    return .FailSaveCategoryInfo
                default:
                    return .UnhandledError(msg: self.localizedDescription)
            }
        }

        return .UnhandledError(msg: self.localizedDescription)
    }
}

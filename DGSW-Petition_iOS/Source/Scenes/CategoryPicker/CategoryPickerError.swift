//
//  CategoryPickerError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import Foundation

enum CategoryPickerError: Error {
    case FailFetchCategory
    
    case UnAuthorized
    case InternalServerError
    case UnhandledError(msg: String)
    
    public var errorDescription: String? {
        switch self {
            case .FailFetchCategory:
                return "카테고리 조회실패"
                
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
    func toCategoryPickerError(_ defaultError: CategoryPickerError) -> CategoryPickerError? {
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

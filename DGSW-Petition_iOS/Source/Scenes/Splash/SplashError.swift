//
//  SplashError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/29.
//

import Foundation

enum SplashError: String, Error {
    case UnAuthorized = "토큰 만료됨"
    case FailFetchMyInfo = "사용자 조회 실패"
    case FailCategoryInfo = "카테고리 조회 실패"
    
    public var errorDescription: String? {
        return self.rawValue
    }
}

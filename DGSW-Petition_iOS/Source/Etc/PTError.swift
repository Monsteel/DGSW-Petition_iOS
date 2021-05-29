//
//  PTError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation

public struct NetworkError: Swift.Error, Foundation.LocalizedError {
    public var message: String?
    public var statusCode: Int?
    
    public var errorDescription: String? {
        return message ?? "알 수 없는 오류가 발생했습니다."
    }
}

public struct CoreDataError: Swift.Error, Foundation.LocalizedError {
    public var tableName: String
    public var type: Type
    
    public var errorDescription: String? {
        return "\(tableName) \(type.rawValue)"
    }
    
    public enum `Type`: String {
        case saveFail   = "정보 저장에 실패했습니다."
        case empty  = "정보를 찾을 수 없습니다."
    }
}

public struct BasicError: Swift.Error, Foundation.LocalizedError {
    public var message: String
    
    public var errorDescription: String? {
        return message
    }
}

//
//  CustomError.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

enum CustomError: Error {
    case error(message:String,
               keys: [ErrorKey] = [.basic],
               errorBody: Dictionary<String, Any> = Dictionary())
}

enum ErrorKey: String {
    case retry = "RETRY"         //재시도가 필요한 오류
    case basic = "BASIC"         //단순 오류
    case unhandled = "UNHANDLED" //개발자에게 보고가 필요한 오류
}

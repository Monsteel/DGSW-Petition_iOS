//
//  Error.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import Foundation
import Moya

extension MoyaError {
    func toNetworkError() -> PTNetworkError {
        let errorBody = (try? self.response?.mapJSON() as? Dictionary<String, Any>) ?? Dictionary()
        
        return PTNetworkError(message: errorBody["message"] as? String,
                            statusCode: self.response?.statusCode)
    }
}

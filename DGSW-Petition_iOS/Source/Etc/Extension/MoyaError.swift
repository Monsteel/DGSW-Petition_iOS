//
//  Error.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import Foundation
import Moya
import Alamofire

extension MoyaError {
    func toNetworkError() -> PTNetworkError {
        if let response = self.response {
            let errorBody = (try? self.response?.mapJSON() as? Dictionary<String, Any>)
            
            return PTNetworkError(message: errorBody?["message"] as? String,
                                  statusCode: response.statusCode)
        }
        
        
        
        return PTNetworkError(message: self.asAFError?.localizedDescription,
                              statusCode: 408)
    }
}

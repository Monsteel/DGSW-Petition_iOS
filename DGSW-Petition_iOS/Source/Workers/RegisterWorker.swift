//
//  RegisterWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation

class RegisterWorker: ApiWorker<AuthAPI> {
    static let shared = RegisterWorker()
    
    func register(_ request: RegisterRequest, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.register(request)) {
            switch $0 {
                case .success: completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
    
    func checkRegisteredUser(_ userID: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.checkRegisteredUser(userID)) { [weak self] in
            guard let self = self else { return completionHandler(.failure(PTNetworkError(message: "Self is Nil", statusCode: 500))) }
            
            switch $0 {
                case .success(let res):
                    let res = try! self.decoder.decode(Response<CheckRegisteredUserResponse>.self, from: res.data)
                    completionHandler(.success(res.data.isRegistered))
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
    
}

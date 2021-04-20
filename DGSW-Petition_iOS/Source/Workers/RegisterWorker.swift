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
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
}

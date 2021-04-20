//
//  LoginWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation
import Moya

class LoginWorker: Worker<AuthAPI, AuthLocal> {
    static let shared = LoginWorker()
    
    func login(_ request: LoginRequest, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.login(request)) {
            switch $0 {
                case .success(let res): self.saveToken(res, completionHandler)
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
    
    private func saveToken(_ res: Moya.Response, _ completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let entity = try! JSONDecoder().decode(Response<LoginResponse>.self, from: res.data).data.toEntity()
        local.insertToken(entity) { completionHandler($0) }
    }
}

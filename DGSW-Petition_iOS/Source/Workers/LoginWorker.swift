//
//  LoginWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation
import Moya

class LoginWorker: ApiWorker<AuthAPI> {
    static let shared = LoginWorker()
    
    func login(_ request: LoginRequest, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.login(request)) {
            switch $0 {
                case .success(let res):
                    let res = try! JSONDecoder().decode(Response<LoginResponse>.self, from: res.data)
                    self.saveToken(res.data)
                    completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
    
    private func saveToken(_ data: LoginResponse) {
        KeychainManager.shared.accessToken = data.accessToken
        KeychainManager.shared.refreshToken = data.refreshToken
    }
}

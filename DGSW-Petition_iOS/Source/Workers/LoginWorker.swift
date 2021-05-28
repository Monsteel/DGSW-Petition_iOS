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
        provider.request(.login(request)) { [weak self] in
            switch $0 {
                case .success(let res):
                    guard let self = self else { return completionHandler(.failure(CustomError.error(message: "Self is Nil", keys: [.retry]))) }
                    let res = try! self.decoder.decode(Response<LoginResponse>.self, from: res.data)
                    self.saveToken(res.data)
                    completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
    
    private func saveToken(_ data: LoginResponse?) {
        KeychainManager.shared.accessToken = data?.accessToken
        KeychainManager.shared.refreshToken = data?.refreshToken
    }
}

//
//  LoginWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation
import Moya
import RealmSwift

class LoginWorker: ApiWorker<AuthAPI> {
    static let shared = LoginWorker()
    
    func login(_ request: LoginRequest, completionHandler: @escaping (Result<Void, PTNetworkError>) -> Void) {
        provider.request(.login(request)) { [weak self] in
            guard let self = self else { return completionHandler(.failure(PTNetworkError(message: "Self is Nil", statusCode: 500))) }
            
            switch $0 {
                case .success(let res):
                    let res = try! self.decoder.decode(Response<LoginResponse>.self, from: res.data)
                    self.saveToken(res.data)
                    completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
    
    private func saveToken(_ data: LoginResponse?) {
        KeychainManager.shared.login(data?.accessToken, data?.refreshToken)
    }
}

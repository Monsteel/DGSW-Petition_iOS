//
//  Worker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation
import Moya

class Worker<T: TargetType, L: DGSW_Petition_iOS.Local> {
    let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])
    let local = L()
    
    lazy var authProvider = MoyaProvider<TokenAPI>(plugins: [NetworkLoggerPlugin()])
    
    func request(_ target: MoyaProvider<T>.Target,
                 callbackQueue: DispatchQueue? = .none,
                 progress: ProgressBlock? = .none,
                 completion: @escaping Completion) -> Cancellable {
        provider.request(target) {
            switch $0 {
                case .success(let res):
                    completion(.success(res))
                case .failure(let err):
                    err.response?.statusCode == 410 ? self.tokenRefresh(completion, target) : completion(.failure(err))
            }
        }
        
    }
    
    private func tokenRefresh(_ completion: @escaping Completion, _ target: MoyaProvider<T>.Target) {
        authProvider.request(.refreshToken) {
            switch $0 {
                case .success(let res):
                    let res = try! JSONDecoder().decode(DGSW_Petition_iOS.Response<String>.self, from: res.data)
                    self.saveToken(res.data, completion, target)
                case .failure(_): break
            }
        }
    }
    
    private func saveToken(_ newToken: String, _ completion: @escaping Completion, _ target: MoyaProvider<T>.Target) {
        AuthLocal.shared.insertToken(TokenEntity(accessToken: newToken,
                                                 refreshToken: "")) {
            switch $0 {
                case .success: provider.request(target, completion: completion)
                case .failure(let err) : completion(.failure(MoyaError.underlying(err, nil)))
            }
        }
    }
    
    
}

class ApiWorker<T: TargetType> {
    let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])
}


class LocalWorker<L: DGSW_Petition_iOS.Local> {
    let local = L()
}
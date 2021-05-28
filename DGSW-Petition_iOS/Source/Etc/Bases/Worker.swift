//
//  Worker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation
import Moya
import Then

class Worker<T: TargetType, L: DGSW_Petition_iOS.Local>: ApiWorker<T> {
    let local = L()
}

class ApiWorker<T: TargetType> {
    let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])
    private lazy var authProvider = MoyaProvider<TokenAPI>(plugins: [NetworkLoggerPlugin()])
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Formatter.iso8601Full)
        return decoder
    }()
    
    @discardableResult
    func request(_ target: MoyaProvider<T>.Target,
                 callbackQueue: DispatchQueue? = .none,
                 progress: ProgressBlock? = .none,
                 completion: @escaping Completion) -> Cancellable {
        return provider.request(target, callbackQueue: callbackQueue, progress: progress) {
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
                case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    private func saveToken(_ newToken: String, _ completion: @escaping Completion, _ target: MoyaProvider<T>.Target) {
        KeychainManager.shared.accessToken = newToken
        
        provider.request(target, completion: completion)
    }
}


class LocalWorker<L: DGSW_Petition_iOS.Local> {
    let local = L()
}

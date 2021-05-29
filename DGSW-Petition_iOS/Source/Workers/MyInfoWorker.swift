//
//  MyInfoWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import Foundation
import Moya

class MyInfoWorker: Worker<MyInfoAPI, MyInfoLocal> {
    static let shared = MyInfoWorker()
    
    func getMyInfo(completionHandler: @escaping (Result<UserDetailInfo, Error>) -> Void) {
        provider.request(.getMyInfo) { [weak self] in
            guard let self = self else { return completionHandler(.failure(NetworkError(message: "Self is Nil", statusCode: 500))) }
            
            switch $0 {
                case .success(let res):
                    let res = try! self.decoder.decode(Response<UserDetailInfo>.self, from: res.data)
                    completionHandler(.success(res.data))
                case .failure:
                    self.insertMyInfo {
                        switch $0 {
                            case .success:
                                self.getMyInfo(completionHandler: completionHandler)
                            case .failure(let err):
                                completionHandler(.failure(err))
                        }
                    }
            }
        }
    }

    func insertMyInfo(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        self.request(.getMyInfo) { [weak self] in
            guard let self = self else { return completionHandler(.failure(NetworkError(message: "Self is Nil", statusCode: 500))) }
            
            switch $0 {
                case .success(let res):
                    let res = try! self.decoder.decode(Response<UserDetailInfo>.self, from: res.data)
                    self.local.insertUser(res.data.toEntity(), res: completionHandler)
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
}

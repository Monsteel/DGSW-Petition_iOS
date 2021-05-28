//
//  AgreeWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation

class AgreeWorker: ApiWorker<AgreeAPI> {
    static let shared = AgreeWorker()
    
    func agree(_ request: AgreeRequest, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        self.request(.agree(request)) {
            switch $0 {
                case .success: completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
    
    func getAgrees(_ petitionIdx: Int,
                   completionHandler: @escaping (Result<Response<Array<AgreeDetailInfo>>, Error>) -> Void) {
        self.request(.getAgree(petitionIdx)) { [weak self] in
            switch $0 {
                case .success(let res):
                    guard let self = self else { return completionHandler(.failure(CustomError.error(message: "Self is Nil", keys: [.retry]))) }
                    let res = try! self.decoder.decode(Response<Array<AgreeDetailInfo>>.self, from: res.data)
                    completionHandler(.success(res))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
}

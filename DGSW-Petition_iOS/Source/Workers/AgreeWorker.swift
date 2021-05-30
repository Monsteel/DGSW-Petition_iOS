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
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
    
    func getAgrees(_ petitionIdx: Int,
                   completionHandler: @escaping (Result<Response<Array<AgreeDetailInfo>>, Error>) -> Void) {
        self.request(.getAgree(petitionIdx)) { [weak self] in
            guard let self = self else { return completionHandler(.failure(PTNetworkError(message: "Self is Nil", statusCode: 500))) }
            
            switch $0 {
                case .success(let res):
                    let res = try! self.decoder.decode(Response<Array<AgreeDetailInfo>>.self, from: res.data)
                    completionHandler(.success(res))
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
}

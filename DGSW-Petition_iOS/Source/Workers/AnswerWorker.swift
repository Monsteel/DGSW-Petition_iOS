//
//  AnswerWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation

class AnswerWorker: ApiWorker<AnswerAPI> {
    static let shared = AnswerWorker()
    
    func addAnswer (_ request: AnswerRequest, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        self.request(.addAnswer(request)) {
            switch $0 {
                case .success: completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
    
    func getAnswers (_ petitionIdx: Int,
                     completionHandler: @escaping (Result<Response<Array<AnswerDetailInfo>>, Error>) -> Void) {
        self.request(.getAnswers(petitionIdx)) { [weak self] in
            guard let self = self else { return completionHandler(.failure(NetworkError(message: "Self is Nil", statusCode: 500))) }
            
            switch $0 {
                case .success(let res):
                    let res = try! self.decoder.decode(Response<Array<AnswerDetailInfo>>.self, from: res.data)
                    completionHandler(.success(res))
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
}

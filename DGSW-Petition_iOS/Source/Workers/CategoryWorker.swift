//
//  CategoryWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/26.
//

import Foundation

class CategoryWorker: DGSW_Petition_iOS.Worker<CategoryAPI, CategoryLocal> {
    static let shared = CategoryWorker()
    
    func getCategories(completionHandler: @escaping (Result<Array<CategoryInfo>, Error>) -> Void) {
        local.selectCategories { [weak self] in
            guard let self = self else { return completionHandler(.failure(PTNetworkError(message: "Self is Nil", statusCode: 501))) }
            
            switch $0 {
                case .success(let res):
                    completionHandler(.success(res.map { $0.toModel() }))
                case .failure:
                    insertCategories {
                        switch $0 {
                            case .success:
                                self.getCategories(completionHandler: completionHandler)
                            case .failure(let err):
                                completionHandler(.failure(err))
                        }
                    }
            }
        }
    }
    
    func getCategory(_ idx: Int,
                   completionHandler: @escaping (Result<CategoryInfo, Error>) -> Void) {
        local.selectCategory(idx) { [weak self] in
            guard let self = self else { return completionHandler(.failure(PTNetworkError(message: "Self is Nil", statusCode: 501))) }
            
            switch $0 {
                case .success(let res):
                    completionHandler(.success(res.toModel()))
                case .failure:
                    insertCategories {
                        switch $0 {
                            case .success:
                                self.getCategory(idx,completionHandler: completionHandler)
                            case .failure(let err):
                                completionHandler(.failure(err))
                        }
                    }
            }
        }
    }
    
    func insertCategories(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        self.request(.getCategories) { [weak self] in
            guard let self = self else { return completionHandler(.failure(PTNetworkError(message: "Self is Nil", statusCode: 501))) }
            
            switch $0 {
                case .success(let res):
                    let res = try! self.decoder.decode(Response<Array<CategoryInfo>>.self, from: res.data)
                    self.local.insertCategory(res.data.map{ $0.toEntity() }, res: completionHandler)
                case .failure(let err): completionHandler(.failure(err.toNetworkError()))
            }
        }
    }
    
}

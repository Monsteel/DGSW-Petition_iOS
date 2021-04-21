//
//  PetitionWorker.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/19.
//

import Foundation

class PetitionWorker: ApiWorker<PetitionAPI> {
    static let shared = PetitionWorker()
    
    func getPetitions(_ page: Int, _ size: Int,
                      completionHandler: @escaping (Result<Response<Array<PetitionSimpleInfo>>, Error>) -> Void){
        request(.getPetitions(page, size)) {
            switch $0 {
                case .success(let res):
                    let res = try! JSONDecoder().decode(Response<Array<PetitionSimpleInfo>>.self, from: res.data)
                    completionHandler(.success(res))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
    
    func searchPetition(_ page: Int, _ size: Int, _ keyword: String,
                      completionHandler: @escaping (Result<Response<Array<PetitionSimpleInfo>>, Error>) -> Void){
        request(.searchPetition(page, size, keyword)) {
            switch $0 {
                case .success(let res):
                    let res = try! JSONDecoder().decode(Response<Array<PetitionSimpleInfo>>.self, from: res.data)
                    completionHandler(.success(res))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
    
    func writePetition(_ request: PetitionRequest,
                      completionHandler: @escaping (Result<Void, Error>) -> Void){
        self.request(.writePetition(request)) {
            switch $0 {
                case .success: completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
    
    func editPetition(_ idx: Int, _ request: PetitionRequest,
                      completionHandler: @escaping (Result<Void, Error>) -> Void){
        self.request(.editPetition(idx, request)) {
            switch $0 {
                case .success: completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
    
    func deletePetition(_ idx: Int,
                      completionHandler: @escaping (Result<Void, Error>) -> Void){
        self.request(.deletePetition(idx)) {
            switch $0 {
                case .success: completionHandler(.success(Void()))
                case .failure(let err): completionHandler(.failure(err))
            }
        }
    }
}

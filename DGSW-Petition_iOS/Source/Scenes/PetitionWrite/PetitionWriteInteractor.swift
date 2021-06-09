//
//  PetitionWriteInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit

protocol PetitionWriteBusinessLogic {
    func refresh(request: PetitionWrite.Refresh.Request)
    func writePetition(request: PetitionWrite.WritePetition.Request)
    func modifyPetition(request: PetitionWrite.ModifyPetition.Request)
}

protocol PetitionWriteDataStore {
    var idx: Int? { get set }
    var categoryIdx: Int? { get set }
    var categoryName: String? { get set }
}

class PetitionWriteInteractor: PetitionWriteBusinessLogic, PetitionWriteDataStore {
    var presenter: PetitionWritePresentationLogic?
    var petitionWorker: PetitionWorker?
    var categoryWorker: CategoryWorker?
    
    
    var idx: Int? = nil
    var categoryIdx: Int? = nil
    var categoryName: String? = nil

    // MARK: Do something (and send response to PetitionWritePresenter)

    func refresh(request: PetitionWrite.Refresh.Request) {
        petitionWorker = PetitionWorker.shared
        petitionWorker?.getPetitionDetailInfo(idx ?? -1) {  [weak self] in
            switch $0 {
                case .success(let res):
                    self?.fetchCategory(res.data)
                case .failure(let err):
                    self?.presentRefreshResult(nil, nil, err.toPetitionWriteError(.FailFetchPetition))
            }
        }
    }
    
    private func fetchCategory(_ petitionDetailInfo: PetitionDetailInfo) {
        categoryWorker = CategoryWorker.shared
        categoryWorker?.getCategory(petitionDetailInfo.category) { [weak self] in
            switch $0 {
                case .success(let categoryInfo):
                    self?.presentRefreshResult(petitionDetailInfo, categoryInfo)
                case .failure:
                    self?.presentRefreshResult(petitionDetailInfo, nil, nil)
            }
        }
    }
    
    func writePetition(request: PetitionWrite.WritePetition.Request) {
        petitionWorker = PetitionWorker.shared
        
        if(categoryIdx == nil){
            presentWriteResult(.NotSelectedCategory)
            return
        } else if (request.title.isEmpty) {
            presentWriteResult(.NotEnteredTitle)
            return
        } else if (request.content.isEmpty) {
            presentWriteResult(.NotEnteredContent)
            return
        }
        
        petitionWorker?.writePetition(.init(category: categoryIdx!,
                                            title: request.title,
                                            content: request.content,
                                            firstKeyword: request.fkeyword,
                                            secondKeyword: request.skeyword,
                                            thirdKeyword: request.tkeyword)) { [weak self] in
            switch $0 {
                case .success:
                    self?.presentWriteResult(nil)
                case .failure(let err):
                    self?.presentWriteResult(err.toPetitionWriteError(.FailWritePetition))
            }
        }
    }
    
    func modifyPetition(request: PetitionWrite.ModifyPetition.Request) {
        petitionWorker = PetitionWorker.shared
        
        if(categoryIdx == nil){
            presentWriteResult(.NotSelectedCategory)
            return
        } else if (request.title.isEmpty) {
            presentWriteResult(.NotEnteredTitle)
            return
        } else if (request.content.isEmpty) {
            presentWriteResult(.NotEnteredContent)
            return
        }
        
        petitionWorker?.editPetition(idx ?? -1, .init(category: categoryIdx!,
                                              title: request.title,
                                              content: request.content,
                                              firstKeyword: request.fkeyword,
                                              secondKeyword: request.skeyword,
                                              thirdKeyword: request.tkeyword)) {  [weak self] in
            switch $0 {
                case .success:
                    self?.presentModifyResult(nil)
                case .failure(let err):
                    self?.presentModifyResult(err.toPetitionWriteError(.FailModifyPetition))
            }
        }
    }
}

extension PetitionWriteInteractor {
    private func presentRefreshResult(_ petitionDetailInfo: PetitionDetailInfo? = nil, _ categoryInfo: CategoryInfo? = nil, _ error: PetitionWriteError? = nil){
        self.categoryIdx = categoryInfo?.idx
        self.categoryName = categoryInfo?.categoryName
        let response = PetitionWrite.Refresh.Response(petitionDetailInfo: petitionDetailInfo, categoryInfo: categoryInfo, error: error)
        self.presenter?.presentRefreshResult(response: response)
    }
    
    private func presentWriteResult(_ error: PetitionWriteError? = nil){
        let response = PetitionWrite.WritePetition.Response(error: error)
        self.presenter?.presentWriteResult(response: response)
    }
    
    private func presentModifyResult(_ error: PetitionWriteError? = nil){
        let response = PetitionWrite.ModifyPetition.Response(error: error)
        self.presenter?.presentModifyResult(response: response)
    }
}

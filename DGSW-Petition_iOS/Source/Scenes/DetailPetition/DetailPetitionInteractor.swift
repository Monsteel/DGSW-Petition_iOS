//
//  DetailPetitionInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/31.
//

import UIKit

protocol DetailPetitionBusinessLogic {
    func refresh(request: DetailPetition.Refresh.Request)
    func fetchAgree(request: DetailPetition.FetchAgree.Request)
    func writeAgree(request: DetailPetition.WriteAgree.Request)
    func deletePetition(request: DetailPetition.DeletePetition.Request)
}

protocol DetailPetitionDataStore {
    var petitionIdx: Int? { get set }
}

class DetailPetitionInteractor: DetailPetitionBusinessLogic, DetailPetitionDataStore {
    var petitionIdx: Int?
    
    var presenter: DetailPetitionPresentationLogic?
    
    var petitionWorker: PetitionWorker?
    var agreeWorker: AgreeWorker?
    var answerWorker: AnswerWorker?
    var categoryWorker: CategoryWorker?
    var myInfoWorker: MyInfoWorker?

    // MARK: Do something (and send response to DetailPetitionPresenter)

    func refresh(request: DetailPetition.Refresh.Request) {
        guard let petitionIdx = self.petitionIdx else {
            presentInitialErrorView(.InvalidAccessError)
            return
        }
        
        petitionWorker = PetitionWorker.shared
        agreeWorker = AgreeWorker.shared
        answerWorker = AnswerWorker.shared
        categoryWorker = CategoryWorker.shared
        myInfoWorker = MyInfoWorker.shared
        
        myInfoWorker?.getMyInfo() { [weak self] in
            switch $0 {
                case .success(let myInfoResponse):
                    self?.petitionWorker?.getPetitionDetailInfo(petitionIdx) { [weak self] in
                        switch $0 {
                            case .success(let petitionResponse):
                                self?.categoryWorker?.getCategory(petitionResponse.data.category) { [weak self] in
                                    switch $0 {
                                        case .success(let categoryInfo):
                                            if(!petitionResponse.data.isAnswer) {
                                                self?.presentInitialView(petitionResponse.data, categoryInfo, nil, myInfoResponse)
                                            }else {
                                                self?.answerWorker?.getAnswers(self?.petitionIdx ?? -1) { [weak self] in
                                                    switch $0 {
                                                        case .success(let answerResponse):
                                                            self?.presentInitialView(petitionResponse.data, categoryInfo, answerResponse.data, myInfoResponse)
                                                        case .failure(let err):
                                                            self?.presentInitialErrorView(err.toDetailPetitionError(.FailFetchPetition))
                                                    }
                                                }
                                            }
                                        case .failure:
                                            if(!petitionResponse.data.isAnswer) {
                                                self?.presentInitialView(petitionResponse.data, nil, nil, nil)
                                            }else {
                                                self?.answerWorker?.getAnswers(self?.petitionIdx ?? -1) { [weak self] in
                                                    switch $0 {
                                                        case .success(let answerResponse):
                                                            self?.presentInitialView(petitionResponse.data, nil, answerResponse.data, nil)
                                                        case .failure(let err):
                                                            self?.presentInitialErrorView(err.toDetailPetitionError(.FailFetchPetition))
                                                    }
                                                }
                                            }
                                    }
                                }
                            case .failure(let err):
                                self?.presentInitialErrorView(err.toDetailPetitionError(.FailFetchPetition))
                        }
                    }
                case .failure(let err):
                    self?.presentInitialErrorView(err.toDetailPetitionError(.FailFetchPetition))
            }
        }
    }
    
    func fetchAgree(request: DetailPetition.FetchAgree.Request) {
        guard let petitionIdx = self.petitionIdx else {
            presentAgreeError(.InvalidAccessError)
            return
        }
        
        petitionWorker = PetitionWorker.shared
        agreeWorker = AgreeWorker.shared
        answerWorker = AnswerWorker.shared
        categoryWorker = CategoryWorker.shared
        myInfoWorker = MyInfoWorker.shared
        
        agreeWorker?.getAgrees(petitionIdx, request.page) { [weak self] in
            switch $0 {
                case .success(let res):
                    self?.presentAgree(res.data)
                case .failure(let err):
                    if(request.page != 0){
                        self?.presentAgree([])
                    } else {
                        self?.presentAgreeError(err.toDetailPetitionError(.FailFetchAgree))
                    }
            }
        }
    }
    
    func deletePetition(request: DetailPetition.DeletePetition.Request) {
        guard let petitionIdx = self.petitionIdx else {
            presentAgreeError(.InvalidAccessError)
            return
        }
        
        petitionWorker = PetitionWorker.shared
        agreeWorker = AgreeWorker.shared
        answerWorker = AnswerWorker.shared
        categoryWorker = CategoryWorker.shared
        myInfoWorker = MyInfoWorker.shared
        
        petitionWorker?.deletePetition(petitionIdx) { [weak self] in
            switch $0 {
                case .success:
                    self?.presenter?.presentDeletePetitionResult(response: .init(error: nil))
                case .failure(let err):
                    self?.presenter?.presentDeletePetitionResult(response: .init(error: err.toDetailPetitionError(.FailDeletePetition)))
            }
        }
    }
    
    func writeAgree(request: DetailPetition.WriteAgree.Request) {
        guard let petitionIdx = self.petitionIdx else {
            presentWriteAgreeError(.InvalidAccessError)
            return
        }
        
        if (request.content.isEmpty) {
            presentWriteAgreeError(.EmptyAgreement)
            return
        }
        
        petitionWorker = PetitionWorker.shared
        agreeWorker = AgreeWorker.shared
        answerWorker = AnswerWorker.shared
        categoryWorker = CategoryWorker.shared
        myInfoWorker = MyInfoWorker.shared
        
        agreeWorker?.agree(.init(petitionIdx: petitionIdx, content: request.content)) { [weak self] in
            switch $0 {
                case .success:
                    self?.presentWriteAgreeResult()
                case .failure(let err):
                    self?.presentWriteAgreeError(err.toDetailPetitionError(.UnhandledError(msg: err.localizedDescription)))
            }
        }
    }
}


extension DetailPetitionInteractor {
    func presentInitialView(_ petitionDetailInfo: PetitionDetailInfo,
                            _ categoryInfo: CategoryInfo?,
                            _ answerInfo: [AnswerDetailInfo]?,
                            _ myInfo: UserDetailInfo?) {
        let response = DetailPetition.Refresh.Response(petitionDetailInfo: petitionDetailInfo,
                                                       categoryInfo: categoryInfo,
                                                       answerInfos: answerInfo,
                                                       myInfo: myInfo,
                                                       error: nil)
        
        presenter?.presentInitialView(response: response)
    }
    
    func presentAgree(_ agreeDetailInfos: [AgreeDetailInfo]?) {
        presenter?.presentAgree(response: .init(agreeDetailInfos: agreeDetailInfos, error: nil))
    }
    
    func presentWriteAgreeResult() {
        presenter?.presentWriteAgreeResult(response: .init(error: nil))
    }
    
    
    
    func presentInitialErrorView(_ error: DetailPetitionError?) {
        let response = DetailPetition.Refresh.Response(petitionDetailInfo: nil,
                                                       categoryInfo: nil,
                                                       answerInfos: nil,
                                                       myInfo: nil,
                                                       error: error)
        
        presenter?.presentInitialView(response: response)
    }
    
    func presentAgreeError(_ error: DetailPetitionError?) {
        presenter?.presentAgree(response: .init(agreeDetailInfos: nil, error: error))
    }
    
    func presentWriteAgreeError(_ error: DetailPetitionError?) {
        presenter?.presentWriteAgreeResult(response: .init(error: error))
    }
}

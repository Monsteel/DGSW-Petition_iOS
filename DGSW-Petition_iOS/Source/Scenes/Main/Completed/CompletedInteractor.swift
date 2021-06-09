//
//  CompletedInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol CompletedBusinessLogic {
    func refresh(request: Completed.Refresh.Request)
    func loadMore(request: Completed.LoadMore.Request)
}

protocol CompletedDataStore {
    
}

class CompletedInteractor: CompletedBusinessLogic, CompletedDataStore {
    var presenter: CompletedPresentationLogic?
    var petitionWorker: PetitionWorker?
    var categoryWorker: CategoryWorker?

    // MARK: Do something (and send response to CompletedPresenter)

    func refresh(request: Completed.Refresh.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getPetitions(0, Constants.INFINITE_SCROLL_LIMIT, type: .COMPLETED) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    self?.getCategories(petitionsResponse.data, .refresh)
                case .failure(let err):
                    self?.presentInitialView(nil, nil, err.toCompletedError(.FailCompletedPetition))
            }
        }
    }
    
    func loadMore(request: Completed.LoadMore.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getPetitions(request.page, Constants.INFINITE_SCROLL_LIMIT, type: .COMPLETED) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    self?.getCategories(petitionsResponse.data, .loadMore)
                case .failure:
                    self?.presentLoadMoreView(nil, nil)
            }
        }
    }
    
    
    private enum From {
        case refresh
        case loadMore
    }
    
    private func getCategories(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ from: From){
        categoryWorker = CategoryWorker.shared
        
        categoryWorker?.getCategories(){ [weak self] in
            switch $0 {
                case .success(let categories):
                    switch from {
                        case .refresh: self?.presentInitialView(petitionSimpleInfos, categories, nil)
                        case .loadMore: self?.presentLoadMoreView(petitionSimpleInfos, categories)
                    }
                    
                case .failure:
                    switch from {
                        case .refresh: self?.presentInitialView(petitionSimpleInfos, nil, nil)
                        case .loadMore: self?.presentLoadMoreView(petitionSimpleInfos, nil)
                    }
            }
        }
    }
}

extension CompletedInteractor {
    private func presentInitialView(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?, _ error: CompletedError?){
        let response = Completed.Refresh.Response(petitionSimpleInfos: petitionSimpleInfos, categoryInfos: categoryInfos, error: error)
        self.presenter?.presentInitialView(response: response)
    }
    
    private func presentLoadMoreView(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?){
        let response = Completed.LoadMore.Response(petitionSimpleInfos: petitionSimpleInfos ?? [], categoryInfos: categoryInfos)
        self.presenter?.presentLoadMoreView(response: response)
    }
}


//
//  AwaitingInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol AwaitingBusinessLogic {
    func refresh(request: Awaiting.Refresh.Request)
    func loadMore(request: Awaiting.LoadMore.Request)
}

protocol AwaitingDataStore {
    
}

class AwaitingInteractor: AwaitingBusinessLogic, AwaitingDataStore {
    var presenter: AwaitingPresentationLogic?
    var petitionWorker: PetitionWorker?
    var categoryWorker: CategoryWorker?

    // MARK: Do something (and send response to AwaitingPresenter)

    func refresh(request: Awaiting.Refresh.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getPetitions(0, Constants.INFINITE_SCROLL_LIMIT, type: .AWAITING) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    self?.getCategories(petitionsResponse.data, .refresh)
                case .failure(let err):
                    self?.presentInitialView(nil, nil, err)
            }
        }
    }
    
    func loadMore(request: Awaiting.LoadMore.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getPetitions(request.page, Constants.INFINITE_SCROLL_LIMIT, type: .AWAITING) { [weak self] in
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
                    
                case .failure(let err):
                    switch from {
                        case .refresh: self?.presentInitialView(petitionSimpleInfos, nil, err)
                        case .loadMore: self?.presentLoadMoreView(petitionSimpleInfos, nil)
                    }
            }
        }
    }
}

extension AwaitingInteractor {
    private func presentInitialView(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?, _ error: Error?){
        let response = Awaiting.Refresh.Response(petitionSimpleInfos: petitionSimpleInfos, categoryInfos: categoryInfos, error: error)
        self.presenter?.presentInitialView(response: response)
    }
    
    private func presentLoadMoreView(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?){
        let response = Awaiting.LoadMore.Response(petitionSimpleInfos: petitionSimpleInfos ?? [], categoryInfos: categoryInfos)
        self.presenter?.presentLoadMoreView(response: response)
    }
}


//
//  OngoingInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol OngoingBusinessLogic {
    func refresh(request: Ongoing.Refresh.Request)
    func loadMore(request: Ongoing.LoadMore.Request)
}

protocol OngoingDataStore {
    
}

class OngoingInteractor: OngoingBusinessLogic, OngoingDataStore {
    var presenter: OngoingPresentationLogic?
    var petitionWorker: PetitionWorker?
    var categoryWorker: CategoryWorker?

    // MARK: Do something (and send response to OngoingPresenter)

    func refresh(request: Ongoing.Refresh.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getPetitions(0, Constants.INFINITE_SCROLL_LIMIT, type: .ON_GOING) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    self?.getCategories(petitionsResponse.data, .refresh)
                case .failure(let err):
                    self?.presentInitialView(nil, nil, err.toOngoingError(.FailOngoingPetition))
            }
        }
    }
    
    func loadMore(request: Ongoing.LoadMore.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.getPetitions(request.page, Constants.INFINITE_SCROLL_LIMIT, type: .ON_GOING) { [weak self] in
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

extension OngoingInteractor {
    private func presentInitialView(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?, _ error: OngoingError?){
        let response = Ongoing.Refresh.Response(petitionSimpleInfos: petitionSimpleInfos, categoryInfos: categoryInfos, error: error)
        self.presenter?.presentInitialView(response: response)
    }
    
    private func presentLoadMoreView(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?){
        let response = Ongoing.LoadMore.Response(petitionSimpleInfos: petitionSimpleInfos ?? [], categoryInfos: categoryInfos)
        self.presenter?.presentLoadMoreView(response: response)
    }
}

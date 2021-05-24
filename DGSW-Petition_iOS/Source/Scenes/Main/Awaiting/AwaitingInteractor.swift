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
    var worker: PetitionWorker?

    // MARK: Do something (and send response to AwaitingPresenter)

    func refresh(request: Awaiting.Refresh.Request) {
        worker = PetitionWorker.shared
        
        worker?.getPetitions(0, Constants.INFINITE_SCROLL_LIMIT) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    let response = Awaiting.Refresh.Response(petitionSimpleInfos: petitionsResponse.data, error: nil)
                    self?.presenter?.presentInitialView(response: response)
                case .failure(let err):
                    let response = Awaiting.Refresh.Response(petitionSimpleInfos: nil, error: err)
                    self?.presenter?.presentInitialView(response: response)
            }
        }
    }
    
    func loadMore(request: Awaiting.LoadMore.Request) {
        worker = PetitionWorker.shared
        
        worker?.getPetitions(request.page, Constants.INFINITE_SCROLL_LIMIT) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    let response = Awaiting.LoadMore.Response(petitionSimpleInfos: petitionsResponse.data)
                    self?.presenter?.presentLoadMoreView(response: response)
                case .failure:
                    let response = Awaiting.LoadMore.Response(petitionSimpleInfos: [])
                    self?.presenter?.presentLoadMoreView(response: response)
            }
        }
    }
}


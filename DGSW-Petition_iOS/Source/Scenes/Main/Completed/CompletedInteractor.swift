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
    var worker: PetitionWorker?

    // MARK: Do something (and send response to CompletedPresenter)

    func refresh(request: Completed.Refresh.Request) {
        worker = PetitionWorker.shared
        
        worker?.getPetitions(0, Constants.INFINITE_SCROLL_LIMIT) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    let response = Completed.Refresh.Response(petitionSimpleInfos: petitionsResponse.data, error: nil)
                    self?.presenter?.presentInitialView(response: response)
                case .failure(let err):
                    let response = Completed.Refresh.Response(petitionSimpleInfos: nil, error: err)
                    self?.presenter?.presentInitialView(response: response)
            }
        }
    }
    
    func loadMore(request: Completed.LoadMore.Request) {
        worker = PetitionWorker.shared
        
        worker?.getPetitions(request.page, Constants.INFINITE_SCROLL_LIMIT) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    let response = Completed.LoadMore.Response(petitionSimpleInfos: petitionsResponse.data)
                    self?.presenter?.presentLoadMoreView(response: response)
                case .failure:
                    let response = Completed.LoadMore.Response(petitionSimpleInfos: [])
                    self?.presenter?.presentLoadMoreView(response: response)
            }
        }
    }
}


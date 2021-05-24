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
    var worker: PetitionWorker?

    // MARK: Do something (and send response to OngoingPresenter)

    func refresh(request: Ongoing.Refresh.Request) {
        worker = PetitionWorker.shared
        
        worker?.getPetitions(0, Constants.INFINITE_SCROLL_LIMIT, type: .ON_GOING) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    let response = Ongoing.Refresh.Response(petitionSimpleInfos: petitionsResponse.data, error: nil)
                    self?.presenter?.presentInitialView(response: response)
                case .failure(let err):
                    let response = Ongoing.Refresh.Response(petitionSimpleInfos: nil, error: err)
                    self?.presenter?.presentInitialView(response: response)
            }
        }
    }
    
    func loadMore(request: Ongoing.LoadMore.Request) {
        worker = PetitionWorker.shared
        
        worker?.getPetitions(request.page, Constants.INFINITE_SCROLL_LIMIT, type: .ON_GOING) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    let response = Ongoing.LoadMore.Response(petitionSimpleInfos: petitionsResponse.data)
                    self?.presenter?.presentLoadMoreView(response: response)
                case .failure:
                    let response = Ongoing.LoadMore.Response(petitionSimpleInfos: [])
                    self?.presenter?.presentLoadMoreView(response: response)
            }
        }
    }
}

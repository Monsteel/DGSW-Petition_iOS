//
//  SearchInteractor.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit

protocol SearchBusinessLogic {
    func search(request: Search.Search.Request)
    func loadMore(request: Search.LoadMore.Request)
}

protocol SearchDataStore {
    var searchKeyword: String { get set }
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    var presenter: SearchPresentationLogic?
    var worker: PetitionWorker?
    var searchKeyword: String = ""

    // MARK: Do something (and send response to SearchPresenter)

    func search(request: Search.Search.Request) {
        worker = PetitionWorker.shared
        
        worker?.searchPetition(0, Constants.INFINITE_SCROLL_LIMIT, searchKeyword) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    let response = Search.Search.Response(petitionSimpleInfos: petitionsResponse.data, error: nil)
                    self?.presenter?.presentSearchResult(response: response)
                case .failure(let err):
                    let response = Search.Search.Response(petitionSimpleInfos: nil, error: err)
                    self?.presenter?.presentSearchResult(response: response)
            }
        }
    }
    
    func loadMore(request: Search.LoadMore.Request) {
        worker = PetitionWorker.shared
        
        worker?.searchPetition(request.page, Constants.INFINITE_SCROLL_LIMIT, searchKeyword) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    let response = Search.LoadMore.Response(petitionSimpleInfos: petitionsResponse.data)
                    self?.presenter?.presentLoadMoreResult(response: response)
                case .failure:
                    let response = Search.LoadMore.Response(petitionSimpleInfos: [])
                    self?.presenter?.presentLoadMoreResult(response: response)
            }
        }
    }
}

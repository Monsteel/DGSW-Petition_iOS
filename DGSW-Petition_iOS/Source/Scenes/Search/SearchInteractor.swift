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
    var petitionWorker: PetitionWorker?
    var categoryWorker: CategoryWorker?
    var searchKeyword: String = ""

    // MARK: Do something (and send response to SearchPresenter)

    func search(request: Search.Search.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.searchPetition(0, Constants.INFINITE_SCROLL_LIMIT, searchKeyword) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    self?.getCategories(petitionsResponse.data, .search)
                case .failure(let err):
                    self?.presentSearchResult(nil, nil, err.toSearchError(.FailCompletedPetition))
            }
        }
    }
    
    func loadMore(request: Search.LoadMore.Request) {
        petitionWorker = PetitionWorker.shared
        
        petitionWorker?.searchPetition(request.page, Constants.INFINITE_SCROLL_LIMIT, searchKeyword) { [weak self] in
            switch $0 {
                case .success(let petitionsResponse):
                    self?.getCategories(petitionsResponse.data, .loadMore)
                case .failure:
                    self?.presentLoadMoreView(nil, nil)
            }
        }
    }
    private enum From {
        case search
        case loadMore
    }
    
    private func getCategories(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ from: From){
        categoryWorker = CategoryWorker.shared
        
        categoryWorker?.getCategories(){ [weak self] in
            switch $0 {
                case .success(let categories):
                    switch from {
                        case .search: self?.presentSearchResult(petitionSimpleInfos, categories, nil)
                        case .loadMore: self?.presentLoadMoreView(petitionSimpleInfos, categories)
                    }
                    
                case .failure:
                    switch from {
                        case .search: self?.presentSearchResult(petitionSimpleInfos, nil, nil)
                        case .loadMore: self?.presentLoadMoreView(petitionSimpleInfos, nil)
                    }
            }
        }
    }
}

extension SearchInteractor {
    private func presentSearchResult(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?, _ error: SearchError?){
        let response = Search.Search.Response(petitionSimpleInfos: petitionSimpleInfos, categoryInfos: categoryInfos, error: error)
        self.presenter?.presentSearchResult(response: response)
    }
    
    private func presentLoadMoreView(_ petitionSimpleInfos: [PetitionSimpleInfo]?, _ categoryInfos: [CategoryInfo]?){
        let response = Search.LoadMore.Response(petitionSimpleInfos: petitionSimpleInfos ?? [], categoryInfos: categoryInfos)
        self.presenter?.presentLoadMoreResult(response: response)
    }
}

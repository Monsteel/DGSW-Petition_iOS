//
//  SearchPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/25.
//

import UIKit

protocol SearchPresentationLogic {
    func presentSearchResult(response: Search.Search.Response)
    func presentLoadMoreResult(response: Search.LoadMore.Response)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?

    // MARK: Parse and calc respnse from SearchInteractor and send simple view model to SearchViewController to be displayed

    func presentSearchResult(response: Search.Search.Response) {
        
        let petitions = response.petitionSimpleInfos?.map { simpleInfo in
            Search.Search.ViewModel.Petition(idx: simpleInfo.idx,
                                             expirationDate: simpleInfo.expirationDate,
                                             category: response.categoryInfos?.filter { $0.idx == simpleInfo.category }.first?.categoryName ?? "=카테고리 조회실패=",
                                             title: simpleInfo.title,
                                             agreeCount: simpleInfo.agreeCount)
        }
        
        let viewModel = Search.Search.ViewModel(petitions: petitions,
                                                errorMessage: response.error?.localizedDescription)
        
        viewController?.displaySearchResult(viewModel: viewModel)
    }
    
    func presentLoadMoreResult(response: Search.LoadMore.Response) {
        let petitions = response.petitionSimpleInfos.map { simpleInfo in
            Search.LoadMore.ViewModel.Petition(idx: simpleInfo.idx,
                                               expirationDate: simpleInfo.expirationDate,
                                               category: response.categoryInfos?.filter { $0.idx == simpleInfo.category }.first?.categoryName ?? "=카테고리 조회실패=",
                                               title: simpleInfo.title,
                                               agreeCount: simpleInfo.agreeCount)
        }
        
        let viewModel = Search.LoadMore.ViewModel(petitions: petitions)
        
        viewController?.displayLoadMoreResult(viewModel: viewModel)
        
    }
}

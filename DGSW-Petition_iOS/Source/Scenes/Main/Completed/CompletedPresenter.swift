//
//  CompletedPresenter.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/04/28.
//

import UIKit

protocol CompletedPresentationLogic {
    func presentInitialView(response: Completed.Refresh.Response)
    func presentLoadMoreView(response: Completed.LoadMore.Response)
}

class CompletedPresenter: CompletedPresentationLogic {
    weak var viewController: CompletedDisplayLogic?

    // MARK: Parse and calc respnse from CompletedInteractor and send simple view model to CompletedViewController to be displayed

    func presentInitialView(response: Completed.Refresh.Response) {
        
        let petitions = response.petitionSimpleInfos?.map { simpleInfo in
            Completed.Refresh.ViewModel.Petition(idx: simpleInfo.idx,
                                               expirationDate: simpleInfo.expirationDate,
                                               category: response.categoryInfos?.filter { $0.idx == simpleInfo.category }.first?.categoryName ?? "=카테고리 조회실패=",
                                               title: simpleInfo.title,
                                               agreeCount: simpleInfo.agreeCount)
        }
        
        let viewModel = Completed.Refresh.ViewModel(petitions: petitions,
                                                  errorMessage: response.error?.localizedDescription)
        
        viewController?.displayInitialView(viewModel: viewModel)
    }
    
    func presentLoadMoreView(response: Completed.LoadMore.Response) {
        let petitions = response.petitionSimpleInfos.map { simpleInfo in
            Completed.LoadMore.ViewModel.Petition(idx: simpleInfo.idx,
                                               expirationDate: simpleInfo.expirationDate,
                                               category: response.categoryInfos?.filter { $0.idx == simpleInfo.category }.first?.categoryName ?? "=카테고리 조회실패=",
                                               title: simpleInfo.title,
                                               agreeCount: simpleInfo.agreeCount)
        }
        
        let viewModel = Completed.LoadMore.ViewModel(petitions: petitions)
        
        viewController?.displayLoadMoreView(viewModel: viewModel)

    }
}
